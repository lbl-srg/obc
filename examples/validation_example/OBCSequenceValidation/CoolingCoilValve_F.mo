within OBCSequenceValidation;
block CoolingCoilValve_F
  "Cooling coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"

  parameter Boolean genEna = true
    "Generic enable disable input"
    annotation(Evaluate=true);

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Controller type"
    annotation(Evaluate=true);

  parameter Real k(final unit="1") = 0.01
    "Controller gain"
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

  parameter Modelica.SIunits.Time Ti = 10 * k / (0.5/100)
    "Time constant of modulation controller integrator block"
    annotation (Dialog(
      andEna=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td=0.1
    "Time constant of derivative block for cooling control loop signal"
    annotation (Dialog(
      andEna=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  // changed from 50 to 30 to temporarily disable
  parameter Real TOutCooCut(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 30
    "Upper outdoor air temperature limit for enabling Cooling"
     annotation(Evaluate=true);

  parameter Real TSatMinHighLim(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 42
    "Minimum supply air temperature for defining the lower limit of the valve position"
    annotation(Evaluate=true);
  parameter Real TSatMaxHighLim(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 50
    "Maximum supply air temperature for defining the lower limit of the valve position"
    annotation(Evaluate=true);

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

  Buildings.Controls.OBC.CDL.Continuous.LimPID TSupCon(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=uMax,
    final yMin=uMin,
    final reverseAction=revAct,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Disabled)
    "Contoller that outputs a signal based on the error between the measured SAT and SAT Cooling setpoint"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant trueSignal(
    final k=true) if not genEna
    "Dummy input if the generic enable/disable signal is not used."
    annotation (Placement(transformation(extent={{-98,-92},{-78,-72}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupMin(final k=TSatMinHighLim)
    "Low range supply air temperature low limit"
    annotation (Placement(transformation(extent={{0,-68},{20,-48}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupMax(final k=TSatMaxHighLim)
    "Low range supply air temperature high limit"
    annotation (Placement(transformation(extent={{40,-68},{60,-48}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCooValMin(final k=uMin)
    "Minimal control loop signal limit when supply air temperature is at a defined high limit"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCooValMax(final k=uMax)
    "Minimal control loop signal limit when supply air temperature is at a defined low limit"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Line yCooValHighLim(final limitBelow=true, final limitAbove=
       true) "Defines lower limit of the Cooling valve signal at low range SATs"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold   greThr(   threshold=TOutCooCut)
    "Determines whether the outdoor air temperature is below a treashold"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Logical.And3 andEna
    "Outputs controller enable signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Min min1
    "Switches the signal between controller and low range limiter signals"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-36,-30},{-16,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Switches the signal between controller and low range limiter signals"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

equation
  connect(TOut, greThr.u) annotation (Line(points={{-140,-20},{-102,-20}}, color={0,0,127}));
  connect(greThr.y, andEna.u1) annotation (Line(points={{-79,-20},{-78,-20},{-78,-20},{-74,-20},{-74,
          -12},{-62,-12}}, color={255,0,255}));
  connect(uSupFan, andEna.u2)
    annotation (Line(points={{-140,-60},{-72,-60},{-72,-20},{-62,-20}},
                                                                      color={255,0,255}));
  connect(TSup, yCooValHighLim.u)
    annotation (Line(points={{-140,40},{10,40},{10,-30},{78,-30}}, color={0,0,127}));
  connect(TSupCon.y, min1.u1)
    annotation (Line(points={{-19,90},{0,90},{0,56},{38,56}}, color={0,0,127}));
  connect(uEnable, andEna.u3)
    annotation (Line(points={{-140,-100},{-70,-100},{-70,-28},{-62,-28}},
                                                                        color={255,0,255}));
  connect(andEna.u3, trueSignal.y)
    annotation (Line(points={{-62,-28},{-70,-28},{-70,-82},{-77,-82}}, color={255,0,255}));
  connect(andEna.y, booToRea.u) annotation (Line(points={{-39,-20},{-38,-20}}, color={255,0,255}));
  connect(yCooVal,max. y) annotation (Line(points={{130,0},{116,0},{116,20},{101,20}},
                                                                       color={0,0,127}));
  connect(max.u1, min1.y)
    annotation (Line(points={{78,26},{70,26},{70,50},{61,50}}, color={0,0,127}));
  connect(TSup, TSupCon.u_m) annotation (Line(points={{-140,40},{-30,40},{-30,76},{-30,76},{-30,78},
          {-30,78}}, color={0,0,127}));
  connect(TSupCon.u_s, TSupSet) annotation (Line(points={{-42,90},{-140,90}}, color={0,0,127}));
  connect(TSupMax.y, yCooValHighLim.x2)
    annotation (Line(points={{61,-58},{68,-58},{68,-34},{78,-34}}, color={0,0,127}));
  connect(yCooValMax.y, yCooValHighLim.f2)
    annotation (Line(points={{61,-90},{72,-90},{72,-38},{78,-38}}, color={0,0,127}));
  connect(TSupMin.y, yCooValHighLim.x1)
    annotation (Line(points={{21,-58},{26,-58},{26,-22},{78,-22}}, color={0,0,127}));
  connect(yCooValMin.y, yCooValHighLim.f1)
    annotation (Line(points={{21,-90},{30,-90},{30,-26},{78,-26}}, color={0,0,127}));
  connect(booToRea.y, min1.u2)
    annotation (Line(points={{-15,-20},{0,-20},{0,44},{38,44}}, color={0,0,127}));
  connect(yCooValHighLim.y, max.u2) annotation (Line(points={{101,-30},{110,-30},{110,0},{70,0},{70,
          14},{78,14}}, color={0,0,127}));
  annotation (
    defaultComponentName = "cooValSta_F",
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
This subsequence defines Cooling coil valve position. The implementation is identical to
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
end CoolingCoilValve_F;
