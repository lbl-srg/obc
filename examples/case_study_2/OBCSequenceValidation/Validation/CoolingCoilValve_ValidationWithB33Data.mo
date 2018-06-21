within OBCSequenceValidation.Validation;
model CoolingCoilValve_ValidationWithB33Data
  "Validation model for the cooling coil control subsequence with real data trends"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.CombiTimeTable TOut_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="OA_Temp",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=(
        "/home/mg/data/B33-AHU-2-ClVal-5s/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_OA_Temp.mos"),
    columns={3})
    "\"Measured outdoor air temperature\""
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupSetpoint_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="SA_Clg_Stpt",
    fileName=(
        "/home/mg/data/B33-AHU-2-ClVal-5s/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_SA_Clg_Stpt.mos"),
    columns={3})
    "\"Supply air temperature setpoint\""
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Modelica.Blocks.Sources.CombiTimeTable coolingValveSignal(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    fileName=
        "/home/mg/data/B33-AHU-2-ClVal-5s/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-CC-22_Clg_Coil_Valve.mos",
    tableName="33-CC-22_Clg_Coil_Valve",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
                     "Output of the cooling valve control subsequence"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Modelica.Blocks.Sources.CombiTimeTable fanFeedback(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="33-BL-22_VFD_Fan_Feedback",
    fileName=(
        "/home/mg/data/B33-AHU-2-ClVal-5s/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-BL-22_VFD_Fan_Feedback.mos"),
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
                                           "Fan feedback"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Modelica.Blocks.Sources.CombiTimeTable fanStatus(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    fileName=(
        "/home/mg/data/B33-AHU-2-ClVal-5s/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-BL-22_VFD_Fan_Enable.mos"),
    tableName="33-BL-22_VFD_Fan_Enable",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
                     "Fan status"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupply_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="33-AHU-02_Supply_Air_Temp",
    fileName=(
        "/home/mg/data/B33-AHU-2-ClVal-5s/LBNL_FMCS_Building_33_Roof_33-AHU-02_(Roof)_33-AHU-02_Supply_Air_Temp.mos"),
    columns={3})                           "\"Measured supply air temperature\""
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  CoolingCoilValve_F_alc
                     cooValSta_F(
    reverseAction=false,
    k_p=1/100,
    k_i=0.5/100,
    holdIntError=false,
    TOutCooCut=32)
    "Cooling valve position control sequence"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain percConvCooValSig(k=0.01)
    "Percentage to number converter"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

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
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));




  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(threshold=1)
    "Converter to boolean" annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain percConvFanFee(k=0.01)
    "Percentage to number converter"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
equation
  connect(TSupUniCon.y, timSerInp.y[1])
    annotation (Line(points={{-79,60},{20,60},{20,71.3333},{98,71.3333}}, color={0,0,127}));
  connect(TSupSetUniCon.y, timSerInp.y[2])
    annotation (Line(points={{-79,30},{-52,30},{-52,68},{24,68},
    {24,70},{98,70}}, color={0,0,127}));
  connect(TOutUniCon.y, timSerInp.y[3])
    annotation (Line(points={{-79,-10},{-40,-10},{-40,66},{26,66},{26,68.6667},{98,68.6667}},
    color={0,0,127}));
  connect(cooValSta_F.yCooVal, timSerRes.y[1])
    annotation (Line(points={{41,30},{50,30},{50,101},{98,101}}, color={0,0,127}));
  connect(cooValSta_F.yCooVal, delta.u2)
    annotation (Line(points={{41,30},{60,30},{60,-36},{98,-36}}, color={0,0,127}));
  connect(cooValSta_F.yCooVal, correlation.y[1])
    annotation (Line(points={{41,30},{70,30},{70,30},{98,30}}, color={0,0,127}));
  connect(percConvCooValSig.y, timSerRes.y[2])
    annotation (Line(points={{-79,90},{20,90},{20,98},{20,98},{20,98},{20,99},{60,99},{98,99}},
                                                                color={0,0,127}));
  connect(percConvCooValSig.y, correlation.x)
    annotation (Line(points={{-79,90},{80,90},{80,22},{98,22}}, color={0,0,127}));
  connect(percConvCooValSig.y, delta.u1) annotation (Line(points={{-79,90},{70,90},{70,-24},{98,-24}},
                              color={0,0,127}));
  connect(greEquThr.y, cooValSta_F.uFanSta)
    annotation (Line(points={{-79,-90},{0,-90},{0,20},{19,20}}, color={255,0,255}));
  connect(percConvFanFee.y, cooValSta_F.uFanFee) annotation (Line(points={{-79,-60},{-10,-60},{-10,
          24},{-10,24},{-10,-60},{-10,25},{4,25},{19,25}}, color={0,0,127}));
  connect(coolingValveSignal.y[1], percConvCooValSig.u)
    annotation (Line(points={{-119,90},{-102,90}}, color={0,0,127}));
  connect(TSupply_F.y[1], TSupUniCon.u)
    annotation (Line(points={{-119,50},{-110,50},{-110,60},{-102,60}}, color={0,0,127}));
  connect(TSupply_F.y[1], cooValSta_F.TSup)
    annotation (Line(points={{-119,50},{-50,50},{-50,40},{19,40}}, color={0,0,127}));
  connect(TOut_F.y[1], TOutUniCon.u)
    annotation (Line(points={{-119,-20},{-108,-20},{-108,-10},{-102,-10}}, color={0,0,127}));
  connect(TOut_F.y[1], cooValSta_F.TOut)
    annotation (Line(points={{-119,-20},{-16,-20},{-16,33},{19,33}}, color={0,0,127}));
  connect(fanFeedback.y[1], percConvFanFee.u)
    annotation (Line(points={{-119,-60},{-102,-60}}, color={0,0,127}));
  connect(fanStatus.y[1], greEquThr.u)
    annotation (Line(points={{-119,-90},{-102,-90}}, color={0,0,127}));
  connect(TSupSetpoint_F.y[1], TSupSetUniCon.u)
    annotation (Line(points={{-119,20},{-110,20},{-110,30},{-102,30}}, color={0,0,127}));
  connect(TSupSetpoint_F.y[1], cooValSta_F.TSupSet)
    annotation (Line(points={{-119,20},{-20,20},{-20,37},{19,37}}, color={0,0,127}));
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
