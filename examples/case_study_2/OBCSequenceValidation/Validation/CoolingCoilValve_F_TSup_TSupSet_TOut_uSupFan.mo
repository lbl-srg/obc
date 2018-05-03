within OBCSequenceValidation.Validation;
model CoolingCoilValve_F_TSup_TSupSet_TOut_uSupFan
  "Validation model for the cooling coil valve control sequence in F"
  extends Modelica.Icons.Example;

  parameter Real TOutCooCut(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 50
    "Lower outdoor air temperature limit for enabling cooling";

  parameter Real TSup(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 65
    "Supply air temperature";

  parameter Real TSupSet(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 60
    "Supply air temperature setpoint";

  parameter Real TSetMinLowLim(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 42
    "Minimum supply air temperature for defining the upper limit of the valve position"
    annotation(Evaluate=true);

  parameter Real TSetMaxLowLim(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 52
    "Maximum supply air temperature for defining the upper limit of the valve position"
    annotation(Evaluate=true);

  parameter Real LowTSupSet(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 47
    "Supply air temeprature setpoint to check the limiter functionality"
    annotation(Evaluate=true);

// Tests disable if supply fan is off
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutAboveCutoff(final k=TOutCooCut + 5)
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
  CoolingCoilValve_F cooValSta_F(genEna=false, revAct=true)
    "Cooling coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

// Tests disable if it is warm outside
  CoolingCoilValve_F cooValSta_F1(genEna=false, revAct=true)
    "Cooling coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutBelowCutoff(final k=TOutCooCut - 5)
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
  CoolingCoilValve_F cooValSta_F2(genEna=false, revAct=true)
    "Cooling coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutAboveCutoff2(final k=TOutCooCut + 5)
    "Outdoor air temperature is above the cutoff"
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
    height=4,
    offset=TSupSet - 1)   "\"Supply air temperature\""
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  CoolingCoilValve_F cooValSta_F3(genEna=false, revAct=true)
    "Cooling coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutAboveCutoff1(final k=TOutCooCut + 5)
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
    offset=TSetMaxLowLim,
    height=TSetMinLowLim - TSetMaxLowLim)
    "Supply air temperature source"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(cooValSta_F.TOut, uTOutAboveCutoff.y)
    annotation (Line(points={{-41,93},{-70,93},{-70,50},{-99,50}}, color={0,0,127}));
  connect(uSupFan.y, cooValSta_F.uSupFan)
    annotation (Line(points={{-59,30},{-50,30},{-50,85},{-41,85}}, color={255,0,255}));
  connect(cooValSta_F1.TOut, uTOutBelowCutoff.y)
    annotation (Line(points={{-41,-27},{-70,-27},{-70,-70},{-99,-70}}, color={0,0,127}));
  connect(uSupFan1.y, cooValSta_F1.uSupFan)
    annotation (Line(points={{-59,-90},{-50,-90},{-50,-35},{-41,-35}}, color={255,0,255}));
  connect(cooValSta_F1.TSupSet, uTSupSet1.y) annotation (Line(points={{-41,-23},{-90,-23},{-90,-40},
          {-130,-40},{-130,-70},{-139,-70}}, color={0,0,127}));
  connect(cooValSta_F1.TSup, uTSup1.y)
    annotation (Line(points={{-41,-20},{-120,-20},{-120,-28},{-139,-28}}, color={0,0,127}));
  connect(cooValSta_F.TSupSet, uTSupSet.y) annotation (Line(points={{-41,97},{-90,97},{-90,80},{-130,
          80},{-130,50},{-139,50}}, color={0,0,127}));
  connect(cooValSta_F.TSup, uTSup.y)
    annotation (Line(points={{-41,100},{-120,100},{-120,90},{-139,90}}, color={0,0,127}));
  connect(cooValSta_F2.TOut, uTOutAboveCutoff2.y) annotation (Line(points={{139,93},{120,93},{100,93},
          {100,80},{100,50},{90,50},{90,50},{81,50}}, color={0,0,127}));
  connect(uSupFan2.y, cooValSta_F2.uSupFan)
    annotation (Line(points={{121,30},{130,30},{130,85},{139,85}}, color={255,0,255}));
  connect(cooValSta_F2.TSupSet, uTSupSet2.y) annotation (Line(points={{139,97},{66,97},{66,96},{66,96},
          {66,80},{50,80},{50,50},{41,50}}, color={0,0,127}));
  connect(cooValSta_F2.TSup, uTSup2.y)
    annotation (Line(points={{139,100},{60,100},{60,90},{41,90}}, color={0,0,127}));
  connect(cooValSta_F3.TOut, uTOutAboveCutoff1.y)
    annotation (Line(points={{139,-27},{110,-27},{110,-70},{81,-70}}, color={0,0,127}));
  connect(uSupFan3.y, cooValSta_F3.uSupFan)
    annotation (Line(points={{121,-90},{130,-90},{130,-35},{139,-35}}, color={255,0,255}));
  connect(cooValSta_F3.TSupSet, uTSupSet3.y) annotation (Line(points={{139,-23},{90,-23},{90,-40},{50,
          -40},{50,-70},{41,-70}}, color={0,0,127}));
  connect(cooValSta_F3.TSup, uTSup3.y)
    annotation (Line(points={{139,-20},{60,-20},{60,-30},{41,-30}}, color={0,0,127}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="CoolingCoilValve_F_TSup_TSupSet_TOut_uSupFan.mos"
    "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates the cooling coil signal subsequence as implemented at LBNL B33 AHU-1 and 2.
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
          textString="Normal operation above the upper limit TSup range."),
        Rectangle(
          extent={{14,-4},{176,-116}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{22,-98},{116,-118}},
          lineColor={0,0,127},
          textString="Operation within the upper limit TSup range.")}));
end CoolingCoilValve_F_TSup_TSupSet_TOut_uSupFan;
