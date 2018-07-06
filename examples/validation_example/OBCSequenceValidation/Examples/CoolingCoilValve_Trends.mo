within OBCSequenceValidation.Examples;
model CoolingCoilValve_Trends
  "Validation model for the cooling coil control subsequence with recorded data trends"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.CombiTimeTable TOut_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="OA_Temp",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    columns={3},
    fileName=("/home/mg/data/obc_validation_study/trends/OA_Temp.mos"))
    "\"Measured outdoor air temperature\""
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupSetpoint_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="SA_Clg_Stpt",
    columns={3},
    fileName=("/home/mg/data/obc_validation_study/trends/SA_Clg_Stpt.mos"))
    "\"Supply air temperature setpoint\""
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Modelica.Blocks.Sources.CombiTimeTable coolingValveSignal(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="Clg_Coil_Valve",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName="/home/mg/data/obc_validation_study/trends/Clg_Coil_Valve.mos")
    "Output of the cooling valve control subsequence"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Modelica.Blocks.Sources.CombiTimeTable fanFeedback(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="VFD_Fan_Feedback",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=("/home/mg/data/obc_validation_study/trends/VFD_Fan_Feedback.mos"))
    "Fan feedback"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Modelica.Blocks.Sources.CombiTimeTable fanStatus(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="VFD_Fan_Enable",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=("/home/mg/data/obc_validation_study/trends/VFD_Fan_Enable.mos"))
    "Fan status"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupply_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="Supply_Air_Temp",
    columns={3},
    fileName=("/home/mg/data/obc_validation_study/trends/Supply_Air_Temp.mos"))
                                           "\"Measured supply air temperature\""
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  CoolingCoilValve cooValSta(               reverseAction=true,
    TSupHighLim(displayUnit="K"),
    TSupHigLim(displayUnit="K"),
    TOutDelta(displayUnit="K"),
    TOutCooCut(displayUnit="K") = 50*(5/9) - 32*(5/9) + 273.15)
    "Cooling valve position control sequence"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain percConvCooValSig(k=0.01)
    "Percentage to number converter"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  inner Buildings.Utilities.Plotters.Configuration plotConfiguration(
    timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.hours,
    activation=Buildings.Utilities.Plotters.Types.GlobalActivation.always,
    samplePeriod=300,
    fileName="cooling_valve_validation.html")
    "\"Cooling valve control sequence validation\""
    annotation (Placement(transformation(extent={{140,80},{160,100}})));

  Buildings.Utilities.Plotters.Scatter correlation(
    n=1,
    legend={"Modeled cooling valve signal"},
    xlabel="Trended cooling valve signal",
    title="Modeled result/recorded trend correlation")
                                             "\"Reference vs. output results\""
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Utilities.Plotters.TimeSeries timSerRes(
    n=2,
    legend={"Cooling valve control signal, modeled","Cooling valve control signal, trended"},
    title="Cooling valve control signal: reference trend vs. modeled result")
    "\"Cooling valve control signal: reference trend vs. modeled result \""
    annotation (Placement(transformation(extent={{100,80},{120,100}})));

  Buildings.Utilities.Plotters.TimeSeries timSerInp(
    legend={"Supply air temperature, [degC]","Supply air temperature setpoint, [degC]",
        "Outdoor air temperature, [degC]"},
    n=3,
    title="Trended input signals") "\"Trended input signals\""
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(threshold=1)
    "Converter to boolean"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain percConvFanFee(k=0.01)
    "Percentage to number converter"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  FromF FromF1 annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  FromF FromF2 annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  FromF FromF3 annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  ToC ToC1 annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  ToC ToC2 annotation (Placement(transformation(extent={{-60,22},{-40,42}})));
  ToC ToC3 annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(cooValSta.yCooVal, timSerRes.y[1])
    annotation (Line(points={{41,0},{60,0},{60,90},{98,90},{98,91}},
                                                                 color={0,0,127}));
  connect(cooValSta.yCooVal, correlation.y[1])
    annotation (Line(points={{41,0},{70,0},{70,30},{98,30}},   color={0,0,127}));
  connect(percConvCooValSig.y, timSerRes.y[2])
    annotation (Line(points={{-79,90},{20,90},{20,96},{98,96},{98,89}},
    color={0,0,127}));
  connect(percConvCooValSig.y, correlation.x)
    annotation (Line(points={{-79,90},{50,90},{50,22},{98,22}}, color={0,0,127}));
  connect(greEquThr.y, cooValSta.uFanSta)
    annotation (Line(points={{-79,-90},{0,-90},{0,-10},{19,-10}},
                                                                color={255,0,255}));
  connect(percConvFanFee.y, cooValSta.uFanFee) annotation (Line(points={{-79,-60},{-80,-60},{-80,
          -60},{-70,-60},{-4,-60},{-4,-5},{19,-5}},    color={0,0,127}));
  connect(coolingValveSignal.y[1], percConvCooValSig.u)
    annotation (Line(points={{-119,90},{-102,90}}, color={0,0,127}));
  connect(fanFeedback.y[1], percConvFanFee.u)
    annotation (Line(points={{-119,-60},{-102,-60}}, color={0,0,127}));
  connect(fanStatus.y[1], greEquThr.u)
    annotation (Line(points={{-119,-90},{-102,-90}}, color={0,0,127}));
  connect(TSupply_F.y[1], FromF1.fahrenheit)
    annotation (Line(points={{-119,50},{-102,50}}, color={0,0,127}));
  connect(TSupSetpoint_F.y[1], FromF2.fahrenheit)
    annotation (Line(points={{-119,20},{-102,20}}, color={0,0,127}));
  connect(TOut_F.y[1], FromF3.fahrenheit)
    annotation (Line(points={{-119,-20},{-108,-20},{-108,-20},{-102,-20}}, color={0,0,127}));
  connect(FromF1.kelvin, ToC1.kelvin)
    annotation (Line(points={{-79,50},{-70,50},{-70,70},{-62,70}}, color={0,0,127}));
  connect(FromF2.kelvin, ToC2.kelvin)
    annotation (Line(points={{-79,20},{-70,20},{-70,32},{-62,32}}, color={0,0,127}));
  connect(FromF3.kelvin, ToC3.kelvin)
    annotation (Line(points={{-79,-20},{-70,-20},{-70,0},{-62,0}}, color={0,0,127}));
  connect(FromF1.kelvin, cooValSta.TSup)
    annotation (Line(points={{-79,50},{0,50},{0,10},{19,10}},     color={0,0,127}));
  connect(FromF2.kelvin, cooValSta.TSupSet)
    annotation (Line(points={{-79,20},{-12,20},{-12,7},{19,7}},   color={0,0,127}));
  connect(FromF3.kelvin, cooValSta.TOut) annotation (Line(points={{-79,-20},{-12,-20},{-12,3},{19,3}},
                                                  color={0,0,127}));
  connect(ToC1.celsius, timSerInp.y[1]) annotation (Line(points={{-39,70},{-30,70},{-30,64},{98,64},
          {98,61.3333}},              color={0,0,127}));
  connect(ToC2.celsius, timSerInp.y[2]) annotation (Line(points={{-39,32},{-30,32},{-30,60},{98,60}},
                            color={0,0,127}));
  connect(ToC3.celsius, timSerInp.y[3]) annotation (Line(points={{-39,0},{-20,0},{-20,56},{98,56},{
          98,58.6667}},              color={0,0,127}));
  annotation(experiment(Tolerance=1e-06),startTime = 3733553700, stopTime=3733560900,
  __Dymola_Commands(file="CoolingCoilValve_Trends.mos"
    "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates the cooling coil signal subsequence implemented using CDL blocks 
aginst the equivalent OBC implementation as installed in one of the LBNL buildings. 
Data used for the validation are measured input and output trends.
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}}), graphics={
        Rectangle(
          extent={{-180,122},{180,-122}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid)}));
end CoolingCoilValve_Trends;
