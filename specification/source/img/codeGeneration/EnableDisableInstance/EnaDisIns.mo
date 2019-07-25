block EnaDisIns "Model with conditional removable instance"
  parameter Boolean enaIns = true "Flag to indicate if instance should be enabled";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1 "Real input"
    annotation (...);
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2 if enaIns "Conditional removable real input"
    annotation (__cdl(default = 1.5, enable = not enaIns), ...);
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y "Real output"
    annotation (...);
  Buildings.Controls.OBC.CDL.Continuous.ConditionalMax conMax(
    final u2_present=enaIns) "Conditional maximum"
    annotation (...);
  Buildings.Controls.OBC.CDL.Continuous.Sqrt fixIns "Square root of the input"
    annotation (...);
  Buildings.Controls.OBC.CDL.Continuous.Log conIns if enaIns "Conditional removable instance"
    annotation (...);
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
  annotation (...);
end EnaDisIns;
