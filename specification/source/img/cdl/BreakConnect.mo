within TestBreakPacakge;
model BreakConnect
  extends TestBreak(break connect(gai.y, conPID.u_m));

  Buildings.Controls.OBC.CDL.Reals.Abs abs1
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
equation
  connect(gai.y, abs1.u)
    annotation (Line(points={{-18,-50},{-2,-50}}, color={0,0,127}));
  connect(abs1.y, conPID.u_m)
    annotation (Line(points={{22,-50},{30,-50},{30,-12}}, color={0,0,127}));
  annotation ();
end BreakConnect;
