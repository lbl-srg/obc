within ChillerPlant.ClosedLoopBase;
model OneDeviceWithWSE_dedicatedCWP
  "Simple chiller plant with a water-side economizer and one of each: chiller, cooling tower cell, condenser, and chiller water pump."
  extends ChillerPlant.BaseClasses.DataCenter(chi(m1_flow_nominal=
          mCW_flow_nominal/2));
  extends ChillerPlant.BaseClasses.EnergyMonitoring;
  extends Modelica.Icons.Example;

  parameter Real dTChi(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=2.2
    "Deadband to avoid chiller short-cycling"
    annotation(Dialog(group="Design parameters"));

  BaseClasses.Controls.CondenserWaterConstant condenserWaterConstant(
      mCW_flow_nominal=mCW_flow_nominal)
    annotation (Placement(transformation(extent={{-100,200},{-60,240}})));
  BaseClasses.Controls.WaterSideEconomizerOnOff waterSideEconomizerOnOff(
      cooTowAppDes=cooTowAppDes)
    annotation (Placement(transformation(extent={{-160,80},{-120,120}})));
  BaseClasses.Controls.ChillerOnOff chillerOnOff(
    dTChi = dTChi)
    annotation (Placement(transformation(extent={{-160,0},{-120,40}})));
  BaseClasses.Controls.ChilledWaterReset chilledWaterReset
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}})));
  BaseClasses.Controls.PlantOnOffWithAnalogueTrimAndRespond plantOnOff(
      TZonSupSet=TZonSupSet)
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}})));
  Modelica.Blocks.Sources.Constant mFanFlo(k=mAir_flow_nominal)
    "Mass flow rate of fan" annotation (Placement(transformation(extent={{240,
            -210},{260,-190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow(redeclare package Medium =
        MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower"      annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={272,121})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal/2,
    dp(start=214992/2 + 15000),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={160,120})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW1(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dp(start=214992 + 15000),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={40,212})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear val(
    redeclare package Medium = Buildings.Media.Water,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal=mCW_flow_nominal/2,
    dpValve_nominal=20902,
    fraK=1)                                           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={300,160})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0.5)
    annotation (Placement(transformation(extent={{320,190},{340,210}})));
equation
  PSupFan = fan.P;
  PChiWatPum = pumCHW.P;
  PConWatPum = pumCW.P;
  PCooTowFan = cooTow.PFan;
  PChi = chi.P;
  QRooIntGai_flow = roo.QSou.Q_flow;
  mConWat_flow = pumCW.m_flow_actual;
  mChiWat_flow = pumCHW.VMachine_flow * rho_default;

  connect(weaBus.TWetBul, cooTow.TAir) annotation (Line(
      points={{-282,-88},{-260,-88},{-260,243},{199,243}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(condenserWaterConstant.yTowFanSpeSet, cooTow.y) annotation (Line(
        points={{-56,230},{-20,230},{-20,260},{199,260},{199,247}}, color={0,0,127},
      pattern=LinePattern.Dot));

  connect(waterSideEconomizerOnOff.ySta, condenserWaterConstant.uWSE)
    annotation (Line(
      points={{-116,88},{-110,88},{-110,230},{-104,230}},
      color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(waterSideEconomizerOnOff.yOn, val4.y) annotation (Line(
      points={{-116,112},{-60,112},{-60,180},{28,180}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(waterSideEconomizerOnOff.yOff, val1.y) annotation (Line(
      points={{-116,100},{-60,100},{-60,-40},{148,-40}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(waterSideEconomizerOnOff.yOn, val3.y) annotation (Line(
      points={{-116,112},{0,112},{0,-18},{60,-18},{60,-48}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TCHWLeaCoi.T, waterSideEconomizerOnOff.TChiWatRet) annotation (Line(
      points={{149,-80},{-200,-80},{-200,112},{-164,112}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(weaBus.TWetBul, waterSideEconomizerOnOff.TWetBul) annotation (Line(
      points={{-282,-88},{-260,-88},{-260,100},{-164,100}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TCWLeaTow.T, waterSideEconomizerOnOff.TConWatSup) annotation (Line(
      points={{272,132},{-210,132},{-210,86},{-164,86}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chillerOnOff.yChi, condenserWaterConstant.uChi) annotation (Line(
      points={{-116,34},{-110,34},{-110,210},{-104,210}},
      color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(chillerOnOff.yChi, chi.on) annotation (Line(
      points={{-116,34},{-110,34},{-110,80},{234,80},{234,96},{218,96}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(chillerOnOff.yOn, val6.y) annotation (Line(
      points={{-116,20},{100,20},{100,40},{288,40}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chillerOnOff.yOff, valByp.y) annotation (Line(
      points={{-116,6},{120,6},{120,32},{230,32}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chillerOnOff.yOn, val5.y) annotation (Line(
      points={{-116,20},{102,20},{102,180},{148,180}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TCHWEntChi.T, chillerOnOff.TChiWatSup) annotation (Line(
      points={{149,0},{140,0},{140,-10},{-180,-10},{-180,34},{-164,34}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chilledWaterReset.TChiWatSupSet, chi.TSet) annotation (Line(
      points={{-116,-28},{-20,-28},{-20,140},{228,140},{228,90},{218,90}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chilledWaterReset.dpChiWatPumSet, pumCHW.dp_in) annotation (Line(
      points={{-116,-52},{-20,-52},{-20,-120},{148,-120}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(plantOnOff.yChiWatPlaRes, chilledWaterReset.uChiWatPlaRes)
    annotation (Line(points={{-176,-120},{-170,-120},{-170,-40},{-164,-40}},
        color={0,0,127}));
  connect(TAirSup.T, plantOnOff.TZonSup) annotation (Line(
      points={{230,-214},{230,-200},{-240,-200},{-240,-120},{-224,-120}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(mFanFlo.y, fan.m_flow_in) annotation (Line(
      points={{261,-200},{280,-200},{280,-213}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(chilledWaterReset.TChiWatSupSet, chillerOnOff.TChiWatSupSet)
    annotation (Line(
      points={{-116,-28},{-100,-28},{-100,-10},{-180,-10},{-180,6},{-164,6}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(TCWLeaTow.port_b, chi.port_a1)
                                        annotation (Line(
      points={{262,121},{262,120},{240,120},{240,99},{216,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(cooCoi.port_a1, val6.port_b) annotation (Line(
      points={{242,-164},{300,-164},{300,30}},
      color={0,127,255},
      thickness=0.5));
  connect(condenserWaterConstant.mConWatPumSet_flow, pumCW.m_flow_in)
    annotation (Line(points={{-56,210},{-20,210},{-20,196},{112,196},{112,120},{
          172,120}},                                         color={0,0,127},
      pattern=LinePattern.Dot));
  connect(val4.port_b, pumCW1.port_a)
    annotation (Line(points={{40,190},{40,202}}, color={0,127,255}));
  connect(pumCW1.port_b, cooTow.port_a) annotation (Line(
      points={{40,222},{40,239},{201,239}},
      color={0,127,255},
      thickness=0.5));
  connect(chi.port_b1, pumCW.port_a) annotation (Line(
      points={{196,99},{196,100},{160,100},{160,110}},
      color={0,128,255},
      thickness=0.5));
  connect(cooTow.port_b, wse.port_a1) annotation (Line(
      points={{221,239},{240,239},{240,200},{80,200},{80,99},{68,99}},
      color={0,127,255},
      thickness=0.5));
  connect(val.port_2, TCWLeaTow.port_a) annotation (Line(points={{300,150},{300,
          121},{282,121}}, color={0,127,255},
      thickness=0.5));
  connect(cooTow.port_b, val.port_1) annotation (Line(points={{221,239},{220,239},
          {220,240},{300,240},{300,170}},      color={0,127,255},
      thickness=0.5));
  connect(val.port_3, pumCW.port_b) annotation (Line(points={{290,160},{160,160},
          {160,130}}, color={0,127,255},
      thickness=0.5));
  connect(pumCW.port_b, val5.port_a) annotation (Line(
      points={{160,130},{160,170}},
      color={0,127,255},
      thickness=0.5));
  connect(val5.port_b, cooTow.port_a) annotation (Line(
      points={{160,190},{160,239},{201,239}},
      color={0,127,255},
      thickness=0.5));
  connect(con.y, val.y) annotation (Line(points={{342,200},{350,200},{350,160},{
          312,160}}, color={0,0,127}));
  connect(condenserWaterConstant.mConWatPumSet_flow, pumCW1.m_flow_in)
    annotation (Line(points={{-56,210},{0,210},{0,212},{52,212}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file=
          "/home/milicag/repos/obc/examples/case_study_2/scripts/ClosedLoopBase/OneDeviceWithWSE_dedicatedCWP.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is the chilled water plant with continuous time control.
The trim and respond logic is approximated by a PI controller which
significantly reduces computing time. The model is described at
<a href=\"Buildings.Examples.ChillerPlant\">
Buildings.Examples.ChillerPlant</a>.
</p>
<p>
See
<a href=\"Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl\">
Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl</a>
for an implementation with the discrete time trim and respond logic.
</p>
</html>", revisions="<html>
<ul>
<li>
January 13, 2015, by Michael Wetter:<br/>
Moved base model to
<a href=\"Buildings.Examples.ChillerPlant.BaseClasses.DataCenter\">
Buildings.Examples.ChillerPlant.BaseClasses.DataCenter</a>.
</li>
<li>
December 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-640,-300},{400,
            300}})),
    experiment(StartTime=13046400, Tolerance=1e-6, StopTime=13651200),
    Icon(coordinateSystem(extent={{-640,-300},{400,300}})));
end OneDeviceWithWSE_dedicatedCWP;
