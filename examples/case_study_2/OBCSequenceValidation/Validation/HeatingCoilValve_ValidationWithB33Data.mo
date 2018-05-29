within OBCSequenceValidation.Validation;
model HeatingCoilValve_ValidationWithB33Data
  "Validation model for the heating coil control subsequence with real data trends"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.CombiTimeTable heatingValveSignal(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    columns={2},
    tableName="33-HC-22_Heating_Valve",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-HC-22_Heating_Valve.mos"),
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
                                "\"Output of the heating valve control subsequence\""
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Modelica.Blocks.Sources.CombiTimeTable TOut_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    columns={2},
    timeScale(displayUnit="s"),
    tableName="OA_Temp",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_OA_Temp.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "\"Measured outdoor air temperature\""
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupSetpoint_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    columns={2},
    timeScale(displayUnit="s"),
    tableName="SA_Stpt",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_SA_Stpt.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
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
    tableName="33-AHU-02_Supply_Air_Temp",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "\"Measured supply air temperature\""
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
                     "\"Flow on, manual vverride and heating required status signals\""
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain percConvHeaValSig(k=0.01)
    "\"Convert from % to 0 - 1 range\""
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  alcPI            alc_PI
                  "Heating valve position control sequence"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold flowOn(threshold=1)
    "\"Flow on signal\""
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

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
    timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.hours,
    activation=Buildings.Utilities.Plotters.Types.GlobalActivation.always,
    samplePeriod=300,
    fileName="b33_ahu_2_heating_validation.html")
    "\"Visualization of heating valve sequence validation against reference data from B33-AHU-2\""
    annotation (Placement(transformation(extent={{140,80},{160,100}})));

  Buildings.Utilities.Plotters.Scatter correlation(
    title="OBC heating valve signal",
    xlabel="B33-AHU-2 heating valve signal",
    n=1,
    legend={"OBC heating valve signal"})     "\"Reference vs. output results\""
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Utilities.Plotters.TimeSeries timSerRes(
    n=2,
    title="Reference and result heating valve control signal",
    legend={"Heating valve control signal, OBC","Heating valve control signal, B33-AHU-2"})
    "\"Reference and result heating valve control signal\""
    annotation (Placement(transformation(extent={{98,94},{118,114}})));
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


  Buildings.Controls.OBC.CDL.Continuous.AddParameter heatingTSupSetpoint(k=1,
    y(unit="F"),
    p=-1)
    "\"Heating SAT setpoint is 1F lower than the SAT setpoint\""
    annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
equation
  connect(EnableDisableSignals.y[1], flowOn.u)
    annotation (Line(points={{-119,-60},{-110,-60},{-110,-40},{-102,-40}}, color={0,0,127}));
  connect(EnableDisableSignals.y[2], manOver.u)
    annotation (Line(points={{-119,-60},{-110,-60},{-110,-70},{-102,-70}}, color={0,0,127}));
  connect(EnableDisableSignals.y[3], heaReq.u)
    annotation (Line(points={{-119,-60},{-110,-60},{-110,-100},{-102,-100}}, color={0,0,127}));
  connect(manOver.y, not1.u) annotation (Line(points={{-79,-70},{-72,-70}}, color={255,0,255}));
  connect(not1.y, enable1.u1)
    annotation (Line(points={{-49,-70},{-46,-70},{-46,-80},{-42,-80}}, color={255,0,255}));
  connect(heaReq.y, enable1.u2)
    annotation (Line(points={{-79,-100},{-60,-100},{-60,-88},{-42,-88}}, color={255,0,255}));
  connect(percConvHeaValSig.y, correlation.x)
    annotation (Line(points={{-79,90},{32,90},{32,90},{66,90},{66,22},{98,22}}, color={0,0,127}));
  connect(percConvHeaValSig.y, delta.u1)
    annotation (Line(points={{-79,90},{80,90},{80,-24},{98,-24}}, color={0,0,127}));
  connect(percConvHeaValSig.y, timSerRes.y[2]) annotation (Line(points={{-79,90},{-40,90},{-40,108},
          {50,108},{50,106},{96,106},{96,103}}, color={0,0,127}));
  connect(TSupply_F.y[1], TSupUniCon.u)
    annotation (Line(points={{-119,50},{-110,50},{-110,60},{-102,60}},
                                                                    color={0,0,127}));
  connect(TSupUniCon.y, timSerInp.y[1])
    annotation (Line(points={{-79,60},{28,60},{28,71.3333},{98,71.3333}}, color={0,0,127}));
  connect(TSupSetpoint_F.y[1], TSupSetUniCon.u)
    annotation (Line(points={{-119,20},{-110,20},{-110,30},{-102,30}},
                                                                    color={0,0,127}));
  connect(TOut_F.y[1], TOutUniCon.u)
    annotation (Line(points={{-119,-20},{-110,-20},{-110,-10},{-104,-10}},
                                                                    color={0,0,127}));
  connect(TSupSetUniCon.y, timSerInp.y[2]) annotation (Line(points={{-79,30},{-52,30},{-52,68},{24,68},
          {24,70},{98,70}},     color={0,0,127}));
  connect(TOutUniCon.y, timSerInp.y[3])
    annotation (Line(points={{-81,-10},{-40,-10},{-40,66},{26,66},{26,68.6667},{98,68.6667}},
                                                                          color={0,0,127}));
  connect(TSupSetpoint_F.y[1], heatingTSupSetpoint.u)
    annotation (Line(points={{-119,20},{-110,20},{-110,10},{-72,10}},
                                                                    color={0,0,127}));
  connect(heatingValveSignal.y[1], percConvHeaValSig.u)
    annotation (Line(points={{-119,90},{-102,90}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-06),
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
