within OBCSequenceValidation;
package Validation "Package with models for the validation of the OBC validation tool sequences"
  extends Modelica.Icons.ExamplesPackage;

  model HeatingCoilValve_TSup_TSupSet_TOut_uSupFan
    "Validation model for a system with heating, cooling and hot water"
    extends Modelica.Icons.Example;


    HeatingCoilValve heaValSta annotation (Placement(transformation(extent={{0,0},{20,20}})));
  equation

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
