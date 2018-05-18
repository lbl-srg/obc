within OBCSequenceValidation;
block HeatingCoilValve_F_alc
  "Heating coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"

  parameter Boolean genEna = true
    "Generic enable disable input"
    annotation(Evaluate=true);

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Controller type"
    annotation(Evaluate=true);

  parameter Real k_p(final unit="1/F") = 5/100
    "Proportional controller gain"
    annotation(Evaluate=true);

  parameter Real k_i(final unit="1/F") = 0.5/100
    "Integral controller gain"
    annotation(Evaluate=true);

  parameter Real interval(min = 1, unit="s") = 15
    "Interval at which integration part of the output gets updated";

  parameter Boolean reverseAction = true "Controller reverse action"
    annotation(Evaluate=true);

  parameter Boolean holdIntError = false
    "Keep calculating integrator error when integrator error is off"
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

  parameter Real TOutHeaCut(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 68
    "Upper outdoor air temperature limit for enabling heating"
     annotation(Evaluate=true);

  parameter Real TSatMinLowLim(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 40
    "Minimum supply air temperature for defining the lower limit of the valve position"
    annotation(Evaluate=true);
  parameter Real TSatMaxLowLim(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 45
    "Maximum supply air temperature for defining the lower limit of the valve position"
    annotation(Evaluate=true);

  alcPI alc_PI(
    final k_i = k_i,
    final k_p = k_p,
    final interval = interval,
    final reverseAction = reverseAction) "PI controller as implemented in the B33"
   annotation (Placement(transformation(extent={{-46,74},{-26,94}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnable if genEna
    "Misc enable-disable signal"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}), iconTransformation(
          extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(
        transformation(extent={{-160,-80},{-120,-40}}),
        iconTransformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="F",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature (SAT)"
    annotation (Placement(transformation(extent={{-160,10},{-120,50}}),
      iconTransformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="F",
    final quantity = "ThermodynamicTemperature") "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-160,70},{-120,110}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="F",
    final quantity = "ThermodynamicTemperature")
    "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
      iconTransformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaVal(
    final min=0,
    final max=1,
    final unit="1") "Heating valve control signal"
    annotation (Placement(transformation(extent={{120,-10},{140,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant trueSignal(
    final k=true) if not genEna
    "Dummy input if the generic enable/disable signal is not used."
    annotation (Placement(transformation(extent={{-102,-90},{-82,-70}})));

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
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Logical.And3 andEna
    "Outputs controller enable signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Switches the signal between controller and low range limiter signals"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant holdIntErrSignal(final k=holdIntError) if
                                                                                    not genEna
    "Dummy input if the generic enable/disable signal is not used."
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));


equation
  connect(TSupMin.y, yHeaValLowLim.x1)
    annotation (Line(points={{21,-70},{24,-70},{24,-22},{78,-22}},    color={0,0,127}));
  connect(TSupMax.y, yHeaValLowLim.x2)
    annotation (Line(points={{61,-70},{70,-70},{70,-34},{78,-34}}, color={0,0,127}));
  connect(TOut, lesEquThr.u)
    annotation (Line(points={{-140,-20},{-102,-20}},                  color={0,0,127}));
  connect(lesEquThr.y, andEna.u1)
    annotation (Line(points={{-79,-20},{-78,-20},{-78,-20},{-74,-20},{-74,-12},{-62,-12}},
                                                                 color={255,0,255}));
  connect(uSupFan, andEna.u2)
    annotation (Line(points={{-140,-60},{-72,-60},{-72,-20},{-62,-20}},
                                                                      color={255,0,255}));
  connect(yHeaValLowLim.f2, yHeaValMin.y)
    annotation (Line(points={{78,-38},{74,-38},{74,-104},{61,-104}}, color={0,0,127}));
  connect(yHeaValLowLim.f1, yHeaValMax.y)
    annotation (Line(points={{78,-26},{30,-26},{30,-104},{21,-104}},    color={0,0,127}));
  connect(TSup, yHeaValLowLim.u)
    annotation (Line(points={{-140,30},{10,30},{10,-30},{78,-30}},     color={0,0,127}));
  connect(uEnable, andEna.u3)
    annotation (Line(points={{-140,-100},{-70,-100},{-70,-28},{-62,-28}},
                                                                        color={255,0,255}));
  connect(andEna.u3, trueSignal.y)
    annotation (Line(points={{-62,-28},{-70,-28},{-70,-80},{-81,-80}}, color={255,0,255}));
  connect(yHeaVal,max. y) annotation (Line(points={{130,0},{116,0},{116,20},{101,20}},
                                                                       color={0,0,127}));
  connect(yHeaValLowLim.y, max.u2) annotation (Line(points={{101,-30},{104,-30},{104,-10},{72,-10},
          {72,14},{78,14}}, color={0,0,127}));
  connect(TSupSet, alc_PI.u_s) annotation (Line(points={{-140,90},{-48,90}}, color={0,0,127}));
  connect(TSup, alc_PI.u_m)
    annotation (Line(points={{-140,30},{-36,30},{-36,72}}, color={0,0,127}));
  connect(holdIntErrSignal.y, alc_PI.holdIntError)
    annotation (Line(points={{-79,50},{-64,50},{-64,76},{-48,76}}, color={255,0,255}));
  connect(alc_PI.y, max.u1)
    annotation (Line(points={{-25,84},{26,84},{26,26},{78,26}}, color={0,0,127}));
  connect(andEna.y, alc_PI.intErrSta) annotation (Line(points={{-39,-20},{-30,-20},{-30,66},{-74,66},
          {-74,82},{-48,82}}, color={255,0,255}));
  annotation (
    defaultComponentName = "heaValSta_F_alc",
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{20,58}}, color={28,108,200}),
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
          extent={{-54,-100},{-20,-114}},
          lineColor={0,0,127},
          textString="Enbale/Disable 
Integral Error",
          fontSize=12),
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
recorded on April 09 2018. This version of the sequences uses F as a temperature unit.
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
end HeatingCoilValve_F_alc;
