within ChillerPlant.ClosedLoopBase.BaseClasses.Controls;
model CondenserWater
  "Constant tower fan and pump speed controls with mixing valve controller"

  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal = 1
   "Nominal condenser water mass flow rate for the WSE loop";

  parameter Real chiFloDivWseFlo = 0.5
   "Ratio of CW flow rates: chiller loop nominal flow divided by the WSE loop nominal flow";

  parameter Real PLRMinUnl = 0.3
   "Minimum chiller unloading part load ratio";

  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mCWFlo(
    final realTrue=mCW_flow_nominal)
    "Mass flow rate of condenser loop"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "Status of water side economizer: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi
    "Chiller status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowFanSpeSet
    "Cooling tower fan speed set-point"
    annotation (Placement(transformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mWSEConWatPumSet_flow
    "Condenser water pump mass flow set-point for the WSE loop"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mCWFlo1(final realTrue=1)
    "Mass flow rate of condenser loop"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=chiFloDivWseFlo)
    "Flow multiplier"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mChiConWatPumSet_flow
    "Condenser water pump mass flow set-point for the chiller condenser loop"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mCWFlo2(final realTrue=
        mCW_flow_nominal)
    "Mass flow rate of condenser loop"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=chiFloDivWseFlo)
    "Flow multiplier"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant set(k=PLRMinUnl)
                                                                  "Constant"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset heaPreCon(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=10,
    final Ti=60,
    final Td=120,
    final r=PLRMinUnl,
    final yMax=1,
    final yMin=0,
    reverseActing=true)
    "Controls the recirculation valve to maintain the CW supply temperature sufficiently above the evaporator side one"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addFlo
    "Adds WSE and chiller condenser side flow "
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mCTConWatPumSet
    "Condenser water pump mass flow set-point for the cooling tower loop"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiConMix
    "Chiller condenser supply temperature regulation valve "
    annotation (Placement(transformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiPLR
    "Measured chiller part load ratio" annotation (Placement(transformation(
          extent={{-140,-80},{-100,-40}}), iconTransformation(extent={{-140,-100},
            {-100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(p=1, k=-1)
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
equation
  connect(uWSE, or2.u1) annotation (Line(points={{-120,80},{-62,80}},
                   color={255,0,255}));
  connect(uChi, or2.u2) annotation (Line(points={{-120,0},{-80,0},{-80,72},{-62,
          72}},      color={255,0,255}));
  connect(mWSEConWatPumSet_flow, mWSEConWatPumSet_flow)
    annotation (Line(points={{120,0},{120,0}},     color={0,0,127}));
  connect(or2.y, mCWFlo1.u) annotation (Line(points={{-38,80},{-22,80}},
                color={255,0,255}));
  connect(mCWFlo1.y, yTowFanSpeSet)
    annotation (Line(points={{2,80},{120,80}},  color={0,0,127}));
  connect(uChi, mCWFlo.u) annotation (Line(points={{-120,0},{-72,0},{-72,40},{
          -22,40}},  color={255,0,255}));
  connect(uWSE, mCWFlo2.u) annotation (Line(points={{-120,80},{-88,80},{-88,-10},
          {-22,-10}},color={255,0,255}));
  connect(mCWFlo.y, gai.u)
    annotation (Line(points={{2,40},{18,40}},    color={0,0,127}));
  connect(gai.y, mChiConWatPumSet_flow)
    annotation (Line(points={{42,40},{120,40}},   color={0,0,127}));
  connect(mCWFlo2.y, gai1.u)
    annotation (Line(points={{2,-10},{18,-10}}, color={0,0,127}));
  connect(gai1.y, mWSEConWatPumSet_flow) annotation (Line(points={{42,-10},{60,-10},
          {60,0},{120,0}},          color={0,0,127}));
  connect(set.y,heaPreCon. u_s)
    annotation (Line(points={{-38,-80},{-22,-80}}, color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(gai.y, addFlo.u1) annotation (Line(points={{42,40},{50,40},{50,-34},{58,
          -34}}, color={0,0,127}));
  connect(gai1.y, addFlo.u2) annotation (Line(points={{42,-10},{48,-10},{48,-46},
          {58,-46}}, color={0,0,127}));
  connect(addFlo.y, mCTConWatPumSet)
    annotation (Line(points={{82,-40},{120,-40}}, color={0,0,127}));
  connect(yChiConMix, yChiConMix)
    annotation (Line(points={{120,-80},{120,-80}}, color={0,0,127}));
  connect(uChi, heaPreCon.trigger) annotation (Line(points={{-120,0},{-80,0},{
          -80,-96},{-16,-96},{-16,-92}},  color={255,0,255}));
  connect(uChiPLR, heaPreCon.u_m) annotation (Line(points={{-120,-60},{-90,-60},
          {-90,-98},{-10,-98},{-10,-92}}, color={0,0,127}));
  connect(heaPreCon.y, addPar.u)
    annotation (Line(points={{2,-80},{38,-80}}, color={0,0,127}));
  connect(addPar.y, yChiConMix)
    annotation (Line(points={{62,-80},{120,-80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200}),
          Text(
          extent={{-48,42},{48,-36}},
          lineColor={28,108,200},
          textString="CW")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end CondenserWater;
