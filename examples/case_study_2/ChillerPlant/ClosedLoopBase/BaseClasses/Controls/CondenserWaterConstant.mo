within ChillerPlant.ClosedLoopBase.BaseClasses.Controls;
model CondenserWaterConstant "Constant tower fan and CW pump speed control"

  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal = 1
   "Nominal condenser water mass flow rate";

  Buildings.Controls.OBC.CDL.Logical.Or
                             or2
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mCWFlo(
    final realTrue=mCW_flow_nominal)
    "Mass flow rate of condenser loop"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "Status of water side economizer: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi
    "Chiller status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowFanSpeSet
    "Cooling tower fan speed set-point"
    annotation (Placement(transformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mConWatPumSet_flow
    "Condenser water pump mass flow set-point"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mCWFlo1(final realTrue=1)
    "Mass flow rate of condenser loop"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
equation
  connect(or2.y,mCWFlo. u) annotation (Line(
      points={{2,0},{18,0}},
      color={255,0,255},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(mCWFlo.y, mConWatPumSet_flow) annotation (Line(points={{42,0},{60,0},
          {60,-50},{120,-50}}, color={0,0,127}));
  connect(uWSE, or2.u1) annotation (Line(points={{-120,50},{-60,50},{-60,0},{
          -22,0}}, color={255,0,255}));
  connect(uChi, or2.u2) annotation (Line(points={{-120,-50},{-60,-50},{-60,-8},
          {-22,-8}}, color={255,0,255}));
  connect(mConWatPumSet_flow, mConWatPumSet_flow)
    annotation (Line(points={{120,-50},{120,-50}}, color={0,0,127}));
  connect(or2.y, mCWFlo1.u) annotation (Line(points={{2,0},{10,0},{10,50},{18,
          50}}, color={255,0,255}));
  connect(mCWFlo1.y, yTowFanSpeSet)
    annotation (Line(points={{42,50},{120,50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200}),
          Text(
          extent={{-82,88},{84,-66}},
          lineColor={28,108,200},
          textString="Base
CW")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end CondenserWaterConstant;
