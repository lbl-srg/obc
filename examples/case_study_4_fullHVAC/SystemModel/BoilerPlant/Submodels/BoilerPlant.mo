within SystemModel.BoilerPlant.Submodels;
model BoilerPlant "Boiler plant model for closed loop testing"
  replaceable package MediumA =
      Buildings.Media.Air;

  replaceable package MediumW =
      Buildings.Media.Water
    "Medium model";

  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal = V*1.2*6/3600
    "Nominal mass flow rate"
    annotation(dialog(group="Zone parameters"));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal = boiEff1[1]*boiCap1 + boiEff2[1]*boiCap2
    "Nominal heat flow rate of radiator"
    annotation(dialog(group="Radiator parameters"));

  parameter Modelica.Units.SI.HeatFlowRate boiCap1= 2200000
    "Boiler capacity for boiler-1"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.HeatFlowRate boiCap2= 2200000
    "Boiler capacity for boiler-2"
    annotation(dialog(group="Boiler parameters"));

  parameter Real boiEff1[6](
    final unit="1",
    displayUnit="1") = {0.6246, 0.7711, -1.2077*10e-15, 0.008576, -0.005933, 0.003156}
    "Efficiency for boiler-1"
    annotation(dialog(group="Boiler parameters"));

  parameter Real boiEff2[6](
    final unit="1",
    displayUnit="1") = {0.6246, 0.7711, -1.2077*10e-15, 0.008576, -0.005933, 0.003156}
    "Efficiency for boiler-2"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.Temperature TRadSup_nominal = 273.15+70
    "Radiator nominal supply water temperature"
    annotation(dialog(group="Radiator parameters"));

  parameter Modelica.Units.SI.Temperature TRadRet_nominal = 273.15+50
    "Radiator nominal return water temperature"
    annotation(dialog(group="Radiator parameters"));

  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal=0.113 * 1000
    "Radiator nominal mass flow rate"
    annotation(dialog(group="Radiator parameters"));

  parameter Modelica.Units.SI.Temperature TBoiSup_nominal = 273.15+70
    "Boiler nominal supply water temperature"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.Temperature TBoiRet_min = 273.15+60
    "Boiler minimum return water temperature"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.MassFlowRate mBoi_flow_nominal1=mRad_flow_nominal
    "Boiler-1 nominal mass flow rate"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.MassFlowRate mBoi_flow_nominal2=mRad_flow_nominal
    "Boiler-2 nominal mass flow rate"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.Volume V=126016.35
    "Room volume"
    annotation(dialog(group="Zone parameters"));

  parameter Modelica.Units.SI.Temperature TAir_nominal=273.15 + 23.9
    "Air temperature at nominal condition"
    annotation(dialog(group="Zone parameters"));

  parameter Real zonTheCap(
    final unit="J/K",
    displayUnit="J/K",
    final quantity="HeatCapacity") = 2*V*1.2*1500
    "Zone thermal capacitance"
    annotation(dialog(group="Zone parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiSta[2]
    "Boiler status signal"
    annotation (Placement(transformation(extent={{-360,140},{-320,180}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumSta[1]
    "Pump status signal"
    annotation (Placement(transformation(extent={{-360,20},{-320,60}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotIsoVal[2](
    final unit="1",
    displayUnit="1")
    "Hot water isolation valve signal"
    annotation (Placement(transformation(extent={{-360,60},{-320,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    displayUnit="1")
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-360,-20},{-320,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBypValSig(
    final unit="1",
    displayUnit="1")
    "Bypass valve signal"
    annotation (Placement(transformation(extent={{-360,-60},{-320,-20}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Measured supply temperature"
    annotation (Placement(transformation(extent={{320,80},{360,120}}),
      iconTransformation(extent={{100,70},{140,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured return temperature"
    annotation (Placement(transformation(extent={{320,40},{360,80}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatDp[1](
    final unit="Pa",
    displayUnit="Pa")
    "Hot water differential pressure between supply and return"
    annotation (Placement(transformation(extent={{320,-10},{360,30}}),
      iconTransformation(extent={{100,10},{140,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VHotWat_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured flowrate in primary circuit"
    annotation (Placement(transformation(extent={{320,-50},{360,-10}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mBoi_flow_nominal1,
    final dp_nominal=dpFixed_nominal_value,
    final Q_flow_nominal=boiCap1,
    final T_nominal=TBoiSup_nominal,
    final effCur=Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear,
    final a=boiEff1,
    final fue=Buildings.Fluid.Data.Fuels.NaturalGasHigherHeatingValue(),
    final UA=boiCap1/39.81) "Boiler-2"
    annotation (Placement(transformation(extent={{110,-160},{90,-140}})));

  Buildings.Fluid.Sources.Boundary_pT preSou(
    redeclare package Medium = MediumW,
    p=100000,
    nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{18,-78},{-2,-58}})));

  Buildings.Fluid.Boilers.BoilerPolynomial           boi1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mBoi_flow_nominal2,
    final dp_nominal=dpFixed_nominal_value,
    final Q_flow_nominal=boiCap2,
    final T_nominal=TBoiSup_nominal,
    final effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    final a=boiEff2,
    final fue=Buildings.Fluid.Data.Fuels.HeatingOilLowerHeatingValue(),
    final UA=boiCap2/39.81) "Boiler-1"
    annotation (Placement(transformation(extent={{110,-220},{90,-200}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Buildings.Media.Water,
    final allowFlowReversal=true,
    m_flow_nominal=mRad_flow_nominal,
    redeclare Buildings.Fluid.Movers.Data.Generic
                                        per,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=false,
    final riseTime=60,
    dp_nominal=75000)
    "Hot water primary pump-1"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-70})));

  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi_flow_nominal2,-mRad_flow_nominal,mBoi_flow_nominal1},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-150})));

  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mRad_flow_nominal,-mRad_flow_nominal,-mRad_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,40})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = Buildings.Media.Water,
    final m_flow_nominal=mRad_flow_nominal,
    final dpValve_nominal=dpValve_nominal_value,
    dpFixed_nominal=dpFixed_nominal_value)
    "Minimum flow bypass valve"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));

  Buildings.Fluid.FixedResistances.Junction spl5(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mRad_flow_nominal,mRad_flow_nominal,-mRad_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=270,
      origin={210,40})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = Buildings.Media.Water,
    final m_flow_nominal=mBoi_flow_nominal1,
    final dpValve_nominal=dpValve_nominal_value,
    use_inputFilter=true,
    init=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    dpFixed_nominal=dpFixed_nominal_value) "Isolation valve for boiler-1"
    annotation (Placement(transformation(extent={{0,-220},{20,-200}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium = Buildings.Media.Water,
    final m_flow_nominal=mBoi_flow_nominal2,
    final dpValve_nominal=dpValve_nominal_value,
    init=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    dpFixed_nominal=dpFixed_nominal_value) "Isolation valve for boiler-2"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro "Element-wise product"
    annotation (Placement(transformation(extent={{-210,-20},{-190,0}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[2]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare package Medium = Buildings.Media.Water)
    "Differential pressure sensor between hot water supply and return"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo(
    redeclare package Medium = Buildings.Media.Water,
    final m_flow_nominal=mRad_flow_nominal/1000)
    "Volume flow-rate through primary circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=90,
        origin={-30,-10})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Buildings.Media.Water,
                     m_flow_nominal=mRad_flow_nominal)
    "HW supply temperature sensor"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium =
        Buildings.Media.Water,
                     m_flow_nominal=mRad_flow_nominal)
    "HW return temperature sensor"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(nout=1)
    "Real replicator"
    annotation (Placement(transformation(extent={{280,0},{300,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoiSta[2]
    "Boiler status signal" annotation (Placement(transformation(extent={{320,-90},
            {360,-50}}), iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(uLow=0.09, uHigh=0.1)
    "Check if pumps are on"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(t=0)
    "Check time for which pump status is on"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumSta[1]
    "Pump status signal" annotation (Placement(transformation(extent={{320,-130},
            {360,-90}}), iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatIsoVal[2]
    "Measured boiler hot water isolation valve position" annotation (Placement(
        transformation(extent={{320,-170},{360,-130}}), iconTransformation(
          extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Hold pump enable status until change process is completed"
    annotation (Placement(transformation(extent={{-300,30},{-280,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Switch to signal from controller once enabling process has been completed"
    annotation (Placement(transformation(extent={{-260,30},{-240,50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre "Logical pre block"
    annotation (Placement(transformation(extent={{240,-140},{260,-120}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem2(redeclare package Medium =
        Buildings.Media.Water, m_flow_nominal=mBoi_flow_nominal1)
    "Boiler-2 HW supply temperature sensor"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem3(redeclare package Medium =
        Buildings.Media.Water, m_flow_nominal=mBoi_flow_nominal2)
    "Boiler-1 HW supply temperature sensor"
    annotation (Placement(transformation(extent={{60,-220},{80,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[2]
    "Switch to signal from controller once enabling process has been completed"
    annotation (Placement(transformation(extent={{-210,150},{-190,170}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1[2]
    "Hold boiler enable status until boiler is proven on"
    annotation (Placement(transformation(extent={{-260,150},{-240,170}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2] "Logical pre block"
    annotation (Placement(transformation(extent={{-300,180},{-280,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBoiHotWatSupSet[2](
    final unit=fill("K", 2),
    displayUnit=fill("degC", 2),
    final quantity=fill("ThermodynamicTemperature", 2))
    "Boiler hot water supply temperature setpoint vector" annotation (Placement(
        transformation(extent={{-360,-150},{-320,-110}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID[2](
    controllerType=fill(Buildings.Controls.OBC.CDL.Types.SimpleController.PI, 2),
    k=fill(10e-3, 2),
    Ti=fill(90, 2),
    yMax=fill(1, 2),
    yMin=fill(0.01, 2),
    xi_start=fill(1, 2))
    "PI controller for regulating hot water supply temperature from boiler"
    annotation (Placement(transformation(extent={{-240,-120},{-220,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro1[2]
    "Product of boiler power and current status"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1[2](k1=fill(-1, 2))
    "Find difference between setpoint and measured temperature"
    annotation (Placement(transformation(extent={{-290,-170},{-270,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi[2]
    "Switch to PI control of part load ratio when supply temperature setpoint is achieved"
    annotation (Placement(transformation(extent={{-90,-170},{-70,-150}})));
  Buildings.Fluid.FixedResistances.Junction spl6(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={-mBoi_flow_nominal1,mRad_flow_nominal,-
        mBoi_flow_nominal2},
    final dp_nominal={0,0,0}) "Splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-150})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[2](h=fill(0.3,
        2)) "Check if supply temperature setpoint is met"
    annotation (Placement(transformation(extent={{-260,-170},{-240,-150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(nout=2)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre1(redeclare package Medium =
        Buildings.Media.Water)
    "Differential pressure sensor between hot water supply and return"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-10})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumW) "HW inlet port"
                 annotation (Placement(transformation(extent={{30,230},{50,250}}),
                     iconTransformation(extent={{60,88},{80,108}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumW) "HW outlet port"
                 annotation (Placement(transformation(extent={{-50,230},{-30,250}}),
                     iconTransformation(extent={{-76,88},{-56,108}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBypValPos(final unit="1",
      displayUnit="1") "Measured bypass valve position" annotation (Placement(
        transformation(extent={{320,130},{360,170}}), iconTransformation(extent=
           {{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr[2](t=fill(0.01, 2))
    "Determine if boilers are proven on"
    annotation (Placement(transformation(extent={{182,-130},{202,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2] "Logical pre block"
    annotation (Placement(transformation(extent={{240,-100},{260,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2[2] "Latch"
    annotation (Placement(transformation(extent={{280,-80},{300,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro2[2]
    "Product of boiler enable status and supply temperature setpoint"
    annotation (Placement(transformation(extent={{-280,-120},{-260,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3
    "Hold boiler part load signal at 1 until supply temperature setpoint is achieved"
    annotation (Placement(transformation(extent={{-190,-170},{-170,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg[2]
    "Trigger boiler enable process to meet required supply temperature setpoint"
    annotation (Placement(transformation(extent={{-280,110},{-260,130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(nin=2) "Multi-Or"
    annotation (Placement(transformation(extent={{-240,110},{-220,130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(nin=2) "Multi And"
    annotation (Placement(transformation(extent={{-230,-170},{-210,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2[2](t=fill(
        273.15 + 95, 2))
    "Check if supply temperature has exceeded safe operation limit"
    annotation (Placement(transformation(extent={{-230,-214},{-210,-194}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nin=2) "Multi Or"
    annotation (Placement(transformation(extent={{-200,-214},{-180,-194}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "End boiler part load hold when supply temperature setpoint is achieved or if supply temperature exceeds safe operation limit"
    annotation (Placement(transformation(extent={{-160,-214},{-140,-194}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe(
    redeclare package Medium = MediumW,
    nParallel=1,
    length=2000,
    isCircular=true,
    diameter=0.0762,
    height_ab=0.0102,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow,
    T_start=293.15,
    nNodes=2,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer,
    flowModel(dp_nominal(displayUnit="Pa") = 50000,
                              m_flow_nominal=mRad_flow_nominal),
    heatTransfer(alpha0=15*1/0.3))
    "Dynamic pipe element to represent duct loss"
    annotation (Placement(transformation(extent={{208,-8},{228,12}}, rotation=-90,
        origin={208,228})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Zone air temperature"
    annotation (Placement(transformation(extent={{-360,-90},{-320,-50}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut1
    "Outside temperature"
    annotation (Placement(transformation(extent={{-280,-80},{-260,-60}})));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal_value=6000
    "Nominal pressure drop of fully open valve, used if CvData=Buildings.Fluid.Types.CvTypes.OpPoint";
  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal_value=1000
    "Pressure drop of pipe and other resistances that are in series";
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(nout=1)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{280,-120},{300,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=mRad_flow_nominal)
    "Convert normalized pump speed to mass flow rate"
    annotation (Placement(transformation(extent={{-114,-20},{-94,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=1/mRad_flow_nominal)
    "Convert mass flow rate back to normalized speed"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr3[2](t=fill(0.02,
        2))
    annotation (Placement(transformation(extent={{180,-200},{200,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre3[2] "Logical pre block"
    annotation (Placement(transformation(extent={{220,-200},{240,-180}})));

  inner Modelica.Fluid.System system "System model"
    annotation (Placement(transformation(extent={{-100,180},{-80,200}})));
equation
  connect(spl4.port_3, val.port_a)
    annotation (Line(points={{-20,40},{80,40}},     color={0,127,255}));
  connect(val.port_b, spl5.port_3)
    annotation (Line(points={{100,40},{200,40}},  color={0,127,255}));
  connect(val2.port_a, spl1.port_3)
    annotation (Line(points={{0,-150},{-20,-150}},    color={0,127,255}));
  connect(val1.port_a, spl1.port_1) annotation (Line(points={{0,-210},{-30,-210},
          {-30,-160}},        color={0,127,255}));

  connect(spl4.port_2, senRelPre.port_a) annotation (Line(points={{-30,50},{-30,
          80},{80,80}},    color={0,127,255}));

  connect(senRelPre.port_b, spl5.port_1) annotation (Line(points={{100,80},{210,
          80},{210,50}},   color={0,127,255}));

  connect(senVolFlo.port_b, spl4.port_1) annotation (Line(points={{-30,0},{-30,30}},
                                                     color={0,127,255}));

  connect(senVolFlo.V_flow, VHotWat_flow) annotation (Line(points={{-41,-10},{-41,
          16},{80,16},{80,-30},{340,-30}},         color={0,0,127}));

  connect(spl4.port_2, senTem.port_a) annotation (Line(points={{-30,50},{-30,120},
          {-20,120}},       color={0,127,255}));

  connect(senTem.T, ySupTem) annotation (Line(points={{-10,131},{-10,140},{270,
          140},{270,100},{340,100}},                color={0,0,127}));

  connect(senTem1.port_b, spl5.port_1) annotation (Line(points={{200,120},{210,
          120},{210,50}},  color={0,127,255}));

  connect(senTem1.T, yRetTem) annotation (Line(points={{190,131},{190,134},{260,
          134},{260,60},{340,60}},
                                color={0,0,127}));

  connect(reaRep.y, yHotWatDp)
    annotation (Line(points={{302,10},{340,10}},     color={0,0,127}));

  connect(senRelPre.p_rel, reaRep.u) annotation (Line(points={{90,71},{90,66},{240,
          66},{240,10},{278,10}},           color={0,0,127}));

  connect(hys2.y, tim1.u)
    annotation (Line(points={{122,-10},{138,-10}}, color={255,0,255}));
  connect(yHotWatIsoVal[1], val1.y_actual) annotation (Line(points={{340,-160},
          {280,-160},{280,-174},{30,-174},{30,-203},{15,-203}},color={0,0,127}));
  connect(yHotWatIsoVal[2], val2.y_actual) annotation (Line(points={{340,-140},
          {280,-140},{280,-174},{30,-174},{30,-143},{15,-143}},color={0,0,127}));
  connect(lat.y, logSwi.u2)
    annotation (Line(points={{-278,40},{-262,40}}, color={255,0,255}));
  connect(lat.y, logSwi.u1) annotation (Line(points={{-278,40},{-270,40},{-270,
          48},{-262,48}}, color={255,0,255}));
  connect(tim1.passed, pre.u) annotation (Line(points={{162,-18},{230,-18},{230,
          -130},{238,-130}}, color={255,0,255}));
  connect(pre.y, lat.clr) annotation (Line(points={{262,-130},{272,-130},{272,
          -220},{-314,-220},{-314,34},{-302,34}}, color={255,0,255}));
  connect(senTem2.port_b, boi.port_b)
    annotation (Line(points={{80,-150},{90,-150}}, color={0,127,255}));
  connect(senTem3.port_b, boi1.port_b)
    annotation (Line(points={{80,-210},{90,-210}}, color={0,127,255}));
  connect(uBoiSta, lat1.u)
    annotation (Line(points={{-340,160},{-262,160}}, color={255,0,255}));
  connect(lat1.y, logSwi1.u2)
    annotation (Line(points={{-238,160},{-212,160}}, color={255,0,255}));
  connect(logSwi1.y, booToRea1.u)
    annotation (Line(points={{-188,160},{-162,160}}, color={255,0,255}));
  connect(uBoiSta, logSwi1.u3) annotation (Line(points={{-340,160},{-310,160},{
          -310,140},{-220,140},{-220,152},{-212,152}}, color={255,0,255}));
  connect(lat1.y, logSwi1.u1) annotation (Line(points={{-238,160},{-220,160},{
          -220,168},{-212,168}}, color={255,0,255}));
  connect(pre1.y, lat1.clr) annotation (Line(points={{-278,190},{-270,190},{
          -270,154},{-262,154}}, color={255,0,255}));
  connect(senTem3.T, conPID[1].u_m) annotation (Line(points={{70,-199},{70,-188},
          {-308,-188},{-308,-126},{-230,-126},{-230,-122}},
                                              color={0,0,127}));
  connect(senTem2.T, conPID[2].u_m) annotation (Line(points={{70,-139},{70,-126},
          {-230,-126},{-230,-122}}, color={0,0,127}));
  connect(conPID.y, pro1.u2) annotation (Line(points={{-218,-110},{-160,-110},{
          -160,-116},{-122,-116}},
                              color={0,0,127}));
  connect(booToRea1.y, pro1.u1) annotation (Line(points={{-138,160},{-130,160},
          {-130,-104},{-122,-104}},color={0,0,127}));
  connect(senTem3.T, add1[1].u2) annotation (Line(points={{70,-199},{70,-188},{
          -308,-188},{-308,-166},{-292,-166}},        color={0,0,127}));
  connect(senTem2.T, add1[2].u2) annotation (Line(points={{70,-139},{70,-126},{
          -308,-126},{-308,-166},{-292,-166}},
                                          color={0,0,127}));
  connect(boi.port_a, spl6.port_1)
    annotation (Line(points={{110,-150},{140,-150}}, color={0,127,255}));
  connect(boi1.port_a, spl6.port_3) annotation (Line(points={{110,-210},{150,
          -210},{150,-160}}, color={0,127,255}));
  connect(pro1.y, swi.u3) annotation (Line(points={{-98,-110},{-96,-110},{-96,
          -168},{-92,-168}}, color={0,0,127}));
  connect(booToRea1.y, swi.u1) annotation (Line(points={{-138,160},{-130,160},{
          -130,-152},{-92,-152}}, color={0,0,127}));
  connect(add1.y, greThr.u)
    annotation (Line(points={{-268,-160},{-262,-160}}, color={0,0,127}));
  connect(booRep.y, swi.u2)
    annotation (Line(points={{-138,-160},{-92,-160}}, color={255,0,255}));
  connect(swi[1].y, boi1.y) annotation (Line(points={{-68,-160},{-60,-160},{-60,
          -120},{120,-120},{120,-202},{112,-202}}, color={0,0,127}));
  connect(swi[2].y, boi.y) annotation (Line(points={{-68,-160},{-60,-160},{-60,
          -120},{120,-120},{120,-142},{112,-142}}, color={0,0,127}));
  connect(senTem1.port_a, port_a)
    annotation (Line(points={{180,120},{40,120},{40,240}}, color={0,127,255}));
  connect(val.y_actual, yBypValPos) annotation (Line(points={{95,47},{120,47},{120,
          150},{340,150}}, color={0,0,127}));
  connect(senTem2.port_a, val2.port_b)
    annotation (Line(points={{60,-150},{20,-150}}, color={0,127,255}));
  connect(senTem3.port_a, val1.port_b)
    annotation (Line(points={{60,-210},{20,-210}}, color={0,127,255}));
  connect(swi.y, lesThr.u) annotation (Line(points={{-68,-160},{-60,-160},{-60,
          -120},{180,-120}}, color={0,0,127}));
  connect(pre2.y, lat2.clr) annotation (Line(points={{262,-90},{270,-90},{270,
          -76},{278,-76}}, color={255,0,255}));
  connect(lat2.y, yBoiSta)
    annotation (Line(points={{302,-70},{340,-70}}, color={255,0,255}));
  connect(lat2.y, pre1.u) annotation (Line(points={{302,-70},{310,-70},{310,220},
          {-310,220},{-310,190},{-302,190}}, color={255,0,255}));
  connect(lesThr.y, pre2.u) annotation (Line(points={{204,-120},{220,-120},{220,
          -90},{238,-90}}, color={255,0,255}));
  connect(TBoiHotWatSupSet, pro2.u2) annotation (Line(points={{-340,-130},{-300,
          -130},{-300,-116},{-282,-116}}, color={0,0,127}));
  connect(pro2.y, conPID.u_s)
    annotation (Line(points={{-258,-110},{-242,-110}}, color={0,0,127}));
  connect(booToRea1.y, pro2.u1) annotation (Line(points={{-138,160},{-130,160},
          {-130,-90},{-300,-90},{-300,-104},{-282,-104}}, color={0,0,127}));
  connect(booRep.u, lat3.y)
    annotation (Line(points={{-162,-160},{-168,-160}}, color={255,0,255}));
  connect(uBoiSta, edg.u) annotation (Line(points={{-340,160},{-310,160},{-310,
          120},{-282,120}}, color={255,0,255}));
  connect(mulOr1.y, lat3.u) annotation (Line(points={{-218,120},{-180,120},{
          -180,-140},{-196,-140},{-196,-160},{-192,-160}}, color={255,0,255}));
  connect(senTem3.T, greThr2[1].u) annotation (Line(points={{70,-199},{70,-188},
          {-240,-188},{-240,-204},{-232,-204}}, color={0,0,127}));
  connect(senTem2.T, greThr2[2].u) annotation (Line(points={{70,-139},{70,-126},
          {-308,-126},{-308,-188},{-240,-188},{-240,-204},{-232,-204}}, color={
          0,0,127}));
  connect(mulOr.y, or2.u1)
    annotation (Line(points={{-178,-204},{-162,-204}}, color={255,0,255}));
  connect(mulAnd.y, or2.u2) annotation (Line(points={{-208,-160},{-204,-160},{
          -204,-184},{-170,-184},{-170,-212},{-162,-212}}, color={255,0,255}));
  connect(or2.y, lat3.clr) annotation (Line(points={{-138,-204},{-130,-204},{
          -130,-180},{-196,-180},{-196,-166},{-192,-166}}, color={255,0,255}));
  connect(pro2.y, add1.u1) annotation (Line(points={{-258,-110},{-250,-110},{
          -250,-140},{-300,-140},{-300,-154},{-292,-154}}, color={0,0,127}));
  connect(spl5.port_2, pipe.port_a)
    annotation (Line(points={{210,30},{210,20}}, color={0,127,255}));
  connect(pipe.port_b, spl6.port_2) annotation (Line(points={{210,0},{210,-150},
          {160,-150}}, color={0,127,255}));
  connect(TZon, TOut1.T)
    annotation (Line(points={{-340,-70},{-282,-70}}, color={0,0,127}));
  connect(TOut1.port, pipe.heatPorts[1]) annotation (Line(points={{-260,-70},{
          -150,-70},{-150,96},{226,96},{226,11.45},{214.4,11.45}}, color={191,0,
          0}));
  connect(TOut1.port, pipe.heatPorts[2]) annotation (Line(points={{-260,-70},{
          -150,-70},{-150,96},{226,96},{226,8.35},{214.4,8.35}}, color={191,0,0}));
  connect(pum.port_b, senVolFlo.port_a)
    annotation (Line(points={{-30,-60},{-30,-20}}, color={0,127,255}));
  connect(senRelPre1.port_a, spl1.port_2) annotation (Line(points={{-70,-20},{-70,
          -140},{-30,-140}}, color={0,127,255}));
  connect(senRelPre1.port_b, spl4.port_1)
    annotation (Line(points={{-70,0},{-70,30},{-30,30}}, color={0,127,255}));
  connect(booRep1.y, yPumSta)
    annotation (Line(points={{302,-110},{340,-110}}, color={255,0,255}));
  connect(tim1.passed, booRep1.u) annotation (Line(points={{162,-18},{230,-18},{
          230,-110},{278,-110}}, color={255,0,255}));
  connect(booToRea.y, pro.u1) annotation (Line(points={{-198,40},{-190,40},{-190,
          20},{-220,20},{-220,-4},{-212,-4}}, color={0,0,127}));
  connect(uPumSpe, pro.u2) annotation (Line(points={{-340,0},{-240,0},{-240,-16},
          {-212,-16}}, color={0,0,127}));
  connect(uPumSta[1], logSwi.u3) annotation (Line(points={{-340,40},{-308,40},{-308,
          20},{-270,20},{-270,32},{-262,32}}, color={255,0,255}));
  connect(uPumSta[1], lat.u)
    annotation (Line(points={{-340,40},{-302,40}}, color={255,0,255}));
  connect(logSwi.y, booToRea.u)
    annotation (Line(points={{-238,40},{-222,40}}, color={255,0,255}));
  connect(uBypValSig, val.y) annotation (Line(points={{-340,-40},{-120,-40},{-120,
          60},{90,60},{90,52}}, color={0,0,127}));
  connect(spl1.port_2, pum.port_a)
    annotation (Line(points={{-30,-140},{-30,-80}}, color={0,127,255}));
  connect(senTem.port_b, port_b) annotation (Line(points={{0,120},{10,120},{10,
          160},{-40,160},{-40,240}}, color={0,127,255}));
  connect(preSou.ports[1], pum.port_a) annotation (Line(points={{-2,-68},{-12,-68},
          {-12,-80},{-30,-80}}, color={0,127,255}));
  connect(pro.y, gai.u)
    annotation (Line(points={{-188,-10},{-116,-10}}, color={0,0,127}));
  connect(gai.y, pum.m_flow_in) annotation (Line(points={{-92,-10},{-88,-10},{
          -88,-70},{-42,-70}}, color={0,0,127}));
  connect(pum.m_flow_actual, gai1.u) annotation (Line(points={{-35,-59},{-35,
          -28},{0,-28},{0,-10},{18,-10}}, color={0,0,127}));
  connect(gai1.y, hys2.u)
    annotation (Line(points={{42,-10},{98,-10}}, color={0,0,127}));
  connect(swi.y, greThr3.u) annotation (Line(points={{-68,-160},{-60,-160},{-60,
          -120},{120,-120},{120,-190},{178,-190}}, color={0,0,127}));
  connect(greThr3.y, pre3.u)
    annotation (Line(points={{202,-190},{218,-190}}, color={255,0,255}));
  connect(pre3.y, lat2.u) annotation (Line(points={{242,-190},{266,-190},{266,
          -70},{278,-70}}, color={255,0,255}));
  connect(uHotIsoVal[1], val1.y) annotation (Line(points={{-340,70},{-52,70},{
          -52,-180},{10,-180},{10,-198}}, color={0,0,127}));
  connect(uHotIsoVal[2], val2.y) annotation (Line(points={{-340,90},{-52,90},{
          -52,-110},{10,-110},{10,-138}}, color={0,0,127}));
  connect(edg.y, mulOr1.u[1:2]) annotation (Line(points={{-258,120},{-250,120},
          {-250,116.5},{-242,116.5}}, color={255,0,255}));
  connect(greThr.y, mulAnd.u[1:2]) annotation (Line(points={{-238,-160},{-236,
          -160},{-236,-163.5},{-232,-163.5}}, color={255,0,255}));
  connect(greThr2.y, mulOr.u[1:2]) annotation (Line(points={{-208,-204},{-206,
          -204},{-206,-207.5},{-202,-207.5}}, color={255,0,255}));
  annotation (defaultComponentName="boiPla",
    Documentation(info="<html>
      <p>
      This model implements a primary-only, condensing boiler plant with headered, 
      variable-speed primary pumps, as defined in ASHRAE RP-1711, March 2020 draft.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      October 28, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-320,-240},{320,240}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-88,160},{112,120}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-40,-18},{40,-98}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-54},{60,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-60},{60,-54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-80},{-12,-98},{14,-98},{0,-80}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(extent={{-80,58},{-50,26}}, lineColor={28,108,200}),
        Polygon(
          points={{-80,40},{-50,40},{-66,58},{-80,40}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-66,-40},{-66,-12}}, color={28,108,200}),
        Line(points={{-66,58},{-66,88}}, color={28,108,200}),
        Line(points={{70,88},{70,-44},{70,-50}}, color={28,108,200}),
        Polygon(points={{-80,26},{-80,26}}, lineColor={28,108,200}),
        Polygon(
          points={{-76,-12},{-54,-12},{-66,0},{-76,-12}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-76,12},{-54,12},{-66,0},{-76,12}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-66,12},{-66,26}}, color={28,108,200}),
        Ellipse(
          extent={{-82,-40},{-52,-72}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Ellipse(
          extent={{56,-38},{86,-70}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}),
    experiment(
      StopTime=10500,
      Interval=60,
      __Dymola_Algorithm="Cvode"));
end BoilerPlant;
