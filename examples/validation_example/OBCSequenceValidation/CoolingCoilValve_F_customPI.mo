within OBCSequenceValidation;
block CoolingCoilValve_F_customPI
  "Cooling coil control sequence as implemented in LBNL 33-AHU-02 (Roof)"

  parameter Real k_p(final unit="1/F") = 5/100
    "Proportional controller gain"
    annotation(Evaluate=true, Dialog(group="Controller"));

  parameter Real k_i(final unit="1/F") = 0.5/100
    "Integral controller gain"
    annotation(Evaluate=true, Dialog(group="Controller"));

  parameter Real interval(min = 1, unit="s") = 15
    "Interval at which integration part of the output gets updated"
    annotation(Evaluate=true, Dialog(group="Controller"));

  parameter Boolean reverseAction = true "Controller reverse action"
    annotation(Evaluate=true, Dialog(group="Controller"));

  parameter Boolean holdIntError = false
    "Keep calculating integrator error when integrator error is off"
    annotation(Evaluate=true, Dialog(group="Controller"));

  parameter Real uMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Maximum controller signal"
    annotation(Evaluate=true, Dialog(group="Controller"));

  parameter Real uMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Minimum controller signal"
    annotation(Evaluate=true, Dialog(group="Controller"));

  parameter Real TOutCooCut(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 50
    "Outdoor air temperature cooling threshold"
     annotation(Evaluate=true);

  parameter Real uFanFeeCut(
    final unit="1") = 0.15
    "Fan status threshold"
     annotation(Evaluate=true);

  parameter Real TSupHighLim(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 50
    "Minimum supply air temperature for defining the upper limit of the valve position"
    annotation(Evaluate=true);

  parameter Real TSuphigLim(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 42
    "Maximum supply air temperature for defining the upper limit of the valve position"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFanSta
    "Optional additional status signal"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
    iconTransformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanFee "Supply fan feedback"
    annotation (Placement(
        transformation(extent={{-160,-80},{-120,-40}}),
        iconTransformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="F",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature (SAT)"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
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

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooVal(
    final min=0,
    final max=1,
    final unit="1") "Cooling valve control signal"
    annotation (Placement(transformation(extent={{120,-10},{140,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  // controller

  CustomPI alc_PI(
    final k_i=k_i,
    final k_p=k_p,
    final interval=interval,
    final reverseAction=reverseAction) "PI controller as implemented in the B33"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCooValMin(final k=uMin)
    "Minimal control loop signal limit when supply air temperature is at a defined high limit"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCooValMax(final k=uMax)
    "Minimal control loop signal limit when supply air temperature is at a defined low limit"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold TOutThr(
    final threshold=TOutCooCut)
    "Determines whether the outdoor air temperature is below a treashold"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold uFanFeeThr(
    final threshold=uFanFeeCut)
    "Checks if the fan status is above a threshold"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant holdIntErrSignal(
    final k=holdIntError)
    "If True, the integral error aggregation continues during periods with integral error off"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  // limiter

  Buildings.Controls.OBC.CDL.Continuous.Line higLim(
    final limitBelow=true,
    final limitAbove=true)
    "Defines lower limit of the Cooling valve signal at low range SATs"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupMin(final k=TSuphigLim)
    "Low range supply air temperature low limit"
    annotation (Placement(transformation(extent={{0,-68},{20,-48}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupMax(final k=TSupHighLim)
    "Low range supply air temperature high limit"
    annotation (Placement(transformation(extent={{40,-68},{60,-48}})));

  Buildings.Controls.OBC.CDL.Logical.And3 andIntErr
    "Outputs controller enable signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Min min
    "Switches the signal between controller and low range limiter signals"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

equation
  connect(TOut, TOutThr.u)
    annotation (Line(points={{-140,-20},{-102,-20}}, color={0,0,127}));
  connect(TOutThr.y, andIntErr.u1)
    annotation (Line(points={{-79,-20},{-74,-20},{-74,-12},{-62,-12}}, color={255,0,255}));
  connect(TSup, higLim.u)
    annotation (Line(points={{-140,40},{10,40},{10,-30},{78,-30}}, color={0,0,127}));
  connect(uFanSta, andIntErr.u3)
    annotation (Line(points={{-140,-100},{-68,-100},{-68,-28},{-62,-28}},color={255,0,255}));
  connect(yCooVal,min. y)
    annotation (Line(points={{130,0},{116,0},{116,20},{101,20}},color={0,0,127}));
  connect(TSupMax.y, higLim.x2)
    annotation (Line(points={{61,-58},{68,-58},{68,-34},{78,-34}}, color={0,0,127}));
  connect(yCooValMax.y, higLim.f2)
    annotation (Line(points={{61,-90},{72,-90},{72,-38},{78,-38}}, color={0,0,127}));
  connect(TSupMin.y, higLim.x1)
    annotation (Line(points={{21,-58},{26,-58},{26,-22},{78,-22}}, color={0,0,127}));
  connect(yCooValMin.y, higLim.f1)
    annotation (Line(points={{21,-90},{30,-90},{30,-26},{78,-26}}, color={0,0,127}));
  connect(higLim.y,min. u2)
    annotation (Line(points={{101,-30},{110,-30},{110,0},{70,0},{70,14},{78,14}}, color={0,0,127}));
  connect(holdIntErrSignal.y, alc_PI.holdIntError)
    annotation (Line(points={{-79,60},{-60,60},{-60,82},{-42,82}}, color={255,0,255}));
  connect(andIntErr.y, alc_PI.intErrSta)
    annotation (Line(points={{-39,-20},{-36,-20},{-36,74},{-68,74},{-68,88},{-42,88}},
    color={255,0,255}));
  connect(TSupSet, alc_PI.u_s)
    annotation (Line(points={{-140,90},{-92,90},{-92,96},{-42,96}}, color={0,0,127}));
  connect(TSup, alc_PI.u_m)
    annotation (Line(points={{-140,40},{-30,40},{-30,78}}, color={0,0,127}));
  connect(alc_PI.y, min.u1)
    annotation (Line(points={{-19,90},{30,90},{30,26},{78,26}}, color={0,0,127}));
  connect(andIntErr.u2, uFanFeeThr.y)
    annotation (Line(points={{-62,-20},{-72,-20},{-72,-50},{-79,-50}}, color={255,0,255}));
  connect(uFanFee, uFanFeeThr.u)
    annotation (Line(points={{-140,-60},{-110,-60},{-110,-50},{-102,-50}}, color={0,0,127}));
  annotation (
    defaultComponentName = "cooVal",
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
This subsequence defines cooling coil valve position. The implementation is identical to
the ALC EIKON control sequence implementation in LBL B33-AHU-02 (Roof), with parameters
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
end CoolingCoilValve_F_customPI;
