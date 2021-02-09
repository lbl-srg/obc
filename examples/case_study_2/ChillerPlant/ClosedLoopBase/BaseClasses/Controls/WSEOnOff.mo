within ChillerPlant.ClosedLoopBase.BaseClasses.Controls;
model WSEOnOff "Water-side economizer status"
  extends Buildings.Examples.ChillerPlant.BaseClasses.Controls.WSEControl;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200}),
          Text(
          extent={{-82,88},{84,-66}},
          lineColor={28,108,200},
          textString="Base
CW")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end WSEOnOff;
