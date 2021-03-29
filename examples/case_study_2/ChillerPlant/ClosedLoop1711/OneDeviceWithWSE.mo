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
    annotation (Placement(transformation(extent={{-240,-240},{-180,-180}})));

  Modelica.Blocks.Sources.Constant mFanFlo(k=mAir_flow_nominal)
    "Mass flow rate of fan" annotation (Placement(transformation(extent={{240,
            -210},{260,-190}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller
    heaPreCon(
    minHeaPreValPos=0.2,
    have_HeaPreConSig=false,
    have_WSE=true,
    fixSpePum=false,
    minChiLif=5,
    Ti=20)
    annotation (Placement(transformation(extent={{-60,180},{-20,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=1)
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TConWatRetSen(redeclare package
      Medium = Buildings.Media.Water,
    m_flow_nominal = mCW_flow_nominal)
    "Condenser water return temperature sensor"
    annotation (Placement(transformation(extent={{164,130},{184,150}})));
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
    wseSta(cooTowAppDes(displayUnit="K") = cooTowAppDes,
    TOutWetDes=TWetBulDes,
    VHeaExcDes_flow=mCHW_flow_nominal/rho_default)
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
    annotation (Placement(transformation(extent={{-54,-86},{22,74}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply
    chilledWaterReset(
    dpChiWatPumMin=0.2*20*6485,
    dpChiWatPumMax=1*20*6485,
    TChiWatSupMin=273.15 + 5.56,
    TChiWatSupMax=273.15 + 22)
    annotation (Placement(transformation(extent={{-160,-160},{-120,-120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable
    plaEna
    annotation (Placement(transformation(extent={{-80,-224},{-60,-204}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    annotation (Placement(transformation(extent={{-130,-220},{-110,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr
    "Generates requests"
    annotation (Placement(transformation(extent={{-160,-220},{-140,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant sigSub1(k=true)
    "Assume chiller is always available"
    annotation (Placement(transformation(extent={{-240,-20},{-220,0}})));
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
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant sigSub2(k=false)
    "Assume change process completes within the 15 minute stage change delay."
    annotation (Placement(transformation(extent={{-240,20},{-220,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sigSub(k=0.9)
    "Addresses a deficiency in 1711. Setting the value to enable a true signal generation in the Down controller. This is as current head pressure controller sets a constant maximum tower fan speed when have WSE"
    annotation (Placement(transformation(extent={{-240,-100},{-220,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(delta=60)
    annotation (Placement(transformation(extent={{-116,34},{-96,54}})));
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
      points={{230,-214},{230,-280},{-250,-280},{-250,-210},{-246,-210}},
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
  connect(val6.port_b, TChiWatSupSen.port_a) annotation (Line(
      points={{300,30},{300,-62}},
      color={0,127,255},
      thickness=0.5));
  connect(TConWatRetSen.T, heaPreCon.TConWatRet) annotation (Line(points={{174,151},
          {-74,151},{-74,212},{-64,212}}, color={0,0,127},
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
      points={{-116,-128},{116,-128},{116,-120},{148,-120}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chilledWaterReset.TChiWatSupSet, chi.TSet) annotation (Line(
      points={{-116,-152},{106,-152},{106,-220},{364,-220},{364,90},{218,90}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(plantOnOff.yChiWatPlaRes, chilledWaterReset.uChiWatPlaRes)
    annotation (Line(
      points={{-174,-210},{-168,-210},{-168,-140},{-164,-140}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(weaBus.TDryBul, plaEna.TOut) annotation (Line(
      points={{-282,-88},{-260,-88},{-260,-292},{-100,-292},{-100,-218},{-82,
          -218},{-82,-218.2}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(plantOnOff.yChiWatPlaRes, greThr.u)
    annotation (Line(points={{-174,-210},{-162,-210}}, color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(greThr.y, booToInt.u)
    annotation (Line(points={{-138,-210},{-132,-210}}, color={255,0,255}));
  connect(booToInt.y, plaEna.chiWatSupResReq) annotation (Line(points={{-108,
          -210},{-82,-210}},                 color={255,127,0}));
  connect(plaEna.yPla, staSetCon.uPla) annotation (Line(points={{-59,-214},{20,
          -214},{20,2},{-72,2},{-72,47.3333},{-61.6,47.3333}},
                                               color={255,0,255}));
  connect(sigSub1.y, staSetCon.uChiAva[1]) annotation (Line(points={{-218,-10},
          {-180,-10},{-180,8},{-172,8},{-172,54.9524},{-61.6,54.9524}}, color={
          255,0,255}));
  connect(TChiWatSupSen.T, staSetCon.TChiWatSup) annotation (Line(points={{311,-72},
          {316,-72},{316,-86},{-10,-86},{-10,16.8571},{-61.6,16.8571}},color={0,
          0,127}));
  connect(chilledWaterReset.TChiWatSupSet, staSetCon.TChiWatSupSet) annotation (
     Line(points={{-116,-152},{-76,-152},{-76,24.4762},{-61.6,24.4762}},
                                                                    color={0,0,
          127}));
  connect(chilledWaterReset.dpChiWatPumSet, staSetCon.dpChiWatPumSet)
    annotation (Line(points={{-116,-128},{-90,-128},{-90,-160},{-6,-160},{-6,
          -28.8571},{-61.6,-28.8571}},
                                    color={0,0,127}));
  connect(chilledWaterReset.dpChiWatPumSet, staSetCon.dpChiWatPum) annotation (
      Line(points={{-116,-128},{-84,-128},{-84,-156},{-44,-156},{-44,-21.2381},
          {-61.6,-21.2381}},
                         color={0,0,127}));
  connect(TCHWLeaCoi.T, staSetCon.TChiWatRet) annotation (Line(points={{149,-80},
          {-52,-80},{-52,-214},{-88,-214},{-88,-68},{-74,-68},{-74,-66.9524},{
          -61.6,-66.9524}},                                              color={
          0,0,127}));
  connect(staSetCon.yChiSet[1], chi.on) annotation (Line(points={{29.6,-17.4286},
          {126,-17.4286},{126,110},{234,110},{234,96},{218,96}},color={255,0,255}));
  connect(staSetCon.yChiSet[1], con2.u) annotation (Line(points={{29.6,-17.4286},
          {67.5,-17.4286},{67.5,-130},{78,-130}},color={255,0,255}));
  connect(staSetCon.yChiSet[1], invCon.u) annotation (Line(points={{29.6,
          -17.4286},{67.5,-17.4286},{67.5,-170},{78,-170}},
                                                  color={255,0,255}));
  connect(con2.y, val6.y) annotation (Line(points={{102,-130},{112,-130},{112,40},
          {288,40}}, color={0,0,127}));
  connect(invCon.y, valByp.y) annotation (Line(points={{102,-170},{118,-170},{118,
          50},{230,50},{230,32}}, color={0,0,127}));
  connect(staSetCon.ySta, intGreThr.u) annotation (Line(points={{29.6,-44.0952},
          {29.6,-170},{68,-170},{68,-266},{92,-266}},
                                                 color={255,127,0}));
  connect(intGreThr.y, pre.u) annotation (Line(points={{116,-266},{122,-266},{
          122,-266},{124,-266}}, color={255,0,255}));
  connect(pre.y, booToInt1.u) annotation (Line(points={{148,-266},{166,-266},{
          166,-272},{174,-272}}, color={255,0,255}));
  connect(booToInt1.y, staSetCon.uSta) annotation (Line(points={{198,-272},{210,
          -272},{210,-290},{-20,-290},{-20,36},{-40,36},{-40,35.9048},{-61.6,
          35.9048}},                                                 color={255,
          127,0}));
  connect(wseSta.y, staSetCon.uWseSta) annotation (Line(points={{-118,120},{
          -112,120},{-112,132},{-16,132},{-16,70.1905},{-61.6,70.1905}},color={
          255,0,255}));
  connect(sigSub2.y, staSetCon.chaPro) annotation (Line(points={{-218,30},{-180,
          30},{-180,12},{-172,12},{-172,62.5714},{-61.6,62.5714}}, color={255,0,
          255}));
  connect(weaBus.TWetBul, staSetCon.TOutWet) annotation (Line(
      points={{-282,-88},{-270,-88},{-270,-40.2857},{-61.6,-40.2857}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(wseSta.yTunPar, staSetCon.uTunPar) annotation (Line(points={{-118,110},
          {-108,110},{-108,90},{-68,90},{-68,-47.9048},{-61.6,-47.9048}},
                                                   color={0,0,127}));
  connect(sigSub.y, staSetCon.uTowFanSpeMax) annotation (Line(points={{-218,-90},
          {-210,-90},{-210,-55.5238},{-61.6,-55.5238}}, color={0,0,127}));
  connect(heaPreCon.yHeaPreConVal, val5.y) annotation (Line(points={{-16,200},{
          66,200},{66,180},{148,180}}, color={0,0,127}));
  connect(chi.port_b1, TConWatRetSen.port_b) annotation (Line(points={{196,99},
          {190,99},{190,140},{184,140}}, color={0,0,127}));
  connect(TConWatRetSen.port_a, val5.port_a) annotation (Line(points={{164,140},
          {160,140},{160,170}},           color={0,127,255},
      thickness=0.5));
  connect(val5.port_b, cooTow.port_a) annotation (Line(points={{160,190},{160,
          239},{201,239}}, color={0,128,255},
      thickness=0.5));
  connect(wseSta.TChiWatRetDowPre, movMea.u) annotation (Line(points={{-118,102},
          {-124,102},{-124,44},{-118,44}}, color={0,0,127}));
  connect(staSetCon.TWsePre, movMea.y) annotation (Line(points={{-61.6,-74.5714},
          {-61.6,-76},{-182,-76},{-182,-20},{-94,-20},{-94,44}},
                                               color={0,0,127}));
  connect(pumCW.port_b, wse.port_a1) annotation (Line(
      points={{300,190},{300,120},{160,120},{160,99},{68,99}},
      color={0,128,255},
      thickness=0.5));
  connect(chi.port_a1, pumCW.port_b) annotation (Line(
      points={{216,99},{300,99},{300,190}},
      color={0,128,255},
      thickness=0.5));
  connect(staSetCon.yChiSet[1], heaPreCon.uChiHeaCon) annotation (Line(points={
          {29.6,-17.4286},{29.6,29.2855},{-64,29.2855},{-64,220}}, color={255,0,
          255}));
  connect(VChiWatSen_flow.V_flow, staSetCon.VChiWat_flow) annotation (Line(
        points={{311,-108},{-104,-108},{-104,-82.1905},{-61.6,-82.1905}}, color
        ={0,0,127}));
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-640,-340},{
            400,340}})),
    experiment(
      StartTime=10000000,
      StopTime=22896000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-640,-340},{400,340}})));
end OneDeviceWithWSE;
