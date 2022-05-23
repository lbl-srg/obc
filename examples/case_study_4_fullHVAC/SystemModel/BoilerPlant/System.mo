within SystemModel.BoilerPlant;
model System
  "Primary-only condensing boiler plant with controller defined by RP-1711"

  package MediumA = Buildings.Media.Air "Medium model for air";
  package MediumW = Buildings.Media.Water "Medium model for water";

  parameter Modelica.Units.SI.MassFlowRate mSec_flow_nominal=100
    "Secondary loop nominal mass flow rate";

  parameter Real boiDesCap(
    final unit="W",
    displayUnit="W",
    final quantity="Power")= 4000000
    "Total boiler plant design capacity";

  parameter Real boiCapRat(
    final unit="1",
    displayUnit="1") = 2/4.3
    "Ratio of capacity of boiler-1 to total boiler plant capacity";

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal_value=6000
    "Nominal pressure drop of fully open valve, used if CvData=Buildings.Fluid.Types.CvTypes.OpPoint";

  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal_value=1000
    "Pressure drop of pipe and other resistances that are in series";

  SystemModel.BoilerPlant.Submodels.BoilerPlant boiPla(
    boiCap1=(1 - boiCapRat)*boiDesCap,
    boiCap2=(boiCapRat)*boiDesCap,
    mSec_flow_nominal=mSec_flow_nominal,
    TBoiSup_nominal=333.15,
    TBoiRet_min=323.15,
    conPID(
      controllerType=fill(Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
          2),
      k=fill(10e-3, 2),
      Ti=fill(90, 2)),
    dpValve_nominal_value(displayUnit="Pa") = 20000,
    dpFixed_nominal_value(displayUnit="Pa") = 1000,
    tim1(t=120))
    "Boiler plant model"
    annotation (Placement(transformation(extent={{20,-44},{40,-16}})));

  SystemModel.BoilerPlant.Submodels.BoilerPlantControls.Controller controller(
    final have_priOnl=true,
    final have_varPriPum=true,
    final have_varSecPum=false,
    final nSenPri=1,
    final nPumPri_nominal=1,
    final nPumSec=0,
    final nSenSec=0,
    final nPumSec_nominal=0,
    TPlaHotWatSetMax=273.15 + 50,
    triAmoVal=-1.111,
    resAmoVal=1.667,
    maxResVal=3.889,
    final VHotWatPri_flow_nominal=0.02,
    final maxLocDpPri=50000,
    final minLocDpPri=50000,
    final VHotWatSec_flow_nominal=1e-6,
    final nBoi=2,
    final boiTyp={SystemModel.BoilerPlant.Submodels.BoilerPlantControls.Types.BoilerTypes.condensingBoiler,
        SystemModel.BoilerPlant.Submodels.BoilerPlantControls.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final boiDesCap={boiCapRat*boiDesCap,(1 - boiCapRat)*boiDesCap},
    final boiFirMin={0.2,0.3},
    final minFloSet={0.2*boiCapRat*mSec_flow_nominal/2000,0.3*(1 - boiCapRat)*
        mSec_flow_nominal/2000},
    final maxFloSet={boiCapRat*mSec_flow_nominal/2000,(1 - boiCapRat)*
        mSec_flow_nominal/2000},
    final bypSetRat=0.000005,
    final nPumPri=1,
    final TMinSupNonConBoi=333.2,
    final k_bypVal=1,
    final Ti_bypVal=90,
    final Td_bypVal=10e-9,
    final boiDesFlo=controller.maxFloSet,
    final k_priPum=0.1,
    final Ti_priPum=75,
    final Td_priPum=10e-9,
    final minPriPumSpeSta={0,0,0},
    final speConTypPri=SystemModel.BoilerPlant.Submodels.BoilerPlantControls.Types.PrimaryPumpSpeedControlTypes.remoteDP)
    "Boiler plant controller"
    annotation (Placement(transformation(extent={{-40,-58},{-20,10}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}}),
      iconTransformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](k=fill(true, 2))
    "Constant Boolean source"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mSec_flow_nominal,-mSec_flow_nominal,-
        mSec_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={20,50})));

  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mSec_flow_nominal,mSec_flow_nominal,-
        mSec_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={80,80})));

  Modelica.Fluid.Interfaces.FluidPort_a port_RehHWSup(redeclare package Medium =
        MediumW) "Reheat hot water supply port"
    annotation (Placement(transformation(extent={{30,110},{50,130}}),
      iconTransformation(extent={{30,90},{50,110}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_AHUHWSup(redeclare package Medium =
        MediumW) "AHU hot water supply port"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}}),
      iconTransformation(extent={{-90,90},{-70,110}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_AHUHWRet(redeclare package Medium =
        MediumW) "AHU hot water return port"
    annotation (Placement(transformation(extent={{-50,110},{-30,130}}),
      iconTransformation(extent={{-50,90},{-30,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput THotWatSupResReq
    "Requests to reset HW supply temperature"
 annotation (Placement(transformation(extent={{-160,10},{-120,50}}),
  iconTransformation(extent={{-140,20},{-100,60}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_RehHWRet(redeclare package Medium =
        MediumW) "Reheat hot water return port"
    annotation (Placement(transformation(extent={{70,110},{90,130}}),
      iconTransformation(extent={{70,90},{90,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput hotWatPlaReq
    "Hot water plant requests" annotation (Placement(transformation(extent={{-160,
            -20},{-120,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonAve(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured zone average temperature"
    annotation (Placement(transformation(extent={{-160,-50},{-120,-10}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

equation
  connect(controller.yBoi, boiPla.uBoiSta) annotation (Line(points={{-18,-14},{
          0,-14},{0,-21},{18,-21}},
                               color={255,0,255}));
  connect(controller.TBoiHotWatSupSet, boiPla.TBoiHotWatSupSet) annotation (
      Line(points={{-18,-18},{8,-18},{8,-39},{18,-39}},
                                                    color={0,0,127}));
  connect(controller.yHotWatIsoVal, boiPla.uHotIsoVal) annotation (Line(points={{-18,-22},
          {14,-22},{14,-24},{18,-24}},     color={0,0,127}));
  connect(controller.yBypValPos, boiPla.uBypValSig) annotation (Line(points={{-18,-26},
          {12,-26},{12,-33},{18,-33}},    color={0,0,127}));
  connect(controller.yPriPum, boiPla.uPumSta) annotation (Line(points={{-18,-30},
          {-6,-30},{-6,-27},{18,-27}},
                                    color={255,0,255}));
  connect(controller.yPriPumSpe, boiPla.uPumSpe)
    annotation (Line(points={{-18,-34},{0,-34},{0,-30},{18,-30}},
                                                  color={0,0,127}));
  connect(boiPla.yBypValPos, controller.uBypValPos) annotation (Line(points={{42,-20},
          {80,-20},{80,-100},{-60,-100},{-60,-53},{-42,-53}},color={0,0,127}));
  connect(boiPla.ySupTem, controller.TSupPri) annotation (Line(points={{42,-23},
          {78,-23},{78,-98},{-58,-98},{-58,-1},{-42,-1}},
                                                        color={0,0,127}));
  connect(boiPla.yRetTem, controller.TRetPri) annotation (Line(points={{42,-26},
          {76,-26},{76,-96},{-56,-96},{-56,-4},{-42,-4}},
                                                        color={0,0,127}));
  connect(boiPla.yHotWatDp, controller.dpHotWatPri_rem) annotation (Line(points={{42,-29},
          {74,-29},{74,-94},{-54,-94},{-54,-13},{-42,-13}},    color={0,0,127}));
  connect(boiPla.VHotWat_flow, controller.VHotWatPri_flow) annotation (Line(
        points={{42,-32},{72,-32},{72,-92},{-52,-92},{-52,-7},{-42,-7}}, color={
          0,0,127}));
  connect(boiPla.yPumSta, controller.uPriPum) annotation (Line(points={{42,-38},
          {68,-38},{68,-88},{-48,-88},{-48,-44},{-42,-44}}, color={255,0,255}));
  connect(boiPla.yBoiSta, controller.uBoi) annotation (Line(points={{42,-35},{
          70,-35},{70,-90},{-50,-90},{-50,-41},{-42,-41}},
                                                        color={255,0,255}));
  connect(boiPla.yHotWatIsoVal, controller.uHotWatIsoVal) annotation (Line(
        points={{42,-41},{66,-41},{66,-86},{-46,-86},{-46,-50},{-42,-50}},
        color={0,0,127}));
  connect(weaBus.TDryBul, controller.TOut) annotation (Line(
      points={{-60,60},{-60,2},{-42,2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(con.y, controller.uBoiAva) annotation (Line(points={{-68,-20},{-60,-20},
          {-60,-16},{-42,-16}},
                       color={255,0,255}));
  connect(spl4.port_2, port_AHUHWSup) annotation (Line(points={{20,60},{20,76},
          {-80,76},{-80,120}},color={0,127,255}));
  connect(spl4.port_3, port_RehHWSup)
    annotation (Line(points={{30,50},{40,50},{40,120}}, color={0,127,255}));
  connect(spl1.port_1, port_RehHWRet) annotation (Line(points={{80,90},{80,100},
          {80,100},{80,120}},
                          color={0,127,255}));
  connect(port_AHUHWRet, spl1.port_3) annotation (Line(points={{-40,120},{-40,100},
          {-40,100},{-40,80},{70,80}},  color={0,127,255}));
  connect(THotWatSupResReq, controller.TSupResReq) annotation (Line(points={{-140,
          30},{-50,30},{-50,8},{-42,8}}, color={255,127,0}));
  connect(hotWatPlaReq, controller.plaReq) annotation (Line(points={{-140,0},{-100,
          0},{-100,5},{-42,5}}, color={255,127,0}));
  connect(TZonAve, boiPla.TZon) annotation (Line(points={{-140,-30},{-100,-30},
          {-100,-80},{10,-80},{10,-36},{18,-36}},color={0,0,127}));
  connect(boiPla.port_b, spl4.port_1) annotation (Line(points={{23.4,-20.2},{
          23.4,20},{20,20},{20,40}},
                            color={0,127,255}));
  connect(boiPla.port_a, spl1.port_2) annotation (Line(points={{37,-20.2},{37,
          10},{80,10},{80,70}},
                          color={0,127,255}));
  connect(controller.TPlaHotWatSupSet, boiPla.TPlaHotWatSupSet) annotation (
      Line(points={{-18,-10},{4,-10},{4,-42},{18,-42}},         color={0,0,127}));
  connect(controller.yPla, boiPla.uPla) annotation (Line(points={{-18,-6},{12,
          -6},{12,-18},{18,-18}}, color={255,0,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,-120},{120,
            120}})),
    __Dymola_Commands(file=
          "./Resources/Scripts/Dymola/Examples/VAVReheat/Guideline36.mos"
        "Simulate and plot"),
    experiment(
      StartTime=86400,
      StopTime=192800,
      Interval=60,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
                                             Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(
      info="<html>
<p>
This model consist of a boiler plant model coupled with a controller implemented
as per sequences defined in ASHRAE RP-1711.
</p>
<p>
The boiler plant consists of a primary-only boiler plant with two condensing boilers
and a single primary pump. It also has isolation valves for each boiler, and a 
bypass control valve to regulate the flow at minimum required flowrate for safe
operation of the boilers.
</p>
<p>
See the model
<a href=\"modelica://SystemModel.BoilerPlant.Submodels.BoilerPlant\">
SystemModel.BoilerPlant.Submodels.BoilerPlant</a>
for a description of the boiler plant.
</p>
<p>
The control is based on ASHRAE RP-1711, and implemented
using the sequences from the library
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant</a> for boiler plants.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 1, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end System;
