within SystemModel;
record SizingParameters "Record with sizing parameters"
  extends Modelica.Icons.Record;

  /* The order of the zones is deduced from the connection between the VAV model
  and the room model. The mapping from the Modelica array to the Modelica zone name,
  and the EnergyPlus zone name, is:
  1: Sou ZN1
  2: Eas ZN2
  3: Nor ZN3
  4: Wes NZ4
  5: Cor Core
  */

    final parameter Modelica.SIunits.MassFlowRate mVAV_flow_nominal[5]=
    1.2 * {
      0.828676, 0.777205, 0.566641, 0.766349, 2.11}
      "Air terminal box design air flow rates, from HVAC_sizing_parameter.xlsx";

  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    1.2 * 4.32
      "System design air flow rate, from HVAC_sizing_parameter.xlsx";

  final parameter Modelica.SIunits.HeatFlowRate QVAVHea_flow_nominal[5]=
    {12929, 8391, 12756, 8506, 24102}
    "Design heat flow rate of VAV terminal boxes, from HVAC_sizing_parameter.xlsx";

  final parameter Modelica.SIunits.MassFlowRate mVAVHea_flow_nominal[5]=
    1.2 * {0.2486, 0.2332, 0.17, 0.2299, 0.739}
    "Design air flow rate of VAV terminal boxes for heating, from HVAC_sizing_parameter.xlsx";


  final parameter Modelica.SIunits.MassFlowRate mVAVCoo_flow_nominal[5]=
    1.2 * {0.8287, 0.7772, 0.5666, 0.7663, 2.112}
    "Design air flow rate of VAV terminal boxes for heating, from HVAC_sizing_parameter.xlsx";

  parameter Modelica.SIunits.Temperature THotWatInl_nominal(
    displayUnit="degC")= 45 + 273.15
    "Reheat coil nominal inlet water temperature";
    annotation (
    defaultComponentName = "sizDat",
    defaultComponentPrefix="parameter");
end SizingParameters;
