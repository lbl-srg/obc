within SystemModel.Validation;
model System
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water "Medium model for water";

  parameter Modelica.SIunits.Temperature THotWatInl_nominal(
    displayUnit="degC")= 45 + 273.15
    "Reheat coil nominal inlet water temperature";

  final parameter Modelica.SIunits.Volume VRooCor = flo.VRooCor
    "Room volume corridor";
  final parameter Modelica.SIunits.Volume VRooSou = flo.VRooSou
    "Room volume south";
  final parameter Modelica.SIunits.Volume VRooNor = flo.VRooNor
    "Room volume north";
  final parameter Modelica.SIunits.Volume VRooEas = flo.VRooEas
    "Room volume east";
  final parameter Modelica.SIunits.Volume VRooWes = flo.VRooWes
    "Room volume west";

  final parameter Modelica.SIunits.Area AFloCor = flo.AFloCor "Floor area corridor";
  final parameter Modelica.SIunits.Area AFloSou = flo.AFloSou "Floor area south";
  final parameter Modelica.SIunits.Area AFloNor = flo.AFloNor "Floor area north";
  final parameter Modelica.SIunits.Area AFloEas = flo.AFloEas "Floor area east";
  final parameter Modelica.SIunits.Area AFloWes = flo.AFloWes "Floor area west";

  VAV.Guideline36 vav(
    redeclare final package MediumA = MediumA,
    redeclare final package MediumW = MediumW,
    final VRooCor=VRooCor,
    final VRooSou=VRooSou,
    final VRooNor=VRooNor,
    final VRooEas=VRooEas,
    final VRooWes=VRooWes,
    final AFloCor=AFloCor,
    final AFloSou=AFloSou,
    final AFloNor=AFloNor,
    final AFloEas=AFloEas,
    final AFloWes=AFloWes,
    final THotWatInl_nominal=THotWatInl_nominal) "VAV and building model"
                 annotation (Placement(transformation(extent={{6,30},{82,76}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false)
    annotation (Placement(transformation(extent={{-60,56},{-40,76}})));

  Building.Floor flo(redeclare package Medium = MediumA)
                     "Floor of the building"
    annotation (Placement(transformation(extent={{120,116},{208,166}})));
  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=THotWatInl_nominal,
    nPorts=1) "Sink for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-22})));
  Buildings.Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=THotWatInl_nominal,
    nPorts=1) "Source for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-32,-22})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=285.15,
    nPorts=1) "Sink for cooling coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={58,-22})));
  Buildings.Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=285.15,
    nPorts=1) "Source for cooling coil loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,-22})));
  Buildings.Fluid.Sources.Boundary_pT souHeaTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=THotWatInl_nominal,
    nPorts=1) "Source for heating of terminal boxes" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={88,-22})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000,
    T=THotWatInl_nominal,
    nPorts=1) "Source for heating of terminal boxes" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={118,-22})));
  Buildings.Fluid.Sources.MassFlowSource_T souAir[4](
    redeclare each package Medium = MediumA,
    each m_flow=0,
    each nPorts=1) "Air flow source to set boundary condition" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,30})));
equation
  connect(weaDat.weaBus,vav. weaBus) annotation (Line(
      points={{-40,66},{-2,66},{-2,66.2889},{10.9875,66.2889}},
      color={255,204,51},
      thickness=0.5));
  connect(souHea.ports[1], vav.portHeaCoiSup) annotation (Line(points={{-32,-12},
          {-32,18},{27.375,18},{27.375,30}},         color={0,127,255}));
  connect(sinHea.ports[1], vav.portHeaCoiRet) annotation (Line(points={{0,-12},{
          0,16},{34.5,16},{34.5,30}},          color={0,127,255}));
  connect(vav.portHeaTerSup,souHeaTer. ports[1]) annotation (Line(points={{60.625,
          30},{56,30},{56,10},{88,10},{88,-12}},           color={0,127,255}));
  connect(vav.portHeaTerRet,sinHeaTer. ports[1]) annotation (Line(points={{67.75,
          30},{64,30},{64,12},{118,12},{118,-12}},        color={0,127,255}));
  connect(souCoo.ports[1], vav.portCooCoiSup) annotation (Line(points={{28,-12},
          {28,12},{44,12},{44,30}},          color={0,127,255}));
  connect(sinCoo.ports[1], vav.portCooCoiRet) annotation (Line(points={{58,-12},
          {58,4},{51.125,4},{51.125,30}},
                                     color={0,127,255}));
  connect(vav.port_supAir[1], flo.portsSou[1]) annotation (Line(points={{82.2375,
          73.4444},{152.139,73.4444},{152.139,126.769}}, color={0,127,255}));
  connect(vav.port_supAir[2], flo.portsEas[1]) annotation (Line(points={{82.2375,
          73.4444},{195.757,73.4444},{195.757,142.154}}, color={0,127,255}));
  connect(vav.port_supAir[3], flo.portsNor[1]) annotation (Line(points={{82.2375,
          73.4444},{94,73.4444},{94,155.231},{152.139,155.231}}, color={0,127,255}));
  connect(vav.port_supAir[4], flo.portsWes[1]) annotation (Line(points={{82.2375,
          73.4444},{94,73.4444},{94,90},{128.417,90},{128.417,142.154}}, color={
          0,127,255}));
  connect(vav.port_supAir[5], flo.portsCor[1]) annotation (Line(points={{82.2375,
          73.4444},{140,73.4444},{140,142.154},{152.139,142.154}},
                                                                 color={0,127,255}));
  connect(flo.TRooAir, vav.TRoo) annotation (Line(points={{209.913,141},{232,
          141},{232,182},{-8,182},{-8,70.8889},{3.625,70.8889}},
                                                              color={0,0,127}));
  connect(vav.port_retAir[5], flo.portAtt) annotation (Line(points={{82.2375,
          51.7222},{192.696,51.7222},{192.696,111.962}},
                                                color={0,127,255}));
  connect(flo.weaBus, weaDat.weaBus) annotation (Line(
      points={{175.478,173.692},{-20,173.692},{-20,66},{-40,66}},
      color={255,204,51},
      thickness=0.5));
  connect(souAir[1:4].ports[1], vav.port_retAir[1:4]) annotation (Line(points={{120,30},
          {120,28},{102,28},{102,51.7222},{82.2375,51.7222}},
                                      color={0,127,255}));
  annotation (
      __Dymola_Commands(file="modelica://SystemModel/Resources/Scripts/Dymola/Validation/System.mos"
        "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{260,200}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{260,
            200}})));
end System;
