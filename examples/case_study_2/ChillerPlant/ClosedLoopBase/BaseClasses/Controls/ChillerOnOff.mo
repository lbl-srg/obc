within ChillerPlant.ClosedLoopBase.BaseClasses.Controls;
model ChillerOnOff "Chiller status"

  parameter Real dTChi(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=2.2
    "Deadband to avoid chiller short-cycling"
    annotation(Dialog(group="Design parameters"));

  Buildings.Examples.ChillerPlant.BaseClasses.Controls.ChillerSwitch chiSwi(
    deaBan = dTChi)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal invCon(realTrue=0,
      realFalse=1) "Boolean to real conversion that inverts input signal"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet
    "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi "Chiller status"
    annotation (Placement(transformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOn
    "1 if chiller is commanded ON, 0 otherwise"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOff
    "1 if chiller is commanded OFF, 0 otherwise"
    annotation (Placement(transformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal con1(realTrue=1,
      realFalse=0) "Boolean to real conversion of input signal"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
equation
  connect(TChiWatSup, chiSwi.chiCHWST) annotation (Line(points={{-120,70},{-70,70},
          {-70,17},{-21,17}}, color={0,0,127}));
  connect(TChiWatSupSet, chiSwi.TSet) annotation (Line(points={{-120,-70},{-70,-70},
          {-70,5},{-21,5}}, color={0,0,127}));
  connect(chiSwi.y, yChi) annotation (Line(points={{1,9.4},{20,9.4},{20,70},{120,
          70}}, color={255,0,255}));
  connect(chiSwi.y, con1.u) annotation (Line(points={{1,9.4},{1,10},{20,10},{20,
          -30},{38,-30}}, color={255,0,255}));
  connect(chiSwi.y, invCon.u) annotation (Line(points={{1,9.4},{2,9.4},{2,10},{20,
          10},{20,-70},{38,-70}}, color={255,0,255}));
  connect(con1.y, yOn) annotation (Line(points={{62,-30},{80,-30},{80,0},{120,0}},
        color={0,0,127}));
  connect(invCon.y, yOff)
    annotation (Line(points={{62,-70},{120,-70}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200}),
          Text(
          extent={{-82,88},{84,-66}},
          lineColor={28,108,200},
          textString="Base
Chiller
On/Off")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end ChillerOnOff;
