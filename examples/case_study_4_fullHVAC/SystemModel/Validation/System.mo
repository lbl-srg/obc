within SystemModel.Validation;
model System
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water "Medium model for water";

  parameter SystemModel.SizingParameters sizDat "Sizing parameters"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));

  /* The order of the zones is deduced from the connection between the VAV model
  and the room model. The mapping from the Modelica array to the Modelica zone name,
  and the EnergyPlus zone name, is:
  1: Sou ZN1
  2: Eas ZN2
  3: Nor ZN3
  4: Wes NZ4
  5: Cor Core
  */
  final parameter Modelica.Units.SI.Volume VRoo[5]=
    {flo.VRooSou, flo.VRooEas, flo.VRooNor, flo.VRooWes, flo.VRooCor} "Room volumes";

  final parameter Modelica.Units.SI.Area AFlo[5]=
    {flo.AFloSou, flo.AFloEas, flo.AFloNor, flo.AFloWes, flo.AFloCor} "Floor areas";

  VAV.Guideline36 vav(
    redeclare final package MediumA = MediumA,
    redeclare final package MediumW = MediumW,
    QHeaAHU_flow_nominal=sizDat.QHeaAHU_flow_nominal,
    QCooAHU_flow_nominal=2.5*sizDat.mCooAHU_flow_nominal*Buildings.Utilities.Psychrometrics.Constants.cpAir*(vav.TCooAirSup_nominal
         - vav.TCooAirMix_nominal),
    mHeaVAV_flow_nominal=sizDat.mHeaVAV_flow_nominal,
    TCooWatInl_nominal=sizDat.TCooWatSup_nominal,
    THeaAirSup_nominal=sizDat.THeaDisAHU_nominal,
    final sizDat=sizDat,
    final VRoo=VRoo,
    final AFlo=AFlo) "VAV and building model"
    annotation (Placement(transformation(extent={{6,30},{82,76}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false)
    annotation (Placement(transformation(extent={{-60,56},{-40,76}})));

  Building.Floor flo(redeclare package Medium = MediumA)
    "Floor of the building"
    annotation (Placement(transformation(extent={{120,116},{208,166}})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=sizDat.TCooWatSup_nominal,
    nPorts=1) "Sink for cooling coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={58,-22})));
  Buildings.Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=sizDat.TCooWatRet_nominal,
    nPorts=1) "Source for cooling coil loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,-22})));
  Buildings.Fluid.Sources.MassFlowSource_T souAir[4](
    redeclare each package Medium = MediumA,
    each m_flow=0,
    each nPorts=1) "Air flow source to set boundary condition" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,30})));


  BoilerPlant.System boiPla(
    final mSec_flow_nominal=sizDat.mHeaSec_flow_nominal,
    final boiDesCap=sizDat.QHeaPla_nominal) "Boiler plant"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Modelica.Blocks.Math.Sum TZonAve(
    nin=5,
    k=1/5*ones(5),
    y(final unit="K",
      displayUnit="degC"))
      "Average zone temperature"
    annotation (Placement(transformation(extent={{232,132},{252,152}})));

equation
  connect(weaDat.weaBus,vav. weaBus) annotation (Line(
      points={{-40,66},{-2,66},{-2,66.2889},{10.9875,66.2889}},
      color={255,204,51},
      thickness=0.5));
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
  connect(flo.TRooAir, vav.TRoo) annotation (Line(points={{209.913,141},{220,
          141},{220,182},{-8,182},{-8,70.8889},{3.625,70.8889}},
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
  connect(boiPla.port_AHUHWSup, vav.portHeaCoiSup) annotation (Line(points={{2,
          -60},{2,18},{27.375,18},{27.375,30}}, color={0,127,255}));
  connect(boiPla.port_AHUHWRet, vav.portHeaCoiRet) annotation (Line(points={{6,
          -60},{6,16},{34.5,16},{34.5,30}}, color={0,127,255}));
  connect(boiPla.port_RehHWSup, vav.portHeaTerSup) annotation (Line(points={{14,
          -60},{14,-40},{80,-40},{80,0},{60.625,0},{60.625,30}}, color={0,127,
          255}));
  connect(boiPla.port_RehHWRet, vav.portHeaTerRet) annotation (Line(points={{18,
          -60},{18,-44},{84,-44},{84,4},{67.75,4},{67.75,30}}, color={0,127,255}));
  connect(boiPla.weaBus, weaDat.weaBus) annotation (Line(
      points={{1,-63},{-20,-63},{-20,66},{-40,66}},
      color={255,204,51},
      thickness=0.5));
  connect(TZonAve.u, flo.TRooAir) annotation (Line(points={{230,142},{230,141},
          {209.913,141}}, color={0,0,127}));
  connect(TZonAve.y, boiPla.TZonAve) annotation (Line(points={{253,142},{256,
          142},{256,-86},{-8,-86},{-8,-74},{-2,-74}}, color={0,0,127}));
  connect(vav.THotWatSupResReq, boiPla.THotWatSupResReq) annotation (Line(
        points={{84.375,37.6667},{98,37.6667},{98,-4},{-6,-4},{-6,-66},{-2,-66}},
        color={255,127,0}));
  connect(vav.yHotWatPlaReq, boiPla.hotWatPlaReq) annotation (Line(points={{84.375,
          32.5556},{94,32.5556},{94,-2},{-8,-2},{-8,-70},{-2,-70}}, color={255,127,
          0}));
  annotation (
      __Dymola_Commands(file="modelica://SystemModel/Resources/Scripts/Dymola/Validation/System.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            260,200}})));
end System;
