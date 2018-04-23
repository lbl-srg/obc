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
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
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
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
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
status signals\"" annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain percConv(k=0.01) "\"Convert from % to 0 - 1 range\""
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  HeatingCoilValve heaValSta annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold flowOn(threshold=1)
    "\"Flow on signal\"" annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold manOver(threshold=1)
    "\"Manual override signal\""
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold heaReq(threshold=1)
    "\"Heating required signal\""
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));
  Buildings.Controls.OBC.CDL.Logical.And enable1 "Aggregated enable signal"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  inner Buildings.Utilities.Plotters.Configuration plotConfiguration(
    samplePeriod=1,
    fileName="b33_ahu_2_validation.html",
    timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.hours,
    activation=Buildings.Utilities.Plotters.Types.GlobalActivation.always)
    "\"Visualization of heating valve sequence validation against reference data from B33-AHU-2\""
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Utilities.Plotters.Scatter correlation(
    samplePeriod=1,
    n=2,
    title="OBC heating valve signal",
    xlabel="B33-AHU-2 heating valve signal") "\"Reference vs. output results\""
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Buildings.Utilities.Plotters.TimeSeries timSerRes(
    n=2,
    title="Reference and result heating valve control signal",
    legend={"Heating valve control signal, OBC","Heating valve control signal, B33-AHU-2"})
    "\"Reference and result heating valve control signal\""
    annotation (Placement(transformation(extent={{98,94},{118,114}})));
  Buildings.Utilities.Diagnostics.CheckEquality cheEqu
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Utilities.Plotters.TimeSeries timSerInp(
    n=3,
    title="Input signals",
    legend={"Supply air temperature, [K]","Supply air temperature setpoint, [K]",
        "Outdoor air temperature, [K]"}) "\"Input signals\""
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TSupUniCon(k=5/9, p=-(5*32)/9 + 273.15)
    "\"FtoC\"" annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TSupSetUniCon(p=-(5*32)/9 + 273.15, k=5/9)
    "\"FtoC\"" annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TOutUniCon(p=-(5*32)/9 + 273.15, k=5/9)
    "\"FtoC\"" annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(heatingValveSignal.y[1], percConv.u)
    annotation (Line(points={{-119,90},{-102,90}}, color={0,0,127}));
  connect(EnableDisableSignals.y[1], flowOn.u)
    annotation (Line(points={{-119,-60},{-110,-60},{-110,-40},{-102,-40}}, color={0,0,127}));
  connect(flowOn.y, heaValSta.uSupFan)
    annotation (Line(points={{-79,-40},{-30,-40},{-30,25},{19,25}}, color={255,0,255}));
  connect(TSupply_F.y[1], heaValSta.TSup)
    annotation (Line(points={{-119,50},{-50,50},{-50,40},{19,40}},  color={0,0,127}));
  connect(heaValSta.TSupSet, TSupSetpoint_F.y[1])
    annotation (Line(points={{19,37},{-50,37},{-50,20},{-119,20}},      color={0,0,127}));
  connect(TOut_F.y[1], heaValSta.TOut)
    annotation (Line(points={{-119,-10},{-40,-10},{-40,32},{-40,32},{-40,33},{19,33}},
                                  color={0,0,127}));
  connect(EnableDisableSignals.y[2], manOver.u)
    annotation (Line(points={{-119,-60},{-110,-60},{-110,-70},{-102,-70}}, color={0,0,127}));
  connect(EnableDisableSignals.y[3], heaReq.u)
    annotation (Line(points={{-119,-60},{-110,-60},{-110,-100},{-102,-100}}, color={0,0,127}));
  connect(manOver.y, not1.u) annotation (Line(points={{-79,-70},{-72,-70}}, color={255,0,255}));
  connect(not1.y, enable1.u1)
    annotation (Line(points={{-49,-70},{-46,-70},{-46,-80},{-42,-80}}, color={255,0,255}));
  connect(heaReq.y, enable1.u2)
    annotation (Line(points={{-79,-100},{-60,-100},{-60,-88},{-42,-88}}, color={255,0,255}));
  connect(enable1.y, heaValSta.uEnable)
    annotation (Line(points={{-19,-80},{0,-80},{0,20},{19,20}}, color={255,0,255}));
  connect(heaValSta.yHeaVal, correlation.y[1])
    annotation (Line(points={{41,32},{60,32},{60,31},{98,31}}, color={0,0,127}));
  connect(percConv.y, correlation.x)
    annotation (Line(points={{-79,90},{32,90},{32,90},{66,90},{66,22},{98,22}}, color={0,0,127}));
  connect(heaValSta.yHeaVal, cheEqu.u2)
    annotation (Line(points={{41,32},{60,32},{60,-36},{98,-36}}, color={0,0,127}));
  connect(percConv.y, cheEqu.u1)
    annotation (Line(points={{-79,90},{80,90},{80,-24},{98,-24}}, color={0,0,127}));
  connect(heaValSta.yHeaVal, timSerRes.y[1]) annotation (Line(points={{41,32},{50,32},{50,104},{74,
          104},{74,105},{96,105}}, color={0,0,127}));
  connect(percConv.y, timSerRes.y[2]) annotation (Line(points={{-79,90},{-38,90},{-38,108},{50,108},
          {50,106},{96,106},{96,103}}, color={0,0,127}));
  connect(percConv.y, correlation.y[2])
    annotation (Line(points={{-79,90},{90,90},{90,29},{98,29},{98,29}}, color={0,0,127}));
  connect(TSupply_F.y[1], TSupUniCon.u)
    annotation (Line(points={{-119,50},{-90,50},{-90,60},{-82,60}}, color={0,0,127}));
  connect(TSupUniCon.y, timSerInp.y[1])
    annotation (Line(points={{-59,60},{28,60},{28,71.3333},{98,71.3333}}, color={0,0,127}));
  connect(TSupSetpoint_F.y[1], TSupSetUniCon.u)
    annotation (Line(points={{-119,20},{-90,20},{-90,30},{-82,30}}, color={0,0,127}));
  connect(TOut_F.y[1], TOutUniCon.u)
    annotation (Line(points={{-119,-10},{-90,-10},{-90,0},{-82,0}}, color={0,0,127}));
  connect(TSupSetUniCon.y, timSerInp.y[2]) annotation (Line(points={{-59,30},{-52,30},{-52,68},{24,
          68},{24,70},{98,70}}, color={0,0,127}));
  connect(TOutUniCon.y, timSerInp.y[3])
    annotation (Line(points={{-59,0},{-46,0},{-46,68.6667},{98,68.6667}}, color={0,0,127}));
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
