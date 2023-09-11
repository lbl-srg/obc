block MyAdderValid
  Interfaces.RealInput u1;
  RealInput u2;
  Interfaces.RealOutput y;
  Reals.Add add;
equation
  connect(add.u1, u1);
  connect(add.u2, u2);
  connect(add.y,  y);
end MyAdderValid;
