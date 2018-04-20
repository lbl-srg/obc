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

  parameter Modelica.SIunits.Time Ti = 1 / 0.5
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


  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature (SAT)"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature") "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-160,70},{-120,110}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-160,-90},{-120,-50}}),
      iconTransformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(
        transformation(extent={{-160,-120},{-120,-80}}),
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
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final reverseAction=false)
    "Contoller that outputs a signal based on the error between the measured SAT and SAT heating setpoint"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupMin(final k=TSatMinLowLim)
    "Low range supply air temperature low limit"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupMax(final k=TSatMaxLowLim)
    "Low range supply air temperature high limit"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yHeaValMin(final k=uMin)
    "Minimal control loop signal limit when supply air temperature is at a defined high limit"
    annotation (Placement(transformation(extent={{40,-114},{60,-94}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yHeaValMax(final k=uMax)
    "Minimal control loop signal limit when supply air temperature is at a defined low limit"
    annotation (Placement(transformation(extent={{0,-114},{20,-94}})));

  Buildings.Controls.OBC.CDL.Continuous.Line yHeaValLowLim(
    final limitBelow=true,
    final limitAbove=true)
    "Defines lower limit of the heating valve signal at low range SATs"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr(threshold=TOutHeaCut)
    "Determines whether the outdoor air temperature is below a treashold"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

  Buildings.Controls.OBC.CDL.Logical.And andEna
    "Outputs controller enable signal"
    annotation (Placement(transformation(extent={{-72,-60},{-52,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swiLim
    "Switches the signal between controller and low range limiter signals"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater greLim
    "Checks if the low supply air temperature range limiter should be applied"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));


equation
  connect(TSup, TSupCon.u_m)
    annotation (Line(points={{-140,40},{-108,40},{-108,58},{-30,58},{-30,78}},
                                                                           color={0,0,127}));
  connect(TSupMin.y, yHeaValLowLim.x1)
    annotation (Line(points={{21,-70},{24,-70},{24,-22},{78,-22}},    color={0,0,127}));
  connect(TSupSet, TSupCon.u_s) annotation (Line(points={{-140,90},{-42,90}}, color={0,0,127}));
  connect(TSupMax.y, yHeaValLowLim.x2)
    annotation (Line(points={{61,-70},{70,-70},{70,-34},{78,-34}}, color={0,0,127}));
  connect(TOut, lesEquThr.u)
    annotation (Line(points={{-140,-70},{-110,-70},{-110,-50},{-102,-50}},
                                                                      color={0,0,127}));
  connect(lesEquThr.y, andEna.u1)
    annotation (Line(points={{-79,-50},{-74,-50}},               color={255,0,255}));
  connect(uSupFan, andEna.u2)
    annotation (Line(points={{-140,-100},{-76,-100},{-76,-58},{-74,-58}},
                                                                      color={255,0,255}));
  connect(yHeaValLowLim.f2, yHeaValMin.y)
    annotation (Line(points={{78,-38},{74,-38},{74,-104},{61,-104}}, color={0,0,127}));
  connect(yHeaValLowLim.f1, yHeaValMax.y)
    annotation (Line(points={{78,-26},{30,-26},{30,-104},{21,-104}},    color={0,0,127}));
  connect(TSup, yHeaValLowLim.u)
    annotation (Line(points={{-140,40},{-68,40},{-68,-30},{78,-30}},   color={0,0,127}));
  connect(swiLim.u2, greLim.y) annotation (Line(points={{78,20},{61,20}}, color={255,0,255}));
  connect(TSupCon.y, greLim.u1)
    annotation (Line(points={{-19,90},{30,90},{30,20},{38,20}},color={0,0,127}));
  connect(yHeaValLowLim.y, greLim.u2)
    annotation (Line(points={{101,-30},{108,-30},{108,-10},{24,-10},{24,12},{38,12}},
    color={0,0,127}));
  connect(yHeaVal, swiLim.y) annotation (Line(points={{130,20},{101,20}},color={0,0,127}));
  connect(TSupCon.y, swiLim.u1)
    annotation (Line(points={{-19,90},{70,90},{70,28},{78,28}},color={0,0,127}));
  connect(yHeaValLowLim.y, swiLim.u3)
    annotation (Line(points={{101,-30},{108,-30},{108,-10},{64,-10},{64,12},{78,12}},
                                                                 color={0,0,127}));
  connect(TSupCon.trigger, andEna.y)
    annotation (Line(points={{-38,78},{-38,-50},{-51,-50}},       color={255,0,255}));
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
          extent={{-10,120},{120,-120}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{80,-104},{120,-112}},
          lineColor={0,0,127},
          textString="Limiter for 
low TSup"),
        Rectangle(
          extent={{-120,0},{-12,-120}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-48,-108},{-20,-114}},
          lineColor={0,0,127},
          textString="Enbale/Disable"),
        Rectangle(
          extent={{-120,120},{-12,2}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-112,12},{-92,6}},
          lineColor={0,0,127},
          textString="Controller")}),
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
