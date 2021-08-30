within SystemModel.VAV.Validation;
model System
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water "Medium model for water";

  parameter Modelica.SIunits.Temperature THotWatInl_nominal(
    displayUnit="degC")= 45 + 273.15
    "Reheat coil nominal inlet water temperature";
  VAV.System vav(
    redeclare final package MediumA = MediumA,
    redeclare final package MediumW = MediumW,
    final lat=lat,
    final THotWatInl_nominal=THotWatInl_nominal) "VAV and building model"
                 annotation (Placement(transformation(extent={{4,30},{80,76}})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=285.15,
    nPorts=1) "Sink for cooling coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-70})));
  Buildings.Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=285.15,
    nPorts=1) "Source for cooling coil loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-102})));
  Buildings.Fluid.Sources.Boundary_pT souHeaTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=THotWatInl_nominal,
    nPorts=1) "Source for heating of terminal boxes" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-150})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000,
    T=THotWatInl_nominal,
    nPorts=1) "Sink for heating of terminal boxes"   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-180})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180 "Latitude";
  Buildings.Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=THotWatInl_nominal,
    nPorts=1) "Source for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,0})));
  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000,
    T=THotWatInl_nominal,
    nPorts=1) "Sink for heating" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-30})));
equation
  connect(sinCoo.ports[1],vav. portCooCoiRet) annotation (Line(points={{-40,-70},
          {28.764,-70},{28.764,30}}, color={0,127,255}));
  connect(souCoo.ports[1],vav. portCooCoiSup) annotation (Line(points={{-40,
          -102},{31.3258,-102},{31.3258,30}},
                                        color={0,127,255}));
  connect(weaDat.weaBus,vav. weaBus) annotation (Line(
      points={{-60,50},{-2,50},{-2,54.7037},{6.13483,54.7037}},
      color={255,204,51},
      thickness=0.5));
  connect(souHeaTer.ports[1], vav.portHeaTerSup) annotation (Line(points={{-40,
          -150},{40,-150},{40,30},{39.0112,30}}, color={0,127,255}));
  connect(sinHeaTer.ports[1], vav.portHeaTerRet) annotation (Line(points={{-40,
          -180},{35.6809,-180},{35.6809,29.9148}}, color={0,127,255}));
  connect(vav.portHeaCoiRet, sinHea.ports[1]) annotation (Line(points={{22.018,
          29.9148},{22.018,-30},{-40,-30}},
                                   color={0,127,255}));
  connect(vav.portHeaCoiSup, souHea.ports[1]) annotation (Line(points={{25.4337,
          29.9148},{25.4337,0},{-40,0}}, color={0,127,255}));
  annotation (
      __Dymola_Commands(file="modelica://SystemModel/Resources/Scripts/Dymola/VAV/Validation/System.mos"
        "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{
            100,100}})));
end System;
