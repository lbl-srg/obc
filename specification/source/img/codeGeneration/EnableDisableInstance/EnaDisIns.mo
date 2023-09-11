block EnaDisIns "Model with conditional removable instances"
  parameter Boolean u2_present = true "If true, input u2 is present";
  CDL.Interfaces.RealInput u1 "Real-valued input";
  CDL.Interfaces.RealInput u2 if u2_present
    "Conditional removable real-valued input"
    annotation (__cdl(default = 1.5));
  CDL.Interfaces.RealOutput y "Real-valued output";
  CDL.Reals.ConditionalMax conMax(
    final u2_present=u2_present) "Conditional maximum";
  CDL.Reals.Sqrt fixIns "Square root of the input";
  CDL.Reals.Log conIns
    if u2_present "Conditionally removable instance";
equation
  connect(conMax.y, y);
  connect(u2, conIns.u);
  connect(conIns.y, conMax.u2);
  connect(u1, fixIns.u);
  connect(fixIns.y, conMax.u1);
end EnaDisIns;
