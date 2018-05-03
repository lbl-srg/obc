within OBCSequenceValidation.Validation;
model HeatingCoilValve_F_TSup_TSupSet_TOut_uSupFan
  "Validation model for the heating coil valve control sequence with all temperatures in F"
  extends Modelica.Icons.Example;

  parameter Real TOutHeaCut(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 68
    "Upper outdoor air temperature limit for enabling heating (68 F)";

  parameter Real TSup(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 60
    "Supply air temperature";

  parameter Real TSupSet(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 70
    "Supply air temperature setpoint";

  parameter Real TSatMinLowLim(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 40
    "Minimum supply air temperature for defining the lower limit of the valve position (40 F)"
    annotation(Evaluate=true);

  parameter Real TSatMaxLowLim(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 45
    "Maximum supply air temperature for defining the lower limit of the valve position (45 F)"
    annotation(Evaluate=true);

  parameter Real LowTSupSet(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 43
    "Fictive low supply air temeprature setpoint to check the limiter functionality"
    annotation(Evaluate=true);

// Tests disable if supply fan is off
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutBelowCutoff(final k=TOutHeaCut - 5)
    "Outdoor air temperature is below the cutoff"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSup(final k=TSup)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet(final k=TSupSet)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uSupFan(k=false)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  HeatingCoilValve_F heaValSta_F(
                               genEna=false, revAct=false)
    "Heating coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

// Tests disable if it is warm outside
  HeatingCoilValve_F heaValSta_F1(
    k=5,
    Ti=1/0.5,
    genEna=false,
    revAct=false) "Heating coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutAboveCutoff1(final k=TOutHeaCut + 5)
    "Outdoor air temperature is above the cutoff"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSup1(final k=TSup)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-160,-38},{-140,-18}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet1(final k=TSupSet)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uSupFan1(k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

// Tests controler normal operation when supply air temperature is above limiter values
  HeatingCoilValve_F heaValSta_F2(
    genEna=false,
    k=5,
    Ti=1/0.5,
    revAct=false)
              "Heating coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutBelowCutoff2(final k=TOutHeaCut - 5)
    "Outdoor air temperature is below the cutoff"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet2(final k=TSupSet)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uSupFan2(k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

// Tests controler operation when supply air temperature is within limiter values
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uTSup2(
    duration=1800,
    startTime=0,
    height=2,
    offset=TSupSet - 2/2) "\"Supply air temperature\""
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  HeatingCoilValve_F heaValSta_F3(
    k=5,
    Ti=1/0.5,
    genEna=false,
    revAct=false) "Heating coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutBelowCutoff1(final k=TOutHeaCut - 5)
    "Outdoor air temperature is below the cutoff"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet3(final k=LowTSupSet)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uSupFan3(k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uTSup3(
    duration=1800,
    startTime=0,
    offset=TSatMinLowLim,
    height=TSatMaxLowLim - TSatMinLowLim)
    "Supply air temperature source"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(heaValSta_F.TOut, uTOutBelowCutoff.y)
    annotation (Line(points={{-41,93},{-70,93},{-70,50},{-99,50}}, color={0,0,127}));
  connect(uSupFan.y, heaValSta_F.uSupFan)
    annotation (Line(points={{-59,30},{-50,30},{-50,85},{-41,85}}, color={255,0,255}));
  connect(heaValSta_F1.TOut, uTOutAboveCutoff1.y)
    annotation (Line(points={{-41,-27},{-70,-27},{-70,-70},{-99,-70}}, color={0,0,127}));
  connect(uSupFan1.y, heaValSta_F1.uSupFan)
    annotation (Line(points={{-59,-90},{-50,-90},{-50,-35},{-41,-35}}, color={255,0,255}));
  connect(heaValSta_F1.TSupSet, uTSupSet1.y) annotation (Line(points={{-41,-23},{-90,-23},{-90,-40},
          {-130,-40},{-130,-70},{-139,-70}}, color={0,0,127}));
  connect(heaValSta_F1.TSup, uTSup1.y)
    annotation (Line(points={{-41,-20},{-120,-20},{-120,-28},{-139,-28}}, color={0,0,127}));
  connect(heaValSta_F.TSupSet, uTSupSet.y) annotation (Line(points={{-41,97},{-90,97},{-90,80},{-130,
          80},{-130,50},{-139,50}}, color={0,0,127}));
  connect(heaValSta_F.TSup, uTSup.y)
    annotation (Line(points={{-41,100},{-120,100},{-120,90},{-139,90}}, color={0,0,127}));
  connect(heaValSta_F2.TOut, uTOutBelowCutoff2.y) annotation (Line(points={{139,93},{120,93},{120,
          94},{100,94},{100,50},{81,50}}, color={0,0,127}));
  connect(uSupFan2.y, heaValSta_F2.uSupFan)
    annotation (Line(points={{121,30},{130,30},{130,85},{139,85}}, color={255,0,255}));
  connect(heaValSta_F2.TSupSet, uTSupSet2.y) annotation (Line(points={{139,97},{108,97},{108,98},{
          76,98},{76,80},{50,80},{50,50},{41,50}}, color={0,0,127}));
  connect(heaValSta_F2.TSup, uTSup2.y)
    annotation (Line(points={{139,100},{60,100},{60,90},{41,90}}, color={0,0,127}));
  connect(heaValSta_F3.TOut, uTOutBelowCutoff1.y)
    annotation (Line(points={{139,-27},{110,-27},{110,-70},{81,-70}}, color={0,0,127}));
  connect(uSupFan3.y, heaValSta_F3.uSupFan)
    annotation (Line(points={{121,-90},{130,-90},{130,-35},{139,-35}}, color={255,0,255}));
  connect(heaValSta_F3.TSupSet, uTSupSet3.y) annotation (Line(points={{139,-23},{90,-23},{90,-40},{
          50,-40},{50,-70},{41,-70}}, color={0,0,127}));
  connect(heaValSta_F3.TSup, uTSup3.y)
    annotation (Line(points={{139,-20},{60,-20},{60,-30},{41,-30}}, color={0,0,127}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="HeatingCoilValve_F_TSup_TSupSet_TOut_uSupFan.mos"
    "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates the heating coil signal subsequence as implemented at LBNL B33 AHU-1 and 2.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 10, Milica Grahovac<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}}),
                        graphics={
        Rectangle(
          extent={{-176,116},{-14,4}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-158,18},{-102,6}},
          lineColor={0,0,127},
          textString="Supply fan is off - disable control"),
        Rectangle(
          extent={{-176,-4},{-14,-116}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-160,-102},{-96,-114}},
          lineColor={0,0,127},
          textString="TOut is above cuttoff - disable control"),
        Rectangle(
          extent={{14,116},{176,4}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{22,22},{116,2}},
          lineColor={0,0,127},
          textString="Normal operation above the lower limit TSup range."),
        Rectangle(
          extent={{14,-4},{176,-116}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{22,-100},{102,-114}},
          lineColor={0,0,127},
          textString="Operation within the lower limit TSup range.")}));
end HeatingCoilValve_F_TSup_TSupSet_TOut_uSupFan;
