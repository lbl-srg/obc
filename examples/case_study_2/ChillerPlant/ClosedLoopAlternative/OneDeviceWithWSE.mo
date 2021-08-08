within ChillerPlant.ClosedLoopAlternative;
model OneDeviceWithWSE
  "Simple chiller plant with a water-side economizer. Alternative controller based on 1711"
  extends ChillerPlant.BaseClasses.DataCenter(
    expVesCHW(p=100000),
    chi(
      m1_flow_nominal=mCW_flow_nominal/2,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes()),
    wse(m1_flow_nominal=mCW_flow_nominal/2),
    val3(dpValve_nominal=200, dpFixed_nominal=800),
    val1(dpValve_nominal=200, dpFixed_nominal=800),
    val6(dpValve_nominal=200, dpFixed_nominal=3300),
    valByp(dpValve_nominal=200, dpFixed_nominal=3300),
    pumCHW(dp_nominal=1000 + 12000 + 15000 + 3500 + 24000),
    roo(nPorts=2));

  extends ChillerPlant.BaseClasses.EnergyMonitoring;
  extends Modelica.Icons.Example;

  parameter Real dTChi(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=2.2
    "Deadband to avoid chiller short-cycling"
    annotation(Dialog(group="Design parameters"));

  ChillerPlant.ClosedLoopBase.BaseClasses.Controls.PlantOnOffWithAnalogueTrimAndRespond
    plantOnOff(TZonSupSet=TZonSupSet)
    annotation (Placement(transformation(extent={{-300,-240},{-240,-180}})));

  Modelica.Blocks.Sources.Constant mFanFlo(k=mAir_flow_nominal)
    "Mass flow rate of fan" annotation (Placement(transformation(extent={{240,
            -210},{260,-190}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller
    heaPreCon(
    minConWatPumSpe=1,
    minHeaPreValPos=0.2,
    have_HeaPreConSig=false,
    have_WSE=true,
    fixSpePum=false,
    minChiLif=5,
    Ti=20)
    annotation (Placement(transformation(extent={{-60,180},{-20,220}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TConWatRetSen(redeclare package
      Medium = Buildings.Media.Water, m_flow_nominal=mCW_flow_nominal/2)
    "Condenser water return temperature sensor"
    annotation (Placement(transformation(extent={{164,130},{184,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TChiWatSupSen(redeclare package
      Medium = Buildings.Media.Water,
    m_flow_nominal = mCHW_flow_nominal) "Chilled water supply tempeature" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={300,-72})));

  Buildings.Fluid.Sensors.VolumeFlowRate VChiWatSen_flow(redeclare package
      Medium = Buildings.Media.Water, final m_flow_nominal=mCHW_flow_nominal)
                                            "Chilled water supply volume flow rate sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={300,-108})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yWSEOff(realTrue=0,
      realFalse=1) "WSE is OFF signal"
    annotation (Placement(transformation(extent={{-132,116},{-124,124}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yWSEOn
    "WSE is ON signal"
    annotation (Placement(transformation(extent={{-132,136},{-124,144}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Controller
    wseSta(
    cooTowAppDes(displayUnit="K") = cooTowAppDes,
    TOutWetDes=TWetBulDes,
    VHeaExcDes_flow=mCHW_flow_nominal/rho_default)
    annotation (Placement(transformation(extent={{-240,100},{-200,140}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController
    staSetCon(
    have_WSE=true,
    anyVsdCen=false,
    nChi=1,
    chiDesCap={471000},
    chiMinCap={0.1*471000},
    chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement},
    nSta=1,
    staMat={{1}},
    posDisMult=0.19,
    smallTDif=2.2,
    largeTDif(displayUnit="degC") = 2.2,
    TDif=2)          "Single chiller with WSE staging controller"
    annotation (Placement(transformation(extent={{-58,-44},{-18,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply
    chilledWaterReset(
    dpChiWatPumMin=0.1*20*6485,
    dpChiWatPumMax=1*20*6485,
    TChiWatSupMin=273.15 + 5.56,
    TChiWatSupMax=273.15 + 22) "Chilled water reset controller"
    annotation (Placement(transformation(extent={{-200,-152},{-160,-112}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable
    plaEna(schTab=[0,1; 6*3600,1; 19*3600,1; 24*3600,1], TChiLocOut=271.15)
    annotation (Placement(transformation(extent={{-138,-220},{-118,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    annotation (Placement(transformation(extent={{-180,-220},{-160,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(h=0.1)
    "Generates requests"
    annotation (Placement(transformation(extent={{-220,-220},{-200,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant sigSub1(k=true)
    "Assume chiller is always available"
    annotation (Placement(transformation(extent={{-320,20},{-300,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal con2(realTrue=1,
      realFalse=0) "Boolean to real conversion of input signal"
    annotation (Placement(transformation(extent={{0,54},{12,66}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal invCon(realTrue=0,
      realFalse=1) "Boolean to real conversion that inverts input signal"
    annotation (Placement(transformation(extent={{0,34},{12,46}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(t=0)
    annotation (Placement(transformation(extent={{-50,-70},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{-30,-70},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    annotation (Placement(transformation(extent={{-10,-70},{0,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant sigSub2(k=false)
    "Assume change process completes within the 15 minute stage change delay."
    annotation (Placement(transformation(extent={{-320,60},{-300,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(delta=60)
    annotation (Placement(transformation(extent={{-180,34},{-168,46}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Controller
    towCon(
    nChi=1,
    totChiSta=3,
    nTowCel=1,
    nConWatPum=1,
    closeCoupledPlant=true,
    desCap=471000,
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
    towCelOnSet={0,1,1}) "Cooling tower fan speed controller"
    annotation (Placement(transformation(extent={{54,332},{100,432}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant sigSub3(k=false)
    "Assume change process completes within the 15 minute stage change delay."
    annotation (Placement(transformation(extent={{-100,360},{-80,380}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    annotation (Placement(transformation(extent={{140,410},{160,430}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sigSub4(k=1)
    "Input signal substitute, as these inputs have no effect for this plant configuration"
    annotation (Placement(transformation(extent={{-100,320},{-80,340}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea1(delta=60)
    annotation (Placement(transformation(extent={{140,370},{160,390}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val5(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal/2,
    dpValve_nominal=6000,
    dpFixed_nominal=2165,
    y_start=1,
    use_inputFilter=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={162,178})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal/2,
    dpValve_nominal=200,
    y_start=0,
    use_inputFilter=false,
    dpFixed_nominal=1965)
    "Control valve for condenser water loop of economizer" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={48,170})));
  Buildings.Fluid.Sources.Boundary_pT expVesCHW1(redeclare package Medium =
        MediumW,
    p=100000,    nPorts=1) "Represents an expansion vessel"
    annotation (Placement(transformation(extent={{230,259},{250,279}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Emulates a two stage pump, one for WSE only operation, and the other one for the integrated operation"
    annotation (Placement(transformation(extent={{-280,182},{-260,202}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=0.5,
      realFalse=0)
    annotation (Placement(transformation(extent={{-320,160},{-300,180}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dp(start=42000 + 1965*2 + 6000 + 200 + 42000 + 15000),
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={300,170})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=mCW_flow_nominal)
    annotation (Placement(transformation(extent={{0,182},{12,194}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(realTrue=0.5,
      realFalse=0)
    annotation (Placement(transformation(extent={{-320,200},{-300,220}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal    booToRea2
    annotation (Placement(transformation(extent={{-80,-220},{-60,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Enables WSE if the plant is enabled and the WSE enable conditions are satisfied"
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
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
      points={{-330,-90},{-330,262},{198,262},{198,243},{197,243}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(TAirSup.T, plantOnOff.TZonSup) annotation (Line(
      points={{230,-214},{230,-204},{140,-204},{140,-258},{-322,-258},{-322,
          -210},{-306,-210}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(mFanFlo.y, fan.m_flow_in) annotation (Line(
      points={{261,-200},{280,-200},{280,-213}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(val6.port_b, TChiWatSupSen.port_a) annotation (Line(
      points={{300,30},{300,-62}},
      color={0,127,255},
      thickness=0.5));
  connect(TConWatRetSen.T, heaPreCon.TConWatRet) annotation (Line(points={{174,151},
          {62,151},{62,146},{-70,146},{-70,212},{-64,212}},
                                          color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TChiWatSupSen.T, heaPreCon.TChiWatSup) annotation (Line(points={{311,-72},
          {330,-72},{330,308},{-80,308},{-80,204},{-64,204}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(VChiWatSen_flow.port_b, cooCoi.port_a1) annotation (Line(
      points={{300,-118},{300,-164},{242,-164}},
      color={0,127,255},
      thickness=0.5));
  connect(VChiWatSen_flow.V_flow,wseSta. VChiWat_flow) annotation (Line(
      points={{311,-108},{330,-108},{330,308},{-254,308},{-254,112},{-244,112}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCHWLeaCoi.T,wseSta. TChiWatRet) annotation (Line(
      points={{149,-80},{136,-80},{136,-92},{-270,-92},{-270,128},{-244,128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCHWEntChi.T,wseSta. TChiWatRetDow) annotation (Line(
      points={{149,2.22045e-15},{32,2.22045e-15},{32,88},{-260,88},{-260,120},{
          -244,120}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(weaBus.TWetBul,wseSta. TOutWet) annotation (Line(
      points={{-330,-90},{-330,136},{-244,136}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(yWSEOn.y, val3.y) annotation (Line(
      points={{-123.2,140},{20,140},{20,-40},{60,-40},{60,-48}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(yWSEOn.y, val4.y) annotation (Line(
      points={{-123.2,140},{-40,140},{-40,170},{36,170}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(yWSEOff.y, val1.y) annotation (Line(
      points={{-123.2,120},{18,120},{18,-40},{148,-40}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(VChiWatSen_flow.port_a, TChiWatSupSen.port_b) annotation (Line(
      points={{300,-98},{300,-82},{300,-82}},
      color={0,127,255},
      thickness=0.5));
  connect(chilledWaterReset.TChiWatSupSet, chi.TSet) annotation (Line(
      points={{-156,-144},{112,-144},{112,70},{238,70},{238,90},{218,90}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(plantOnOff.yChiWatPlaRes, chilledWaterReset.uChiWatPlaRes)
    annotation (Line(
      points={{-234,-210},{-228,-210},{-228,-132},{-204,-132}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(weaBus.TDryBul, plaEna.TOut) annotation (Line(
      points={{-330,-90},{-330,-280},{-150,-280},{-150,-218},{-140,-218},{-140,
          -214.2}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(plantOnOff.yChiWatPlaRes, greThr.u)
    annotation (Line(points={{-234,-210},{-222,-210}}, color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(greThr.y, booToInt.u)
    annotation (Line(points={{-198,-210},{-182,-210}}, color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(booToInt.y, plaEna.chiWatSupResReq) annotation (Line(points={{-158,
          -210},{-146,-210},{-146,-206},{-140,-206}},
                                             color={255,127,0},
      pattern=LinePattern.DashDot));
  connect(plaEna.yPla, staSetCon.uPla) annotation (Line(points={{-117,-210},{
          -110,-210},{-110,26},{-62,26}},      color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(sigSub1.y, staSetCon.uChiAva[1]) annotation (Line(points={{-298,30},{
          -62,30}},                                                     color={255,0,
          255},
      pattern=LinePattern.DashDot));
  connect(TChiWatSupSen.T, staSetCon.TChiWatSup) annotation (Line(points={{311,-72},
          {330,-72},{330,-90},{-154,-90},{-154,10},{-62,10}},          color={0,0,127},
      pattern=LinePattern.Dash));

  connect(chilledWaterReset.TChiWatSupSet, staSetCon.TChiWatSupSet) annotation (
     Line(points={{-156,-144},{-80,-144},{-80,14},{-62,14}},        color={0,0,127},
      pattern=LinePattern.DashDot));

  connect(chilledWaterReset.dpChiWatPumSet, staSetCon.dpChiWatPumSet)
    annotation (Line(points={{-156,-120},{-90,-120},{-90,-14},{-62,-14}},
                                    color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(chilledWaterReset.dpChiWatPumSet, staSetCon.dpChiWatPum) annotation (
      Line(points={{-156,-120},{-86,-120},{-86,-10},{-62,-10}},
                         color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(TCHWLeaCoi.T, staSetCon.TChiWatRet) annotation (Line(points={{149,-80},
          {136,-80},{136,-94},{-86,-94},{-86,-34},{-62,-34}},            color={0,0,127},
      pattern=LinePattern.Dash));

  connect(staSetCon.yChiSet[1], chi.on) annotation (Line(points={{-14,-8},{100,
          -8},{100,80},{230,80},{230,96},{218,96}},             color={255,0,
          255},
      pattern=LinePattern.Dot));
  connect(staSetCon.yChiSet[1], con2.u) annotation (Line(points={{-14,-8},{-8,
          -8},{-8,60},{-1.2,60}},                color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(staSetCon.yChiSet[1], invCon.u) annotation (Line(points={{-14,-8},{-8,
          -8},{-8,40},{-1.2,40}},                 color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(con2.y, val6.y) annotation (Line(points={{13.2,60},{260,60},{260,40},
          {288,40}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(invCon.y, valByp.y) annotation (Line(points={{13.2,40},{230,40},{230,
          32}},                   color={0,0,127},
      pattern=LinePattern.Dot));
  connect(staSetCon.ySta, intGreThr.u) annotation (Line(points={{-14,-22},{0,
          -22},{0,-52},{-60,-52},{-60,-65},{-51,-65}},
                                                 color={255,127,0},
      pattern=LinePattern.DashDot));
  connect(intGreThr.y, pre.u) annotation (Line(points={{-39,-65},{-31,-65}},
                                 color={255,0,255}));
  connect(pre.y, booToInt1.u) annotation (Line(points={{-19,-65},{-11,-65}},
                                 color={255,0,255}));
  connect(booToInt1.y, staSetCon.uSta) annotation (Line(points={{1,-65},{20,-65},
          {20,-80},{-74,-80},{-74,20},{-62,20}},                     color={255,127,
          0},
      pattern=LinePattern.DashDot));
  connect(sigSub2.y, staSetCon.chaPro) annotation (Line(points={{-298,70},{-100,
          70},{-100,34},{-62,34}},                                 color={255,0,
          255},
      pattern=LinePattern.DashDot));
  connect(weaBus.TWetBul, staSetCon.TOutWet) annotation (Line(
      points={{-330,-90},{-330,-42},{-196,-42},{-196,-20},{-62,-20}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(wseSta.yTunPar, staSetCon.uTunPar) annotation (Line(points={{-198,110},
          {-108,110},{-108,88},{-68,88},{-68,-24},{-62,-24}},
                                                   color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(chi.port_b1, TConWatRetSen.port_b) annotation (Line(points={{196,99},
          {190,99},{190,140},{184,140}}, color={28,108,200},
      thickness=0.5));
  connect(wseSta.TChiWatRetDowPre, movMea.u) annotation (Line(points={{-198,102},
          {-194,102},{-194,40},{-181.2,40}},
                                           color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(staSetCon.TWsePre, movMea.y) annotation (Line(points={{-62,-38},{-160,
          -38},{-160,40},{-166.8,40}},         color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(staSetCon.yChiSet[1], heaPreCon.uChiHeaCon) annotation (Line(points={{-14,-8},
          {24,-8},{24,152},{-76,152},{-76,220},{-64,220}},
                 color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(VChiWatSen_flow.V_flow, staSetCon.VChiWat_flow) annotation (Line(
      points={{311,-108},{328,-108},{328,-264},{-146,-264},{-146,-42},{-62,-42}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(booToInt1.y, towCon.uChiSta) annotation (Line(points={{1,-65},{34,-65},
          {34,364.5},{49.4,364.5}},                   color={255,127,0},
      pattern=LinePattern.DashDot));
  connect(staSetCon.ySta, towCon.uChiStaSet) annotation (Line(points={{-14,-22},
          {28,-22},{28,360},{49.4,360},{49.4,359.5}},
                                                   color={255,127,0},
      pattern=LinePattern.DashDot));
  connect(sigSub3.y, towCon.uTowStaCha) annotation (Line(points={{-78,370},{-70,
          370},{-70,354.5},{49.4,354.5}},
                                   color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(plaEna.yPla, towCon.uLeaConWatPum) annotation (Line(points={{-117,-210},
          {-112,-210},{-112,350},{49.4,350},{49.4,349.5}},
                                                   color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(sigSub3.y, towCon.uChaCel[1]) annotation (Line(points={{-78,370},{-60,
          370},{-60,344.5},{49.4,344.5}},
                                   color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(staSetCon.yChiSet, towCon.uChi) annotation (Line(points={{-14,-8},{26,
          -8},{26,402},{49.4,402},{49.4,424.5}},   color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(towCon.yLeaCel, pre1.u) annotation (Line(points={{104.6,409.5},{120,
          409.5},{120,420},{138,420}},
                                color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(pre1.y, towCon.uTowSta[1]) annotation (Line(points={{162,420},{176,
          420},{176,466},{30,466},{30,389.5},{49.4,389.5}},
                                                      color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(plaEna.yPla, towCon.uPla) annotation (Line(points={{-117,-210},{-110,
          -210},{-110,384.5},{49.4,384.5}},
                                     color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(heaPreCon.yMaxTowSpeSet, towCon.uMaxTowSpeSet[1]) annotation (Line(
        points={{-16,212},{32,212},{32,394.5},{49.4,394.5}},
                                                       color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(sigSub4.y, towCon.uIsoVal[1]) annotation (Line(points={{-78,330},{-60,
          330},{-60,339.5},{49.4,339.5}},
                                   color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(sigSub4.y, towCon.watLev) annotation (Line(points={{-78,330},{-60,330},
          {-60,334.5},{49.4,334.5}},
                              color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(TConWatRetSen.T, towCon.TConWatRet) annotation (Line(points={{174,151},
          {80,151},{80,300},{-50,300},{-50,379.5},{49.4,379.5}},
                                                         color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TChiWatSupSen.T, towCon.TChiWatSup) annotation (Line(points={{311,-72},
          {330,-72},{330,308},{-40,308},{-40,409.5},{49.4,409.5}},
                                                         color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chilledWaterReset.TChiWatSupSet, towCon.TChiWatSupSet) annotation (
      Line(points={{-156,-144},{-106,-144},{-106,404},{49.4,404},{49.4,404.5}},
                                                                          color={0,0,127},
      pattern=LinePattern.DashDot));

  connect(staSetCon.yCapReq, towCon.reqPlaCap) annotation (Line(points={{-14,-42},
          {30,-42},{30,399.5},{49.4,399.5}},
                                          color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(chi.QEva, towCon.chiLoa[1]) annotation (Line(points={{195,84},{195,86},
          {192,86},{192,280},{-34,280},{-34,370},{49.4,370},{49.4,429.5}},
                                   color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chi.QEva, towCon.chiLoa[1]) annotation (Line(points={{195,84},{32,84},
          {32,429.5},{49.4,429.5}},             color={0,0,127},
      pattern=LinePattern.Dash));
  connect(towCon.yFanSpe[1], movMea1.u)
    annotation (Line(points={{104.6,354.5},{120,354.5},{120,380},{138,380}},
                                                             color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(movMea1.y, towCon.uFanSpe) annotation (Line(points={{162,380},{180,
          380},{180,474},{24,474},{24,428},{50,428},{50,414.5},{49.4,414.5}},
                                                      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(movMea1.y, staSetCon.uTowFanSpeMax) annotation (Line(points={{162,380},
          {180,380},{180,300},{-92,300},{-92,-28},{-62,-28}},             color={0,0,127},
      pattern=LinePattern.DashDot));

  connect(towCon.yFanSpe[1], cooTow.y) annotation (Line(points={{104.6,354.5},{160,
          354.5},{160,260},{200,260},{200,247},{197,247}},
                                     color={0,0,127},
      pattern=LinePattern.Dot));
  connect(movMea1.y, wseSta.uTowFanSpeMax) annotation (Line(
      points={{162,380},{180,380},{180,474},{-248,474},{-248,104},{-244,104}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(val4.port_b, cooTow.port_a) annotation (Line(
      points={{48,180},{48,239},{199,239}},
      color={0,127,255},
      thickness=0.5));
  connect(wse.port_b1, val4.port_a) annotation (Line(
      points={{48,99},{48,160}},
      color={0,127,255},
      thickness=0.5));
  connect(TConWatRetSen.port_a, val5.port_a) annotation (Line(
      points={{164,140},{162,140},{162,168}},
      color={0,127,255},
      thickness=0.5));
  connect(val5.port_b, cooTow.port_a) annotation (Line(
      points={{162,188},{162,239},{199,239}},
      color={0,127,255},
      thickness=0.5));
  connect(expVesCHW1.ports[1], cooTow.port_b) annotation (Line(
      points={{250,269},{250,239},{219,239}},
      color={0,127,255},
      thickness=0.5));
  connect(add2.y, heaPreCon.desConWatPumSpe) annotation (Line(points={{-258,192},
          {-86,192},{-86,196},{-64,196}}, color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(booToRea.y, add2.u2) annotation (Line(points={{-298,170},{-292,170},{
          -292,186},{-282,186}}, color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(staSetCon.yChiSet[1], booToRea.u) annotation (Line(points={{-14,-8},{
          24,-8},{24,152},{-324,152},{-324,170},{-322,170}},
        color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(cooTow.port_b, pumCW.port_a) annotation (Line(
      points={{219,239},{300,239},{300,180}},
      color={0,127,255},
      thickness=0.5));
  connect(heaPreCon.yConWatPumSpeSet, gai.u) annotation (Line(points={{-16,188},
          {-1.2,188}},                                    color={0,0,127},
      pattern=LinePattern.Dot));
  connect(gai.y, pumCW.m_flow_in)
    annotation (Line(points={{13.2,188},{260,188},{260,170},{288,170}},
                                                   color={0,0,127},
      pattern=LinePattern.Dot));
  connect(sigSub4.y, towCon.uConWatPumSpe[1]) annotation (Line(points={{-78,330},
          {-60,330},{-60,374.5},{49.4,374.5}},
                                       color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(booToRea1.y, add2.u1) annotation (Line(points={{-298,210},{-290,210},
          {-290,198},{-282,198}}, color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(pumCHW.dp_in, pro.y)
    annotation (Line(points={{148,-120},{142,-120}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chilledWaterReset.dpChiWatPumSet, pro.u1) annotation (Line(points={{-156,
          -120},{-68,-120},{-68,-108},{100,-108},{100,-114},{118,-114}},
        color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(booToRea2.y, pro.u2) annotation (Line(points={{-58,-210},{100,-210},{
          100,-126},{118,-126}}, color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(plaEna.yPla, booToRea2.u)
    annotation (Line(points={{-117,-210},{-82,-210}},color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(plaEna.yPla, and2.u1) annotation (Line(points={{-117,-210},{-110,-210},
          {-110,6},{-190,6},{-190,130},{-182,130}},
                                  color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(wseSta.y, and2.u2) annotation (Line(points={{-198,120},{-192,120},{
          -192,122},{-182,122}}, color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(and2.y, yWSEOn.u) annotation (Line(points={{-158,130},{-140,130},{
          -140,140},{-132.8,140}},
                           color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(and2.y, yWSEOff.u) annotation (Line(points={{-158,130},{-140,130},{
          -140,120},{-132.8,120}},   color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(and2.y, booToRea1.u) annotation (Line(points={{-158,130},{-150,130},{
          -150,238},{-326,238},{-326,210},{-322,210}},
                                            color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(and2.y, heaPreCon.uWSE) annotation (Line(points={{-158,130},{-150,130},
          {-150,188},{-64,188}},color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(and2.y, towCon.uWse) annotation (Line(points={{-158,130},{-110,130},{
          -110,419.5},{49.4,419.5}},
                               color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(and2.y, staSetCon.uWseSta) annotation (Line(points={{-158,130},{-150,
          130},{-150,38},{-62,38}},        color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(roo.airPorts[2], cooCoi.port_a2) annotation (Line(
      points={{190.45,-229.3},{186,-229.3},{186,-226},{160,-226},{160,-176},{
          222,-176}},
      color={0,127,255},
      thickness=0.5));
  connect(heaPreCon.yHeaPreConVal, val5.y) annotation (Line(
      points={{-16,200},{120,200},{120,178},{150,178}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(wse.port_a1, pumCW.port_b) annotation (Line(
      points={{68,99},{180,99},{180,114},{300,114},{300,160}},
      color={0,127,255},
      thickness=0.5));
  connect(pumCW.port_b, chi.port_a1) annotation (Line(
      points={{300,160},{300,99},{216,99}},
      color={0,127,255},
      thickness=0.5));
  annotation (
    __Dymola_Commands(file=
          "/home/milicag/repos/obc/examples/case_study_2/scripts/ClosedLoopAlternative/OneDeviceWithWSE.mos"
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
    Diagram(coordinateSystem(
      preserveAspectRatio=false, extent={{-640,-300},{400,480}})),
    experiment(
      StopTime=33651200,
      Tolerance=1e-05,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end OneDeviceWithWSE;
