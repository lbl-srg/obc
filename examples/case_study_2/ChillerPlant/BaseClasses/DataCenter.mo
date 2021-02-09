within ChillerPlant.BaseClasses;
partial model DataCenter
  "Primary only chiller plant system with water-side economizer without controls"

  // control parameters used in both base and 1711 cases
  parameter Real cooTowAppDes(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=6
    "Design cooling tower approach"
    annotation(Dialog(group="Design parameters"));

  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal=roo.QRoo_flow/(1005
      *15) "Nominal mass flow rate at fan";
  parameter Modelica.SIunits.Power P_nominal=80E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal=3 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=2*roo.QRoo_flow/(
      4200*20) "Nominal mass flow rate at chilled water";

  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=2*roo.QRoo_flow/(
      4200*6) "Nominal mass flow rate at condenser water";

  parameter Modelica.SIunits.PressureDifference dp_nominal=500
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
    dp2_nominal=249*3,
    UA_nominal=mAir_flow_nominal*1006*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    dp1_nominal(displayUnit="Pa") = 1000 + 89580)
    "Cooling coil"
    annotation (Placement(transformation(extent={{242,-180},{222,-160}})));
  Buildings.Examples.ChillerPlant.BaseClasses.SimplifiedRoom roo(
    redeclare package Medium = MediumA,
    nPorts=2,
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
    dp(start=325474),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Chilled water pump" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={160,-120})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(redeclare package Medium =
        MediumW, V_start=1) "Expansion vessel"
    annotation (Placement(transformation(extent={{190,-147},{210,-127}})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    PFan_nominal=6000,
    TAirInWB_nominal(displayUnit="degC") = 283.15,
    TApp_nominal=cooTowAppDes,
    dp_nominal=14930 + 14930 + 74650,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Cooling tower"                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={211,239})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dp(start=214992),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={300,200})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness wse(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    eps=0.8,
    dp2_nominal=0,
    dp1_nominal=0) "Water side economizer (Heat exchanger)"
    annotation (Placement(transformation(extent={{68,83},{48,103}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val5(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_inputFilter=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,180})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
    use_inputFilter=false)
    "Bypass control valve for economizer. 1: disable economizer, 0: enable economoizer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,-40})));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(redeclare package Medium =
        MediumW, V_start=1)
    annotation (Placement(transformation(extent={{178,143},{198,163}})));
  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19XR_742kW_5_42COP_VSD(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
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
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=59720,
    y_start=0,
    use_inputFilter=false)
    "Control valve for condenser water loop of economizer" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,180})));
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
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow(redeclare package Medium =
        MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower"      annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={272,119})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
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
    "Control valve for economizer. 0: disable economizer, 1: enable economoizer"
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
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-320,-100},{-300,-80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-292,-98},{-272,-78}})));
  Modelica.Blocks.Sources.RealExpression PHVAC(y=fan.P + pumCHW.P + pumCW.P +
        cooTow.PFan + chi.P) "Power consumed by HVAC system"
                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-310,-240})));
  Modelica.Blocks.Sources.RealExpression PIT(y=roo.QSou.Q_flow)
    "Power consumed by IT"   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-310,-270})));
  Modelica.Blocks.Continuous.Integrator EHVAC(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Energy consumed by HVAC"
    annotation (Placement(transformation(extent={{-260,-252},{-240,-232}})));
  Modelica.Blocks.Continuous.Integrator EIT(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Energy consumed by IT"
    annotation (Placement(transformation(extent={{-260,-282},{-240,-262}})));
equation
  connect(expVesCHW.port_a, cooCoi.port_b1) annotation (Line(
      points={{200,-147},{200,-164},{222,-164}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(cooTow.port_b, pumCW.port_a) annotation (Line(
      points={{221,239},{300,239},{300,210}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val5.port_a, chi.port_b1) annotation (Line(
      points={{160,170},{160,99},{196,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(expVesChi.port_a, chi.port_b1) annotation (Line(
      points={{188,143},{188,99},{196,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val4.port_a, wse.port_b1) annotation (Line(
      points={{40,170},{40,99},{48,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));

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
      points={{192.475,-229.3},{192.475,-225},{220,-225}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(roo.airPorts[2], cooCoi.port_a2) annotation (Line(
      points={{188.425,-229.3},{188.425,-225},{160,-225},{160,-176},{222,-176}},
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
  connect(TCWLeaTow.port_b, chi.port_a1)
                                        annotation (Line(
      points={{262,119},{242,119},{242,99},{216,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCWLeaTow.port_b, wse.port_a1)
                                        annotation (Line(
      points={{262,119},{80,119},{80,99},{68,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(weaData.weaBus, weaBus) annotation (Line(
      points={{-300,-90},{-291,-90},{-291,-88},{-282,-88}},
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
  connect(val5.port_b, cooTow.port_a) annotation (Line(
      points={{160,190},{160,239},{201,239}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val4.port_b, cooTow.port_a) annotation (Line(
      points={{40,190},{40,239},{201,239}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(pumCW.port_b, TCWLeaTow.port_a)
                                         annotation (Line(
      points={{300,190},{300,119},{282,119}},
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
  connect(PHVAC.y, EHVAC.u) annotation (Line(
      points={{-299,-240},{-280,-240},{-280,-242},{-262,-242}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIT.y, EIT.u) annotation (Line(
      points={{-299,-270},{-280,-270},{-280,-272},{-262,-272}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCoi.port_a1, val6.port_b) annotation (Line(
      points={{242,-164},{300,-164},{300,30}},
      color={0,127,255},
      thickness=0.5));
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
