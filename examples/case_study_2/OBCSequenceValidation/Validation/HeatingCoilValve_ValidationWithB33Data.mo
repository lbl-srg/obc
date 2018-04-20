within OBCSequenceValidation.Validation;
model HeatingCoilValve_ValidationWithB33Data
  "Validation model for a system with heating, cooling and hot water"
  extends Modelica.Icons.Example;

  parameter Real TOutHeaCut(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 293.15
    "Upper outdoor air temperature limit for enabling heating (68 F)";

  parameter Real TSup(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 289
    "Supply air temperature";

  parameter Real TSupSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 294.261
    "Supply air temperature setpoint";

  parameter Real TSatMinLowLim(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 277.5944
    "Minimum supply air temperature for defining the lower limit of the valve position (40 F)"
    annotation(Evaluate=true);

  parameter Real TSatMaxLowLim(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 280.3722
    "Maximum supply air temperature for defining the lower limit of the valve position (45 F)"
    annotation(Evaluate=true);

  parameter Real LowTSupSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 279
    "Fictive low supply air temeprature setpoint to check the limiter functionality"
    annotation(Evaluate=true);

// Tests disable if supply fan is off

// Tests disable if it is warm outside

// Tests controler normal operation when supply air temperature is above limiter values

// Tests controler operation when supply air temperature is within limiter values

  Modelica.Blocks.Sources.CombiTimeTable heatingValveSignal(
    tableOnFile=true,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    columns={2},
    tableName="33-HC-22_Heating_Valve",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-HC-22_Heating_Valve.mos"),
    timeScale(displayUnit="s")) "\"Output of the heating valve control subsequence\""
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Modelica.Blocks.Sources.CombiTimeTable TOut_F(
    tableOnFile=true,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    columns={2},
    timeScale(displayUnit="s"),
    tableName="OA_Temp",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_OA_Temp.mos"))
    "\"Measured outdoor air temperature\""
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Modelica.Blocks.Sources.CombiTimeTable TSupSetpoint_F(
    tableOnFile=true,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    columns={2},
    timeScale(displayUnit="s"),
    tableName="SA_Stpt",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_SA_Stpt.mos"))
    "\"Supply air temperature setpoint\""
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Modelica.Blocks.Sources.CombiTimeTable TSupply_F(
    tableOnFile=true,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    columns={2},
    timeScale(displayUnit="s"),
    tableName="Supply_Air_Temp",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-AHU-02_Supply_Air_Temp.mos"))
    "\"Measured supply air temperature\""
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Modelica.Blocks.Sources.CombiTimeTable EnableDisableSignals(
    tableOnFile=true,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="Manualy_Created_Enable_Statuses",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-HC-22_Manualy_Created_Enable_Statuses.mos"),
    columns={2,3,4}) "\"Flow on, manual vverride and heating required
status signals\"" annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain percConv(k=0.01) "\"Convert from % to 0 - 1 range\""
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  HeatingCoilValve heaValSta annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold flowOn(threshold=1)
    "\"Flow on signal\"" annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold manOver(threshold=1)
    "\"Manual override signal\""
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold heaReq(threshold=1)
    "\"Heating required signal\""
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And enable1 "Aggregated enable signal"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  inner Buildings.Utilities.Plotters.Configuration plotConfiguration(
    samplePeriod=1,
    fileName="b33_ahu_2_validation.html",
    timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.hours,
    activation=Buildings.Utilities.Plotters.Types.GlobalActivation.always)
    "\"Visualization of heating valve sequence validation against reference data from B33-AHU-2\""
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Utilities.Plotters.Scatter sca(samplePeriod=1)
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Buildings.Utilities.Plotters.TimeSeries timSer
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
equation
  connect(heatingValveSignal.y[1], percConv.u)
    annotation (Line(points={{-119,90},{-102,90}}, color={0,0,127}));
  connect(EnableDisableSignals.y[1], flowOn.u)
    annotation (Line(points={{-119,-70},{-110,-70},{-110,-50},{-102,-50}}, color={0,0,127}));
  connect(flowOn.y, heaValSta.uSupFan)
    annotation (Line(points={{-79,-50},{-50,-50},{-50,25},{19,25}}, color={255,0,255}));
  connect(TSupply_F.y[1], heaValSta.TSup)
    annotation (Line(points={{-119,50},{-70,50},{-70,40},{19,40}},  color={0,0,127}));
  connect(heaValSta.TSupSet, TSupSetpoint_F.y[1])
    annotation (Line(points={{19,37},{-69.5,37},{-69.5,10},{-119,10}},  color={0,0,127}));
  connect(TOut_F.y[1], heaValSta.TOut)
    annotation (Line(points={{-119,-30},{-60,-30},{-60,32},{-40,32},{-40,33},{19,33}},
                                  color={0,0,127}));
  connect(EnableDisableSignals.y[2], manOver.u)
    annotation (Line(points={{-119,-70},{-110,-70},{-110,-80},{-102,-80}}, color={0,0,127}));
  connect(EnableDisableSignals.y[3], heaReq.u)
    annotation (Line(points={{-119,-70},{-110,-70},{-110,-110},{-102,-110}}, color={0,0,127}));
  connect(manOver.y, not1.u) annotation (Line(points={{-79,-80},{-72,-80}}, color={255,0,255}));
  connect(not1.y, enable1.u1)
    annotation (Line(points={{-49,-80},{-46,-80},{-46,-90},{-42,-90}}, color={255,0,255}));
  connect(heaReq.y, enable1.u2)
    annotation (Line(points={{-79,-110},{-60,-110},{-60,-98},{-42,-98}}, color={255,0,255}));
  connect(enable1.y, heaValSta.uEnable)
    annotation (Line(points={{-19,-90},{0,-90},{0,20},{19,20}}, color={255,0,255}));
  annotation(experiment(Tolerance=1e-06),startTime = 15430000, stopTime=15472000,
  __Dymola_Commands(file="HeatingCoilValve_ValidationWithB33Data.mos"
    "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates the heating coil signal subsequence implemented using CDL blocks 
aginst the equivalent OBC implementation as installed in LBNL B33 AHU-2. Data used for the
validation are measured sequence input and output timeseries.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 10, Milica Grahovac<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}})));
end HeatingCoilValve_ValidationWithB33Data;
