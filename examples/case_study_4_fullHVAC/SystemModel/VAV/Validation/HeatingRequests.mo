within SystemModel.VAV.Validation;
model HeatingRequests
  "Validation of model that generates heating requests"

  SystemModel.VAV.HeatingRequests sysReq_RehBox
    "Block outputs system requests"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    freqHz=1/7200,
    offset=305.15)
    "Generate data for setpoint"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TDisHeaSet(
    samplePeriod=1800)
    "Discharge air setpoint temperature"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TDis(
    freqHz=1/7200,
    amplitude=2,
    offset=293.15)
    "Discharge air temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp valPos(
    duration=7200,
    height=1,
    offset=0)
    "Hot water valve position"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

equation
  connect(sine1.y, TDisHeaSet.u)
    annotation (Line(points={{-68,10},{-22,10}},   color={0,0,127}));
  connect(TDisHeaSet.y, sysReq_RehBox.TDisHeaSet)
    annotation (Line(points={{2,10},{20,10},{20,4},{58,4}},
      color={0,0,127}));
  connect(TDis.y, sysReq_RehBox.TDis)
    annotation (Line(points={{-38,-10},{20,-10},{20,0},{58,0}},
      color={0,0,127}));
  connect(valPos.y,sysReq_RehBox.uHeaVal)
    annotation (Line(points={{2,-30},{30,-30},{30,-4},{58,-4}},
      color={0,0,127}));

annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://SystemModel/Resources/Scripts/Dymola/VAV/Validation/HeatingRequests.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://SystemModel.VAV.HeatingRequests\">
SystemModel.VAV.HeatingRequests</a>
for generating system requests.
</p>
</html>", revisions="<html>
<ul>
<li>
November 4, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
end HeatingRequests;
