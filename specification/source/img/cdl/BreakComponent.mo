model BreakComponent
  extends TestBreak(break conPID);

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPID1
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation 
  connect(div1.y, conPID1.u_s)
    annotation (Line(points={{-18,0},{18,0}}, color={0,0,127}));
  connect(gai.y, conPID1.u_m)
    annotation (Line(points={{-18,-50},{30,-50},{30,-12}}, color={0,0,127}));
  connect(con.y, conPID1.trigger)
    annotation (Line(points={{-18,40},{0,40},{0,-20},{24,-20},{24,-12}}, color={255,0,255}));
  connect(conPID1.y, y1)
    annotation (Line(points={{42,0},{80,0}}, color={0,0,127}));
end BreakComponent;
