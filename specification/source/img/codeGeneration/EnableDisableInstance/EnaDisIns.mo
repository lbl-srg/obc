block EnaDisIns "Model with conditional removable instance"
  parameter Boolean enaIns = true "Flag to indicate if instance should be enabled";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1 "Real input";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2 if enaIns "Conditional removable real input"
    annotation (__cdl(default = 1.5), ...);
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y "Real output";
  Buildings.Controls.OBC.CDL.Continuous.ConditionalMax conMax(
    final u2_present=enaIns) "Conditional maximum";
  Buildings.Controls.OBC.CDL.Continuous.Sqrt fixIns "Square root of the input";
  Buildings.Controls.OBC.CDL.Continuous.Log conIns if enaIns "Conditional removable instance";
equation
  connect(conMax.y, y);
  connect(u2, conIns.u);
  connect(conIns.y, conMax.u2);
  connect(u1, fixIns.u);
  connect(fixIns.y, conMax.u1);
end EnaDisIns;
