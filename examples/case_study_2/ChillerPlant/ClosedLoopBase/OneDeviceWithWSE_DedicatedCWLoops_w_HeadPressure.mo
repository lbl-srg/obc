within ChillerPlant.ClosedLoopBase;
model OneDeviceWithWSE_DedicatedCWLoops_w_HeadPressure
  "Simple chiller plant with a water-side economizer and one of each: chiller, cooling tower cell, condenser, and chiller water pump."
  extends ChillerPlant.BaseClasses.DataCenter(
    mCW_flow_nominal = 2*roo.QRoo_flow/(4200*6),
    chi(m1_flow_nominal=mCW_flow_nominal/2));
  extends ChillerPlant.BaseClasses.EnergyMonitoring;
  extends Modelica.Icons.Example;

  Modelica.SIunits.Power PWSEWatPum;

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
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow(redeclare package Medium =
        MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower"      annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={240,201},
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
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={120,120})));
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
    final k=0.5,
    final Ti=120,
    final Td=120,
    r=chi.per.PLRMinUnl,
    final yMax=1,
    final yMin=0,
    reverseActing=true,
    final y_reset=1)
    "Controls the recirculation valve to maintain the CW supply temperature sufficiently above the evaporator side one"
    annotation (Placement(transformation(extent={{-50,170},{-30,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=chi.per.PLRMinUnl)
                                                                  "Constant"
    annotation (Placement(transformation(extent={{-90,170},{-70,190}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(p=1, k=-0.95)
    annotation (Placement(transformation(extent={{0,140},{20,160}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val5(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal/2,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_inputFilter=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,190})));
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
        origin={40,192})));
  Buildings.Fluid.Sources.Boundary_pT expVesCHW1(redeclare package Medium =
        MediumW, nPorts=1) "Represents an expansion vessel"
    annotation (Placement(transformation(extent={{240,281},{260,301}})));
equation
  PSupFan = fan.P;
  PChiWatPum = pumCHW.P;
  PConWatPum = pumCW.P;
  PWSEWatPum = pumCWWSE.P;
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
      points={{229,201},{180,201},{180,260},{-230,260},{-230,86},{-164,86}},
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
  connect(chillerOnOff.yOn, val5.y) annotation (Line(
      points={{-116,20},{100,20},{100,190},{148,190}},
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
      color={0,128,255},
      thickness=0.5));
  connect(cooTow.port_b, val.port_1) annotation (Line(points={{221,239},{220,
          239},{220,240},{300,240},{300,170}}, color={0,127,255},
      thickness=0.5));
  connect(val.port_3, pumCW.port_b) annotation (Line(points={{290,160},{160,160},
          {160,130}}, color={0,127,255},
      thickness=0.5));
  connect(pumCW.port_b, val5.port_a) annotation (Line(
      points={{160,130},{160,180}},
      color={0,127,255},
      thickness=0.5));
  connect(val5.port_b, cooTow.port_a) annotation (Line(
      points={{160,200},{160,239},{201,239}},
      color={0,127,255},
      thickness=0.5));
  connect(wse.port_b1, val4.port_a) annotation (Line(points={{48,99},{44,99},{
          44,100},{40,100},{40,182}}, color={0,127,255},
      thickness=0.5));
  connect(waterSideEconomizerOnOff.yOn, val4.y) annotation (Line(
      points={{-116,112},{-20,112},{-20,192},{28,192}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(cooTow.port_a, val4.port_b)
    annotation (Line(points={{201,239},{40,239},{40,202}}, color={0,128,255},
      thickness=0.5));
  connect(waterSideEconomizerOnOff.ySta, condenserWaterConstantTwoLoops.uWSE)
    annotation (Line(points={{-116,88},{-108,88},{-108,230},{-84,230}}, color={255,
          0,255}));
  connect(chillerOnOff.yChi, condenserWaterConstantTwoLoops.uChi) annotation (
      Line(points={{-116,34},{-100,34},{-100,210},{-84,210}}, color={255,0,255}));
  connect(condenserWaterConstantTwoLoops.yTowFanSpeSet, cooTow.y) annotation (
      Line(points={{-36,230},{-10,230},{-10,247},{199,247}},
        color={0,0,127},
      pattern=LinePattern.Dot));
  connect(condenserWaterConstantTwoLoops.mChiConWatPumSet_flow, pumCW.m_flow_in)
    annotation (Line(points={{-36,218},{80,218},{80,152},{180,152},{180,120},{172,
          120}},                                                       color={0,0,127},
      pattern=LinePattern.Dot));

  connect(condenserWaterConstantTwoLoops.mWSEConWatPumSet_flow, pumCWWSE.m_flow_in)
    annotation (Line(points={{-36,208},{-10,208},{-10,120},{108,120}},
                 color={0,0,127},
      pattern=LinePattern.Dot));
  connect(PWSEWatPum1.y, PWSEWatPumAgg.u) annotation (Line(
      points={{-499,20},{-480,20},{-480,30},{-462,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chillerOnOff.yChi, heaPreCon.trigger) annotation (Line(points={{-116,34},
          {-60,34},{-60,160},{-46,160},{-46,168}},
                                   color={255,0,255}));
  connect(val.port_2, chi.port_a1) annotation (Line(points={{300,150},{300,100},
          {258,100},{258,99},{216,99}}, color={0,127,255},
      thickness=0.5));
  connect(pumCWWSE.port_b, wse.port_a1) annotation (Line(
      points={{120,110},{120,99},{68,99}},
      color={0,127,255},
      thickness=0.5));
  connect(TCWLeaTow.port_a, cooTow.port_b) annotation (Line(
      points={{240,211},{240,239},{221,239}},
      color={0,127,255},
      thickness=0.5));
  connect(TCWLeaTow.port_b, pumCWWSE.port_a) annotation (Line(
      points={{240,191},{240,144},{120,144},{120,130}},
      color={0,127,255},
      thickness=0.5));
  connect(one.y, heaPreCon.u_s)
    annotation (Line(points={{-68,180},{-52,180}}, color={0,0,127}));
  connect(heaPreCon.y, addPar.u)
    annotation (Line(points={{-28,180},{-14,180},{-14,150},{-2,150}},
                                                  color={0,0,127}));
  connect(addPar.y, val.y)
    annotation (Line(points={{22,150},{280,150},{280,180},{320,180},{320,160},{312,
          160}},                                  color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chi.yPLR1, heaPreCon.u_m) annotation (Line(points={{217,102},{238,102},
          {238,138},{-40,138},{-40,168}}, color={0,0,127}));
  connect(expVesCHW1.ports[1], cooTow.port_b) annotation (Line(
      points={{260,291},{260,239},{221,239}},
      color={0,127,255},
      thickness=0.5));
  annotation (
    __Dymola_Commands(file=
          "/home/milicag/repos/obc/examples/case_study_2/scripts/ClosedLoopBase/OneDeviceWithWSE_DedicatedCWLoops_w_HeadPressure.mos"
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
end OneDeviceWithWSE_DedicatedCWLoops_w_HeadPressure;
