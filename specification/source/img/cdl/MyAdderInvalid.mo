model MyAdderInvalid
  Interfaces.RealInput u1;
  Interfaces.RealInput u2;
  Interfaces.RealOutput y = u1 + u2; // not allowed
end MyAdderInvalid;
