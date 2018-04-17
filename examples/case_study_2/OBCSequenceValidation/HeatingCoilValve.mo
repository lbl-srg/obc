within OBCSequenceValidation;
block HeatingCoilValve
  "Heating coil valve position sequence"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Controller type"
    annotation(Evaluate=true);

  parameter Real k(final unit="1/K") = 5
    "Controller gain as in : 33-AHU-02 (Roof) / m488, Apr 17, '18"
    annotation(Evaluate=true);

  parameter Boolean revAct = true "Controller reverse action"
    annotation(Evaluate=true);

  parameter Real uMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Maximum controller signal"
    annotation(Evaluate=true);
  parameter Real uMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Minimum controller signal"
    annotation(Evaluate=true);

  parameter Modelica.SIunits.Time Ti=k / 0.5
    "Time constant of modulation controller integrator block, 33-AHU-02 (Roof) / m488 integral gain = 0.2, , Apr 17 '18"
    annotation (Dialog(
      andEna=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td=0.1
    "Time constant of derivative block for cooling control loop signal"
    annotation (Dialog(
      andEna=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TOutHeaCut(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 293.15
    "Upper outdoor air temperature limit for enabling heating (68 F)"
     annotation(Evaluate=true);

  parameter Real TSatMinLowLim(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 277.5944
    "Minimum supply air temperature for defining the lower limit of the valve position (40 F)"
    annotation(Evaluate=true);
  parameter Real TSatMaxLowLim(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 280.3722
    "Maximum supply air temperature for defining the lower limit of the valve position (45 F)"
    annotation(Evaluate=true);

  parameter Real yHeaValMinLowLim(
    final min=0,
    final max=1,
    final unit="1")= 0
    "Minimum valve position signal at maximum lower limit defining supply air temperature"
    annotation(Evaluate=true);
  parameter Real yHeaValMaxLowLim(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Maximum valve position signal at minimum lower limit defining supply air temperature"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature (SAT)"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature") "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-160,-50},{-120,-10}}),
      iconTransformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(
        transformation(extent={{-160,-80},{-120,-40}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaVal(
    final min=0,
    final max=1,
    final unit="1") "Heating valve control signal"
    annotation (Placement(transformation(extent={{120,10},{140,30}}),
      iconTransformation(extent={{100,10},{120,30}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID TSupCon(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=uMax,
    final yMin=uMin,
    final reverseAction=revAct,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    "Contoller that outputs a signal based on the error between the measured SAT and SAT heating setpoint"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupMin(final k=TSatMinLowLim)
    "Low range supply air temperature low limit"
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupMax(final k=TSatMaxLowLim)
    "Low range supply air temperature high limit"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yHeaValMin(final k=uMin)
    "Minimal control loop signal limit when supply air temperature is at a defined high limit"
    annotation (Placement(transformation(extent={{-10,-114},{10,-94}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yHeaValMax(final k=uMax)
    "Minimal control loop signal limit when supply air temperature is at a defined low limit"
    annotation (Placement(transformation(extent={{-50,-114},{-30,-94}})));

  Buildings.Controls.OBC.CDL.Continuous.Line yHeaValLowLim(
    final limitBelow=true,
    final limitAbove=true)
    "Defines lower limit of the heating valve signal at low range SATs"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr(threshold=TOutHeaCut)
    "Determines whether the outdoor air temperature is below a treashold"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  Buildings.Controls.OBC.CDL.Logical.And andEna
    "Outputs controller enable signal"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swiLim
    "Switches the signal between controller and low range limiter signals"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greLim
    "Checks if the low supply air temperature range limiter should be applied"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));


equation
  connect(TSup, TSupCon.u_m)
    annotation (Line(points={{-140,40},{-108,40},{-108,58},{0,58},{0,68}}, color={0,0,127}));
  connect(TSupMin.y, yHeaValLowLim.x1)
    annotation (Line(points={{-29,-70},{-26,-70},{-26,-22},{38,-22}}, color={0,0,127}));
  connect(TSupSet, TSupCon.u_s) annotation (Line(points={{-140,80},{-12,80}}, color={0,0,127}));
  connect(TSupMax.y, yHeaValLowLim.x2)
    annotation (Line(points={{11,-70},{20,-70},{20,-34},{38,-34}}, color={0,0,127}));
  connect(TOut, lesEquThr.u)
    annotation (Line(points={{-140,-30},{-110,-30},{-110,0},{-92,0}}, color={0,0,127}));
  connect(lesEquThr.y, andEna.u1)
    annotation (Line(points={{-69,0},{-60,0},{-60,30},{-52,30}}, color={255,0,255}));
  connect(uSupFan, andEna.u2)
    annotation (Line(points={{-140,-60},{-58,-60},{-58,22},{-52,22}}, color={255,0,255}));
  connect(andEna.y, TSupCon.trigger)
    annotation (Line(points={{-29,30},{-8,30},{-8,68}}, color={255,0,255}));
  connect(yHeaValLowLim.f2, yHeaValMin.y)
    annotation (Line(points={{38,-38},{30,-38},{30,-104},{11,-104}}, color={0,0,127}));
  connect(yHeaValLowLim.f1, yHeaValMax.y)
    annotation (Line(points={{38,-26},{-20,-26},{-20,-104},{-29,-104}}, color={0,0,127}));
  connect(TSup, yHeaValLowLim.u)
    annotation (Line(points={{-140,40},{-100,40},{-100,-30},{38,-30}}, color={0,0,127}));
  connect(swiLim.u2, greLim.y) annotation (Line(points={{68,20},{51,20}}, color={255,0,255}));
  connect(TSupCon.y, greLim.u1)
    annotation (Line(points={{11,80},{20,80},{20,20},{28,20}}, color={0,0,127}));
  connect(yHeaValLowLim.y, greLim.u2)
    annotation (Line(points={{61,-30},{64,-30},{64,-10},{20,-10},{20,12},{28,12}},
    color={0,0,127}));
  connect(yHeaVal, swiLim.y) annotation (Line(points={{130,20},{91,20}}, color={0,0,127}));
  connect(TSupCon.y, swiLim.u1)
    annotation (Line(points={{11,80},{60,80},{60,28},{68,28}}, color={0,0,127}));
  connect(yHeaValLowLim.y, swiLim.u3)
    annotation (Line(points={{61,-30},{64,-30},{64,12},{68,12}}, color={0,0,127}));
  annotation (
    defaultComponentName = "heaValSta",
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{20,58}}, color={28,108,200}),
        Line(
          points={{-92,-84},{-50,-84},{12,70},{82,70}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-66,58},{12,58},{50,-76},{100,-76}},
          color={0,0,127},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Text(
          extent={{-108,138},{102,110}},
          lineColor={0,0,127},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}}), graphics={
        Rectangle(
          extent={{42,118},{78,102}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{90,118},{118,102}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This subsequence defines heating coil valve position. The implementation is identical to
the actual ALC EIKON control sequence implementation in LBL B33-AHU-02 (Roof), with parameters
recorded on April 09 2018.
</p>

</p>

</html>", revisions="<html>
<ul>
<li>
April 09, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatingCoilValve;
