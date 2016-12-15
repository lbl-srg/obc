model MyAdderValid
  Modelica.Blocks.Interfaces.RealInput u1;
  Modelica.Blocks.Interfaces.RealInput u2;
  Modelica.Blocks.Interfaces.RealOutput y;
  Buildings.Controls.OpenBuildingControl.CDL.Continuous.Add add;
  // fixme: need to replace signals with signals from OpenBuildingControl
equation
  connect(u1, add.u1);
  connect(u2, add.u2);
  connect(add.y, y);
end MyAdderValid;
