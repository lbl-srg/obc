within ChillerPlant.ClosedLoopBase;
model OneDeviceWithWSE_wse_design_limit
  "Simple chiller plant with a water-side economizer and one of each: chiller, cooling tower cell, condenser, and chiller water pump."
  extends ChillerPlant.BaseClasses.DataCenter(
    mCW_flow_nominal = 2*roo.QRoo_flow/(4200*6),
    chi(
      m1_flow_nominal=mCW_flow_nominal/2,
      m2_flow_nominal=mCHW_flow_nominal,
      dp1_nominal=42000 + 1444/2,
      dp2_nominal=19000),
    pumCHW(m_flow_nominal=mCHW_flow_nominal, dp_nominal=1000 + 12000 + 15000 +
          3500 + 24000),
    cooCoi(m1_flow_nominal=mCHW_flow_nominal),
    val1(m_flow_nominal=mCHW_flow_nominal,
      dpValve_nominal=200,
      dpFixed_nominal=800),
    TCHWEntChi(m_flow_nominal=mCHW_flow_nominal),
    valByp(m_flow_nominal=mCHW_flow_nominal,
      dpValve_nominal=200,
      use_inputFilter=false,
      dpFixed_nominal=3300),
    val6(m_flow_nominal=mCHW_flow_nominal,
      dpValve_nominal=200,
      dpFixed_nominal=3300),
    cooTow(m_flow_nominal=1.1*mCW_flow_nominal, dp_nominal=15000 + 2887 - 400),
    expVesCHW(p=100000),
    val3(dpValve_nominal=200, dpFixed_nominal=800),
    roo(nPorts=2),
    mFanFlo(k=mAir_flow_nominal),
    wse(dp1_nominal=42000 + 1444/2));
  extends ChillerPlant.BaseClasses.EnergyMonitoring;
  extends Modelica.Icons.Example;

  Modelica.SIunits.Power PWSEWatPum;

  Modelica.SIunits.Power PCooTowWatPum;

  parameter Real dTChi(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=2.2
    "Deadband to avoid chiller short-cycling"
    annotation(Dialog(group="Design parameters"));

  BaseClasses.Controls.WaterSideEconomizerOnOff waterSideEconomizerOnOff(
      cooTowAppDes=cooTowAppDes)
    annotation (Placement(transformation(extent={{-160,80},{-120,120}})));
  BaseClasses.Controls.ChillerOnOff chillerOnOff(
    dTChi = dTChi)
    annotation (Placement(transformation(extent={{-160,0},{-120,40}})));
  BaseClasses.Controls.ChilledWaterReset chilledWaterReset(linPieTwo(y10=0.1))
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}})));
  BaseClasses.Controls.PlantOnOffWithAnalogueTrimAndRespond plantOnOff(
      TZonSupSet=TZonSupSet)
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow(redeclare package Medium =
        MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower"      annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={300,227},
        rotation=90)));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal/2,
    dp(start=33000 + 1444),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={160,120})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCWWSE(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal/2,
    dp(start=33000 + 1444 + 200),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={40,162})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear val(
    redeclare package Medium = Buildings.Media.Water,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    riseTime=30,
    m_flow_nominal=mCW_flow_nominal/2,
    dpValve_nominal=6000,
    fraK=1) "Chiller head pressure bypass valve"      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={302,144})));
  BaseClasses.Controls.CondenserWater condenserWater(
    mCW_flow_nominal=mCW_flow_nominal,
    chiFloDivWseFlo=0.5,
    PLRMinUnl=chi.per.PLRMinUnl)
    annotation (Placement(transformation(extent={{-80,200},{-40,240}})));
  Modelica.Blocks.Sources.RealExpression PWSEWatPum1(y=PWSEWatPum)
    "WSE water pump power consumption" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-510,20})));
  Modelica.Blocks.Continuous.Integrator PWSEWatPumAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0)
    "Condensed water pump power consumption meter for the WSE loop"
    annotation (Placement(transformation(extent={{-460,20},{-440,40}})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare package Medium = Buildings.Media.Water,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={1.1*mCW_flow_nominal,-1*mCW_flow_nominal,-0.1*
        mCW_flow_nominal},
    dp_nominal=200*{1,-1,-1})                   "Splits flow"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={300,200})));
  Buildings.Fluid.FixedResistances.Junction mix(
    redeclare package Medium = Buildings.Media.Water,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={1.1*mCW_flow_nominal,-1*mCW_flow_nominal,0.1*
        mCW_flow_nominal},
    dp_nominal=200*{1,-1,1})                    "Joins two flows"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,200})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCT(
    redeclare package Medium = Buildings.Media.Water,
    m_flow_nominal=1.1*mCW_flow_nominal,
    dp(start=15000 + 2887),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling tower loop pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={140,240})));
  Buildings.Fluid.Sources.Boundary_pT expVesWSE(redeclare package Medium =
        MediumW,
    p=100000,    nPorts=1) "Represents an expansion vessel"
    annotation (Placement(transformation(extent={{50,111},{70,131}})));
  Modelica.Blocks.Sources.RealExpression PCTWatPum(y=PCooTowWatPum)
    "Cooling tower water pump power consumption" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={-510,-20})));
  Modelica.Blocks.Continuous.Integrator PCooTowWatPumAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Cooling tower pump power consumption meter for the WSE loop"
    annotation (Placement(transformation(extent={{-460,-20},{-440,0}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=200,
    dpFixed_nominal=1244,
    y_start=0,
    use_inputFilter=false)
    "Control valve for condenser water loop of economizer" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={120,120})));
  Buildings.Fluid.Sources.Boundary_pT expVesChi(redeclare package Medium =
        MediumW,
    p=100000,    nPorts=1) "Represents an expansion vessel"
    annotation (Placement(transformation(extent={{212,111},{232,131}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TwtBulDes(
    height=12.5,
    duration=70*3600,
    offset=273.15 + 10,
    startTime=3600*1) "Build-up to stationary design condition"
    annotation (Placement(transformation(extent={{-328,116},{-308,136}})));
equation
  PSupFan = fan.P;
  PChiWatPum = pumCHW.P;
  PConWatPum = pumCW.P;
  PWSEWatPum = pumCWWSE.P;
  PCooTowWatPum = pumCT.P;
  PCooTowFan = cooTow.PFan;
  PChi = chi.P;
  QRooIntGai_flow = roo.QSou.Q_flow;
  mConWat_flow = pumCW.m_flow_actual;
  mChiWat_flow = pumCHW.VMachine_flow * rho_default;

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
  connect(TCWLeaTow.T, waterSideEconomizerOnOff.TConWatSup) annotation (Line(
      points={{289,227},{248,227},{248,272},{-230,272},{-230,86},{-164,86}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chillerOnOff.yChi, chi.on) annotation (Line(
      points={{-116,34},{-100,34},{-100,80},{236,80},{236,96},{218,96}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(chillerOnOff.yOn, val6.y) annotation (Line(
      points={{-116,20},{100,20},{100,40},{288,40}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chillerOnOff.yOff, valByp.y) annotation (Line(
      points={{-116,6},{120,6},{120,38},{230,38},{230,32}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TCHWEntChi.T, chillerOnOff.TChiWatSup) annotation (Line(
      points={{149,0},{140,0},{140,-10},{-180,-10},{-180,34},{-164,34}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chilledWaterReset.TChiWatSupSet, chi.TSet) annotation (Line(
      points={{-116,-28},{-20,-28},{-20,60},{230,60},{230,90},{218,90}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chilledWaterReset.dpChiWatPumSet, pumCHW.dp_in) annotation (Line(
      points={{-116,-52},{-20,-52},{-20,-120},{148,-120}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(plantOnOff.yChiWatPlaRes, chilledWaterReset.uChiWatPlaRes)
    annotation (Line(points={{-176,-120},{-170,-120},{-170,-40},{-164,-40}},
        color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(TAirSup.T, plantOnOff.TZonSup) annotation (Line(
      points={{230,-214},{230,-200},{-240,-200},{-240,-120},{-224,-120}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chilledWaterReset.TChiWatSupSet, chillerOnOff.TChiWatSupSet)
    annotation (Line(
      points={{-116,-28},{-100,-28},{-100,-10},{-180,-10},{-180,6},{-164,6}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(cooCoi.port_a1, val6.port_b) annotation (Line(
      points={{242,-164},{300,-164},{300,30}},
      color={0,127,255},
      thickness=0.5));
  connect(chi.port_b1, pumCW.port_a) annotation (Line(
      points={{196,99},{196,100},{160,100},{160,110}},
      color={28,108,200},
      thickness=0.5));
  connect(val.port_3, pumCW.port_b) annotation (Line(points={{292,144},{160,144},
          {160,130}}, color={28,108,200},
      thickness=0.5));
  connect(waterSideEconomizerOnOff.ySta,
    condenserWater.uWSE) annotation (Line(
      points={{-116,88},{-108,88},{-108,236},{-84,236}},
      color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(chillerOnOff.yChi, condenserWater.uChi)
    annotation (Line(
      points={{-116,34},{-100,34},{-100,220},{-84,220}},
      color={255,0,255},
      pattern=LinePattern.DashDot));

  connect(condenserWater.yTowFanSpeSet, cooTow.y)
    annotation (Line(
      points={{-36,236},{-8,236},{-8,270},{194,270},{194,247},{197,247}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(condenserWater.mChiConWatPumSet_flow, pumCW.m_flow_in)
    annotation (Line(
      points={{-36,228},{80,228},{80,152},{180,152},{180,120},{172,120}},
      color={0,0,127},
      pattern=LinePattern.Dot));

  connect(condenserWater.mWSEConWatPumSet_flow,
    pumCWWSE.m_flow_in) annotation (Line(
      points={{-36,220},{-10,220},{-10,162},{28,162}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(PWSEWatPum1.y, PWSEWatPumAgg.u) annotation (Line(
      points={{-499,20},{-480,20},{-480,30},{-462,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(val.port_2, chi.port_a1) annotation (Line(points={{302,134},{302,99},{
          216,99}},                     color={28,108,200},
      thickness=0.5));
  connect(TCWLeaTow.port_b, spl.port_1)
    annotation (Line(points={{300,217},{300,210}}, color={0,127,255}));
  connect(mix.port_3, spl.port_3)
    annotation (Line(points={{110,200},{290,200}}, color={0,127,255}));
  connect(spl.port_2, val.port_1) annotation (Line(
      points={{300,190},{300,154},{302,154}},
      color={28,108,200},
      thickness=0.5));
  connect(pumCW.port_b, mix.port_1) annotation (Line(
      points={{160,130},{160,168},{100,168},{100,190}},
      color={28,108,200},
      thickness=0.5));
  connect(wse.port_a1, expVesWSE.ports[1]) annotation (Line(points={{68,99},{80,
          99},{80,121},{70,121}},color={0,127,255}));
  connect(PCTWatPum.y, PCooTowWatPumAgg.u) annotation (Line(
      points={{-499,-20},{-480,-20},{-480,-10},{-462,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(waterSideEconomizerOnOff.yOn, val4.y) annotation (Line(points={{-116,
          112},{0,112},{0,70},{100,70},{100,120},{108,120}},
                                        color={0,0,127},
      pattern=LinePattern.Dot));
  connect(spl.port_2, val4.port_b) annotation (Line(points={{300,190},{300,180},
          {120,180},{120,130}},
                      color={0,127,255},
      thickness=0.5));
  connect(val4.port_a, wse.port_a1) annotation (Line(points={{120,110},{120,100},
          {80,100},{80,99},{68,99}},
                             color={0,127,255},
      thickness=0.5));
  connect(wse.port_b1, pumCWWSE.port_a)
    annotation (Line(points={{48,99},{44,99},{44,100},{40,100},{40,152}},
                                                        color={0,127,255},
      thickness=0.5));
  connect(pumCWWSE.port_b, mix.port_1) annotation (Line(points={{40,172},{40,180},
          {100,180},{100,190}},
                           color={0,127,255},
      thickness=0.5));
  connect(chi.port_a1, expVesChi.ports[1]) annotation (Line(points={{216,99},{
          228,99},{228,100},{240,100},{240,120},{238,120},{238,121},{232,121}},
                                            color={28,108,200}));
  connect(pumCT.port_b, cooTow.port_a) annotation (Line(points={{150,240},{176,
          240},{176,239},{199,239}}, color={0,127,255}));
  connect(mix.port_2, pumCT.port_a) annotation (Line(points={{100,210},{100,240},
          {130,240}},           color={0,127,255}));
  connect(cooTow.port_b, TCWLeaTow.port_a) annotation (Line(points={{219,239},{
          298,239},{298,237},{300,237}}, color={0,127,255}));
  connect(roo.airPorts[2], cooCoi.port_a2) annotation (Line(
      points={{190.45,-229.3},{188,-229.3},{188,-226},{160,-226},{160,-176},{
          222,-176}},
      color={0,127,255},
      thickness=0.5));
  connect(condenserWater.mCTConWatPumSet, pumCT.m_flow_in) annotation (Line(
      points={{-36,212},{140,212},{140,228}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chi.yPLR1, condenserWater.uChiPLR) annotation (Line(
      points={{217,102},{224,102},{224,70},{-92,70},{-92,204},{-84,204}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(val.y, condenserWater.yChiConMix) annotation (Line(
      points={{314,144},{322,144},{322,174},{68,174},{68,204},{-36,204}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TwtBulDes.y, waterSideEconomizerOnOff.TWetBul) annotation (Line(
        points={{-306,126},{-242,126},{-242,100},{-164,100}}, color={255,255,0},
      thickness=0.5));

  connect(TwtBulDes.y, cooTow.TAir) annotation (Line(points={{-306,126},{-242,
          126},{-242,262},{170,262},{170,243},{197,243}},
                                                     color={255,255,0},
      thickness=0.5));
  annotation (
    __Dymola_Commands(file=
          "/home/milicag/repos/obc/examples/case_study_2/scripts/ClosedLoopBase/OneDeviceWithWSE_wse_design_limit.mos"
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
July xx, 2021, by Milica Grahovac:<br/>
Revised pressure drops, packaged sub-controllers, and added metering panel.
</li>
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
    Diagram(coordinateSystem(extent={{-640,-280},{340,280}})),
    experiment(
      StopTime=295200,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end OneDeviceWithWSE_wse_design_limit;
