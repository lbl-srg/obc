within ChillerPlant.ClosedLoop1711.BaseClasses.Controls;
model CondenserWaterReset "Tower fan and CW pump speed control with reset"

  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal = 1
   "Nominal mass flow rate at fan";

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowFanSpeSet
    "Cooling tower fan speed set-point"
    annotation (Placement(transformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mConWatPumSet_flow
    "Condenser water pump mass flow set-point"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller
    heaPreCon(have_HeaPreConSig=false, have_WSE=true)
    annotation (Placement(transformation(extent={{12,-58},{32,-38}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.ControlLoop
    chiHeaPreLoo
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaPreEna
    "Status of head pressure control: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller
    enaWSE(
    have_HeaPreConSig=false,
    have_WSE=true,
    fixSpePum=true)
           "Head pressure for plant with waterside economizer that is enabled"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
equation
  connect(mConWatPumSet_flow, mConWatPumSet_flow)
    annotation (Line(points={{120,-50},{120,-50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200}),
          Text(
          extent={{-82,88},{84,-66}},
          lineColor={28,108,200},
          textString="Base
CW")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end CondenserWaterReset;
