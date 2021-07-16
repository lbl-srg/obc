within ChillerPlant.ClosedLoopBase.BaseClasses.Controls;
model WaterSideEconomizerStateMachine
  "Water-side economizer status state machine controller"
  extends Buildings.Examples.ChillerPlant.BaseClasses.Controls.WSEControl;

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySta
    "WSE status setpoint, ON = true, OFF = false" annotation (Placement(
        transformation(extent={{180,-120},{220,-80}}), iconTransformation(
          extent={{180,-120},{220,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));
equation
  connect(ySta, not1.y)
    annotation (Line(points={{200,-100},{162,-100}}, color={255,0,255}));
  connect(off.active, not1.u) annotation (Line(points={{10,76.8},{10,-100},{138,
          -100}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-20,180},{180,-160}},  lineColor={28,108,200}),
          Text(
          extent={{-6,100},{160,-54}},
          lineColor={28,108,200},
          textString="WSE")}),
        Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-74,148},{-8,144}},
          lineColor={28,108,200},
          textString="fixme: this input is effectivelly 
chilled water return temperature
upstream of WSE")}));
end WaterSideEconomizerStateMachine;
