within OBCSequenceValidation;
block FromF "Fahrenheit to Kelvin unit converter"

  Buildings.Controls.OBC.CDL.Interfaces.RealInput fahrenheit(
    final unit = "degF",
    final quantity = "ThermodynamicTemperature")
    "Temparature in Fahrenheit"
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput kelvin(
    final unit = "K",
    final quantity = "ThermodynamicTemperature")
    "Temparature in Kelvin"
    annotation (Placement(transformation(extent={{40,-10},{60,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  parameter Real k = 0.55555556 "Multiplier";
  parameter Real p = 255.37222222 "Adder";

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p = p,
    final k = k) "Unit converter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(fahrenheit, addPar.u)
    annotation (Line(points={{-60,0},{-12,0}}, color={0,0,127}));
  connect(addPar.y, kelvin)
    annotation (Line(points={{11,0},{50,0}}, color={0,0,127}));
  annotation (
      defaultComponentName = "FromF",
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
          extent={{12,-12},{92,-88}},
          lineColor={0,0,127},
          textString="SI")}),
          Documentation(info="<html>
<p>
Converts temperature from Fahrenheit to Kelvin.
</p>

</html>", revisions="<html>
<ul>
<li>
July 05, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end FromF;
