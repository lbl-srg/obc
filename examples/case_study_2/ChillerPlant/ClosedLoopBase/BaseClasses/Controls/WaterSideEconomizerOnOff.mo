within ChillerPlant.ClosedLoopBase.BaseClasses.Controls;
model WaterSideEconomizerOnOff "Water-side economizer status"

  parameter Real cooTowAppDes(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=6
    "Design cooling tower approach"
    annotation(Dialog(group="Design parameters"));

  WaterSideEconomizerStateMachine waterSideEconomizerBase
    annotation (Placement(transformation(extent={{-10,-20},{10,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet
    "Chilled water return temperature upstream of WSE"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWetBul
    "Outdoor air wetbulb temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOn
    "1 if WSE is commanded on, 0 otherwise"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOff
    "1 if WSE is commanded off, 0 otherwise"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySta
    "Water-side economizer status"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=cooTowAppDes)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(con.y, waterSideEconomizerBase.towTApp) annotation (Line(points={{-58,
          -30},{-30,-30},{-30,-5.88235},{-12,-5.88235}}, color={0,0,127}));
  connect(TChiWatRet, waterSideEconomizerBase.wseCHWST) annotation (Line(points={{-120,60},
          {-40,60},{-40,12.9412},{-12,12.9412}},           color={0,0,127}));
  connect(TWetBul, waterSideEconomizerBase.TWetBul) annotation (Line(points={{-120,
          0},{-40,0},{-40,1.17647},{-12,1.17647}}, color={0,0,127}));
  connect(TConWatSup, waterSideEconomizerBase.wseCWST) annotation (Line(points={{-120,
          -70},{-20,-70},{-20,-15.0588},{-12,-15.0588}},       color={0,0,127}));
  connect(waterSideEconomizerBase.y1, yOn) annotation (Line(points={{11,3.52941},
          {60,3.52941},{60,60},{120,60}}, color={0,0,127}));
  connect(waterSideEconomizerBase.y2, yOff) annotation (Line(points={{11,-5.88235},
          {60,-5.88235},{60,0},{120,0}}, color={0,0,127}));
  connect(waterSideEconomizerBase.ySta, ySta) annotation (Line(points={{12,
          -12.9412},{60,-12.9412},{60,-60},{120,-60}},
                                             color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200}),
          Text(
          extent={{-88,86},{84,-74}},
          lineColor={28,108,200},
          textString="WSE
On/Off")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end WaterSideEconomizerOnOff;
