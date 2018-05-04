within OBCSequenceValidation.Validation;
model CoolingCoilValve_ValidationWithB33Data
  "Validation model for the cooling coil control subsequence with real data trends"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.CombiTimeTable TOut_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    columns={2},
    timeScale(displayUnit="s"),
    tableName="OA_Temp",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_OA_Temp.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "\"Measured outdoor air temperature\""
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupSetpoint_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    columns={2},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="SA_Clg_Stpt",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_SA_Clg_Stpt.mos"))
    "\"Supply air temperature setpoint\""
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupply_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    columns={2},
    timeScale(displayUnit="s"),
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-AHU-02_Supply_Air_Temp.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="33-AHU-02_Supply_Air_Temp") "\"Measured supply air temperature\""
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Modelica.Blocks.Sources.CombiTimeTable EnableDisableSignals(
    tableOnFile=true,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-HC-22_Manualy_Created_Enable_Statuses.mos"),
    columns={2,3,4},
    tableName="33-HC-22_Manualy_Created_Enable_Statuses")
                     "\"Flow on, manual vverride and cooling required status signals\""
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  CoolingCoilValve_F cooValSta_F(
    genEna=true,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    revAct=true)
    "Cooling valve position control sequence"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain percConvCooValSig(k=0.01)
    "Percentage to number converter"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold flowOn(threshold=1)
    "\"Flow on signal\""
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold manOver(threshold=1)
    "\"Manual override signal\""
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold cooReq(threshold=1)
    "\"Cooling required signal\""
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));

  Buildings.Controls.OBC.CDL.Logical.And enable1 "Aggregated enable signal"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

  inner Buildings.Utilities.Plotters.Configuration plotConfiguration(
    timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.hours,
    activation=Buildings.Utilities.Plotters.Types.GlobalActivation.always,
    samplePeriod=300,
    fileName="b33_ahu_2_cooling_validation.html")
    "\"Visualization of cooling valve sequence validation against reference data from B33-AHU-2\""
    annotation (Placement(transformation(extent={{140,80},{160,100}})));

  Buildings.Utilities.Plotters.Scatter correlation(
    title="OBC cooling valve signal",
    xlabel="B33-AHU-2 cooling valve signal",
    n=1,
    legend={"OBC cooling valve signal"})     "\"Reference vs. output results\""
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Utilities.Plotters.TimeSeries timSerRes(
    title="Reference and result cooling valve control signal",
    legend={"Cooling valve control signal, OBC","Cooling valve control signal, B33-AHU-2"},
    n=2)
    "\"Reference and result cooling valve control signal\""
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Add delta(k2=-1)
    "Delta between the reference and the calculated control signal"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Utilities.Plotters.TimeSeries timSerInp(
    n=3,
    title="Input signals",
    legend={"Supply air temperature, [K]","Supply air temperature setpoint, [K]",
        "Outdoor air temperature, [K]"})
     "\"Input signals\""
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TSupUniCon(k=5/9, p=-(5*32)/9)
    "\"FtoC\""
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter TSupSetUniCon(k=5/9, p=-(5*32)/9) "\"FtoC\""
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter TOutUniCon(k=5/9, p=-(5*32)/9)
    "\"FtoC\""
    annotation (Placement(transformation(extent={{-102,-20},{-82,0}})));


  Modelica.Blocks.Sources.CombiTimeTable coolingValveSignal(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    columns={2},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableName="Clg_Coil_Valve",
    fileName=("/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-CC-22_Clg_Coil_Valve.mos"))
    "\"Output of the cooling valve control subsequence\""
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter coolingTSupSetpoint(k=1, p=-5)
    "\"Heating SAT setpoint is 1F lower than the SAT setpoint\""
    annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
