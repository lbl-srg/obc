within TestBreakPacakge;
model TestBreak
  Buildings.Controls.OBC.CDL.Reals.PID conPID
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1 "Input for dividend"
    annotation (Placement(transformation(extent={{-100,0},{-60,40}}),
        iconTransformation(extent={{-128,8},{-88,48}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2 "Input for dividend"
    annotation (Placement(transformation(extent={{-100,-40},{-60,0}}),
        iconTransformation(extent={{-128,8},{-88,48}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u3 "Input for dividend"
    annotation (Placement(transformation(extent={{-100,-70},{-60,-30}}),
        iconTransformation(extent={{-128,8},{-88,48}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y1
    "Actuator output signal" annotation (Placement(transformation(extent={{60,
            -20},{100,20}}), iconTransformation(extent={{80,-20},{120,20}})));
equation
  connect(gai.y, conPID.u_m)
    annotation (Line(points={{-18,-50},{30,-50},{30,-12}}, color={0,0,127}));
  connect(div1.u1, u1) annotation (Line(points={{-42,6},{-50,6},{-50,20},{-80,
          20}}, color={0,0,127}));
  connect(u3, gai.u)
    annotation (Line(points={{-80,-50},{-42,-50}}, color={0,0,127}));
  connect(u2, div1.u2) annotation (Line(points={{-80,-20},{-50,-20},{-50,-6},{
          -42,-6}}, color={0,0,127}));
  connect(div1.y, conPID.u_s)
    annotation (Line(points={{-18,0},{18,0}}, color={0,0,127}));
  connect(conPID.y, y1)
    annotation (Line(points={{42,0},{80,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-80},
            {60,60}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-60,-80},{60,60}})));
end TestBreak;
