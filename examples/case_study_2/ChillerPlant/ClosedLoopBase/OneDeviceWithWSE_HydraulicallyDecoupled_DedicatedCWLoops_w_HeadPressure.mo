within ChillerPlant.ClosedLoopBase;
model OneDeviceWithWSE_HydraulicallyDecoupled_DedicatedCWLoops_w_HeadPressure
  "Simple chiller plant with a water-side economizer and one of each: chiller, cooling tower cell, condenser, and chiller water pump."
  extends ChillerPlant.BaseClasses.DataCenter(
    mCW_flow_nominal = 2*roo.QRoo_flow/(4200*6),
    chi(m1_flow_nominal=mCW_flow_nominal/2, dp1_nominal=89580),
    wse(dp1_nominal=59720));
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
  Modelica.Blocks.Sources.Constant mFanFlo(k=mAir_flow_nominal)
    "Mass flow rate of fan" annotation (Placement(transformation(extent={{240,
            -210},{260,-190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow(redeclare package Medium
      = MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower"      annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={300,227},
        rotation=90)));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal/2,
    dp(start=214992),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={160,120})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCWWSE(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dp(start=214992),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={40,170})));
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
        origin={300,144})));
  BaseClasses.Controls.CondenserWaterConstantTwoLoops
    condenserWaterConstantTwoLoops(mCW_flow_nominal=mCW_flow_nominal)
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
    final Ti=120,
    final Td=120,
    r=chi.per.PLRMinUnl,
    final yMax=1,
    final yMin=0,
    reverseActing=true,
    final y_reset=1)
    "Controls the recirculation valve to maintain the CW supply temperature sufficiently above the evaporator side one"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=chi.per.PLRMinUnl)
                                                                  "Constant"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(p=1, k=-0.95)
    annotation (Placement(transformation(extent={{0,140},{20,160}})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare package Medium = Buildings.Media.Water,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={2*mCW_flow_nominal,-1.5*mCW_flow_nominal,-0.5*
        mCW_flow_nominal},
    dp_nominal=200*{1,-1,-1})                   "Splits flow"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={300,204})));
  Buildings.Fluid.FixedResistances.Junction mix(
    redeclare package Medium = Buildings.Media.Water,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={1.5*mCW_flow_nominal,-2*mCW_flow_nominal,0.5*
        mCW_flow_nominal},
    dp_nominal=200*{1,-1,1})                    "Joins two flows"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={106,200})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCT(
    redeclare package Medium = Buildings.Media.Water,
    m_flow_nominal=2*mCW_flow_nominal,
    dp(start=214992),
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
        MediumW, nPorts=1) "Represents an expansion vessel"
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
    dpValve_nominal=20902,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for condenser water loop of economizer" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={190,176})));
  Buildings.Fluid.Sources.Boundary_pT expVesChi(redeclare package Medium =
        MediumW, nPorts=1) "Represents an expansion vessel"
    annotation (Placement(transformation(extent={{252,111},{272,131}})));
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
      points={{-282,-88},{-260,-88},{-260,260},{170,260},{170,243},{199,243}},
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
      points={{-116,34},{-110,34},{-110,80},{234,80},{234,96},{218,96}},
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
      points={{-116,-28},{-20,-28},{-20,140},{230,140},{230,90},{218,90}},
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
  connect(waterSideEconomizerOnOff.ySta, condenserWaterConstantTwoLoops.uWSE)
    annotation (Line(points={{-116,88},{-108,88},{-108,230},{-84,230}}, color={255,
          0,255}));
  connect(chillerOnOff.yChi, condenserWaterConstantTwoLoops.uChi) annotation (
      Line(points={{-116,34},{-100,34},{-100,210},{-84,210}}, color={255,0,255}));
  connect(condenserWaterConstantTwoLoops.yTowFanSpeSet, cooTow.y) annotation (
      Line(points={{-36,230},{-8,230},{-8,270},{194,270},{194,247},{199,247}},
        color={0,0,127},
      pattern=LinePattern.Dot));
  connect(condenserWaterConstantTwoLoops.mChiConWatPumSet_flow, pumCW.m_flow_in)
    annotation (Line(points={{-36,218},{80,218},{80,152},{180,152},{180,120},{172,
          120}},                                                       color={0,0,127},
      pattern=LinePattern.Dot));

  connect(condenserWaterConstantTwoLoops.mWSEConWatPumSet_flow, pumCWWSE.m_flow_in)
    annotation (Line(points={{-36,208},{-10,208},{-10,170},{28,170}},
                 color={0,0,127},
      pattern=LinePattern.Dot));
  connect(PWSEWatPum1.y, PWSEWatPumAgg.u) annotation (Line(
      points={{-499,20},{-480,20},{-480,30},{-462,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chillerOnOff.yChi, heaPreCon.trigger) annotation (Line(points={{-116,34},
          {-36,34},{-36,168}},     color={255,0,255}));
  connect(val.port_2, chi.port_a1) annotation (Line(points={{300,134},{300,99},{
          216,99}},                     color={28,108,200},
      thickness=0.5));
  connect(one.y, heaPreCon.u_s)
    annotation (Line(points={{-58,180},{-42,180}}, color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(heaPreCon.y, addPar.u)
    annotation (Line(points={{-18,180},{-14,180},{-14,150},{-2,150}},
                                                  color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(addPar.y, val.y)
    annotation (Line(points={{22,150},{280,150},{280,174},{320,174},{320,144},{
          312,144}},                              color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chi.yPLR1, heaPreCon.u_m) annotation (Line(
      points={{217,102},{240,102},{240,140},{-30,140},{-30,168}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCWLeaTow.port_b, spl.port_1)
    annotation (Line(points={{300,217},{300,214}}, color={0,127,255}));
  connect(mix.port_3, spl.port_3)
    annotation (Line(points={{116,200},{200,200},{200,204},{290,204}},
                                                   color={0,127,255}));
  connect(spl.port_2, val.port_1) annotation (Line(
      points={{300,194},{300,154}},
      color={28,108,200},
      thickness=0.5));
  connect(pumCW.port_b, mix.port_1) annotation (Line(
      points={{160,130},{160,168},{106,168},{106,190}},
      color={28,108,200},
      thickness=0.5));
  connect(condenserWaterConstantTwoLoops.mChiConWatPumSet_flow, addFlo.u1)
    annotation (Line(
      points={{-36,218},{10,218},{10,246},{18,246}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(condenserWaterConstantTwoLoops.mWSEConWatPumSet_flow, addFlo.u2)
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
          112},{-6,112},{-6,176},{178,176}},
                                        color={0,0,127}));
  connect(spl.port_2, val4.port_b) annotation (Line(points={{300,194},{190,194},
          {190,186}}, color={0,127,255}));
  connect(val4.port_a, wse.port_a1) annotation (Line(points={{190,166},{136,166},
          {136,99},{68,99}}, color={0,127,255}));
  connect(wse.port_b1, pumCWWSE.port_a)
    annotation (Line(points={{48,99},{40,99},{40,160}}, color={0,127,255}));
  connect(pumCWWSE.port_b, mix.port_1) annotation (Line(points={{40,180},{106,
          180},{106,190}}, color={0,127,255}));
  connect(chi.port_a1, expVesChi.ports[1]) annotation (Line(points={{216,99},{
          245.5,99},{245.5,121},{272,121}}, color={0,0,127}));
  connect(pumCT.port_b, cooTow.port_a) annotation (Line(points={{150,240},{176,
          240},{176,239},{201,239}}, color={0,127,255}));
  connect(mix.port_2, pumCT.port_a) annotation (Line(points={{106,210},{108,210},
          {108,240},{130,240}}, color={0,127,255}));
  connect(cooTow.port_b, TCWLeaTow.port_a) annotation (Line(points={{221,239},{
          298,239},{298,237},{300,237}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(file=
          "/home/milicag/repos/obc/examples/case_study_2/scripts/ClosedLoopBase/OneDeviceWithWSE_HydraulicallyDecoupled_DedicatedCWLoops_w_HeadPressure.mos"
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
end OneDeviceWithWSE_HydraulicallyDecoupled_DedicatedCWLoops_w_HeadPressure;
