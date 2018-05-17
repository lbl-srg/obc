within OBCSequenceValidation;
block alcPI "ALC implementation of a PI controller"

  parameter Real k_p(min=0, unit="1/F") = 1 "Proportional Gain";
  parameter Real k_i(min=0, unit="1/F") = 1 "Integral Gain";
  parameter Real interval(min = 1, unit="s") = 10
    "Interval at which integration part of the output gets updated";

  parameter Boolean reverseAction = false
    "Reverse action";
  parameter Real ra = if reverseAction then -1 else 1
    "Reverse action multiplier";

  parameter Real uMin = 0 "Upper limit of output";
  parameter Real uMax = 1 "Lower limit of output";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-160}, extent={{20,-20},{-20,20}},
      rotation=270), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=270,
        origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput holdIntError
    "If False, the integrator error is reset to 0 after a period of integrator inactivity"
     annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
     iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
    iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Add error(k1=-1*ra, k2=ra)
    "Absolute difference between the measurement and the setpoint"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

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
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(samplePeriod=interval)
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(samplePeriod=interval)
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Add error1
    "Absolute difference between the measurement and the setpoint"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput intErrSta
    "If False, the integral error is 0."
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
    iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge resetIntErr
    "Resets the integrator error when integrator error status is off if the integrator error hold is off."
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro1
    annotation (Placement(transformation(extent={{30,86},{50,106}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-130,50},{-110,70}})));

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
    Line(points={{-19,-30},{-10,-30},{-10,80},{-100,80},{-100,110},{-82,110}},color={0,0,127}));
  connect(sam.y, error1.u2)
    annotation (Line(points={{-59,110},{-40,110},{-40,104},{-22,104}}, color={0,0,127}));
  connect(zerOrdHol.y, error1.u1)
    annotation (Line(points={{101,110},{140,110},{140,140},{-30,140},{-30,116},{-22,116}},
    color={0,0,127}));
  connect(addPI.u1, pro.y)
    annotation (Line(points={{58,6},{50,6},{50,20},{41,20}}, color={0,0,127}));
  connect(zerOrdHol.y, pro.u1)
    annotation (Line(points={{101,110},{140,110},{140,80},{10,80},{10,26},{18,26}},
                                                                                color={0,0,127}));
  connect(pro.u2, booToRea.y)
    annotation (Line(points={{18,14},{10,14},{10,20},{-79,20}},color={0,0,127}));
  connect(intErrSta, booToRea.u)
    annotation (Line(points={{-160,20},{-102,20}}, color={255,0,255}));
  connect(error1.y, pro1.u1)
    annotation (Line(points={{1,110},{14,110},{14,102},{28,102}}, color={0,0,127}));
  connect(zerOrdHol.u, pro1.y)
    annotation (Line(points={{78,110},{64,110},{64,96},{51,96}}, color={0,0,127}));
  connect(pro1.u2, booToRea1.y)
    annotation (Line(points={{28,90},{4,90},{4,60},{-19,60}}, color={0,0,127}));
  connect(and2.u1, not1.y) annotation (Line(points={{-102,60},{-109,60}}, color={255,0,255}));
  connect(holdIntError, not1.u) annotation (Line(points={{-160,60},{-132,60}}, color={255,0,255}));
  connect(intErrSta, and2.u2) annotation (Line(points={{-160,20},{-120,20},{-120,40},{-106,40},{-106,
          52},{-102,52}}, color={255,0,255}));
  connect(and2.y, resetIntErr.u) annotation (Line(points={{-79,60},{-72,60}}, color={255,0,255}));
  connect(booToRea1.u, resetIntErr.y)
    annotation (Line(points={{-42,60},{-49,60}}, color={255,0,255}));
  annotation (
    defaultComponentName = "alc_PI",
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
end alcPI;
