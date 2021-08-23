within ;
model System
  Buildings.Fluid.Sources.Boundary_pT heaBou(
    redeclare package Medium = MediumW,
    p=300000,
    T=318.15,
    nPorts=6) "Supply and return for heating coil"
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-30})));
  VAV vAV annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=285.15,
    nPorts=1) "Supply and return boundary condition for cooling"
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-70})));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    uses(Buildings(version="9.0.0")));
end System;
