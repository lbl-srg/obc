within OBCSequenceValidation;
block alcPI "ALC implementation of a PI controller"

  parameter Real k_p(min=0, unit="1/F") = 1 "Proportional Gain";
  parameter Real k_i(min=0, unit="1/F") = 1 "Integral Gain";
  parameter Real interval(min = 1, unit="s") = 10
    "Interval at which integration part of the output gets updated";

  parameter Boolean reverseAction = false
    "Reverse action";

  parameter Real uMin = 0 "Upper limit of output";

  parameter Real uMax = 1 "Lower limit of output";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-120}, extent={{20,-20},{-20,20}},
      rotation=270)));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add error(k1=-1*ra, k2=ra)
    "Absolute difference between the measurement and the setpoint"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Modelica.Blocks.Nonlinear.Limiter limiter(
    final uMax=uMax,
    final uMin=uMin)     "Output limiter"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain proGain(k=k_p) "Proportional gain"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain intGain(k=k_i)
    "Gain of the integral part of the controller signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addPI
    "Sums proportional and integral parts of the controller signal"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset integrator(reset=Buildings.Controls.OBC.CDL.Types.Reset.Disabled)
    "Cumulates input signals" annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse sampler(period=interval, width=1/interval)
    "Integral error sampler" annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

protected
  parameter Real ra = if reverseAction then -1 else 1
    "Reverse action multiplier";

equation
  connect(u_m, error.u2)
    annotation (Line(points={{0,-120},{0,-80},{-88,-80},{-88,-6},{-82,-6}}, color={0,0,127}));
  connect(u_s, error.u1)
    annotation (Line(points={{-120,0},{-88,0},{-88,6},{-82,6}}, color={0,0,127}));
  connect(y, limiter.y) annotation (Line(points={{110,0},{91,0}}, color={0,0,127}));
  connect(error.y, proGain.u)
    annotation (Line(points={{-59,0},{-50,0},{-50,-30},{-42,-30}}, color={0,0,127}));
  connect(proGain.y, addPI.u2)
    annotation (Line(points={{-19,-30},{-10,-30},{-10,-6},{38,-6}}, color={0,0,127}));
  connect(limiter.u, addPI.y) annotation (Line(points={{68,0},{61,0}}, color={0,0,127}));
  connect(error.y, intGain.u)
    annotation (Line(points={{-59,0},{-50,0},{-50,30},{-42,30}}, color={0,0,127}));
  connect(integrator.y, addPI.u1)
    annotation (Line(points={{21,70},{30,70},{30,6},{38,6}}, color={0,0,127}));
  connect(sampler.y, pro.u1)
    annotation (Line(points={{-59,70},{-50,70},{-50,76},{-42,76}}, color={0,0,127}));
  connect(intGain.y, pro.u2) annotation (Line(points={{-19,30},{-10,30},{-10,50},{-50,50},{-50,64},{
          -42,64}}, color={0,0,127}));
  connect(pro.y, integrator.u) annotation (Line(points={{-19,70},{-2,70}}, color={0,0,127}));
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
          preserveAspectRatio=false)), Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));

end alcPI;
