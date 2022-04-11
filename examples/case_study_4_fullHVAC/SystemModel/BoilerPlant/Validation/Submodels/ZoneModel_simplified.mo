within SystemModel.BoilerPlant.Validation.Submodels;
model ZoneModel_simplified
  "Zone model"

  replaceable package MediumW =Buildings.Media.Water
    "Water medium model";

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor zonTem
    "Zone temperature sensor"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QFlo "Power added to zone"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Measured zone temperature"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    m_flow_nominal=mRad_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    T_a_nominal=TRadSup_nominal,
    T_b_nominal=TRadRet_nominal,
    TAir_nominal=TAir_nominal,
    dp_nominal=0) "Radiator"
    annotation (Placement(transformation(extent={{-10,-160},{10,-140}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(
    C=zonTheCap)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal = 4359751.36
    "Nominal heat flow rate of radiator"
    annotation(Dialog(group="Radiator"));

  parameter Modelica.Units.SI.Temperature TRadSup_nominal = 273.15+70
    "Radiator nominal supply water temperature"
    annotation(Dialog(group="Radiator"));

  parameter Modelica.Units.SI.Temperature TRadRet_nominal = 273.15+50
    "Radiator nominal return water temperature"
    annotation(Dialog(group="Radiator"));

  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal=0.000604*1000
    "Radiator nominal mass flow rate"
    annotation(Dialog(group="Radiator"));

  parameter Modelica.Units.SI.Volume V=1200
    "Room volume"
    annotation(Dialog(group="Zone"));

  parameter Real zonTheCap(
    final unit="J/K",
    displayUnit="J/K",
    final quantity="HeatCapacity") = 2*V*1.2*1500+V*1.2*1006
    "Zone thermal capacitance"
    annotation(Dialog(group="Zone"));

  parameter Modelica.Units.SI.Temperature TAir_nominal=273.15 + 23.9
    "Air temperature at nominal condition"
    annotation(Dialog(group="Zone"));

  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal = V*1.2*6/3600
    "Nominal mass flow rate"
    annotation(Dialog(group="Zone"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = MediumW) "HHW inlet port"
                 annotation (Placement(transformation(extent={{-50,-210},{-30,
            -190}}), iconTransformation(extent={{-50,-110},{-30,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = MediumW) "HHW outlet port"
                 annotation (Placement(transformation(extent={{30,-210},{50,
            -190}}), iconTransformation(extent={{30,-110},{50,-90}})));
equation
  connect(zonTem.T, TZon)
    annotation (Line(points={{177,0},{220,0}}, color={0,0,127}));
  connect(QFlo, preHea.Q_flow)
    annotation (Line(points={{-220,0},{-100,0}}, color={0,0,127}));
  connect(port_a, rad.port_a) annotation (Line(points={{-40,-200},{-40,-150},{-10,
          -150}}, color={0,127,255}));
  connect(port_b, rad.port_b) annotation (Line(points={{40,-200},{40,-150},{10,-150}},
        color={0,127,255}));
  connect(zonTem.port, heaCap.port) annotation (Line(points={{160,0},{0,0}},
                        color={191,0,0}));
  connect(preHea.port, heaCap.port)
    annotation (Line(points={{-80,0},{0,0}}, color={191,0,0}));
  connect(rad.heatPortCon, heaCap.port)
    annotation (Line(points={{-2,-142.8},{-2,0},{0,0}}, color={191,0,0}));
  connect(rad.heatPortRad, heaCap.port)
    annotation (Line(points={{2,-142.8},{2,0},{0,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-200},{200,200}})));
end ZoneModel_simplified;
