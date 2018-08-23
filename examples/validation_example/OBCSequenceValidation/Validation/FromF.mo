within OBCSequenceValidation.Validation;
model FromF
  "Test unit conversion from Kelvin to Celsius"
  extends Modelica.Icons.Example;

  OBCSequenceValidation.FromF FromF "Fahrenheit to Kelvin unit converter"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  OBCSequenceValidation.FromF FromF1 "Fahrenheit to Kelvin unit converter"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant value(k=32) "Value to convert"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant value1(k=212) "Value to convert"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant result(k=273.15)
    "Expected converted value"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant result1(k=373.15)
    "Expected converted value"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add(k2=-1) "Result checker"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1) "Result checker"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(value.y, FromF.u)
    annotation (Line(points={{-39,50},{-22,50}}, color={0,0,127}));
  connect(value1.y, FromF1.u)
    annotation (Line(points={{-39,-30},{-22,-30}}, color={0,0,127}));
  connect(result.y, add.u2)
    annotation (Line(points={{1,20},{10,20},{10,44},{18,44}},     color={0,0,127}));
  connect(FromF.y, add.u1)
    annotation (Line(points={{1,50},{10,50},{10,56},{18,56}},     color={0,0,127}));
  connect(result1.y, add1.u2)
    annotation (Line(points={{1,-60},{10,-60},{10,-36},{18,-36}},     color={0,0,127}));
  connect(FromF1.y, add1.u1)
    annotation (Line(points={{1,-30},{10,-30},{10,-24},{18,-24}},     color={0,0,127}));
  annotation (Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(coordinateSystem(
          preserveAspectRatio=false)),
            experiment(StopTime=1000.0, Tolerance=1e-06),
  __Dymola_Commands(file="FromF.mos"
    "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates the Fahrenheit to Kelvin unit converter.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 05, Milica Grahovac<br/>
First implementation.
</li>
</ul>
</html>"));
end FromF;