equation
  connect(EnableDisableSignals.y[1], flowOn.u)
    annotation (Line(points={{-119,-60},{-110,-60},{-110,-40},{-102,-40}}, color={0,0,127}));
  connect(flowOn.y,cooValSta_F. uSupFan)
    annotation (Line(points={{-79,-40},{-10,-40},{-10,24},{4,24},{4,25},{19,25}},
    color={255,0,255}));
  connect(TSupply_F.y[1],cooValSta_F. TSup)
    annotation (Line(points={{-119,50},{-50,50},{-50,40},{19,40}}, color={0,0,127}));
  connect(TOut_F.y[1],cooValSta_F. TOut)
    annotation (Line(points={{-119,-20},{-36,-20},{-36,32},{-8,
          32},{-8,33},{19,33}}, color={0,0,127}));
  connect(EnableDisableSignals.y[2], manOver.u)
    annotation (Line(points={{-119,-60},{-110,-60},{-110,-70},{-102,-70}}, color={0,0,127}));
  connect(EnableDisableSignals.y[3], cooReq.u)
    annotation (Line(points={{-119,-60},{-110,-60},{-110,-100},{-102,-100}}, color={0,0,127}));
  connect(manOver.y, not1.u)
    annotation (Line(points={{-79,-70},{-72,-70}}, color={255,0,255}));
  connect(not1.y, enable1.u1)
    annotation (Line(points={{-49,-70},{-46,-70},{-46,-80},{-42,-80}}, color={255,0,255}));
  connect(cooReq.y, enable1.u2)
    annotation (Line(points={{-79,-100},{-60,-100},{-60,-88},{-42,-88}}, color={255,0,255}));
  connect(enable1.y,cooValSta_F. uEnable)
    annotation (Line(points={{-19,-80},{0,-80},{0,20},{19,20}}, color={255,0,255}));
  connect(TSupply_F.y[1], TSupUniCon.u)
    annotation (Line(points={{-119,50},{-110,50},{-110,60},{-102,60}},
                                                                    color={0,0,127}));
  connect(TSupUniCon.y, timSerInp.y[1])
    annotation (Line(points={{-79,60},{28,60},{28,71.3333},{98,71.3333}}, color={0,0,127}));
  connect(TSupSetpoint_F.y[1], TSupSetUniCon.u)
    annotation (Line(points={{-119,20},{-110,20},{-110,30},{-102,30}}, color={0,0,127}));
  connect(TOut_F.y[1], TOutUniCon.u)
    annotation (Line(points={{-119,-20},{-110,-20},{-110,-10},{-104,-10}},
    color={0,0,127}));
  connect(TSupSetUniCon.y, timSerInp.y[2])
    annotation (Line(points={{-79,30},{-52,30},{-52,68},{24,68},
    {24,70},{98,70}}, color={0,0,127}));
  connect(TOutUniCon.y, timSerInp.y[3])
    annotation (Line(points={{-81,-10},{-40,-10},{-40,66},{26,66},{26,68.6667},{98,68.6667}},
    color={0,0,127}));
  connect(cooValSta_F.yCooVal, timSerRes.y[1])
    annotation (Line(points={{41,32},{50,32},{50,101},{98,101}}, color={0,0,127}));
  connect(cooValSta_F.yCooVal, delta.u2)
    annotation (Line(points={{41,32},{60,32},{60,-36},{98,-36}}, color={0,0,127}));
  connect(cooValSta_F.yCooVal, correlation.y[1])
    annotation (Line(points={{41,32},{70,32},{70,30},{98,30}}, color={0,0,127}));
  connect(percConvCooValSig.y, timSerRes.y[2])
    annotation (Line(points={{-79,90},{8,90},{8,99},{98,99}},   color={0,0,127}));
  connect(percConvCooValSig.y, correlation.x)
    annotation (Line(points={{-79,90},{80,90},{80,22},{98,22}}, color={0,0,127}));
  connect(percConvCooValSig.y, delta.u1) annotation (Line(points={{-79,90},{72,90},{72,-24},{88,-24},
          {88,-24},{98,-24}}, color={0,0,127}));
  connect(coolingValveSignal.y[1], percConvCooValSig.u)
    annotation (Line(points={{-119,90},{-102,90}}, color={0,0,127}));
  connect(coolingTSupSetpoint.y, cooValSta_F.TSupSet) annotation (Line(points={{-49,10},{-26,10},{
          -26,36},{-26,36},{-26,37},{19,37}}, color={0,0,127}));
  connect(TSupSetpoint_F.y[1], coolingTSupSetpoint.u)
    annotation (Line(points={{-119,20},{-96,20},{-96,10},{-72,10}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-06),startTime = 3733553700, stopTime=3733560900,
  __Dymola_Commands(file="CoolingCoilValve_ValidationWithB33Data.mos"
    "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates the cooling coil signal subsequence implemented using CDL blocks 
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
end CoolingCoilValve_ValidationWithB33Data;
