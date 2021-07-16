within ChillerPlant.ClosedLoopBase.BaseClasses.Controls;
model PlantOnOffWithAnalogueTrimAndRespond "Plant status"

  // control parameters used in both base and 1711 cases
  parameter Real TZonSupSet(
    final unit="K",
    final quantity="Temperature",
    displayUnit="degC")=273.15 + 27
    "Zone supply air temperature setpoint"
    annotation(Dialog(group="Design parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSup
    "Measured zone air supply temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPlaRes
    "Chilled water plant reset signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TAirSet(
    final k=TZonSupSet)
    "Set temperature for air supply to the room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-30,-30})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback feedback
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespondContinuousTimeApproximation
    triAndRes1 annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(TAirSet.y,feedback. u2) annotation (Line(
      points={{-18,-30},{0,-30},{0,-12}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(feedback.y, triAndRes1.u)
    annotation (Line(points={{12,0},{38,0}},  color={0,0,127}));
  connect(TZonSup, feedback.u1) annotation (Line(points={{-120,0},{-12,0}},
                        color={0,0,127}));
  connect(triAndRes1.y, yChiWatPlaRes) annotation (Line(points={{61,0},{120,0}},
                           color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200}),
          Text(
          extent={{-60,62},{62,-56}},
          lineColor={28,108,200},
          textString="Plant
On/Off")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end PlantOnOffWithAnalogueTrimAndRespond;
