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

  final parameter Modelica.SIunits.MassFlowRate mCooAHU_flow_nominal=1.2*4.3204
    "System design air flow rate, from HVAC_sizing_parameter.xlsx";

  final parameter Modelica.SIunits.MassFlowRate mHeaAHU_flow_nominal=1.2*1.6207
    "System design air flow rate, from HVAC_sizing_parameter.xlsx";

  final parameter Modelica.SIunits.HeatFlowRate QHeaVAV_flow_nominal[5]={12929,8391,
      12756,8506,24102}
    "Design heat flow rate of VAV terminal boxes, from HVAC_sizing_parameter.xlsx";

  final parameter Modelica.SIunits.HeatFlowRate QHeaAHU_flow_nominal=
      mHeaAHU_flow_nominal*1006*(THeaDisAHU_nominal-(273.15+4))
    "Design heat flow rate of AHU heating coil";

  final parameter Modelica.SIunits.MassFlowRate mHeaVAV_flow_nominal[5]=1.2*{0.2486,
      0.2332,0.17,0.2299,0.739}
    "Design air flow rate of VAV terminal boxes for heating, from HVAC_sizing_parameter.xlsx";


  final parameter Modelica.SIunits.MassFlowRate mCooVAV_flow_nominal[5]=1.2*{0.8287,
      0.7772,0.5666,0.7663,2.112}
    "Design air flow rate of VAV terminal boxes for heating, from HVAC_sizing_parameter.xlsx";

  final parameter Modelica.SIunits.MassFlowRate mMinVAV_flow_nominal[5]=1.2*{0.2486,
      0.2332,0.17,0.2299,0.739}
    "Minimum air flow rate of VAV terminal boxes, from HVAC_sizing_parameter.xlsx";

  parameter Modelica.SIunits.Temperature THeaDisAHU_nominal(displayUnit="degC")=
       13 + 273.15 "Maximum heating discharge air temperature at AHU";

  parameter Modelica.SIunits.Temperature THeaDisVAV_nominal(displayUnit="degC")=
       50 + 273.15 "Maximum heating discharge air temperature for VAV boxes";

  parameter Modelica.SIunits.Temperature TCooDisVAV_nominal(displayUnit="degC")=
       13 + 273.15 "Minimum cooling discharge air temperature for VAV boxes";

  parameter Modelica.SIunits.Temperature THeaWatSup_nominal(displayUnit="degC")=
       45 + 273.15+35
    "Main heating coil and reheat coil nominal inlet water temperature";

  parameter Modelica.SIunits.Temperature THeaWatRet_nominal(displayUnit="degC")=
       35 + 273.15+35
    "Main heating coil and reheat coil nominal return water temperature";
    annotation (
    defaultComponentName = "sizDat",
    defaultComponentPrefix="parameter",
    defaultComponentName = "sizDat",
    defaultComponentPrefix="parameter");


end SizingParameters;
