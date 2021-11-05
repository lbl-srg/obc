within SystemModel.VAV;
block HeatingRequests "Heating requests from AHU heating coil"

  parameter Real errTDis_1(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=17
    "Limit value of difference between discharge air temperature and its setpoint
    for generating 3 hot water reset requests";

  parameter Real errTDis_2(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=8.3
    "Limit value of difference between discharge air temperature and its setpoint
    for generating 2 hot water reset requests";

  parameter Real durTimDisAir(
    final unit="s",
    final quantity="Time")=300
    "Duration time of discharge air temperature is less than setpoint"
    annotation(Dialog(group="Duration times"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDisHeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Discharge airflow setpoint temperature for heating"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge airflow temperature"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaVal(
    final min=0,
    final max=1,
    final unit="1")                   "Heating valve position"
    annotation (Placement(transformation(extent={{-220,-40},{-180,0}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaValResReq
    "Hot water reset requests"
    annotation (Placement(transformation(extent={{180,70},{220,110}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaPlaReq
    "Heating plant request"
    annotation (Placement(transformation(extent={{180,-120},{220,-80}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys8(
    final uLow=-0.1,
    final uHigh=0.1)
    "Check if discharge air temperature is errTDis_1 less than setpoint"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys9(
    final uLow=-0.1,
    final uHigh=0.1)
    "Check if discharge air temperature is errTDis_2 less than setpoint"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys10(
    final uLow=0.85,
    final uHigh=0.95)
    "Check if valve position is greater than 0.95"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys11(final uHigh=0.15,
    final uLow=0.1)
    "Check if valve position is greater than 0.95"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Add add6(final k2=-1)
    "Calculate difference of discharge temperature (plus errTDis_1) and its setpoint"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add7(final k2=-1)
    "Calculate difference of discharge temperature (plus errTDis_2) and its setpoint"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final k=1,
    final p=errTDis_1)
    "Discharge temperature plus errTDis_1"
    annotation (Placement(transformation(extent={{-140,58},{-120,78}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final k=1,
    final p=errTDis_2)
    "Discharge temperature plus errTDis_2"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer value"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real to integer value"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant thrHeaResReq(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant twoHeaResReq(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneHeaResReq(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerHeaResReq(
    final k=0)
    "Constant 0"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerBoiPlaReq(
    final k=0)
    "Constant 0"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneBoiPlaReq(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi7
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi8
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi9
    "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi10
    "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim4(delayTime=durTimDisAir)
    "Check if it is more than durTimDisAir"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim5(delayTime=durTimDisAir)
    "Check if it is more than durTimDisAir"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

equation
  connect(TDis, addPar.u)
    annotation (Line(points={{-200,40},{-160,40},{-160,68},{-142,68}},
      color={0,0,127}));
  connect(addPar.y, add6.u2)
    annotation (Line(points={{-118,68},{-108,68},{-108,84},{-82,84}},
      color={0,0,127}));
  connect(TDisHeaSet, add6.u1)
    annotation (Line(points={{-200,120},{-100,120},{-100,96},{-82,96}},
      color={0,0,127}));
  connect(add6.y, hys8.u)
    annotation (Line(points={{-58,90},{-42,90}},     color={0,0,127}));
  connect(addPar1.y, add7.u2)
    annotation (Line(points={{-118,10},{-108,10},{-108,24},{-82,24}},
      color={0,0,127}));
  connect(add7.y, hys9.u)
    annotation (Line(points={{-58,30},{-42,30}},     color={0,0,127}));
  connect(hys9.y, tim5.u)
    annotation (Line(points={{-18,30},{-2,30}},     color={255,0,255}));
  connect(thrHeaResReq.y, swi7.u1)
    annotation (Line(points={{62,120},{80,120},{80,98},{98,98}},
      color={0,0,127}));
  connect(twoHeaResReq.y, swi8.u1)
    annotation (Line(points={{62,60},{80,60},{80,38},{98,38}},
      color={0,0,127}));
  connect(swi8.y, swi7.u3)
    annotation (Line(points={{122,30},{140,30},{140,70},{80,70},{80,82},{98,82}},
                  color={0,0,127}));
  connect(TDis, addPar1.u)
    annotation (Line(points={{-200,40},{-160,40},{-160,10},{-142,10}},
      color={0,0,127}));
  connect(TDisHeaSet, add7.u1)
    annotation (Line(points={{-200,120},{-100,120},{-100,36},{-82,36}},
      color={0,0,127}));
  connect(uHeaVal, hys10.u)
    annotation (Line(points={{-200,-20},{-142,-20}},   color={0,0,127}));
  connect(hys10.y, swi9.u2)
    annotation (Line(points={{-118,-20},{98,-20}},   color={255,0,255}));
  connect(oneHeaResReq.y, swi9.u1)
    annotation (Line(points={{62,0},{80,0},{80,-12},{98,-12}},
      color={0,0,127}));
  connect(zerHeaResReq.y, swi9.u3)
    annotation (Line(points={{62,-40},{80,-40},{80,-28},{98,-28}},
      color={0,0,127}));
  connect(swi9.y, swi8.u3)
    annotation (Line(points={{122,-20},{140,-20},{140,10},{80,10},{80,22},{98,22}},
                  color={0,0,127}));
  connect(swi7.y, reaToInt2.u)
    annotation (Line(points={{122,90},{138,90}},     color={0,0,127}));
  connect(reaToInt2.y, yHeaValResReq)
    annotation (Line(points={{162,90},{200,90}},     color={255,127,0}));
  connect(uHeaVal, hys11.u)
    annotation (Line(points={{-200,-20},{-160,-20},{-160,-100},{-142,-100}},
      color={0,0,127}));
  connect(hys11.y, swi10.u2)
    annotation (Line(points={{-118,-100},{98,-100}}, color={255,0,255}));
  connect(oneBoiPlaReq.y, swi10.u1)
    annotation (Line(points={{62,-80},{80,-80},{80,-92},{98,-92}},
      color={0,0,127}));
  connect(zerBoiPlaReq.y, swi10.u3)
    annotation (Line(points={{62,-120},{80,-120},{80,-108},{98,-108}},
      color={0,0,127}));
  connect(swi10.y, reaToInt3.u)
    annotation (Line(points={{122,-100},{138,-100}}, color={0,0,127}));
  connect(reaToInt3.y,yHeaPlaReq)
    annotation (Line(points={{162,-100},{200,-100}}, color={255,127,0}));
  connect(tim5.y, swi8.u2)
    annotation (Line(points={{22,30},{98,30}},     color={255,0,255}));
  connect(hys8.y, tim4.u)
    annotation (Line(points={{-18,90},{-2,90}},     color={255,0,255}));
  connect(tim4.y, swi7.u2)
    annotation (Line(points={{22,90},{98,90}},     color={255,0,255}));

annotation (
  defaultComponentName="heaReq",
  Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-180,-140},{180,140}}),
      graphics={
        Rectangle(
          extent={{-158,128},{158,-48}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-158,-72},{158,-128}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-152,-30},{-26,-50}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Hot water reset requests"),
        Text(
          extent={{-150,-110},{-12,-132}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Boiler plant reset requests")}),
     Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
          graphics={
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,48},{-52,32}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDisHeaSet"),
        Text(
          extent={{-98,4},{-64,-6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          extent={{-98,-36},{-64,-46}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHeaVal"),
        Text(
          extent={{42,52},{98,32}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHeaValResReq"),
        Text(
          extent={{58,-34},{98,-50}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHeaPlaReq")}),
  Documentation(info="<html>
<p>
This sequence outputs the heating reset requests, i.e.,
</p>
<ul>
<li>
the hot water reset requests <code>yHeaValResReq</code>, and
</li>
<li>
the boiler plant reset requests <code>yHeaPlaReq</code>.
</li>
</ul>
<p>
The calculations are according to ASHRAE
Guideline 36 (G36), PART 5.E.9, in the steps shown below.
</p>
<h4>a. Hot water reset requests <code>yHeaValResReq</code></h4>
<ol>
<li>
If the discharge air temperature <code>TDis</code> is 17 &deg;C (30 &deg;F)
less than the setpoint <code>TDisHeaSet</code> for 5 minutes, send 3 requests
(<code>yHeaValResReq=3</code>).
</li>
<li>
Else if the discharge air temperature <code>TDis</code> is 8.3 &deg;C (15 &deg;F)
less than the setpoint <code>TDisHeaSet</code> for 5 minutes, send 2 requests
(<code>yHeaValResReq=2</code>).
</li>
<li>
Else if the hot water valve position <code>uHeaVal</code> is greater than 95%, send 1 request
(<code>yHeaValResReq=1</code>) until <code>uHeaVal</code> is less than 85%.
</li>
<li>
Else if <code>uHeaVal</code> is less than 95%, send 0 request (<code>yHeaValResReq=0</code>).
</li>
</ol>
<h4>b. Send the boiler plant that serves the zone a boiler
plant requests <code>yHeaPlaReq</code> as follows:</h4>
<ol>
<li>
If the hot water valve position <code>uHeaVal</code> is greater than 15%, send 1 request
(<code>yHeaPlaReq=1</code>) until <code>uHeaVal</code> is less than 10%.
</li>
<li>
Else if <code>uHeaVal</code> is less than 15%, send 0 request (<code>yHeaPlaReq=0</code>).
</li>
</ol>
<h4>Implementation</h4>
<p>
Some input signals are time sampled, because the output that is generated
from these inputs are used in the trim and respond logic, which
is also time sampled. However, signals that use a delay are not
sampled, as sampling were to change the dynamic response.
</p>
</html>", revisions="<html>
<ul>
<li>
November 4, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatingRequests;
