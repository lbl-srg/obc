within ChillerPlant.ClosedLoop1711;
model OneDeviceWithWSE_CWReset
  "Simple chiller plant with a water-side economizer. Base controls enhanced in 1711 CW reset."
  extends ChillerPlant.BaseClasses.DataCenter;
  extends ChillerPlant.BaseClasses.EnergyMonitoring;
  extends Modelica.Icons.Example;

  parameter Real dTChi(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=2.2
    "Deadband to avoid chiller short-cycling"
    annotation(Dialog(group="Design parameters"));

  ClosedLoopBase.BaseClasses.Controls.WaterSideEconomizerOnOff waterSideEconomizerOnOff(
      cooTowAppDes=cooTowAppDes)
    annotation (Placement(transformation(extent={{-160,80},{-120,120}})));

  ClosedLoopBase.BaseClasses.Controls.ChillerOnOff chillerOnOff(
    final dTChi=dTChi)
    annotation (Placement(transformation(extent={{-160,0},{-120,40}})));

  ClosedLoopBase.BaseClasses.Controls.ChilledWaterReset chilledWaterReset
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}})));

  ClosedLoopBase.BaseClasses.Controls.PlantOnOff plantOnOff
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}})));

  Modelica.Blocks.Sources.Constant mFanFlo(k=mAir_flow_nominal)
    "Mass flow rate of fan" annotation (Placement(transformation(extent={{240,
            -210},{260,-190}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller
    heaPreCon(
    have_HeaPreConSig=false,
    have_WSE=true,
    fixSpePum=false)
    annotation (Placement(transformation(extent={{-60,180},{-20,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=1)
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow(redeclare package Medium =
        MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower"      annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={270,119})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TConWatRetSen(redeclare package
      Medium = Buildings.Media.Water,
    m_flow_nominal = mCW_flow_nominal)
    "Condenser water return temperature sensor"
    annotation (Placement(transformation(extent={{168,230},{188,250}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TChiWatSupSen(redeclare package
      Medium = Buildings.Media.Water,
    m_flow_nominal = mCHW_flow_nominal) "Chilled water supply tempeature" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={300,-72})));
  Buildings.Fluid.Movers.SpeedControlled_y     pumCW(
    redeclare package Medium = Buildings.Media.Water,
    m_flow_small=0,
    dp(start=214992),
    redeclare Buildings.Fluid.Movers.Data.Generic per(pressure(V_flow={0,
            mCW_flow_nominal,2*mCW_flow_nominal}, dp={2*dp_nominal,dp_nominal,0})),
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Condenser water pump - fixme: check the pump characteristics in the record w MW"
                           annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={300,200})));

equation
  PSupFan = fan.P;
  PChiWatPum = pumCHW.P;
  PConWatPum = pumCW.P;
  PCooTowFan = cooTow.PFan;
  PChi = chi.P;
  QRooIntGai_flow = roo.QSou.Q_flow;
  mConWat_flow = pumCW.VMachine_flow * 995.586;
  mChiWat_flow = pumCHW.VMachine_flow * 995.586;

  connect(weaBus.TWetBul, cooTow.TAir) annotation (Line(
      points={{-282,-88},{-260,-88},{-260,260},{198,260},{198,243},{199,243}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

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
      points={{-116,20},{100,20},{100,180},{148,180}},
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
  connect(con.y, heaPreCon.desConWatPumSpe) annotation (Line(points={{-98,200},{
          -82,200},{-82,196},{-64,196}},  color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(chillerOnOff.yChi, heaPreCon.uChiHeaCon) annotation (Line(points={{
          -116,34},{-72,34},{-72,220},{-64,220}}, color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(heaPreCon.uWSE, waterSideEconomizerOnOff.ySta) annotation (Line(
        points={{-64,188},{-72,188},{-72,88},{-116,88}}, color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(heaPreCon.yMaxTowSpeSet, cooTow.y) annotation (Line(points={{-16,212},
          {90,212},{90,256},{194,256},{194,247},{199,247}},
                                        color={0,0,127},
      pattern=LinePattern.Dot));
  connect(heaPreCon.yConWatPumSpeSet, pumCW.y) annotation (Line(points={{-16,
          188},{0,188},{0,200},{288,200}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(pumCW.port_b,TCWLeaTow. port_a)
                                         annotation (Line(
      points={{300,190},{300,119},{280,119}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCWLeaTow.port_b, wse.port_a1)
                                        annotation (Line(
      points={{260,119},{78,119},{78,99},{68,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCWLeaTow.port_b, chi.port_a1)
                                        annotation (Line(
      points={{260,119},{240,119},{240,99},{216,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(cooTow.port_a, TConWatRetSen.port_b) annotation (Line(
      points={{201,239},{194,239},{194,240},{188,240}},
      color={0,127,255},
      thickness=0.5));
  connect(val4.port_b, TConWatRetSen.port_a) annotation (Line(
      points={{40,190},{40,240},{168,240}},
      color={0,127,255},
      thickness=0.5));
  connect(val5.port_b, TConWatRetSen.port_a) annotation (Line(
      points={{160,190},{160,240},{168,240}},
      color={0,127,255},
      thickness=0.5));
  connect(val6.port_b, TChiWatSupSen.port_a) annotation (Line(
      points={{300,30},{300,-62}},
      color={0,127,255},
      thickness=0.5));
  connect(TChiWatSupSen.port_b, cooCoi.port_a1) annotation (Line(
      points={{300,-82},{300,-164},{242,-164}},
      color={0,127,255},
      thickness=0.5));
  connect(TConWatRetSen.T, heaPreCon.TConWatRet) annotation (Line(points={{178,251},
          {-74,251},{-74,212},{-64,212}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TChiWatSupSen.T, heaPreCon.TChiWatSup) annotation (Line(points={{311,-72},
          {330,-72},{330,270},{-80,270},{-80,204},{-64,204}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(cooTow.port_b,pumCW. port_a) annotation (Line(
      points={{221,239},{300,239},{300,210}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  annotation (
    __Dymola_Commands(file=
          "/home/milicag/repos/obc/examples/case_study_2/scripts/ClosedLoop1711/OneDeviceWithWSE_CWReset.mos"
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
end OneDeviceWithWSE_CWReset;
