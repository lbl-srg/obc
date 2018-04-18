within OBCSequenceValidation;
package Validation "Package with models for the validation of the OBC validation tool sequences"
  extends Modelica.Icons.ExamplesPackage;

  model HeatingCoilValve_TSup_TSupSet_TOut_uSupFan
    "Validation model for a system with heating, cooling and hot water"
    extends Modelica.Icons.Example;

    OBCSequenceValidation.HeatingCoilValve heaValSta
      "Heating coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"
      annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

    parameter Real TOutHeaCut(
      final unit="K",
      final quantity = "ThermodynamicTemperature") = 293.15
      "Upper outdoor air temperature limit for enabling heating (68 F)";

    parameter Real TSup(
      final unit="K",
      final quantity = "ThermodynamicTemperature") = 289
      "Supply air temperature";

    parameter Real TSupSet(
      final unit="K",
      final quantity = "ThermodynamicTemperature") = 294.261
      "Supply air temperature setpoint";

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutBelowCutoff(final k=TOutHeaCut - 5)
      "Outdoor air temperature is below the cutoff"
      annotation (Placement(transformation(extent={{-220,60},{-200,80}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSup(final k=TSup)
      "Supply air temperature"
      annotation (Placement(transformation(extent={{-260,100},{-240,120}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet(final k=TSupSet)
      "Supply air temperature setpoint"
      annotation (Placement(transformation(extent={{-260,60},{-240,80}})));



    Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=false)
      annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
    HeatingCoilValve                       heaValSta1
      "Heating coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"
      annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutAboveCutoff(final k=TOutHeaCut + 5)
      "Outdoor air temperature is below the cutoff"
      annotation (Placement(transformation(extent={{-220,-60},{-200,-40}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSup1(final k=TSup)
      "Supply air temperature"
      annotation (Placement(transformation(extent={{-260,-18},{-240,2}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet1(final k=TSupSet)
      "Supply air temperature setpoint"
      annotation (Placement(transformation(extent={{-260,-60},{-240,-40}})));
    Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(k=true)
      annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  equation





    connect(heaValSta.TOut, uTOutBelowCutoff.y)
      annotation (Line(points={{-141,113},{-170,113},{-170,70},{-199,70}}, color={0,0,127}));
    connect(con.y, heaValSta.uSupFan)
      annotation (Line(points={{-159,50},{-150,50},{-150,100},{-141,100}}, color={255,0,255}));
    connect(heaValSta1.TOut, uTOutAboveCutoff.y)
      annotation (Line(points={{-141,-7},{-170,-7},{-170,-50},{-199,-50}}, color={0,0,127}));
    connect(con1.y, heaValSta1.uSupFan)
      annotation (Line(points={{-159,-70},{-150,-70},{-150,-20},{-141,-20}}, color={255,0,255}));
  connect(heaValSta1.TSupSet, uTSupSet1.y) annotation (Line(points={{-141,-3},{-190,-3},{-190,-20},
          {-230,-20},{-230,-50},{-239,-50}}, color={0,0,127}));
  connect(heaValSta1.TSup, uTSup1.y)
    annotation (Line(points={{-141,0},{-220,0},{-220,-8},{-239,-8}}, color={0,0,127}));
  connect(heaValSta.TSupSet, uTSupSet.y) annotation (Line(points={{-141,117},{-190,117},{-190,100},
          {-230,100},{-230,70},{-239,70}}, color={0,0,127}));
  connect(heaValSta.TSup, uTSup.y)
    annotation (Line(points={{-141,120},{-220,120},{-220,110},{-239,110}}, color={0,0,127}));
    annotation(experiment(Tolerance=1e-06, StopTime=31536000),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/?/?/?.mos"
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
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-280,-120},{
              140,140}})));
  end HeatingCoilValve_TSup_TSupSet_TOut_uSupFan;

annotation (Documentation(info="<html>
<p>
This package contains models that validate the district heating and cooling models.
The examples plot various outputs, which have been verified against
analytical solutions or by inspecting their change due to parametric changes.
These model outputs are stored as reference data to
allow continuous validation whenever models in the library change.
</p>
</html>"));
end Validation;
