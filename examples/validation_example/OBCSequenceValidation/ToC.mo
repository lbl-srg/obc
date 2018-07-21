within OBCSequenceValidation;
block ToC "Kelvin to Celsius unit converter"

  Buildings.Controls.OBC.CDL.Interfaces.RealInput kelvin(
    final unit = "K",
    final quantity = "ThermodynamicTemperature")
    "Temparature in Kelvin"
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput celsius(
    final unit = "degC",
    final quantity = "ThermodynamicTemperature")
    "Temparature in Celsius"
    annotation (Placement(transformation(extent={{40,-10},{60,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  parameter Real k = 1 "Multiplier";
  parameter Real p = -273.15 "Adder";

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p = p,
    final k = k) "Unit converter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(kelvin, addPar.u)
    annotation (Line(points={{-60,0},{-12,0}}, color={0,0,127}));
  connect(addPar.y, celsius) annotation (Line(points={{11,0},{50,0}}, color={0,0,127}));
  annotation (
      defaultComponentName = "ToC",
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{20,58}}, color={28,108,200}),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{-122,-26},{-20,12}},
          lineColor={0,0,127},
          textString="K"),
        Text(
          extent={{0,12},{80,-48}},
          lineColor={0,0,127},
          textString="degC
")}),     Documentation(info="<html>
<p>
Converts temperature from Kelvin to Fahrenheit.
</p>

</html>", revisions="<html>
<ul>
<li>
July 05, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ToC;
