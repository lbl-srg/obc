within ChillerPlant.ClosedLoopBase;
model OneDeviceWithWSE_heaPreVal
  "Simple chiller plant with a water-side economizer and one of each: chiller, cooling tower cell, condenser, and chiller water pump."
  extends ChillerPlant.BaseClasses.DataCenter;
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
        origin={270,119})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dp(start=214992),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={300,180})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TConWatRetSen(redeclare package
      Medium = Buildings.Media.Water, m_flow_nominal=mCW_flow_nominal)
    "Condenser water return temperature sensor"
    annotation (Placement(transformation(extent={{168,138},{188,158}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TChiWatSupSen(redeclare package
      Medium = Buildings.Media.Water, m_flow_nominal=mCHW_flow_nominal)
                                        "Chilled water supply tempeature" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={300,-72})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller
    heaPreCon(
    minHeaPreValPos=0.1,
    have_HeaPreConSig=false,
    have_WSE=true,
    fixSpePum=false,
    minChiLif=5,
    Ti=20)
    annotation (Placement(transformation(extent={{10,254},{50,294}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=1)
    annotation (Placement(transformation(extent={{-98,256},{-78,276}})));
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
        origin={156,184})));
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
      points={{270,130},{-210,130},{-210,86},{-164,86}},
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
  connect(TCWLeaTow.port_b, wse.port_a1)
                                        annotation (Line(
      points={{260,119},{260,120},{180,120},{180,99},{68,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCWLeaTow.port_b, chi.port_a1)
                                        annotation (Line(
      points={{260,119},{260,120},{240,120},{240,99},{216,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val4.port_b, cooTow.port_a) annotation (Line(
      points={{40,190},{40,239},{201,239}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val5.port_b, cooTow.port_a) annotation (Line(
      points={{156,194},{156,239},{201,239}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(cooTow.port_b,pumCW. port_a) annotation (Line(
      points={{221,239},{300,239},{300,190}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(pumCW.port_b, TCWLeaTow.port_a)
                                         annotation (Line(
      points={{300,170},{300,120},{280,120},{280,119}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(condenserWaterConstant.mConWatPumSet_flow, pumCW.m_flow_in)
    annotation (Line(points={{-56,210},{280,210},{280,180},{288,180}},
                                                             color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TConWatRetSen.port_a, val5.port_a) annotation (Line(points={{168,148},
          {156,148},{156,174}},           color={0,127,255},
      thickness=0.5));
  connect(chi.port_b1,TConWatRetSen. port_b) annotation (Line(points={{196,99},{
          194,99},{194,148},{188,148}},  color={0,128,255},
      thickness=0.5));
  connect(val6.port_b,TChiWatSupSen. port_a) annotation (Line(
      points={{300,30},{300,-62}},
      color={0,127,255},
      thickness=0.5));
  connect(cooCoi.port_a1, TChiWatSupSen.port_b) annotation (Line(
      points={{242,-164},{300,-164},{300,-82}},
      color={0,127,255},
      thickness=0.5));
  connect(con.y, heaPreCon.desConWatPumSpe) annotation (Line(points={{-76,266},{
          -26,266},{-26,270},{6,270}},    color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(chillerOnOff.yChi, heaPreCon.uChiHeaCon) annotation (Line(points={{-116,
          34},{-50,34},{-50,294},{6,294}}, color={255,0,255}));
  connect(waterSideEconomizerOnOff.ySta, heaPreCon.uWSE) annotation (Line(
        points={{-116,88},{-48,88},{-48,262},{6,262}}, color={255,0,255}));
  connect(TConWatRetSen.T, heaPreCon.TConWatRet) annotation (Line(points={{178,159},
          {-18,159},{-18,286},{6,286}}, color={0,0,127}));
  connect(TChiWatSupSen.T, heaPreCon.TChiWatSup) annotation (Line(points={{311,-72},
          {-12,-72},{-12,278},{6,278}}, color={0,0,127}));
  connect(heaPreCon.yHeaPreConVal, val5.y) annotation (Line(points={{54,274},{
          102,274},{102,184},{144,184}},
                                     color={0,0,127}));
  connect(wse.port_b1, val4.port_a) annotation (Line(points={{48,99},{42,99},{
          42,170},{40,170}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(file=
          "/home/milicag/repos/obc/examples/case_study_2/scripts/ClosedLoopBase/OneDeviceWithWSE_heaPreVal.mos"
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
end OneDeviceWithWSE_heaPreVal;
