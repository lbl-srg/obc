within OBCSequenceValidation.Validation;
model DisIntPI_TSup
  "Validates the PI controller with a fixed timestep integration"

  extends Modelica.Icons.Example;

  DisIntPI disIntPI(
    k_p=0.05,
    k_i=0.005,
    reverseAction=true,
    interval=10)
    "PI controller with a fixed timestep integration"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  DisIntPI disIntPI1(
    k_p=0.05,
    k_i=0.005,
    interval=10,
    reverseAction=false)
    "PI controller with a fixed timestep integration"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSup(final k=71)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet(final k=72)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSup1(final k=66)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet1(final k=65)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(width=0.6, period=100)
    "Pulse signal"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant holdIntError(k=false)
    "Hold integer error signal"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(width=0.6, period=100)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant holdIntError1(k=true)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

equation
  connect(uTSupSet.y, disIntPI.u_s)
    annotation (Line(points={{-59,70},{-30,70},{-30,16},{-22,16}}, color={0,0,127}));
  connect(uTSup.y, disIntPI.u_m)
    annotation (Line(points={{-59,-50},{-10,-50},{-10,-2}}, color={0,0,127}));
  connect(disIntPI.intErrSta, booPul.y)
    annotation (Line(points={{-22,8},{-40,8},{-40,30},{-59,30}}, color={255,0,255}));
  connect(disIntPI.holdIntError, holdIntError.y)
    annotation (Line(points={{-22,2},{-40,2},{-40,-10},{-59,-10}}, color={255,0,255}));
  connect(uTSupSet1.y, disIntPI1.u_s)
    annotation (Line(points={{41,70},{70,70},{70,16},{78,16}}, color={0,0,127}));
  connect(uTSup1.y, disIntPI1.u_m)
    annotation (Line(points={{41,-50},{90,-50},{90,-2}}, color={0,0,127}));
  connect(disIntPI1.intErrSta, booPul1.y)
    annotation (Line(points={{78,8},{60,8},{60,30},{41,30}}, color={255,0,255}));
  connect(disIntPI1.holdIntError, holdIntError1.y)
    annotation (Line(points={{78,2},{60,2},{60,-10},{41,-10}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(coordinateSystem(
          preserveAspectRatio=false), graphics={
        Text(
          extent={{-78,-66},{-28,-84}},
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Heating with
Hold integer error = False"),
        Text(
          extent={{22,-66},{70,-82}},
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Cooling with
Hold integer error = True")}),
            experiment(StopTime=1000.0, Tolerance=1e-06),
  __Dymola_Commands(file="DisIntPI_TSup.mos"
    "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates direct and reverse action operation of a fixed timestep 
integrator PI controller. Reverse action example uses integrator error 
reset at integrator disable.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 10, Milica Grahovac<br/>
First implementation.
</li>
</ul>
</html>"));
end DisIntPI_TSup;
