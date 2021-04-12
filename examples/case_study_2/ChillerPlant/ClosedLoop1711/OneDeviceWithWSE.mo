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
    annotation (Placement(transformation(extent={{-54,-86},{20,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply
    chilledWaterReset(
    dpChiWatPumMin=0.2*20*6485,
    dpChiWatPumMax=1*20*6485,
    TChiWatSupMin=273.15 + 5.56,
    TChiWatSupMax=273.15 + 22)
    annotation (Placement(transformation(extent={{-160,-168},{-120,-128}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable
    plaEna(schTab=[0,1; 6*3600,1; 19*3600,1; 24*3600,1], TChiLocOut=271.15)
    annotation (Placement(transformation(extent={{-100,-220},{-80,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    annotation (Placement(transformation(extent={{-130,-220},{-110,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr
    "Generates requests"
    annotation (Placement(transformation(extent={{-160,-220},{-140,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant sigSub1(k=true)
    "Assume chiller is always available"
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal con2(realTrue=1,
      realFalse=0) "Boolean to real conversion of input signal"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal invCon(realTrue=0,
      realFalse=1) "Boolean to real conversion that inverts input signal"
    annotation (Placement(transformation(extent={{100,32},{120,52}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(t=0)
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant sigSub2(k=false)
    "Assume change process completes within the 15 minute stage change delay."
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(delta=60)
    annotation (Placement(transformation(extent={{-114,34},{-102,46}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Controller
    towCon(
    nChi=1,
    totChiSta=3,
    nTowCel=1,
    nConWatPum=1,
    closeCoupledPlant=true,
    desCap=742000,
    fanSpeMin=0.2,
    chiMinCap={140980},
    TiIntOpe=120,
    TiWSE=120,
    LIFT_min(displayUnit="K") = {5},
    TConWatSup_nominal={293.15},
    TConWatRet_nominal={303.15},
    TChiWatSupMin={278.71},
    TiCouPla=120,
    staVec={0,0.5,1},
    towCelOnSet={0,1,1})
    annotation (Placement(transformation(extent={{80,300},{140,420}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant sigSub3(k=false)
    "Assume change process completes within the 15 minute stage change delay."
    annotation (Placement(transformation(extent={{-20,330},{0,350}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    annotation (Placement(transformation(extent={{160,380},{180,400}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sigSub4(k=1)
    "Input signal filler, as these inputs have no effect for this plant"
    annotation (Placement(transformation(extent={{0,290},{20,310}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea1(delta=60)
    annotation (Placement(transformation(extent={{160,340},{180,360}})));
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
        origin={162,176})));
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
  connect(heaPreCon.yConWatPumSpeSet, pumCW.y) annotation (Line(points={{-16,188},
          {0,188},{0,196},{120,196},{120,200},{288,200}},
                                           color={0,0,127},
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
      points={{149,-80},{136,-80},{136,-94},{-200,-94},{-200,128},{-164,128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCHWEntChi.T,wseSta. TChiWatRetDow) annotation (Line(
      points={{149,2.22045e-15},{32,2.22045e-15},{32,94},{-190,94},{-190,120},{
          -164,120}},
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
      points={{-78,140},{-60,140},{-60,100},{34,100},{34,-30},{60,-30},{60,-48}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(yWSEOn.y, val4.y) annotation (Line(
      points={{-78,140},{-60,140},{-60,170},{20,170},{20,180},{28,180}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(yWSEOff.y, val1.y) annotation (Line(
      points={{-78,110},{84,110},{84,-40},{148,-40}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(VChiWatSen_flow.port_a, TChiWatSupSen.port_b) annotation (Line(
      points={{300,-98},{300,-82},{300,-82}},
      color={0,127,255},
      thickness=0.5));
  connect(wseSta.y, heaPreCon.uWSE) annotation (Line(
      points={{-118,120},{-110,120},{-110,180},{-80,180},{-80,188},{-64,188}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(chilledWaterReset.dpChiWatPumSet, pumCHW.dp_in) annotation (Line(
      points={{-116,-136},{-60,-136},{-60,-110},{120,-110},{120,-120},{148,-120}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chilledWaterReset.TChiWatSupSet, chi.TSet) annotation (Line(
      points={{-116,-160},{106,-160},{106,-220},{364,-220},{364,90},{218,90}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(plantOnOff.yChiWatPlaRes, chilledWaterReset.uChiWatPlaRes)
    annotation (Line(
      points={{-174,-210},{-168,-210},{-168,-148},{-164,-148}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(weaBus.TDryBul, plaEna.TOut) annotation (Line(
      points={{-282,-88},{-260,-88},{-260,-292},{-104,-292},{-104,-218},{-102,
          -218},{-102,-214.2}},
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
          -210},{-106,-210},{-106,-206},{-102,-206}},
                                             color={255,127,0}));
  connect(plaEna.yPla, staSetCon.uPla) annotation (Line(points={{-79,-210},{-70,
          -210},{-70,44},{-61.4,44}},          color={255,0,255}));
  connect(sigSub1.y, staSetCon.uChiAva[1]) annotation (Line(points={{-158,30},{
          -140,30},{-140,52},{-100,52},{-100,51.4286},{-61.4,51.4286}}, color={
          255,0,255}));
  connect(TChiWatSupSen.T, staSetCon.TChiWatSup) annotation (Line(points={{311,-72},
          {320,-72},{320,-90},{-104,-90},{-104,14.2857},{-61.4,14.2857}},
                                                                       color={0,0,127},
      pattern=LinePattern.DashDot));

  connect(chilledWaterReset.TChiWatSupSet, staSetCon.TChiWatSupSet) annotation (
     Line(points={{-116,-160},{-80,-160},{-80,21.7143},{-61.4,21.7143}},
                                                                    color={0,0,127},
      pattern=LinePattern.DashDot));

  connect(chilledWaterReset.dpChiWatPumSet, staSetCon.dpChiWatPumSet)
    annotation (Line(points={{-116,-136},{-90,-136},{-90,-30.2857},{-61.4,
          -30.2857}},               color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(chilledWaterReset.dpChiWatPumSet, staSetCon.dpChiWatPum) annotation (
      Line(points={{-116,-136},{-86,-136},{-86,-22.8571},{-61.4,-22.8571}},
                         color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(TCHWLeaCoi.T, staSetCon.TChiWatRet) annotation (Line(points={{149,-80},
          {136,-80},{136,-94},{-86,-94},{-86,-67.4286},{-61.4,-67.4286}},color={0,0,127},
      pattern=LinePattern.Dash));

  connect(staSetCon.yChiSet[1], chi.on) annotation (Line(points={{27.4,-19.1429},
          {50,-19.1429},{50,-20},{74,-20},{74,114},{228,114},{228,96},{218,96}},
                                                                color={255,0,255}));
  connect(staSetCon.yChiSet[1], con2.u) annotation (Line(points={{27.4,-19.1429},
          {74,-19.1429},{74,70},{98,70}},        color={255,0,255}));
  connect(staSetCon.yChiSet[1], invCon.u) annotation (Line(points={{27.4,
          -19.1429},{74,-19.1429},{74,42},{98,42}},
                                                  color={255,0,255}));
  connect(con2.y, val6.y) annotation (Line(points={{122,70},{260,70},{260,40},{
          288,40}},  color={0,0,127}));
  connect(invCon.y, valByp.y) annotation (Line(points={{122,42},{230,42},{230,
          32}},                   color={0,0,127}));
  connect(staSetCon.ySta, intGreThr.u) annotation (Line(points={{27.4,-45.1429},
          {27.4,-44},{32,-44},{32,-100},{-50,-100},{-50,-130},{-42,-130}},
                                                 color={255,127,0}));
  connect(intGreThr.y, pre.u) annotation (Line(points={{-18,-130},{-2,-130}},
                                 color={255,0,255}));
  connect(pre.y, booToInt1.u) annotation (Line(points={{22,-130},{38,-130}},
                                 color={255,0,255}));
  connect(booToInt1.y, staSetCon.uSta) annotation (Line(points={{62,-130},{70,
          -130},{70,-150},{-76,-150},{-76,36},{-70,36},{-70,32.8571},{-61.4,
          32.8571}},                                                 color={255,
          127,0}));
  connect(wseSta.y, staSetCon.uWseSta) annotation (Line(points={{-118,120},{
          -112,120},{-112,70},{-96,70},{-96,66.2857},{-61.4,66.2857}},  color={
          255,0,255}));
  connect(sigSub2.y, staSetCon.chaPro) annotation (Line(points={{-158,70},{-140,
          70},{-140,60},{-100,60},{-100,58.8571},{-61.4,58.8571}}, color={255,0,
          255}));
  connect(weaBus.TWetBul, staSetCon.TOutWet) annotation (Line(
      points={{-282,-88},{-270,-88},{-270,-41.4286},{-61.4,-41.4286}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(wseSta.yTunPar, staSetCon.uTunPar) annotation (Line(points={{-118,110},
          {-108,110},{-108,90},{-68,90},{-68,-48.8571},{-61.4,-48.8571}},
                                                   color={0,0,127}));
  connect(chi.port_b1, TConWatRetSen.port_b) annotation (Line(points={{196,99},
          {190,99},{190,140},{184,140}}, color={0,0,127}));
  connect(wseSta.TChiWatRetDowPre, movMea.u) annotation (Line(points={{-118,102},
          {-114,102},{-114,40},{-115.2,40}},
                                           color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(staSetCon.TWsePre, movMea.y) annotation (Line(points={{-61.4,-74.8571},
          {-61.4,-76},{-96,-76},{-96,40},{-100.8,40}},
                                               color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(pumCW.port_b, wse.port_a1) annotation (Line(
      points={{300,190},{300,120},{160,120},{160,99},{68,99}},
      color={0,128,255},
      thickness=0.5));
  connect(chi.port_a1, pumCW.port_b) annotation (Line(
      points={{216,99},{300,99},{300,190}},
      color={0,128,255},
      thickness=0.5));
  connect(staSetCon.yChiSet[1], heaPreCon.uChiHeaCon) annotation (Line(points={{27.4,
          -19.1429},{27.4,-18},{36,-18},{36,146},{-72,146},{-72,220},{-64,220}},
                 color={255,0,255}));
  connect(VChiWatSen_flow.V_flow, staSetCon.VChiWat_flow) annotation (Line(
      points={{311,-108},{320,-108},{320,-180},{-100,-180},{-100,-82.2857},{
          -61.4,-82.2857}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(booToInt1.y, towCon.uChiSta) annotation (Line(points={{62,-130},{40,
          -130},{40,340},{58,340},{58,339},{74,339}}, color={255,127,0}));
  connect(staSetCon.ySta, towCon.uChiStaSet) annotation (Line(points={{27.4,
          -45.1429},{27.4,334},{74,334},{74,333}}, color={255,127,0}));
  connect(sigSub3.y, towCon.uTowStaCha) annotation (Line(points={{2,340},{42,
          340},{42,327},{74,327}}, color={255,0,255}));
  connect(plaEna.yPla, towCon.uLeaConWatPum) annotation (Line(points={{-79,-210},
          {-76,-210},{-76,322},{74,322},{74,321}}, color={255,0,255}));
  connect(sigSub3.y, towCon.uChaCel[1]) annotation (Line(points={{2,340},{40,
          340},{40,315},{74,315}}, color={255,0,255}));
  connect(staSetCon.yChiSet, towCon.uChi) annotation (Line(points={{27.4,
          -19.1429},{27.4,410},{74,410},{74,411}}, color={255,0,255}));
  connect(wseSta.y, towCon.uWse) annotation (Line(points={{-118,120},{-112,120},
          {-112,405},{74,405}}, color={255,0,255}));
  connect(towCon.yLeaCel, pre1.u) annotation (Line(points={{146,393},{152,393},
          {152,390},{158,390}}, color={255,0,255}));
  connect(pre1.y, towCon.uTowSta[1]) annotation (Line(points={{182,390},{190,
          390},{190,442},{54,442},{54,369},{74,369}}, color={255,0,255}));
  connect(plaEna.yPla, towCon.uPla) annotation (Line(points={{-79,-210},{-80,
          -210},{-80,363},{74,363}}, color={255,0,255}));
  connect(heaPreCon.yMaxTowSpeSet, towCon.uMaxTowSpeSet[1]) annotation (Line(
        points={{-16,212},{32,212},{32,375},{74,375}}, color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(towCon.uConWatPumSpe[1], pumCW.y) annotation (Line(points={{74,351},{
          54,351},{54,210},{280,210},{280,200},{288,200}},
                                       color={0,0,127}));
  connect(sigSub4.y, towCon.uIsoVal[1]) annotation (Line(points={{22,300},{50,
          300},{50,309},{74,309}}, color={0,0,127}));
  connect(sigSub4.y, towCon.watLev) annotation (Line(points={{22,300},{50,300},
          {50,303},{74,303}}, color={0,0,127}));
  connect(TConWatRetSen.T, towCon.TConWatRet) annotation (Line(points={{174,151},
          {62,151},{62,356},{68,356},{68,357},{74,357}}, color={0,0,127}));
  connect(TChiWatSupSen.T, towCon.TChiWatSup) annotation (Line(points={{311,-72},
          {46,-72},{46,392},{60,392},{60,393},{74,393}}, color={0,0,127}));
  connect(chilledWaterReset.TChiWatSupSet, towCon.TChiWatSupSet) annotation (
      Line(points={{-116,-160},{-102,-160},{-102,388},{74,388},{74,387}}, color=
         {0,0,127}));
  connect(staSetCon.yCapReq, towCon.reqPlaCap) annotation (Line(points={{27.4,
          -82.2857},{27.4,381},{74,381}}, color={0,0,127}));
  connect(chi.QEva, towCon.chiLoa[1]) annotation (Line(points={{195,84},{195,
          112},{194,112},{194,194},{134,194},{134,282},{66,282},{66,346},{74,
          346},{74,417}},          color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chi.QEva, towCon.chiLoa[1]) annotation (Line(points={{195,84},{32,84},
          {32,416},{54,416},{54,417},{74,417}}, color={0,0,127}));
  connect(towCon.yFanSpe[1], movMea1.u)
    annotation (Line(points={{146,327},{158,327},{158,350}}, color={0,0,127}));
  connect(movMea1.y, towCon.uFanSpe) annotation (Line(points={{182,350},{202,
          350},{202,446},{48,446},{48,399},{74,399}}, color={0,0,127}));
  connect(movMea1.y, staSetCon.uTowFanSpeMax) annotation (Line(points={{182,350},
          {186,350},{186,290},{-92,290},{-92,-56.2857},{-61.4,-56.2857}}, color=
         {0,0,127}));
  connect(towCon.yFanSpe[1], cooTow.y) annotation (Line(points={{146,327},{174,
          327},{174,247},{199,247}}, color={0,0,127}));
  connect(movMea1.y, wseSta.uTowFanSpeMax) annotation (Line(
      points={{182,350},{202,350},{202,446},{-196,446},{-196,104},{-164,104}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(val4.port_b, cooTow.port_a) annotation (Line(
      points={{40,190},{40,239},{201,239}},
      color={0,127,255},
      thickness=0.5));
  connect(wse.port_b1, val4.port_a) annotation (Line(
      points={{48,99},{40,99},{40,170}},
      color={0,127,255},
      thickness=0.5));
  connect(TConWatRetSen.port_a, val5.port_a) annotation (Line(
      points={{164,140},{160,140},{160,166},{162,166}},
      color={0,127,255},
      thickness=0.5));
  connect(val5.port_b, cooTow.port_a) annotation (Line(
      points={{162,186},{162,239},{201,239}},
      color={0,127,255},
      thickness=0.5));
  connect(heaPreCon.yHeaPreConVal, val5.y) annotation (Line(
      points={{-16,200},{106,200},{106,176},{150,176}},
      color={0,0,127},
      pattern=LinePattern.Dot));
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
April xx, 2021, by Milica Grahovac:<br/>
Added 1711-based controls with the corresponding instrumentation and parametrization.
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-640,-300},{
            400,480}})),
    experiment(
      StopTime=700000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-640,-300},{400,480}})));
end OneDeviceWithWSE;
