within SystemModel.Building.Validation;
model Unconditioned "Floor without any HVAC system"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium model for air";

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false)
    annotation (Placement(transformation(extent={{-60,56},{-40,76}})));

  Floor flo(redeclare package Medium = MediumA) "Floor"
    annotation (Placement(transformation(extent={{-24,14},{22,40}})));
equation
  connect(weaDat.weaBus, flo.weaBus) annotation (Line(
      points={{-40,66},{5,66},{5,44}},
      color={255,204,51},
      thickness=0.5));
  annotation (experiment(
      StopTime=172800,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://SystemModel/Resources/Scripts/Dymola/Building/Validation/Unconditioned.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This model validates the floor model if simulated as unconditioned zones.
There is no HVAC system connected.
All internal heat gains are simulated in EnergyPlus, e.g., there is no internal heat gain specified in Modelica.
Infiltration and exfiltration is based on wind pressure only.
</p>
</html>", revisions="<html>
<ul>
<li>
February 14, 2022, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Unconditioned;
