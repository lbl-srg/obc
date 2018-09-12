within OBCSequenceValidation.Examples;
model CoolingCoilValve_disIntPI_Trends
  "Validation model for the cooling coil control subsequence with recorded data trends using a custom controller model"
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
    "Measured outdoor air temperature"
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
    "Supply air temperature setpoint"
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
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  CoolingCoilValve_disIntPI cooValSta_F(
    reverseAction=false,
    k_p=1/100,
    k_i=0.5/100,
    holdIntError=false,
    TOutCooCut=50) "Cooling valve position control sequence"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain percConv(k=0.01) "Percentage to number converter"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(threshold=0.5)
    "Converter to boolean"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain percConv1(k=0.01)
    "Percentage to real converter"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));

  Buildings.Controls.OBC.UnitConversions.From_degF from_degF
    "Unit Converter"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.OBC.UnitConversions.From_degF from_degF1
    "Unit Converter"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.UnitConversions.From_degF from_degF2
    "Unit Converter"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Controls.OBC.UnitConversions.To_degC to_degC
    "Unit Converter"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.UnitConversions.To_degC to_degC1
    "Unit Converter"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.UnitConversions.To_degC to_degC2
    "Unit Converter"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

protected
  Buildings.Utilities.IO.Files.CSVWriter cSVWriter(
    samplePeriod=5,
    nin=2,
    headerNames={"Trended","Modeled"})
    "Writes trended and modeled cooling coil valve position to CSV"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  inner Buildings.Utilities.Plotters.Configuration plotConfiguration(
    timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.hours,
    activation=Buildings.Utilities.Plotters.Types.GlobalActivation.always,
    samplePeriod=300,
    fileName="coolingCoilValve_customPI_validationPlots.html")
    "Cooling valve control sequence validation"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));

  Buildings.Utilities.Plotters.Scatter correlation(
    xlabel="Cooling valve signal",
    n=1,
    title="Modeled result/recorded trend correlation",
    legend={"Modeled cooling valve signal"}) "Reference vs. output results"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Utilities.Plotters.TimeSeries timSerRes(
    n=2,
    legend={"Cooling valve control signal, modeled","Cooling valve control signal, trended"},
    title="Cooling valve control signal: reference trend vs. modeled result")
    "Reference and result cooling valve control signal"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

  Buildings.Utilities.Plotters.TimeSeries timSerInp(
    legend={"Supply air temperature, [degC]","Supply air temperature setpoint, [degC]","Outdoor air temperature, [degC]"},
    title="Trended input signals",
    n=3) "Trended input signals"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

equation
  connect(cooValSta_F.yCooVal, timSerRes.y[1])
    annotation (Line(points={{41,30},{50,30},{50,104},{98,104},{98,101}},
    color={0,0,127}));
  connect(cooValSta_F.yCooVal, correlation.y[1])
    annotation (Line(points={{41,30},{70,30},{70,30},{98,30}}, color={0,0,127}));
  connect(percConv.y, timSerRes.y[2])
    annotation (Line(points={{-79,100},{38,100},{38,96},{98,96},{98,99}},
    color={0,0,127}));
  connect(percConv.y, correlation.x)
    annotation (Line(points={{-79,100},{-10,100},{-10,80},{60,80},{60,22},{98,22}},
    color={0,0,127}));
  connect(greEquThr.y, cooValSta_F.uFanSta)
    annotation (Line(points={{-79,-90},{0,-90},{0,20},{19,20}}, color={255,0,255}));
  connect(percConv1.y, cooValSta_F.uFanFee)
    annotation (Line(points={{-79,-60},{-10,-60},{-10,24},{
          -10,24},{-10,-60},{-10,25},{4,25},{19,25}}, color={0,0,127}));
  connect(coolingValveSignal.y[1], percConv.u)
    annotation (Line(points={{-119,90},{-110,90},{-110,100},{-102,100}},
    color={0,0,127}));
  connect(TOut_F.y[1], cooValSta_F.TOut)
    annotation (Line(points={{-119,-20},{-110,-20},{-110,-30},{-16,-30},{-16,33},
          {19,33}}, color={0,0,127}));
  connect(fanFeedback.y[1], percConv1.u)
    annotation (Line(points={{-119,-60},{-102,-60}}, color={0,0,127}));
  connect(fanStatus.y[1], greEquThr.u)
    annotation (Line(points={{-119,-90},{-102,-90}}, color={0,0,127}));
  connect(TSupSetpoint_F.y[1], cooValSta_F.TSupSet)
    annotation (Line(points={{-119,20},{-110,20},{-110,10},{-20,10},{-20,37},{19,
          37}}, color={0,0,127}));
  connect(from_degF1.y, to_degC1.u)
    annotation (Line(points={{-79,30},{-62,30}}, color={0,0,127}));
  connect(TSupply_F.y[1], from_degF.u)
    annotation (Line(points={{-119,50},{-110,50},{-110,70},{-102,70}},
    color={0,0,127}));
  connect(from_degF.y, to_degC.u)
    annotation (Line(points={{-79,70},{-62,70}}, color={0,0,127}));
  connect(TSupply_F.y[1], cooValSta_F.TSup) annotation (Line(points={{-119,50},{
          0,50},{0,40},{19,40}}, color={0,0,127}));
  connect(TSupSetpoint_F.y[1], from_degF1.u) annotation (Line(points={{-119,20},
          {-110,20},{-110,30},{-102,30}}, color={0,0,127}));
  connect(to_degC2.u, from_degF2.y)
    annotation (Line(points={{-62,-10},{-79,-10}}, color={0,0,127}));
  connect(TOut_F.y[1], from_degF2.u) annotation (Line(points={{-119,-20},{-110,-20},
          {-110,-10},{-102,-10}}, color={0,0,127}));
  connect(to_degC.y, timSerInp.y[1]) annotation (Line(points={{-39,70},{-30,70},
          {-30,72},{98,72},{98,71.3333}}, color={0,0,127}));
  connect(to_degC1.y, timSerInp.y[2]) annotation (Line(points={{-39,30},{-26,30},
          {-26,70},{98,70}}, color={0,0,127}));
  connect(to_degC2.y, timSerInp.y[3]) annotation (Line(points={{-39,-10},{-22,
          -10},{-22,68},{98,68},{98,68.6667}},
                                          color={0,0,127}));
  connect(percConv.y, cSVWriter.u[1]) annotation (Line(points={{-79,100},{70,100},
          {70,-29},{100,-29}}, color={0,0,127}));
  connect(cooValSta_F.yCooVal, cSVWriter.u[2]) annotation (Line(points={{41,30},
          {50,30},{50,-32},{100,-32},{100,-31}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-06),startTime = 3733553700, stopTime=3733560900,
  __Dymola_Commands(file="CoolingCoilValve_disIntPI_Trends.mos"
    "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates the cooling coil signal subsequence implemented 
in Building 33 on the main LBNL campus. Data used for the validation are measured 
input and output trends with 5s time steps exported from the building's ALC EIKON webserver.
OBC implementation of the subsequence implemented in this example 
uses the discrete timestep integrator PI.  
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}}),
        graphics={
        Rectangle(
          extent={{-180,120},{180,-120}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid)}));
end CoolingCoilValve_disIntPI_Trends;
