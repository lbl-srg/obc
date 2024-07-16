block MyPID
  extends Buildings.Controls.OBC.Utilities.PIDWithInputGains(
    final yMin = 0,
    final yMax = 1);

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput error
    "Control error"
    annotation(
      Placement(
        transformation(
	  origin = {240, -120},
	  extent = {{-20, -20}, {20, 20}}),
        iconTransformation(
	  origin = {120, -60},
	  extent = {{-20, -20}, {20, 20}})));
equation
  connect(controlError.y, error) annotation(
    Line(
      points = {{-178, -6}, {-160, -6},
                {-160, -120}, {240, -120}},
      color = {0, 0, 127}));
  annotation(
    uses(Buildings(version = "12.0.0")),
    Documentation(
      info = "<p>
PID controller that extends the PID controller
with input gains, and that limits the output
between 0 and 1, and
adds an output connector that reports
the control error.
</p>"));
  
end MyPID;