within ChillerPlant.BaseClasses;
partial model DataCenter
  "Primary only chiller plant system with water-side economizer without controls"

  //parameter Modelica.Media.Water.WaterIF97_base.ThermodynamicState sta_default=Medium.setState_pTX(
  //  T=Medium.T_default,
  //  p=Medium.p_default,
  //  X=Medium.X_default)
  //  "State of the medium at the medium default properties";

  //parameter Modelica.SIunits.Density rho_default=Medium.density(sta_default)
  //  "Density at the medium default properties";

  parameter Buildings.Media.Water.ThermodynamicState sta_default=Buildings.Media.Water.setState_pTX(
      T=Buildings.Media.Water.T_default,
      p=Buildings.Media.Water.p_default,
      X=Buildings.Media.Water.X_default);

  parameter Modelica.SIunits.Density rho_default=Buildings.Media.Water.density(sta_default)
    "Density, used to compute fluid volume";

  parameter Modelica.SIunits.ThermodynamicTemperature TZonSupSet = 273.15 + 27
    "Zone supply temperature setpoint";

  // control parameters
  parameter Modelica.SIunits.TemperatureDifference cooTowAppDes = 4
    "Design cooling tower approach"
    annotation(Dialog(group="Design parameters"));

  parameter Modelica.SIunits.ThermodynamicTemperature TWetBulDes = 273.15 + 22
    "Design wet bulb temperature"
    annotation(Dialog(group="Design parameters"));

  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal=roo.QRoo_flow/(1005
      *15) "Nominal mass flow rate at fan";
  parameter Modelica.SIunits.Power P_nominal=80E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=6
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=6
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal=5 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=2*roo.QRoo_flow/(
      4200*20) "Nominal mass flow rate at chilled water";

  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=2*roo.QRoo_flow/(
      4200*6) "Nominal mass flow rate at condenser water";

  parameter Modelica.SIunits.PressureDifference dp_nominal=200000
    "Nominal pressure difference";
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    dp(start=249),
    m_flow(start=mAir_flow_nominal),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=293.15) "Fan for air flow through the data center"
    annotation (Placement(transformation(extent={{290,-235},{270,-215}})));
  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow cooCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m2_flow_nominal=mAir_flow_nominal,
    m1_flow_nominal=mCHW_flow_nominal,
    m1_flow(start=mCHW_flow_nominal),
    m2_flow(start=mAir_flow_nominal),
    dp2_nominal=200,
    UA_nominal=mAir_flow_nominal*1006*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    dp1_nominal(displayUnit="Pa") = 24000)
    "Cooling coil"
    annotation (Placement(transformation(extent={{242,-180},{222,-160}})));
  Buildings.Examples.ChillerPlant.BaseClasses.SimplifiedRoom roo(
    redeclare package Medium = MediumA,
    nPorts=1,
    rooLen=50,
    rooWid=30,
    rooHei=3,
    m_flow_nominal=mAir_flow_nominal,
    QRoo_flow=500000) "Room model" annotation (Placement(transformation(extent={
            {-10,10},{10,-10}}, origin={190,-238})));
  Buildings.Fluid.Movers.FlowControlled_dp pumCHW(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    m_flow(start=mCHW_flow_nominal),
    dp(start=1000 + 12000 + 15000 + 3500 + 24000),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Chilled water pump" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={160,-120})));
  Buildings.Fluid.Sources.Boundary_pT expVesCHW(redeclare package Medium =
        MediumW,
    p=100000,    nPorts=1) "Represents an expansion vessel"
    annotation (Placement(transformation(extent={{188,-149},{208,-129}})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    TAirInWB_nominal(displayUnit="degC") = 283.15,
    TApp_nominal=cooTowAppDes,
    dp_nominal=15000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    PFan_nominal=6500)
    "Cooling tower"                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={209,239})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness wse(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=mCW_flow_nominal/2,
    m2_flow_nominal=mCHW_flow_nominal,
    eps=0.8,
    dp2_nominal=15000,
    dp1_nominal=42000)
                   "Water side economizer (Heat exchanger)"
    annotation (Placement(transformation(extent={{68,83},{48,103}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
    use_inputFilter=false)
    "Bypass control valve for economizer. 1: disable economizer, 0: enable economizer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,-40})));
  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=mCW_flow_nominal/2,
    m2_flow_nominal=mCHW_flow_nominal,
    dp2_nominal=19000,
    dp1_nominal=42000,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial) "Chiller"
    annotation (Placement(transformation(extent={{216,83},{196,103}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val6(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=14930 + 89580,
    y_start=1,
    use_inputFilter=false,
    from_dp=true)
    "Control valve for chilled water leaving from chiller" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={300,40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(redeclare package Medium =
        MediumA, m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature to data center" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={230,-225})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWEntChi(redeclare package
      Medium = MediumW, m_flow_nominal=mCHW_flow_nominal)
    "Temperature of chilled water entering chiller" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={160,0})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear          valByp(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
    riseTime=60,
    dpFixed_nominal=14930,
    y_start=0,
    use_inputFilter=false,
    from_dp=true)          "Bypass valve for chiller." annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={230,20})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val3(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=59720 + 1000,
    use_inputFilter=false)
    "Control valve for economizer. 0: disable economizer, 1: enable economizer"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}}, origin={60,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWLeaCoi(redeclare package
      Medium = MediumW, m_flow_nominal=mCHW_flow_nominal)
    "Temperature of chilled water leaving the cooling coil"
                                                     annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={160,-80})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaData(filNam=
        "/home/milicag/repos/obc/examples/case_study_2/weatherdata/USA_CA_Sacramento.724835_TMY2.mos")
    annotation (Placement(transformation(extent={{-398,-102},{-378,-82}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-340,-100},{-320,-80}})));
  Modelica.Blocks.Sources.Constant mFanFlo(k=mAir_flow_nominal)
    "Mass flow rate of fan" annotation (Placement(transformation(extent={{240,
            -210},{260,-190}})));
equation

  connect(cooCoi.port_b2, fan.port_a) annotation (Line(
      points={{242,-176},{301,-176},{301,-225},{290,-225}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));

  connect(wse.port_a2, val3.port_b) annotation (Line(
      points={{48,87},{40,87},{40,-60},{50,-60}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TAirSup.port_a, fan.port_b) annotation (Line(
      points={{240,-225},{270,-225}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(roo.airPorts[1],TAirSup. port_b) annotation (Line(
      points={{190.45,-229.3},{190.45,-225},{220,-225}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCHWLeaCoi.port_a, pumCHW.port_b)
                                           annotation (Line(
      points={{160,-90},{160,-110}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCHWEntChi.port_b, valByp.port_a)
                                         annotation (Line(
      points={{160,10},{160,20},{220,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCHWEntChi.port_a, val1.port_b)
                                         annotation (Line(
      points={{160,-10},{160,-30}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val1.port_a, TCHWLeaCoi.port_b)
                                         annotation (Line(
      points={{160,-50},{160,-70}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val3.port_a, TCHWLeaCoi.port_b)
                                         annotation (Line(
      points={{70,-60},{160,-60},{160,-70}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(weaData.weaBus, weaBus) annotation (Line(
      points={{-378,-92},{-328,-92},{-328,-88},{-330,-88},{-330,-90}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TCHWEntChi.port_a, wse.port_b2)
                                         annotation (Line(
      points={{160,-10},{160,-20},{80,-20},{80,87},{68,87}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(valByp.port_b, val6.port_b)
                                    annotation (Line(
      points={{240,20},{300,20},{300,30}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCHWEntChi.port_b, chi.port_a2)
                                         annotation (Line(
      points={{160,10},{160,88},{196,88},{196,87}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));

  connect(chi.port_b2, val6.port_a) annotation (Line(
      points={{216,87},{300,87},{300,50}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(pumCHW.port_a, cooCoi.port_b1) annotation (Line(
      points={{160,-130},{160,-164},{222,-164}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(expVesCHW.ports[1], cooCoi.port_b1) annotation (Line(
      points={{208,-139},{208,-140},{220,-140},{220,-164},{222,-164}},
      color={0,127,255},
      thickness=0.5));
  connect(mFanFlo.y, fan.m_flow_in) annotation (Line(points={{261,-200},{280,
          -200},{280,-213}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-360,-300},{360,
            300}})),
Documentation(info="<HTML>
<p>
This model is the chilled water plant with discrete time control and
trim and respond logic for a data center. The model is described at
<a href=\"Buildings.Examples.ChillerPlant\">
Buildings.Examples.ChillerPlant</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July xx, 2021, by Milica Grahovac:<br/>
Revised pressure drops, removed elements per OBC data center chiller plant case study needs.
</li>
<li>
September 21, 2017, by Michael Wetter:<br/>
Set <code>from_dp = true</code> in <code>val6</code> and in <code>valByp</code>
which is needed for Dymola 2018FD01 beta 2 for
<a href=\"modelica://Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl\">
Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl</a>
to converge.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
January 13, 2015 by Michael Wetter:<br/>
Moved model to <code>BaseClasses</code> because the continuous and discrete time
implementation of the trim and respond logic do not extend from a common class,
and hence the <code>constrainedby</code> operator is not applicable.
Moving the model here allows to implement both controllers without using a
<code>replaceable</code> class.
</li>
<li>
January 12, 2015 by Michael Wetter:<br/>
Made media instances replaceable, and used the same instance for both
water loops.
This was done to simplify the numerical benchmarks.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 25, 2014, by Michael Wetter:<br/>
Updated model with new expansion vessel.
</li>
<li>
December 5, 2012, by Michael Wetter:<br/>
Removed the filtered speed calculation for the valves to reduce computing time by 25%.
</li>
<li>
October 16, 2012, by Wangda Zuo:<br/>
Reimplemented the controls.
</li>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Added comments and merge to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-360,-300},{360,300}})));
end DataCenter;
