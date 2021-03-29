within ChillerPlant.ClosedLoop1711;
model OneDeviceWithWSE_WSEOnOff
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

  ClosedLoopBase.BaseClasses.Controls.CondenserWaterConstant condenserWaterConstant(
      mCW_flow_nominal=mCW_flow_nominal)
    annotation (Placement(transformation(extent={{-100,200},{-60,240}})));
  ClosedLoopBase.BaseClasses.Controls.ChillerOnOff chillerOnOff(dTChi=dTChi)
    annotation (Placement(transformation(extent={{-160,0},{-120,40}})));
  ClosedLoopBase.BaseClasses.Controls.PlantOnOffWithAnalogueTrimAndRespond
    plantOnOff(TZonSupSet=TZonSupSet)
    annotation (Placement(transformation(extent={{-240,-160},{-180,-100}})));
  Modelica.Blocks.Sources.Constant mFanFlo(k=mAir_flow_nominal)
    "Mass flow rate of fan" annotation (Placement(transformation(extent={{240,
            -210},{260,-190}})));
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
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Controller
    wseSta(
    cooTowAppDes(displayUnit="K") = cooTowAppDes,
    TOutWetDes=TWetBulDes,
    VHeaExcDes_flow=mCHW_flow_nominal/rho_default)
    annotation (Placement(transformation(extent={{-160,100},{-120,140}})));
  Buildings.Fluid.Sensors.VolumeFlowRate VChiWatSen_flow(redeclare package
      Medium = Buildings.Media.Water,
    final m_flow_nominal=mCHW_flow_nominal) "Chilled water supply volume flow rate sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={300,-70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yWSEOn
    "WSE is ON signal"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yWSEOff(realTrue=0,
      realFalse=1) "WSE is OFF signal"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply
    chilledWaterReset(
    dpChiWatPumMin=0.2*20*6485,
    dpChiWatPumMax=1*20*6485,
    TChiWatSupMin=273.15 + 5.56,
    TChiWatSupMax=273.15 + 22)
    annotation (Placement(transformation(extent={{-160,-70},{-120,-30}})));
equation
  PSupFan = fan.P;
  PChiWatPum = pumCHW.P;
  PConWatPum = pumCW.P;
  PCooTowFan = cooTow.PFan;
  PChi = chi.P;
  QRooIntGai_flow = roo.QSou.Q_flow;
  mConWat_flow = pumCW.m_flow_actual;
  mChiWat_flow = pumCHW.VMachine_flow * 995.586;

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
  connect(chillerOnOff.yOn, val5.y) annotation (Line(
      points={{-116,20},{100,20},{100,180},{148,180}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TCHWEntChi.T, chillerOnOff.TChiWatSup) annotation (Line(
      points={{149,0},{140,0},{140,-10},{-180,-10},{-180,34},{-164,34}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TAirSup.T, plantOnOff.TZonSup) annotation (Line(
      points={{230,-214},{230,-200},{-260,-200},{-260,-130},{-246,-130}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(mFanFlo.y, fan.m_flow_in) annotation (Line(
      points={{261,-200},{280,-200},{280,-213}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(val4.port_b, cooTow.port_a) annotation (Line(
      points={{40,190},{40,239},{201,239}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val5.port_b, cooTow.port_a) annotation (Line(
      points={{160,190},{160,239},{201,239}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(cooTow.port_b,pumCW. port_a) annotation (Line(
      points={{221,239},{300,239},{300,190}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(condenserWaterConstant.mConWatPumSet_flow, pumCW.m_flow_in)
    annotation (Line(points={{-56,210},{288,210},{288,180}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(QRooIntGai1_flow.y, QRooIntGaiAgg.u) annotation (Line(
      points={{-599,-10},{-562,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.TWetBul, wseSta.TOutWet) annotation (Line(
      points={{-282,-88},{-260,-88},{-260,136},{-164,136}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TCHWLeaCoi.T, wseSta.TChiWatRet) annotation (Line(
      points={{149,-80},{-200,-80},{-200,128},{-164,128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCHWEntChi.T, wseSta.TChiWatRetDow) annotation (Line(
      points={{149,0},{140,0},{140,-10},{-190,-10},{-190,120},{-164,120}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(condenserWaterConstant.yTowFanSpeSet, wseSta.uTowFanSpeMax)
    annotation (Line(
      points={{-56,230},{-40,230},{-40,260},{-170,260},{-170,104},{-164,104}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(val6.port_b, VChiWatSen_flow.port_a) annotation (Line(
      points={{300,30},{300,-60}},
      color={0,127,255},
      thickness=0.5));
  connect(VChiWatSen_flow.port_b, cooCoi.port_a1) annotation (Line(
      points={{300,-80},{300,-164},{242,-164}},
      color={0,127,255},
      thickness=0.5));
  connect(VChiWatSen_flow.V_flow, wseSta.VChiWat_flow) annotation (Line(
      points={{311,-70},{320,-70},{320,270},{-180,270},{-180,112},{-164,112}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(wseSta.y, condenserWaterConstant.uWSE) annotation (Line(
      points={{-118,120},{-110,120},{-110,230},{-104,230}},
      color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(wseSta.y, yWSEOn.u) annotation (Line(
      points={{-118,120},{-110,120},{-110,140},{-102,140}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(wseSta.y, yWSEOff.u) annotation (Line(
      points={{-118,120},{-110,120},{-110,110},{-102,110}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(yWSEOn.y, val4.y) annotation (Line(
      points={{-78,140},{-60,140},{-60,180},{28,180}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(yWSEOn.y, val3.y) annotation (Line(
      points={{-78,140},{-60,140},{-60,-40},{60,-40},{60,-48}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(yWSEOff.y, val1.y) annotation (Line(
      points={{-78,110},{0,110},{0,-30},{100,-30},{100,-40},{148,-40}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(plantOnOff.yChiWatPlaRes, chilledWaterReset.uChiWatPlaRes)
    annotation (Line(
      points={{-174,-130},{-170,-130},{-170,-50},{-164,-50}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(chilledWaterReset.dpChiWatPumSet, pumCHW.dp_in) annotation (Line(
      points={{-116,-38},{36,-38},{36,-120},{148,-120}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chi.TSet, chilledWaterReset.TChiWatSupSet) annotation (Line(
      points={{218,90},{226,90},{226,140},{-40,140},{-40,-62},{-116,-62}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chilledWaterReset.TChiWatSupSet, chillerOnOff.TChiWatSupSet)
    annotation (Line(
      points={{-116,-62},{-100,-62},{-100,-20},{-170,-20},{-170,6},{-164,6}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(chi.port_b1, val5.port_a) annotation (Line(points={{196,99},{196,106},
          {160,106},{160,170}}, color={0,128,255},
      thickness=0.5));
  connect(pumCW.port_b, wse.port_a1) annotation (Line(
      points={{300,170},{300,120},{180,120},{180,99},{68,99}},
      color={0,128,255},
      thickness=0.5));
  connect(chi.port_a1, pumCW.port_b) annotation (Line(
      points={{216,99},{300,99},{300,170}},
      color={0,128,255},
      thickness=0.5));
  annotation (
    __Dymola_Commands(file=
          "/home/milicag/repos/obc/examples/case_study_2/scripts/ClosedLoop1711/OneDeviceWithWSE_WSEOnOff.mos"
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
      StartTime=22896000,
      StopTime=30896000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-640,-300},{400,300}})));
end OneDeviceWithWSE_WSEOnOff;
