within OBCSequenceValidation.Validation;
model HeatingCoilValve_ValidationWithB33Data_alc
  "Validation model for the heating coil control subsequence with real data trends"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.CombiTimeTable heatingValveSignal(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    tableName="33-HC-22_Heating_Valve",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-HC-22_Heating_Valve.mos"),
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={1,2,3})            "\"Output of the heating valve control subsequence\""
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Modelica.Blocks.Sources.CombiTimeTable TOut_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="OA_Temp",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_OA_Temp.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={1,2,3})
    "\"Measured outdoor air temperature\""
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupSetpoint_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={1,2,3},
    tableName="SA_Stpt",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_SA_Stpt.mos"))
    "\"Supply air temperature setpoint\""
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupply_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={1,2,3},
    tableName="SA_Htg_Stpt",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-AHU-02_SA_Htg_Stpt.mos"))
    "\"Measured supply air temperature\""
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Modelica.Blocks.Sources.CombiTimeTable EnableDisableSignals(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableName="33-HC-22_flow_status_and_manual_override",
    fileName=(
        "/home/mg/data/B33-AHU-2-HtVal/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-HC-22_flow_status_and_manual_override.mos"),
    columns={1,2,3,4})
                     "\"Flow on, manual vverride and heating required status signals\""
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain percConvHeaValSig(k=0.01)
    "\"Convert from % to 0 - 1 range\""
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold flowOn(threshold=1)
    "\"Flow on signal\""
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold manOver(threshold=1)
    "\"Manual override signal\""
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));

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
    legend={"OBC heating valve signal"},
    n=1)                                     "\"Reference vs. output results\""
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
    annotation (Placement(transformation(extent={{-20,34},{0,54}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter TOutUniCon(k=5/9, p=-(5*32)/9)
    "\"FtoC\""
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter heatingTSupSetpoint(k=1,
    y(unit="F"),
    p=0)
    "\"Heating SAT setpoint is 1F lower than the SAT setpoint\""
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  HeatingCoilValve_F_alc heaValSta_F_alc(reverseAction=true)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(manOver.y, not1.u) annotation (Line(points={{-79,-70},{-72,-70}}, color={255,0,255}));
  connect(percConvHeaValSig.y, correlation.x)
    annotation (Line(points={{-79,90},{32,90},{32,90},{66,90},{66,22},{98,22}}, color={0,0,127}));
  connect(percConvHeaValSig.y, delta.u1)
    annotation (Line(points={{-79,90},{80,90},{80,-24},{98,-24}}, color={0,0,127}));
  connect(percConvHeaValSig.y, timSerRes.y[1]) annotation (Line(points={{-79,90},{-40,90},{-40,108},
          {50,108},{50,106},{96,106},{96,105}}, color={0,0,127}));
  connect(TSupUniCon.y, timSerInp.y[1])
    annotation (Line(points={{-79,60},{-50,60},{-50,71.3333},{98,71.3333}},
                                                                          color={0,0,127}));
  connect(TSupSetUniCon.y, timSerInp.y[2]) annotation (Line(points={{1,44},{10,44},{10,70},{98,70}},
                                color={0,0,127}));
  connect(TOutUniCon.y, timSerInp.y[3])
    annotation (Line(points={{-79,-10},{-40,-10},{-40,66},{26,66},{26,68.6667},{98,68.6667}},
                                                                          color={0,0,127}));
  connect(heaValSta_F_alc.yHeaVal, timSerRes.y[2])
    annotation (Line(points={{21,10},{58,10},{58,103},{96,103}}, color={0,0,127}));
  connect(heaValSta_F_alc.yHeaVal, correlation.y[1])
    annotation (Line(points={{21,10},{58,10},{58,30},{98,30}}, color={0,0,127}));
  connect(heaValSta_F_alc.yHeaVal, delta.u2)
    annotation (Line(points={{21,10},{58,10},{58,-36},{98,-36}}, color={0,0,127}));
  connect(flowOn.y, heaValSta_F_alc.uSupFan) annotation (Line(points={{-79,-40},{-20,-40},{-20,4},{
          -20,4},{-20,5},{-1,5}}, color={255,0,255}));
  connect(heatingTSupSetpoint.y, TSupSetUniCon.u)
    annotation (Line(points={{-79,20},{-34,20},{-34,44},{-22,44}}, color={0,0,127}));
  connect(not1.y, heaValSta_F_alc.uEnable)
    annotation (Line(points={{-49,-70},{-10,-70},{-10,0},{-1,0}}, color={255,0,255}));
  connect(heatingValveSignal.y[3], percConvHeaValSig.u)
    annotation (Line(points={{-119,90},{-102,90}}, color={0,0,127}));
  connect(TSupply_F.y[3], TSupUniCon.u)
    annotation (Line(points={{-119,50},{-110,50},{-110,60},{-102,60}}, color={0,0,127}));
  connect(TSupply_F.y[3], heaValSta_F_alc.TSup)
    annotation (Line(points={{-119,50},{-30,50},{-30,20},{-1,20}}, color={0,0,127}));
  connect(TSupSetpoint_F.y[3], heatingTSupSetpoint.u)
    annotation (Line(points={{-119,20},{-102,20}}, color={0,0,127}));
  connect(TOut_F.y[3], TOutUniCon.u)
    annotation (Line(points={{-119,-20},{-110,-20},{-110,-10},{-102,-10}}, color={0,0,127}));
  connect(TOut_F.y[3], heaValSta_F_alc.TOut) annotation (Line(points={{-119,-20},{-24,-20},{-24,12},
          {-24,12},{-24,13},{-1,13}}, color={0,0,127}));
  connect(EnableDisableSignals.y[3], flowOn.u)
    annotation (Line(points={{-119,-60},{-110,-60},{-110,-40},{-102,-40}}, color={0,0,127}));
  connect(EnableDisableSignals.y[4], manOver.u)
    annotation (Line(points={{-119,-60},{-110,-60},{-110,-70},{-102,-70}}, color={0,0,127}));
  connect(heaValSta_F_alc.TSupSet, heatingTSupSetpoint.y) annotation (Line(points={{-1,17},{-30,17},
          {-60,17},{-60,18},{-60,18},{-60,18},{-60,20},{-79,20}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-06),
  __Dymola_Commands(file="HeatingCoilValve_ValidationWithB33Data_alc.mos"
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
end HeatingCoilValve_ValidationWithB33Data_alc;
