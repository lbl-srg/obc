within VAVMultiZone.Example;
model SimpleTest "Simple test case to verify scripts"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=1)
    "Constant input"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset int "Integrator"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(con.y, int.u)
    annotation (Line(points={{-19,0},{18,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SimpleTest;
