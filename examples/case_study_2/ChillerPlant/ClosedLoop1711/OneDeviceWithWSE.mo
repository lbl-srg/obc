within ChillerPlant.ClosedLoop1711;
model OneDeviceWithWSE
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

  ClosedLoopBase.BaseClasses.Controls.PlantOnOffWithAnalogueTrimAndRespond
    plantOnOff(TZonSupSet=TZonSupSet)
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}})));

  Modelica.Blocks.Sources.Constant mFanFlo(k=mAir_flow_nominal)
    "Mass flow rate of fan" annotation (Placement(transformation(extent={{240,
            -210},{260,-190}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller
    heaPreCon(
    have_HeaPreConSig=false,
    have_WSE=true,
    fixSpePum=false,
    minChiLif=5)
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
    annotation (Placement(transformation(extent={{164,132},{184,152}})));
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
    redeclare Buildings.Fluid.Movers.Data.Generic per(pressure(V_flow={0,1*
            mCW_flow_nominal,2*mCW_flow_nominal}*(mCW_flow_nominal/50)/
            rho_default, dp={2*dp_nominal,dp_nominal,0})),
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Condenser water pump - fixme: check the pump characteristics in the record w MW"
                           annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={300,200})));

  Buildings.Fluid.Sensors.VolumeFlowRate VChiWatSen_flow(redeclare package
      Medium = Buildings.Media.Water, final m_flow_nominal=mCHW_flow_nominal)
                                            "Chilled water supply volume flow rate sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={300,-108})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yWSEOff(realTrue=0,
      realFalse=1) "WSE is OFF signal"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yWSEOn
    "WSE is ON signal"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Controller
    wseSta
    annotation (Placement(transformation(extent={{-160,100},{-120,140}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController
    staSetCon(
    have_WSE=true,
    anyVsdCen=false,
    nChi=1,
    chiDesCap={742000},
    chiMinCap={140980},
    chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement},
    nSta=1,
    staMat={{1}},
    posDisMult=0.19,
    TDif=2)          "Single chiller with WSE staging controller"
    annotation (Placement(transformation(extent={{0,-206},{50,-102}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply
    chilledWaterReset(
    dpChiWatPumMin=0.2*20*6485,
    dpChiWatPumMax=1*20*6485,
    TChiWatSupMin=273.15 + 5.56,
    TChiWatSupMax=273.15 + 22)
    annotation (Placement(transformation(extent={{-160,-72},{-120,-32}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable
    plaEna
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr
    "Generates requests"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(k=true)
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal con2(realTrue=1,
      realFalse=0) "Boolean to real conversion of input signal"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal invCon(realTrue=0,
      realFalse=1) "Boolean to real conversion that inverts input signal"
    annotation (Placement(transformation(extent={{80,-180},{100,-160}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(t=0)
    annotation (Placement(transformation(extent={{94,-276},{114,-256}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{126,-276},{146,-256}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    annotation (Placement(transformation(extent={{176,-282},{196,-262}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(k=false)
    annotation (Placement(transformation(extent={{-64,-66},{-44,-46}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    annotation (Placement(transformation(extent={{64,38},{84,58}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(k=0.9)
    "Setting this to always provide a true signal in the Down controller, as there seems to be an error in 1711 due to constant max tower fan speed from the head pressure controller when have WSE"
    annotation (Placement(transformation(extent={{-90,-224},{-70,-204}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(samplePeriod=1000)
    annotation (Placement(transformation(extent={{-102,64},{-82,84}})));
equation
  PSupFan = fan.P;
  PChiWatPum = pumCHW.P;
  PConWatPum = pumCW.P;
  PCooTowFan = cooTow.PFan;
  PChi = chi.P;
  QRooIntGai_flow = roo.QSou.Q_flow;
  mConWat_flow = pumCW.VMachine_flow * rho_default;
  mChiWat_flow = pumCHW.VMachine_flow * rho_default;

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

  connect(TAirSup.T, plantOnOff.TZonSup) annotation (Line(
      points={{230,-214},{230,-200},{-240,-200},{-240,-120},{-224,-120}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(mFanFlo.y, fan.m_flow_in) annotation (Line(
      points={{261,-200},{280,-200},{280,-213}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(con.y, heaPreCon.desConWatPumSpe) annotation (Line(points={{-98,200},{
          -82,200},{-82,196},{-64,196}},  color={0,0,127},
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
  connect(val6.port_b, TChiWatSupSen.port_a) annotation (Line(
      points={{300,30},{300,-62}},
      color={0,127,255},
      thickness=0.5));
  connect(TConWatRetSen.T, heaPreCon.TConWatRet) annotation (Line(points={{174,153},
          {-74,153},{-74,212},{-64,212}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TChiWatSupSen.T, heaPreCon.TChiWatSup) annotation (Line(points={{311,-72},
          {330,-72},{330,270},{-80,270},{-80,204},{-64,204}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(cooTow.port_b,pumCW. port_a) annotation (Line(
      points={{221,239},{300,239},{300,210}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(QRooIntGai1_flow.y, QRooIntGaiAgg.u) annotation (Line(
      points={{-599,-10},{-562,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(VChiWatSen_flow.port_b, cooCoi.port_a1) annotation (Line(
      points={{300,-118},{300,-164},{242,-164}},
      color={0,127,255},
      thickness=0.5));
  connect(wseSta.y, yWSEOn.u) annotation (Line(
      points={{-118,120},{-110,120},{-110,140},{-102,140}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(wseSta.y, yWSEOff.u) annotation (Line(
      points={{-118,120},{-110,120},{-110,110},{-102,110}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(VChiWatSen_flow.V_flow,wseSta. VChiWat_flow) annotation (Line(
      points={{311,-108},{330,-108},{330,270},{-180,270},{-180,112},{-164,112}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCHWLeaCoi.T,wseSta. TChiWatRet) annotation (Line(
      points={{149,-80},{-200,-80},{-200,128},{-164,128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCHWEntChi.T,wseSta. TChiWatRetDow) annotation (Line(
      points={{149,2.22045e-15},{140,2.22045e-15},{140,-10},{-190,-10},{-190,
          120},{-164,120}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(weaBus.TWetBul,wseSta. TOutWet) annotation (Line(
      points={{-282,-88},{-260,-88},{-260,136},{-164,136}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(yWSEOn.y, val3.y) annotation (Line(
      points={{-78,140},{-60,140},{-60,-40},{60,-40},{60,-48}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(yWSEOn.y, val4.y) annotation (Line(
      points={{-78,140},{-60,140},{-60,170},{20,170},{20,180},{28,180}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(yWSEOff.y, val1.y) annotation (Line(
      points={{-78,110},{0,110},{0,-30},{100,-30},{100,-40},{148,-40}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(VChiWatSen_flow.port_a, TChiWatSupSen.port_b) annotation (Line(
      points={{300,-98},{300,-82},{300,-82}},
      color={0,127,255},
      thickness=0.5));
  connect(con.y, wseSta.uTowFanSpeMax) annotation (Line(
      points={{-98,200},{-90,200},{-90,250},{-170,250},{-170,104},{-164,104}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(wseSta.y, heaPreCon.uWSE) annotation (Line(
      points={{-118,120},{-110,120},{-110,180},{-80,180},{-80,188},{-64,188}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(chilledWaterReset.dpChiWatPumSet, pumCHW.dp_in) annotation (Line(
      points={{-116,-40},{116,-40},{116,-120},{148,-120}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chilledWaterReset.TChiWatSupSet, chi.TSet) annotation (Line(
      points={{-116,-64},{106,-64},{106,-220},{364,-220},{364,90},{218,90}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(plantOnOff.yChiWatPlaRes, chilledWaterReset.uChiWatPlaRes)
    annotation (Line(
      points={{-176,-120},{-170,-120},{-170,-52},{-164,-52}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(weaBus.TDryBul, plaEna.TOut) annotation (Line(
      points={{-282,-88},{-260,-88},{-260,-160},{-80,-160},{-80,-144.2},{-62,-144.2}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(plantOnOff.yChiWatPlaRes, greThr.u)
    annotation (Line(points={{-176,-120},{-162,-120}}, color={0,0,127}));
  connect(greThr.y, booToInt.u)
    annotation (Line(points={{-138,-120},{-122,-120}}, color={255,0,255}));
  connect(booToInt.y, plaEna.chiWatSupResReq) annotation (Line(points={{-98,-120},
          {-80,-120},{-80,-136},{-62,-136}}, color={255,127,0}));
  connect(plaEna.yPla, staSetCon.uPla) annotation (Line(points={{-39,-140},{-20,
          -140},{-20,-119.333},{-5,-119.333}}, color={255,0,255}));
  connect(con1.y, staSetCon.uChiAva[1]) annotation (Line(points={{-38,-110},{
          -22,-110},{-22,-114.381},{-5,-114.381}},
                                               color={255,0,255}));
  connect(TChiWatSupSen.T, staSetCon.TChiWatSup) annotation (Line(points={{311,-72},
          {316,-72},{316,-86},{-10,-86},{-10,-139.143},{-5,-139.143}}, color={0,
          0,127}));
  connect(chilledWaterReset.TChiWatSupSet, staSetCon.TChiWatSupSet) annotation (
     Line(points={{-116,-64},{-76,-64},{-76,-134.19},{-5,-134.19}}, color={0,0,
          127}));
  connect(chilledWaterReset.dpChiWatPumSet, staSetCon.dpChiWatPumSet)
    annotation (Line(points={{-116,-40},{-90,-40},{-90,-160},{-6,-160},{-6,
          -168.857},{-5,-168.857}}, color={0,0,127}));
  connect(chilledWaterReset.dpChiWatPumSet, staSetCon.dpChiWatPum) annotation (
      Line(points={{-116,-40},{-84,-40},{-84,-156},{-44,-156},{-44,-163.905},{
          -5,-163.905}}, color={0,0,127}));
  connect(VChiWatSen_flow.V_flow, staSetCon.VChiWat_flow) annotation (Line(
        points={{311,-108},{322,-108},{322,-208},{-36,-208},{-36,-203.524},{-5,
          -203.524}},
        color={0,0,127}));
  connect(TCHWLeaCoi.T, staSetCon.TChiWatRet) annotation (Line(points={{149,-80},
          {-28,-80},{-28,-194},{-16,-194},{-16,-193.619},{-5,-193.619}}, color={
          0,0,127}));
  connect(staSetCon.yChiSet[1], chi.on) annotation (Line(points={{55,-161.429},
          {126,-161.429},{126,110},{234,110},{234,96},{218,96}},color={255,0,255}));
  connect(staSetCon.yChiSet[1], con2.u) annotation (Line(points={{55,-161.429},
          {67.5,-161.429},{67.5,-130},{78,-130}},color={255,0,255}));
  connect(staSetCon.yChiSet[1], invCon.u) annotation (Line(points={{55,-161.429},
          {67.5,-161.429},{67.5,-170},{78,-170}}, color={255,0,255}));
  connect(con2.y, val6.y) annotation (Line(points={{102,-130},{112,-130},{112,40},
          {288,40}}, color={0,0,127}));
  connect(invCon.y, valByp.y) annotation (Line(points={{102,-170},{118,-170},{118,
          50},{230,50},{230,32}}, color={0,0,127}));
  connect(staSetCon.ySta, intGreThr.u) annotation (Line(points={{55,-178.762},{
          55,-178},{70,-178},{70,-266},{92,-266}},
                                                 color={255,127,0}));
  connect(intGreThr.y, pre.u) annotation (Line(points={{116,-266},{122,-266},{
          122,-266},{124,-266}}, color={255,0,255}));
  connect(pre.y, booToInt1.u) annotation (Line(points={{148,-266},{166,-266},{
          166,-272},{174,-272}}, color={255,0,255}));
  connect(booToInt1.y, staSetCon.uSta) annotation (Line(points={{198,-272},{210,
          -272},{210,-290},{-30,-290},{-30,-126.762},{-5,-126.762}}, color={255,
          127,0}));
  connect(wseSta.y, staSetCon.uWseSta) annotation (Line(points={{-118,120},{
          -112,120},{-112,132},{-16,132},{-16,-104.476},{-5,-104.476}}, color={
          255,0,255}));
  connect(con3.y, staSetCon.chaPro) annotation (Line(points={{-42,-56},{-22,-56},
          {-22,-109.429},{-5,-109.429}}, color={255,0,255}));
  connect(weaBus.TWetBul, staSetCon.TOutWet) annotation (Line(
      points={{-282,-88},{-270,-88},{-270,-176.286},{-5,-176.286}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pre1.y, heaPreCon.uChiHeaCon) annotation (Line(points={{86,48},{114,
          48},{114,168},{-72,168},{-72,220},{-64,220}}, color={255,0,255}));
  connect(staSetCon.yChiSet[1], pre1.u) annotation (Line(points={{55,-161.429},
          {55,-144},{64,-144},{64,-48},{62,-48},{62,48}}, color={255,0,255}));
  connect(wseSta.yTunPar, staSetCon.uTunPar) annotation (Line(points={{-118,110},
          {-62,110},{-62,-181.238},{-5,-181.238}}, color={0,0,127}));
  connect(wseSta.TChiWatRetDowPre, uniDel.u) annotation (Line(points={{-118,102},
          {-110,102},{-110,74},{-104,74}}, color={0,0,127}));
  connect(uniDel.y, staSetCon.TWsePre) annotation (Line(points={{-80,74},{-42,
          74},{-42,-198.571},{-5,-198.571}}, color={0,0,127}));
  connect(con4.y, staSetCon.uTowFanSpeMax) annotation (Line(points={{-68,-214},
          {-36,-214},{-36,-186.19},{-5,-186.19}}, color={0,0,127}));
  connect(heaPreCon.yHeaPreConVal, val5.y) annotation (Line(points={{-16,200},{
          66,200},{66,180},{148,180}}, color={0,0,127}));
  connect(chi.port_b1, TConWatRetSen.port_b) annotation (Line(points={{196,99},
          {190,99},{190,142},{184,142}}, color={0,0,127}));
  connect(TConWatRetSen.port_a, val5.port_a) annotation (Line(points={{164,142},
          {164,155},{160,155},{160,170}}, color={0,127,255}));
  connect(val5.port_b, cooTow.port_a) annotation (Line(points={{160,190},{160,
          239},{201,239}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(file=
          "/home/milicag/repos/obc/examples/case_study_2/scripts/ClosedLoop1711/OneDeviceWithWSE.mos"
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
      StartTime=17046400,
      StopTime=22651200,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-640,-300},{400,300}})));
end OneDeviceWithWSE;
