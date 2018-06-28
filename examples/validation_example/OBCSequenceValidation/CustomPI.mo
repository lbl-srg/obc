within OBCSequenceValidation;
block CustomPI
  "Customized PI controller reflecting the controller from the validation example"

  parameter Boolean reverseAction = false "Reverse action";
  parameter Real k_p(min=0, unit="1/F") = 1 "Proportional Gain";
  parameter Real k_i(min=0, unit="1/F") = 1 "Integral Gain";
  parameter Real interval(min = 1, unit="s") = 10
    "Interval at which integration part of the output gets updated";
  parameter Real ra = if reverseAction then -1 else 1
    "Reverse action multiplier";
  parameter Real uMin = 0 "Upper limit of output";
  parameter Real uMax = 1 "Lower limit of output";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput holdIntError
    "If False, the integrator error is reset to 0 after a period of integrator inactivity"
     annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
     iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput intErrSta
    "If False, the integral error is 0."
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
    iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-160}, extent={{20,-20},{-20,20}},
      rotation=270), iconTransformation(
      extent={{20,-20},{-20,20}}, rotation=270, origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
    iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
    iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(samplePeriod=interval)
    "Samples values at a provided interval"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(samplePeriod=interval)
    "Zero order hold"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Limiter limiter(
    final uMax=uMax,
    final uMin=uMin) "Output limiter"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain proGain(k=k_p) "Proportional gain"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain intGain(k=k_i)
    "Gain of the integral part of the controller signal"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addPI
    "Sums proportional and integral parts of the controller signal"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add intErrSum
    "Absolute difference between the measurement and the setpoint"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Add error(k1=-1*ra, k2=ra)
    "Absolute difference between the measurement and the setpoint"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Product intErrHolPro
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or  or2  "Logical and"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Boolean to real converter"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1 "Boolean to real converter"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Limiter limiter1(final uMax=uMax, final uMin=uMin)
                     "Output limiter"
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
equation
  connect(u_m, error.u2)
    annotation (Line(points={{0,-160},{0,-120},{-90,-120},{-90,-66},{-82,-66}},color={0,0,127}));
  connect(u_s, error.u1)
    annotation (Line(points={{-160,-60},{-90,-60},{-90,-54},{-82,-54}},color={0,0,127}));
  connect(y, limiter.y) annotation (Line(points={{150,0},{121,0}},color={0,0,127}));
  connect(error.y, proGain.u)
    annotation (Line(points={{-59,-60},{-50,-60},{-50,-90},{-42,-90}},color={0,0,127}));
  connect(proGain.y, addPI.u2)
    annotation (Line(points={{-19,-90},{40,-90},{40,-6},{58,-6}},   color={0,0,127}));
  connect(limiter.u, addPI.y) annotation (Line(points={{98,0},{81,0}}, color={0,0,127}));
  connect(error.y, intGain.u)
    annotation (Line(points={{-59,-60},{-50,-60},{-50,-30},{-42,-30}},color={0,0,127}));
  connect(intGain.y, sam.u) annotation (
    Line(points={{-19,-30},{-10,-30},{-10,80},{-80,80},{-80,110},{-62,110}},  color={0,0,127}));
  connect(sam.y, intErrSum.u2)
    annotation (Line(points={{-39,110},{-20,110},{-20,104},{-2,104}}, color={0,0,127}));
  connect(zerOrdHol.y, intErrSum.u1) annotation (Line(points={{121,100},{130,100},{130,130},{-10,
          130},{-10,116},{-2,116}},
                               color={0,0,127}));
  connect(addPI.u1, pro.y)
    annotation (Line(points={{58,6},{50,6},{50,20},{41,20}}, color={0,0,127}));
  connect(zerOrdHol.y, pro.u1)
    annotation (Line(points={{121,100},{130,100},{130,80},{10,80},{10,26},{18,26}},
                                                                                color={0,0,127}));
  connect(pro.u2, booToRea.y)
    annotation (Line(points={{18,14},{10,14},{10,20},{-79,20}},color={0,0,127}));
  connect(intErrSta, booToRea.u)
    annotation (Line(points={{-160,20},{-102,20}}, color={255,0,255}));
  connect(intErrSum.y, intErrHolPro.u1)
    annotation (Line(points={{21,110},{28,110},{28,106},{38,106}}, color={0,0,127}));
  connect(intErrHolPro.u2, booToRea1.y)
    annotation (Line(points={{38,94},{0,94},{0,60},{-39,60}}, color={0,0,127}));
  connect(intErrSta, or2.u2)
    annotation (Line(points={{-160,20},{-120,20},{-120,52},{-102,52}}, color={255,0,255}));
  connect(or2.y, booToRea1.u) annotation (Line(points={{-79,60},{-62,60}}, color={255,0,255}));
  connect(holdIntError, or2.u1) annotation (Line(points={{-160,60},{-102,60}}, color={255,0,255}));
  connect(intErrHolPro.y, limiter1.u)
    annotation (Line(points={{61,100},{68,100}}, color={0,0,127}));
  connect(zerOrdHol.u, limiter1.y) annotation (Line(points={{98,100},{91,100}}, color={0,0,127}));
  annotation (
    defaultComponentName = "customPI",
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
  Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
          Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end CustomPI;
