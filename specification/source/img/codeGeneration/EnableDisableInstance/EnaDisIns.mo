within ;
block EnaDisIns "Model with conditional removable instance"
  parameter Boolean enaIns = true "Flag to indicate if instance should be enabled";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1 "Real input"
    annotation (Placement(transformation(extent={{-100,20},{-60,60}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2 if enaIns
    "Real input that could be conditional removed"
    annotation (__cdl(default = 1.5, enable = not enaIns),
      Placement(transformation(extent={{-100,-60},{-60,-20}}),
        iconTransformation(extent={{-140,-82},{-100,-42}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y "Real output"
    annotation (Placement(transformation(extent={{60,-10},{80,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.ConditionalMax conMax(
    final u2_present=enaIns) "Conditional maximum"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sqrt fixIns "Square root of the input"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Log conIns if enaIns
    "Natural (base e) logarithm of the input, can be conditional removed"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

equation
  connect(conMax.y, y)
    annotation (Line(points={{41,0},{70,0}}, color={0,0,127}));
  connect(u2, conIns.u)
    annotation (Line(points={{-80,-40},{-42,-40}}, color={0,0,127}));
  connect(conIns.y, conMax.u2)
    annotation (Line(points={{-19,-40},{0,-40},{0,-6},{18,-6}}, color={0,0,127}));
  connect(u1, fixIns.u)
    annotation (Line(points={{-80,40},{-42,40}}, color={0,0,127}));
  connect(fixIns.y, conMax.u1)
    annotation (Line(points={{-19,40},{0,40},{0,6},{18,6}}, color={0,0,127}));

annotation (
  defaultComponentName = "enaTest",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Rectangle(extent={{-100,-100},{100,100}},
            lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid),
        Text(extent={{-150,150},{150,110}}, textString="%name", lineColor={0,0,255}),
        Text(extent={{-90,36},{90,-36}}, lineColor={160,160,164}, textString="max()")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},{60,60}})),
    uses(Buildings(version="6.1.0")));
end EnaDisIns;
