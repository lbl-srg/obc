within SystemModel.BoilerPlant.Submodels.BoilerPlantControls.Generic.EquipmentRotation.Subsequences;
block LeastRuntime
  "Generates equipment rotation signal at each device enable if that device has a least total runtime"

  parameter Boolean lag = true
    "true = lead/lag; false = lead/standby";

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Initiation"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta[nDev]
    "Device status: true = proven ON, false = proven OFF"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
                   iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPreDevRolSig[nDev]
    "Device roles in the previous time instance: true = lead; false = lag or standby"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yRot
    "Rotation trigger signal"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating accTim[nDev]
    "Measures time spent loaded at the current role (lead or lag)"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nDev](
    final k=fill(false, nDev)) "Constant"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater longer1
    "Runtime of the first device is longer than runtime of the second device"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater longer2
    "Runtime of the second device is longer than the runtime of the first device"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nDev) "Multiple or"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 if lag "Logical not"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2 if lag "Logical not"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3[nDev] if lag "Logical not"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and3[nDev] if lag "Logical not"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg [nDev](
    final pre_u_start=fill(false, nDev)) if lag "Rising edge"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Controls.OBC.CDL.Logical.And and1[nDev] if not lag "Logical and"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg [nDev](
    final pre_u_start=fill(false, nDev)) if not lag "Falling edge"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));

equation
  connect(uDevSta, accTim.u)
    annotation (Line(points={{-180,60},{-62,60}}, color={255,0,255}));
  connect(accTim[1].y, longer1.u1)
    annotation (Line(points={{-38,60},{-22,60}}, color={0,0,127}));
  connect(accTim[2].y, longer1.u2) annotation (Line(points={{-38,60},{-30,60},{-30,
          52},{-22,52}}, color={0,0,127}));
  connect(accTim[1].y, longer2.u2) annotation (Line(points={{-38,60},{-30,60},{-30,
          22},{-22,22}}, color={0,0,127}));
  connect(accTim[2].y, longer2.u1) annotation (Line(points={{-38,60},{-30,60},{-30,
          30},{-22,30}}, color={0,0,127}));
  connect(uDevSta, edg.u) annotation (Line(points={{-180,60},{-120,60},{-120,-10},
          {-102,-10}}, color={255,0,255}));
  connect(yRot, yRot)
    annotation (Line(points={{180,0},{180,0}}, color={255,0,255}));
  connect(longer2.y, not2.u)
    annotation (Line(points={{2,30},{18,30}}, color={255,0,255}));
  connect(longer1.y, not1.u)
    annotation (Line(points={{2,60},{18,60}}, color={255,0,255}));
  connect(uPreDevRolSig, not3.u)
    annotation (Line(points={{-180,-40},{18,-40}}, color={255,0,255}));
  connect(edg.y, and3.u2) annotation (Line(points={{-78,-10},{80,-10},{80,20},{98,
          20}}, color={255,0,255}));
  connect(not3.y, and3.u3) annotation (Line(points={{42,-40},{88,-40},{88,12},{98,
          12}}, color={255,0,255}));
  connect(not1.y, and3[1].u1) annotation (Line(points={{42,60},{80,60},{80,28},{
          98,28}}, color={255,0,255}));
  connect(not2.y, and3[2].u1) annotation (Line(points={{42,30},{70,30},{70,28},{
          98,28}}, color={255,0,255}));
  connect(mulOr.y, yRot)
    annotation (Line(points={{152,0},{180,0}}, color={255,0,255}));
  connect(and3.y, mulOr.u) annotation (Line(points={{122,20},{124,20},{124,0},{128,
          0},{128,0}},            color={255,0,255}));
  connect(uDevSta, falEdg.u) annotation (Line(points={{-180,60},{-120,60},{-120,
          -60},{-102,-60}}, color={255,0,255}));
  connect(longer1.y, and1[1].u1) annotation (Line(points={{2,60},{10,60},{10,-20},
          {80,-20},{80,-60},{98,-60}}, color={255,0,255}));
  connect(longer2.y, and1[2].u1) annotation (Line(points={{2,30},{10,30},{10,-20},
          {80,-20},{80,-60},{98,-60}}, color={255,0,255}));
  connect(and1.y, mulOr.u) annotation (Line(points={{122,-60},{122,0},{128,0}},
                       color={255,0,255}));
  connect(falEdg.y, and1.u2) annotation (Line(points={{-78,-60},{20,-60},{20,
          -68},{98,-68}}, color={255,0,255}));
  connect(con.y, accTim.reset) annotation (Line(points={{-78,30},{-70,30},{-70,52},
          {-62,52}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-80},{160,80}})),
      defaultComponentName="leaRunTim",
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
      Line(points={{-66,-70},{82,-70}},
        color={192,192,192}),
      Line(points={{-58,68},{-58,-80}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-58,90},{-66,68},{-50,68},{-58,90}}),
      Line(points={{-56,-70},{-38,-70},{-38,-26},{40,-26},{40,-70},{68,-70}},
        color={255,0,255}),
      Line(points={{-58,0},{-40,0},{40,90},{40,0},{68,0}},
        color={0,0,127})}),
  Documentation(info="<html>
<p>
This subsequence generates a rotation trigger signal <code>yRot</code> based on measuring the time each of the devices/groups of devices
has spent in its current role. The rotation trigger output <code>yRot</code> is generated:
</p>
<ul>
<li>
for lead/lag operation when a device/a group of devices is enabled that has the shortest cumulative runtime
</li>
<li>
for lead/standby operation when a device/a group of devices is disbled that has the longest cumulative runtime
</li>
</ul>
<p>
The implementation corresponts sections 5.1.2.3. and 5.1.2.4.1. of RP1711 March 2020 draft when applied to
two devices or groups of devices.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end LeastRuntime;
