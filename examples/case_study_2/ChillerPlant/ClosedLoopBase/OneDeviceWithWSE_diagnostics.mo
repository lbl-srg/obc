within ChillerPlant.ClosedLoopBase;
model OneDeviceWithWSE_diagnostics
  "Simple chiller plant with a water-side economizer and one of each: chiller, cooling tower cell, condenser, and chiller water pump."
  extends ChillerPlant.BaseClasses.DataCenter(
    mCW_flow_nominal = 2*roo.QRoo_flow/(4200*6),
    chi(
      m1_flow_nominal=mCW_flow_nominal/2,
      m2_flow_nominal=mCHW_flow_nominal,
      dp1_nominal=33000 + 1444 - 200),
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
    roo(nPorts=2));
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
  BaseClasses.Controls.ChilledWaterReset chilledWaterReset
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}})));
  BaseClasses.Controls.PlantOnOffWithAnalogueTrimAndRespond plantOnOff(
      TZonSupSet=TZonSupSet)
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow(redeclare package Medium =
        MediumW, m_flow_nominal=1.1*mCW_flow_nominal)
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
        origin={42,162})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear val(
    redeclare package Medium = Buildings.Media.Water,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    riseTime=30,
    m_flow_nominal=mCW_flow_nominal/2,
    dpValve_nominal=200,
    fraK=1)                                           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={300,144})));
  BaseClasses.Controls.CondenserWaterConstantTwoLoops_SameFlow
    condenserWaterConstantTwoLoops_SameFlow(
                                   mCW_flow_nominal=mCW_flow_nominal)
    annotation (Placement(transformation(extent={{-80,200},{-40,240}})));
  Modelica.Blocks.Sources.RealExpression PWSEWatPum1(y=PWSEWatPum)
    "WSE water pump power consumption" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-510,20})));
  Modelica.Blocks.Continuous.Integrator PWSEWatPumAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0)
    "Condensed water pump power consumption meter for the WSE loop"
    annotation (Placement(transformation(extent={{-460,20},{-440,40}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset heaPreCon(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=1,
    final Ti=60,
    final Td=120,
    r=chi.per.PLRMinUnl,
    final yMax=1,
    final yMin=0,
    reverseActing=true,
    final y_reset=1)
    "Controls the recirculation valve to maintain the CW supply temperature sufficiently above the evaporator side one"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant set(k=chi.per.PLRMinUnl)
                                                                  "Constant"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(p=1, k=-1)
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
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
  Buildings.Controls.OBC.CDL.Continuous.Add addFlo
    "Adds WSE and chiller condenser side flow "
    annotation (Placement(transformation(extent={{20,230},{40,250}})));
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
    annotation (Placement(transformation(extent={{212,113},{232,133}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow1(redeclare package
      Medium = Buildings.Media.Water, m_flow_nominal=1.1*mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower"      annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={190,219},
        rotation=0)));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Buildings.Media.Water)
    annotation (Placement(transformation(extent={{154,210},{174,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{320,280},{340,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{360,240},{380,260}})));
  Modelica.Blocks.Continuous.Integrator QCooTowInt(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Total tower heat exchange integrator"
    annotation (Placement(transformation(extent={{442,240},{462,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{438,180},{458,200}})));
  Modelica.Blocks.Continuous.Integrator QCooTowIntNoP(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0)
    "Total tower heat exchange integrator without the compressor power"
    annotation (Placement(transformation(extent={{500,180},{520,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=4182)
    "Specific heat capacity"
    annotation (Placement(transformation(extent={{400,240},{420,260}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirToCoil(redeclare package
      Medium = Buildings.Media.Air, m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature after the data center" annotation (Placement(
        transformation(extent={{10,-10},{-10,10}}, origin={142,-229})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo1(redeclare package Medium =
        Buildings.Media.Air)
    annotation (Placement(transformation(extent={{122,-190},{142,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(k1=-1, k2=1)
    annotation (Placement(transformation(extent={{342,-260},{362,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro1
    annotation (Placement(transformation(extent={{382,-270},{402,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(k=993)
    "Specific heat capacity"
    annotation (Placement(transformation(extent={{420,-270},{440,-250}})));
  Modelica.Blocks.Continuous.Integrator QRooInt(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Total tower heat exchange integrator"
    annotation (Placement(transformation(extent={{460,-270},{480,-250}})));
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

  connect(weaBus.TWetBul, cooTow.TAir) annotation (Line(
      points={{-282,-88},{-260,-88},{-260,260},{170,260},{170,243},{197,243}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

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
      points={{289,227},{248,227},{248,272},{-230,272},{-230,86},{-164,86}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chillerOnOff.yChi, chi.on) annotation (Line(
      points={{-116,34},{-108,34},{-108,80},{236,80},{236,96},{218,96}},
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
  connect(val.port_3, pumCW.port_b) annotation (Line(points={{290,144},{160,144},
          {160,130}}, color={28,108,200},
      thickness=0.5));
  connect(waterSideEconomizerOnOff.ySta,
    condenserWaterConstantTwoLoops_SameFlow.uWSE) annotation (Line(
      points={{-116,88},{-108,88},{-108,230},{-84,230}},
      color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(chillerOnOff.yChi, condenserWaterConstantTwoLoops_SameFlow.uChi)
    annotation (Line(
      points={{-116,34},{-100,34},{-100,210},{-84,210}},
      color={255,0,255},
      pattern=LinePattern.DashDot));

  connect(condenserWaterConstantTwoLoops_SameFlow.yTowFanSpeSet, cooTow.y)
    annotation (Line(
      points={{-36,230},{-8,230},{-8,270},{194,270},{194,247},{197,247}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(condenserWaterConstantTwoLoops_SameFlow.mChiConWatPumSet_flow, pumCW.m_flow_in)
    annotation (Line(
      points={{-36,218},{80,218},{80,152},{180,152},{180,120},{172,120}},
      color={0,0,127},
      pattern=LinePattern.Dot));

  connect(condenserWaterConstantTwoLoops_SameFlow.mWSEConWatPumSet_flow,
    pumCWWSE.m_flow_in) annotation (Line(
      points={{-36,208},{-10,208},{-10,162},{30,162}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(PWSEWatPum1.y, PWSEWatPumAgg.u) annotation (Line(
      points={{-499,20},{-480,20},{-480,30},{-462,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chillerOnOff.yChi, heaPreCon.trigger) annotation (Line(points={{-116,34},
          {-36,34},{-36,168}},     color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(val.port_2, chi.port_a1) annotation (Line(points={{300,134},{300,99},
          {216,99}},                    color={28,108,200},
      thickness=0.5));
  connect(set.y, heaPreCon.u_s)
    annotation (Line(points={{-58,180},{-42,180}}, color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(heaPreCon.y, addPar.u)
    annotation (Line(points={{-18,180},{-14,180},{-14,140},{-2,140}},
                                                  color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(addPar.y, val.y)
    annotation (Line(points={{22,140},{280,140},{280,174},{320,174},{320,144},{
          312,144}},                              color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TCWLeaTow.port_b, spl.port_1)
    annotation (Line(points={{300,217},{300,210}}, color={0,127,255}));
  connect(mix.port_3, spl.port_3)
    annotation (Line(points={{110,200},{290,200}}, color={0,127,255}));
  connect(spl.port_2, val.port_1) annotation (Line(
      points={{300,190},{300,154}},
      color={28,108,200},
      thickness=0.5));
  connect(pumCW.port_b, mix.port_1) annotation (Line(
      points={{160,130},{160,168},{100,168},{100,190}},
      color={28,108,200},
      thickness=0.5));
  connect(condenserWaterConstantTwoLoops_SameFlow.mChiConWatPumSet_flow, addFlo.u1)
    annotation (Line(
      points={{-36,218},{10,218},{10,246},{18,246}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(condenserWaterConstantTwoLoops_SameFlow.mWSEConWatPumSet_flow, addFlo.u2)
    annotation (Line(
      points={{-36,208},{0,208},{0,234},{18,234}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(addFlo.y, pumCT.m_flow_in) annotation (Line(
      points={{42,240},{80,240},{80,220},{140,220},{140,228}},
      color={0,0,127},
      pattern=LinePattern.Dot));
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
    annotation (Line(points={{48,99},{42,99},{42,152}}, color={0,127,255},
      thickness=0.5));
  connect(pumCWWSE.port_b, mix.port_1) annotation (Line(points={{42,172},{42,
          180},{100,180},{100,190}},
                           color={0,127,255},
      thickness=0.5));
  connect(chi.port_a1, expVesChi.ports[1]) annotation (Line(points={{216,99},{
          228,99},{228,100},{240,100},{240,122},{236,122},{236,123},{232,123}},
                                            color={28,108,200}));
  connect(mix.port_2, pumCT.port_a) annotation (Line(points={{100,210},{100,240},
          {130,240}},           color={0,127,255}));
  connect(cooTow.port_b, TCWLeaTow.port_a) annotation (Line(points={{219,239},{
          298,239},{298,237},{300,237}}, color={0,127,255}));
  connect(chi.QEva, heaPreCon.u_m) annotation (Line(
      points={{195,84},{196,84},{196,74},{-30,74},{-30,168}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(senMasFlo.port_b, TCWLeaTow1.port_b) annotation (Line(points={{174,
          220},{180,220},{180,219}}, color={0,127,255}));
  connect(pumCT.port_b, senMasFlo.port_a)
    annotation (Line(points={{150,240},{150,220},{154,220}}, color={0,0,127}));
  connect(TCWLeaTow1.port_a, cooTow.port_a) annotation (Line(points={{200,219},
          {200,239},{199,239}}, color={0,127,255}));
  connect(TCWLeaTow1.T, add2.u1)
    annotation (Line(points={{190,230},{190,296},{318,296}}, color={0,0,127}));
  connect(TCWLeaTow.T, add2.u2) annotation (Line(points={{289,227},{274,227},{
          274,228},{260,228},{260,284},{318,284}}, color={0,0,127}));
  connect(senMasFlo.m_flow, pro.u2) annotation (Line(points={{164,231},{164,264},
          {280,264},{280,244},{358,244}}, color={0,0,127}));
  connect(add2.y, pro.u1) annotation (Line(points={{342,290},{352,290},{352,256},
          {358,256}}, color={0,0,127}));
  connect(chi.P, add1.u2) annotation (Line(points={{195,102},{198,102},{198,98},
          {196,98},{196,96},{184,96},{184,110},{358,110},{358,184},{436,184}},
        color={0,0,127}));
  connect(pro.y, gai.u)
    annotation (Line(points={{382,250},{398,250}}, color={0,0,127}));
  connect(gai.y, QCooTowInt.u)
    annotation (Line(points={{422,250},{440,250}}, color={0,0,127}));
  connect(add3.y, pro1.u1) annotation (Line(points={{364,-250},{370,-250},{370,
          -254},{380,-254}}, color={0,0,127}));
  connect(gai2.y, QRooInt.u)
    annotation (Line(points={{442,-260},{458,-260}}, color={0,0,127}));
  connect(pro1.y, gai2.u)
    annotation (Line(points={{404,-260},{418,-260}}, color={0,0,127}));
  connect(TAirSup.T, add3.u1) annotation (Line(points={{230,-214},{238,-214},{
          238,-220},{244,-220},{244,-244},{340,-244}}, color={0,0,127}));
  connect(TAirToCoil.T, add3.u2) annotation (Line(points={{142,-218},{142,-210},
          {122,-210},{122,-260},{322,-260},{322,-256},{340,-256}}, color={0,0,
          127}));
  connect(TAirToCoil.port_b, senMasFlo1.port_a) annotation (Line(points={{132,
          -229},{102,-229},{102,-180},{122,-180}}, color={0,127,255}));
  connect(senMasFlo1.port_b, cooCoi.port_a2) annotation (Line(points={{142,-180},
          {182,-180},{182,-176},{222,-176}}, color={0,127,255}));
  connect(senMasFlo1.m_flow, pro1.u2) annotation (Line(points={{132,-169},{132,
          -166},{80,-166},{80,-290},{374,-290},{374,-266},{380,-266}}, color={0,
          0,127}));
  connect(roo.airPorts[2], TAirToCoil.port_a) annotation (Line(points={{188.425,
          -229.3},{179.225,-229.3},{179.225,-229},{152,-229}}, color={0,127,255}));
  connect(add1.y, QCooTowIntNoP.u)
    annotation (Line(points={{460,190},{498,190}}, color={0,0,127}));
  connect(gai.y, add1.u1) annotation (Line(points={{422,250},{430,250},{430,196},
          {436,196}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file=
          "/home/milicag/repos/obc/examples/case_study_2/scripts/ClosedLoopBase/OneDeviceWithWSE_diagnostics.mos"
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
    experiment(
      StopTime=30651200,
      Tolerance=1e-05,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-640,-300},{400,300}})));
end OneDeviceWithWSE_diagnostics;
