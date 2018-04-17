within OBCSequenceValidation;
package Validation "Package with models for the validation of the OBC validation tool sequences"
  extends Modelica.Icons.ExamplesPackage;

  model HeatingCoilValve_TSup_TSupSet_TOut_uSupFan
    "Validation model for a system with heating, cooling and hot water"
    extends Modelica.Icons.Example;

    OBCSequenceValidation.HeatingCoilValve heaValSta
      "Heating coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"
      annotation (Placement(transformation(extent={{-138,58},{-118,78}})));

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
      annotation (Placement(transformation(extent={{-220,20},{-200,40}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSup(final k=TSup)
      "Supply air temperature"
      annotation (Placement(transformation(extent={{-260,20},{-240,40}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet(final k=TOut)
      "Supply air temperature setpoint"
      annotation (Placement(transformation(extent={{-260,60},{-240,80}})));



  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=false)
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  equation





  connect(heaValSta.TOut, uTOutBelowCutoff.y)
    annotation (Line(points={{-139,71},{-170,71},{-170,30},{-199,30}}, color={0,0,127}));
  connect(heaValSta.TSup, uTSupSet.y)
    annotation (Line(points={{-139,78},{-190,78},{-190,70},{-239,70}}, color={0,0,127}));
  connect(heaValSta.TSupSet, uTSup.y) annotation (Line(points={{-139,75},{-224,75},{-224,74},{-228,
          74},{-228,30},{-239,30}}, color={0,0,127}));
  connect(con.y, heaValSta.uSupFan)
    annotation (Line(points={{-159,130},{-150,130},{-150,58},{-139,58}}, color={255,0,255}));
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
