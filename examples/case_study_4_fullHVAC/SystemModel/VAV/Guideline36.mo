within SystemModel.VAV;
model Guideline36
  "Variable air volume flow system with terminal reheat that serves five thermal zones"
  extends Buildings.Examples.VAVReheat.BaseClasses.Guideline36(
    mCor_flow_nominal=ACHCor*VRooCor*conv,
    mSou_flow_nominal=ACHSou*VRooSou*conv,
    mEas_flow_nominal=ACHEas*VRooEas*conv,
    mNor_flow_nominal=ACHNor*VRooNor*conv,
    mWes_flow_nominal=ACHWes*VRooWes*conv,
    m_flow_nominal=0.7*(ACHCor*VRooCor + ACHSou*VRooSou +
        ACHEas*VRooEas + ACHNor*VRooNor + ACHWes*VRooWes)*conv);

  parameter Real ACHCor(final unit="1/h")=6
    "Design air change per hour core";
  parameter Real ACHSou(final unit="1/h")=6
    "Design air change per hour south";
  parameter Real ACHEas(final unit="1/h")=9
    "Design air change per hour east";
  parameter Real ACHNor(final unit="1/h")=6
    "Design air change per hour north";
  parameter Real ACHWes(final unit="1/h")=7
    "Design air change per hour west";

  annotation (
    Documentation(info="<html>
<p>
Model of a VAV system.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
</p>
</html>", revisions="<html>
<ul>
<li>
October 7, 2021, by Michael Wetter:<br/>
First implementation
</li>
</ul>
</html>"));

end Guideline36;
