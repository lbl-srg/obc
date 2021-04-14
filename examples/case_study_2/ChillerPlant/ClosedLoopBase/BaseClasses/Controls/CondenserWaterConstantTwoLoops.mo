within ChillerPlant.ClosedLoopBase.BaseClasses.Controls;
model CondenserWaterConstantTwoLoops
  "Constant tower fan and CW pump speed control for separate WSE and chilled water loops"

  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal = 1
   "Nominal condenser water mass flow rate for the WSE loop";

  parameter Real chiFloDivWseFlo = 0.5
   "Ratio of CW flow rates: chiller loop nominal flow divided by the WSE loop nominal flow";

  Buildings.Controls.OBC.CDL.Logical.Or
                             or2
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mCWFlo(
    final realTrue=mCW_flow_nominal)
    "Mass flow rate of condenser loop"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "Status of water side economizer: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi
    "Chiller status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowFanSpeSet
    "Cooling tower fan speed set-point"
    annotation (Placement(transformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mWSEConWatPumSet_flow
    "Condenser water pump mass flow set-point for the WSE loop"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mCWFlo1(final realTrue=1)
    "Mass flow rate of condenser loop"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=chiFloDivWseFlo)
    "Flow multiplier"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mChiConWatPumSet_flow
    "Condenser water pump mass flow set-point for the chiller condenser loop"
    annotation (Placement(transformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mCWFlo2(final realTrue=
        mCW_flow_nominal)
    "Mass flow rate of condenser loop"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(k1=-1, k2=1)
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
equation
  connect(uWSE, or2.u1) annotation (Line(points={{-120,50},{-62,50}},
                   color={255,0,255}));
  connect(uChi, or2.u2) annotation (Line(points={{-120,-50},{-80,-50},{-80,42},
          {-62,42}}, color={255,0,255}));
  connect(mWSEConWatPumSet_flow, mWSEConWatPumSet_flow)
    annotation (Line(points={{120,-60},{120,-60}}, color={0,0,127}));
  connect(or2.y, mCWFlo1.u) annotation (Line(points={{-38,50},{-22,50}},
                color={255,0,255}));
  connect(mCWFlo1.y, yTowFanSpeSet)
    annotation (Line(points={{2,50},{120,50}},  color={0,0,127}));
  connect(uChi, mCWFlo.u) annotation (Line(points={{-120,-50},{-72,-50},{-72,
          -10},{-22,-10}},
                     color={255,0,255}));
  connect(uWSE, mCWFlo2.u) annotation (Line(points={{-120,50},{-88,50},{-88,-60},
          {-22,-60}},color={255,0,255}));
  connect(mCWFlo.y, gai.u)
    annotation (Line(points={{2,-10},{18,-10}},  color={0,0,127}));
  connect(mWSEConWatPumSet_flow, add2.y)
    annotation (Line(points={{120,-60},{82,-60}}, color={0,0,127}));
  connect(gai.y, add2.u1) annotation (Line(points={{42,-10},{50,-10},{50,-54},{
          58,-54}}, color={0,0,127}));
  connect(mCWFlo2.y, add2.u2) annotation (Line(points={{2,-60},{20,-60},{20,-66},
          {58,-66}}, color={0,0,127}));
  connect(gai.y, mChiConWatPumSet_flow)
    annotation (Line(points={{42,-10},{120,-10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200}),
          Text(
          extent={{-82,88},{84,-66}},
          lineColor={28,108,200},
          textString="Base
CW")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end CondenserWaterConstantTwoLoops;
