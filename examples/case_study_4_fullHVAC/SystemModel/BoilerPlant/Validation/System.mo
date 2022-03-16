within SystemModel.BoilerPlant.Validation;
model System
  "Validation model for boiler system"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water "Medium model for water";

  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal=96.323
    "Radiator nominal mass flow rate"
    annotation(dialog(group="Radiator parameters"));

  parameter Real boiDesCap = 4359751.36;

  parameter Real boiCapRat = 2/4.3;

  parameter Modelica.Units.SI.Temperature THotWatInl_nominal(
    displayUnit="degC")= 45 + 273.15
    "Reheat coil nominal inlet water temperature";
  parameter Modelica.Units.SI.Angle lat=41.98*3.14159/180 "Latitude";
  SystemModel.BoilerPlant.System boiPlaSys
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val3(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mRad_flow_nominal,
    deltaM=0.1,
    final dpValve_nominal=6000,
    use_inputFilter=true,
    y_start=0,
    dpFixed_nominal=1000,
    l=0.0001)
    "Isolation valve for radiator"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=90,
        origin={-34,-14})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=10e-2,
    Ti=300)
    "Radiator isolation valve controller"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter
                                           addPar(p=273.15)
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=-1)
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis
                                         hys(uLow=0.05, uHigh=0.1)
    "Check if radiator control valve opening is above threshold for enabling boiler plant"
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis
                                         hys1(uLow=0.25, uHigh=0.3)
    "Check if radiator control valve opening is above threshold for rasing HHW supply temperature"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger
                                                booToInt1(integerTrue=3)
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger
                                                booToInt
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  SystemModel.BoilerPlant.Validation.Submodels.ZoneModel_simplified
                                  zoneModel_simplified(
    Q_flow_nominal=4359751.36,
    TRadSup_nominal=333.15,
    TRadRet_nominal=323.15,
    mRad_flow_nominal=96.323,
    V=126016.35,
    zonTheCap=6987976290,
    vol(T_start=283.15),
    heaCap(T(start=10)),
    rad(dp_nominal=40000))
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(final filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://SystemModel/Resources/weatherdata/USA_NY_Buffalo-Greater.Buffalo.Intl.AP.725280_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=true,
    tableName="tab1",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://SystemModel/Resources/Data/BoilerPlant/Validation/System.txt"),
    verboseRead=true,
    columns={2,5},
    timeScale=60) "Boiler thermal load from EnergyPlus simulation"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));

equation
  connect(val3.port_b, zoneModel_simplified.port_a) annotation (Line(points={{-34,-4},
          {-34,10}},                         color={0,127,255}));
  connect(zoneModel_simplified.TZon, conPID.u_m)
    annotation (Line(points={{-18,20},{0,20},{0,48}}, color={0,0,127}));
  connect(zoneModel_simplified.QFlo, gai.y)
    annotation (Line(points={{-42,20},{-48,20}}, color={0,0,127}));
  connect(combiTimeTable.y[1], gai.u)
    annotation (Line(points={{-89,20},{-72,20}}, color={0,0,127}));
  connect(combiTimeTable.y[2], addPar.u) annotation (Line(points={{-89,20},{-80,
          20},{-80,60},{-72,60}}, color={0,0,127}));
  connect(addPar.y, conPID.u_s)
    annotation (Line(points={{-48,60},{-12,60}}, color={0,0,127}));
  connect(weaDat.weaBus, boiPlaSys.weaBus) annotation (Line(
      points={{-80,-20},{-60,-20},{-60,-63},{-29,-63}},
      color={255,204,51},
      thickness=0.5));
  connect(hys1.y, booToInt1.u)
    annotation (Line(points={{52,20},{68,20}}, color={255,0,255}));
  connect(hys.y, booToInt.u)
    annotation (Line(points={{52,100},{68,100}}, color={255,0,255}));
  connect(conPID.y, hys.u) annotation (Line(points={{12,60},{20,60},{20,100},{28,
          100}}, color={0,0,127}));
  connect(conPID.y, hys1.u) annotation (Line(points={{12,60},{20,60},{20,20},{28,
          20}}, color={0,0,127}));
  connect(conPID.y, val3.y) annotation (Line(points={{12,60},{20,60},{20,0},{
          -50,0},{-50,-14},{-46,-14}},
                                   color={0,0,127}));
  connect(zoneModel_simplified.TZon, boiPlaSys.TZonAve) annotation (Line(points=
         {{-18,20},{0,20},{0,-86},{-34,-86},{-34,-74},{-32,-74}}, color={0,0,
          127}));
  connect(booToInt1.y, boiPlaSys.TSupResReq) annotation (Line(points={{92,20},{100,
          20},{100,-90},{-40,-90},{-40,-66},{-32,-66}}, color={255,127,0}));
  connect(booToInt.y, boiPlaSys.supResReq) annotation (Line(points={{92,100},{110,
          100},{110,-100},{-50,-100},{-50,-70},{-32,-70}}, color={255,127,0}));
  connect(boiPlaSys.port_AHUHWSup, val3.port_a) annotation (Line(points={{-24,-60},
          {-24,-40},{-34,-40},{-34,-24}},      color={0,127,255}));
  connect(zoneModel_simplified.port_b, boiPlaSys.port_AHUHWRet) annotation (
      Line(points={{-26,10},{-26,4},{-14,4},{-14,-36},{-28,-36},{-28,-60}},
        color={0,127,255}));
  annotation (
      __Dymola_Commands(file="modelica://SystemModel/Resources/Scripts/Dymola/BoilerPlant/Validation/System.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}})));
end System;
