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

  final parameter Modelica.Units.SI.MassFlowRate mVAV_flow_nominal[5]=
    1.2 * {
      1.139, 0.7414, 1.1285, 0.7501, 2.2613}
      "Air terminal box design air flow rates, from HVAC_sizing_parameter.xlsx";

  final parameter Modelica.Units.SI.MassFlowRate mCooAHU_flow_nominal=1.2*4.5202
    "System design air flow rate, from HVAC_sizing_parameter.xlsx";

  final parameter Modelica.Units.SI.MassFlowRate mHeaAHU_flow_nominal=1.2*1.697
    "System design air flow rate, from HVAC_sizing_parameter.xlsx";

  final parameter Modelica.Units.SI.HeatFlowRate QHeaAHU_flow_nominal=
      mHeaAHU_flow_nominal*1006*(THeaDisAHU_nominal-(273.15+4))
    "Design heat flow rate of AHU heating coil";

  final parameter Modelica.Units.SI.MassFlowRate mHeaWatAHU_flow_nominal=0.43899
    "Heating water design flow rate at AHU **** this is the same as xxx, but Dymola fails to evaluate this parameter";

  final parameter Modelica.Units.SI.MassFlowRate xxx=( QHeaAHU_flow_nominal)  /(4200*(THeaWatSup_nominal-THeaWatRet_nominal))
    "Heating water design flow rate at AHU";

  final parameter Modelica.Units.SI.HeatFlowRate QHeaVAV_flow_nominal[5]={
    20395.03, 13248.64, 20127.95, 13414.6, 31889.35}
    "Design heat flow rate of VAV terminal boxes, from HVAC_sizing_parameter.xlsx";

  final parameter Real eps_errorResolution_sizingFactor = 2.2
    "The original VAV heating mode air mass flow rates assigned as per EPlus sizing
    run were resulting in a heating coil efficiency eps > 1. This factor was
    assigned to resolve that simulation error. The same value is assigned as a
    sizing factor at the end of the expression for mHeaVAV_flow_nominal, since
    Dymola was not able to evaluate the expression when this parameter variable
    was used directly.";

  final parameter Modelica.Units.SI.MassFlowRate mHeaVAV_flow_nominal[5]= 1.2*{
    0.2786, 0.1579, 0.3357, 0.1581, 0.7666} * 2.2
    "Design air flow rate of VAV terminal boxes for heating, from HVAC_sizing_parameter.xlsx";

  final parameter Modelica.Units.SI.MassFlowRate mCooVAV_flow_nominal[5]=1.2*
    {1.139, 0.7414, 1.1285, 0.7501, 2.2613}
    "Design air flow rate of VAV terminal boxes for heating, from HVAC_sizing_parameter.xlsx";

  final parameter Modelica.Units.SI.MassFlowRate mMinVAV_flow_nominal[5]=1.2*
    {0.352, 0.1483, 0.4063, 0.15, 0.7666}
    "Minimum air flow rate of VAV terminal boxes, from HVAC_sizing_parameter.xlsx";

  parameter Modelica.Units.SI.Temperature THeaDisAHU_nominal(displayUnit="degC")=
       13 + 273.15 "Maximum heating discharge air temperature at AHU";

  parameter Modelica.Units.SI.Temperature THeaDisVAV_nominal(displayUnit="degC")=
       28 + 273.15 "Maximum heating discharge air temperature for VAV boxes";

  parameter Modelica.Units.SI.Temperature TCooDisVAV_nominal(displayUnit="degC")=
       13 + 273.15 "Minimum cooling discharge air temperature for VAV boxes";

  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal(displayUnit="degC")=
       45 + 273.15
    "Main heating coil and reheat coil nominal inlet water temperature";

  parameter Modelica.Units.SI.Temperature THeaWatRet_nominal(displayUnit="degC")=
       35 + 273.15
    "Main heating coil and reheat coil nominal return water temperature";
    annotation (
    defaultComponentName = "sizDat",
    defaultComponentPrefix="parameter",
    defaultComponentName = "sizDat",
    defaultComponentPrefix="parameter");


end SizingParameters;
