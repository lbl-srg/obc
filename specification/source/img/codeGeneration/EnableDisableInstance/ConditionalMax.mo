within Buildings.Controls.OBC.CDL.Continuous;
block ConditionalMax
  "Maximum between two inputs with one of them could be conditional removed"
  parameter Boolean u2_present = true "Flag to indicate if second input should present";

  Interfaces.RealInput u1 "Real input"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Interfaces.RealInput u2 if u2_present "Real input"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.RealOutput y "Real output"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Interfaces.RealInput u_internal
    "Internal input needed to connect to conditional connector";

equation
  connect(u_internal, u2);
  if not u2_present then
    u_internal = 0;
  end if;
  y = if u2_present then max(u1, u_internal) else u1;

annotation (
  defaultComponentName = "conMax",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
       Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
       Text(extent={{-150,150},{150,110}}, textString="%name", lineColor={0,0,255}),
       Text(extent={{-90,36},{90,-36}}, lineColor={160,160,164}, textString="max()")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end ConditionalMax;
