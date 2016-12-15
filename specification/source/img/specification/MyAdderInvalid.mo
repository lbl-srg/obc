model MyAdderInvalid
  Modelica.Blocks.Interfaces.RealInput u1;
  Modelica.Blocks.Interfaces.RealInput u2;
  Modelica.Blocks.Interfaces.RealOutput y = u1 + u2; // not allowed
  // fixme: need to replace signals with signals from OpenBuildingControl
end MyAdderInvalid;
