within SystemModel.VAV.BaseClasses;
partial model PartialOpenLoop
  "Partial model of variable air volume flow system with terminal reheat and five thermal zones"

  replaceable package MediumA = Buildings.Media.Air "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water "Medium model for water";

  constant Integer numZon=5 "Total number of served VAV boxes";

  parameter Modelica.SIunits.Volume VRooCor=flo.VRooCor
    "Room volume corridor";
  parameter Modelica.SIunits.Volume VRooSou=flo.VRooSou
    "Room volume south";
  parameter Modelica.SIunits.Volume VRooNor=flo.VRooNor
    "Room volume north";
  parameter Modelica.SIunits.Volume VRooEas=flo.VRooEas
    "Room volume east";
  parameter Modelica.SIunits.Volume VRooWes=flo.VRooWes
    "Room volume west";

  parameter Modelica.SIunits.Area AFloCor=flo.AFloCor "Floor area corridor";
  parameter Modelica.SIunits.Area AFloSou=flo.AFloSou "Floor area south";
  parameter Modelica.SIunits.Area AFloNor=flo.AFloNor "Floor area north";
  parameter Modelica.SIunits.Area AFloEas=flo.AFloEas "Floor area east";
  parameter Modelica.SIunits.Area AFloWes=flo.AFloWes "Floor area west";

  parameter Modelica.SIunits.Area AFlo[numZon]={flo.AFloCor,flo.AFloSou,flo.AFloEas,
      flo.AFloNor,flo.AFloWes} "Floor area of each zone";
  final parameter Modelica.SIunits.Area ATot=sum(AFlo) "Total floor area";

  constant Real conv=1.2/3600 "Conversion factor for nominal mass flow rate";

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

  parameter Modelica.SIunits.MassFlowRate mCor_flow_nominal=ACHCor*VRooCor*conv
    "Design mass flow rate core";
  parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=ACHSou*VRooSou*conv
    "Design mass flow rate south";
  parameter Modelica.SIunits.MassFlowRate mEas_flow_nominal=ACHEas*VRooEas*conv
    "Design mass flow rate east";
  parameter Modelica.SIunits.MassFlowRate mNor_flow_nominal=ACHNor*VRooNor*conv
    "Design mass flow rate north";
  parameter Modelica.SIunits.MassFlowRate mWes_flow_nominal=ACHWes*VRooWes*conv
    "Design mass flow rate west";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.7*(mCor_flow_nominal
       + mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal +
      mWes_flow_nominal) "Nominal mass flow rate";

  parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal=m_flow_nominal*1000*
      (10 - (-20))/4200/10 "Nominal water mass flow rate for heating coil in AHU";
  parameter Modelica.SIunits.MassFlowRate mCooWat_flow_nominal=m_flow_nominal*1000*
      15/4200/10 "Nominal water mass flow rate for cooling coil";

  parameter Real ratVFloHea(final unit="1") = 0.3
    "VAV box maximum air flow rate ratio in heating mode";

  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180 "Latitude";

  parameter Real ratOAFlo_A(final unit="m3/(s.m2)") = 0.3e-3
    "Outdoor airflow rate required per unit area";
  parameter Real ratOAFlo_P = 2.5e-3
    "Outdoor airflow rate required per person";
  parameter Real ratP_A = 5e-2
    "Occupant density";
  parameter Real effZ(final unit="1") = 0.8
    "Zone air distribution effectiveness (limiting value)";
  parameter Real divP(final unit="1") = 0.7
    "Occupant diversity ratio";
  parameter Modelica.SIunits.VolumeFlowRate VCorOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloCor / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate VSouOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloSou / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate VEasOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloEas / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate VNorOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloNor / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate VWesOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloWes / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate Vou_flow_nominal=
    (divP * ratOAFlo_P * ratP_A + ratOAFlo_A) * sum(
      {AFloCor, AFloSou, AFloNor, AFloEas, AFloWes})
    "System uncorrected outdoor air flow rate";
  parameter Real effVen(final unit="1") = if divP < 0.6 then
    0.88 * divP + 0.22 else 0.75
    "System ventilation efficiency";
  parameter Modelica.SIunits.VolumeFlowRate Vot_flow_nominal=
    Vou_flow_nominal / effVen
    "System design outdoor air flow rate";

  parameter Modelica.SIunits.Temperature THeaOn=293.15
    "Heating setpoint during on";
  parameter Modelica.SIunits.Temperature THeaOff=285.15
    "Heating setpoint during off";
  parameter Modelica.SIunits.Temperature TCooOn=297.15
    "Cooling setpoint during on";
  parameter Modelica.SIunits.Temperature TCooOff=303.15
    "Cooling setpoint during off";
  parameter Modelica.SIunits.PressureDifference dpBuiStaSet(min=0) = 12
    "Building static pressure";
  parameter Real yFanMin = 0.1 "Minimum fan speed";

  parameter Modelica.SIunits.Temperature THotWatInl_nominal(
    displayUnit="degC")=55 + 273.15
    "Reheat coil nominal inlet water temperature";

  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Evaluate=true);

  parameter Boolean use_windPressure=true "Set to true to enable wind pressure";

  parameter Boolean sampleModel=true
    "Set to true to time-sample the model, which can give shorter simulation time if there is already time sampling in the system model"
    annotation (Evaluate=true, Dialog(tab=
    "Experimental (may be changed in future releases)"));

  Buildings.Fluid.Sources.Outside amb(redeclare package Medium = MediumA,
      nPorts=2) "Ambient conditions"
    annotation (Placement(transformation(extent={{-136,-56},{-114,-34}})));

  SystemModel.VAV.BaseClasses.Floor flo(
      redeclare final package Medium = MediumA,
      final use_windPressure=use_windPressure)
    "Model of a floor of the building that is served by this VAV system"
    annotation (Placement(transformation(extent={{772,396},{1100,616}})), choicesAllMatching=true);

  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU heaCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mHeaWat_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    show_T=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    Q_flow_nominal=m_flow_nominal*1006*(16.7 - 4),
    dp1_nominal=3000,
    dp2_nominal=200 + 200 + 100 + 40,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal,
    T_a1_nominal=THotWatInl_nominal,
    T_a2_nominal=277.15)
    "Heating coil"
    annotation (Placement(transformation(extent={{118,-36},{98,-56}})));

  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(
    show_T=true,
    UA_nominal=3*m_flow_nominal*1000*15/
        Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1=26.2,
        T_b1=12.8,
        T_a2=6,
        T_b2=16),
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mCooWat_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=3000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal) "Cooling coil"
    annotation (Placement(transformation(extent={{210,-36},{190,-56}})));
  Buildings.Fluid.FixedResistances.PressureDrop dpRetDuc(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = MediumA,
    allowFlowReversal=allowFlowReversal,
    dp_nominal=40) "Pressure drop for return duct"
    annotation (Placement(transformation(extent={{400,130},{380,150}})));
  Buildings.Fluid.Movers.SpeedControlled_y fanSup(
    redeclare package Medium = MediumA,
    per(pressure(V_flow={0,m_flow_nominal/1.2*2}, dp=2*{780 + 10 + dpBuiStaSet,
            0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{300,-50},{320,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senSupFlo(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)
    "Sensor for supply fan flow rate"
    annotation (Placement(transformation(extent={{400,-50},{420,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senRetFlo(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)
    "Sensor for return fan flow rate"
    annotation (Placement(transformation(extent={{360,130},{340,150}})));

  Modelica.Blocks.Routing.RealPassThrough TOut(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0))
    annotation (Placement(transformation(extent={{-300,170},{-280,190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{330,-50},{350,-30}})));
  Buildings.Fluid.Sensors.RelativePressure dpDisSupFan(redeclare package Medium
      = MediumA) "Supply fan static discharge pressure" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={320,0})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-318,-220},{-298,-200}})));
  Buildings.Utilities.Math.Min min(nin=5) "Computes lowest room temperature"
    annotation (Placement(transformation(extent={{1200,440},{1220,460}})));
  Buildings.Utilities.Math.Average ave(nin=5)
    "Compute average of room temperatures"
    annotation (Placement(transformation(extent={{1200,410},{1220,430}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TRet(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Return air temperature sensor"
    annotation (Placement(transformation(extent={{110,130},{90,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TMix(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    transferHeat=true)                   "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Fluid.Sensors.VolumeFlowRate VOut1(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal) "Outside air volume flow rate"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox cor(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mCor_flow_nominal,
    VRoo=VRooCor,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal-10,
    TAirInl_nominal=12+273.15,
    QHea_flow_nominal=mCor_flow_nominal*ratVFloHea*cpAir*(32-12))
    "Zone for core of buildings (azimuth will be neglected)"
    annotation (Placement(transformation(extent={{570,22},{610,62}})));
  Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox sou(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mSou_flow_nominal,
    VRoo=VRooSou,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal-10,
    TAirInl_nominal=12+273.15,
    QHea_flow_nominal=mSou_flow_nominal*ratVFloHea*cpAir*(32-12))
    "South-facing thermal zone"
    annotation (Placement(transformation(extent={{750,20},{790,60}})));
  Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox eas(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mEas_flow_nominal,
    VRoo=VRooEas,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal-10,
    TAirInl_nominal=12+273.15,
    QHea_flow_nominal=mEas_flow_nominal*ratVFloHea*cpAir*(32-12))
    "East-facing thermal zone"
    annotation (Placement(transformation(extent={{930,20},{970,60}})));
  Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox nor(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mNor_flow_nominal,
    VRoo=VRooNor,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal-10,
    TAirInl_nominal=12+273.15,
    QHea_flow_nominal=mNor_flow_nominal*ratVFloHea*cpAir*(32-12))
    "North-facing thermal zone"
    annotation (Placement(transformation(extent={{1090,20},{1130,60}})));
  Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox wes(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mWes_flow_nominal,
    VRoo=VRooWes,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal-10,
    TAirInl_nominal=12+273.15,
    QHea_flow_nominal=mWes_flow_nominal*ratVFloHea*cpAir*(32-12))
    "West-facing thermal zone"
    annotation (Placement(transformation(extent={{1290,20},{1330,60}})));
  Buildings.Fluid.FixedResistances.Junction splRetRoo1(
    redeclare package Medium = MediumA,
    m_flow_nominal={m_flow_nominal,m_flow_nominal - mCor_flow_nominal,
        mCor_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{630,10},{650,-10}})));
  Buildings.Fluid.FixedResistances.Junction splRetSou(
    redeclare package Medium = MediumA,
    m_flow_nominal={mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal
         + mWes_flow_nominal,mEas_flow_nominal + mNor_flow_nominal +
        mWes_flow_nominal,mSou_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{812,10},{832,-10}})));
  Buildings.Fluid.FixedResistances.Junction splRetEas(
    redeclare package Medium = MediumA,
    m_flow_nominal={mEas_flow_nominal + mNor_flow_nominal + mWes_flow_nominal,
        mNor_flow_nominal + mWes_flow_nominal,mEas_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{992,10},{1012,-10}})));
  Buildings.Fluid.FixedResistances.Junction splRetNor(
    redeclare package Medium = MediumA,
    m_flow_nominal={mNor_flow_nominal + mWes_flow_nominal,mWes_flow_nominal,
        mNor_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{1142,10},{1162,-10}})));
  Buildings.Fluid.FixedResistances.Junction splSupRoo1(
    redeclare package Medium = MediumA,
    m_flow_nominal={m_flow_nominal,m_flow_nominal - mCor_flow_nominal,
        mCor_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{580,-30},{600,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupSou(
    redeclare package Medium = MediumA,
    m_flow_nominal={mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal
         + mWes_flow_nominal,mEas_flow_nominal + mNor_flow_nominal +
        mWes_flow_nominal,mSou_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{760,-30},{780,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupEas(
    redeclare package Medium = MediumA,
    m_flow_nominal={mEas_flow_nominal + mNor_flow_nominal + mWes_flow_nominal,
        mNor_flow_nominal + mWes_flow_nominal,mEas_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{940,-30},{960,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupNor(
    redeclare package Medium = MediumA,
    m_flow_nominal={mNor_flow_nominal + mWes_flow_nominal,mWes_flow_nominal,
        mNor_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{1100,-30},{1120,-50}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather Data Bus"
    annotation (Placement(transformation(extent={{-330,170},{-310,190}}),
        iconTransformation(extent={{-360,170},{-340,190}})));

  Modelica.Blocks.Routing.DeMultiplex5 TRooAir(u(each unit="K", each
        displayUnit="degC")) "Demultiplex for room air temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={488,286})));

  Results res(
    final A=ATot,
    PFan=fanSup.P + 0,
    PPum=pumHeaCoi.P + pumCooCoi.P,
    PHea=heaCoi.Q2_flow + cor.terHea.Q2_flow + nor.terHea.Q2_flow + wes.terHea.Q2_flow + eas.terHea.Q2_flow + sou.terHea.Q2_flow,
    PCooSen=cooCoi.QSen2_flow,
    PCooLat=cooCoi.QLat2_flow) "Results of the simulation";

  /*fanRet*/

  Buildings.Examples.VAVReheat.BaseClasses.FreezeStat freSta
    "Freeze stat for heating coil"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Buildings.Fluid.Actuators.Dampers.Exponential damRet(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    from_dp=false,
    riseTime=15,
    dpDamper_nominal=5,
    dpFixed_nominal=5) "Return air damper" annotation (Placement(transformation(
        origin={0,-10},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  Buildings.Fluid.Actuators.Dampers.Exponential damOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    from_dp=false,
    riseTime=15,
    dpDamper_nominal=5,
    dpFixed_nominal=5) "Outdoor air damper"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Fluid.FixedResistances.Junction splCooSup(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={220,-166})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valCooCoi(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0) "Valve for cooling coil" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={180,-210})));
  Buildings.Fluid.FixedResistances.Junction splCooRet(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,-166})));
  Buildings.Fluid.Movers.SpeedControlled_y pumCooCoi(
    redeclare package Medium = MediumW,
    per(pressure(V_flow={0,mCooWat_flow_nominal/1000*2}, dp=2*{3000,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={180,-120})));
  Buildings.Fluid.Movers.SpeedControlled_y pumHeaCoi(
    redeclare package Medium = MediumW,
    per(pressure(V_flow={0,mHeaWat_flow_nominal/1000*2}, dp=2*{3000,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Pump for heating coil" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={130,-118})));

  Modelica.Fluid.Interfaces.FluidPort_a portHeaCoiSup(redeclare package Medium
      = MediumW) "Heating coil loop supply"
    annotation (Placement(transformation(extent={{130,-410},{150,-390}}),
        iconTransformation(extent={{92,-412},{112,-392}})));
  Modelica.Fluid.Interfaces.FluidPort_b portHeaCoiRet(redeclare package Medium
      = MediumW) "Heating coil loop return" annotation (Placement(
        transformation(extent={{50,-410},{70,-390}}), iconTransformation(extent={{12,-412},
            {32,-392}})));
  Modelica.Fluid.Interfaces.FluidPort_a portHeaTerSup(redeclare package Medium
      = MediumW) "Terminal heat loop supply"
    annotation (Placement(transformation(extent={{450,-410},{470,-390}}),
        iconTransformation(extent={{410,-410},{430,-390}})));
  Modelica.Fluid.Interfaces.FluidPort_b portHeaTerRet(redeclare package Medium
      = MediumW) "Terminal heat loop return" annotation (Placement(
        transformation(extent={{370,-410},{390,-390}}),
                                                      iconTransformation(extent={{332,
            -412},{352,-392}})));

  Modelica.Fluid.Interfaces.FluidPort_a portCooCoiSup(redeclare package Medium
      = MediumW) "Cooling coil loop supply"
    annotation (Placement(transformation(extent={{250,-410},{270,-390}}),
        iconTransformation(extent={{230,-410},{250,-390}})));
  Modelica.Fluid.Interfaces.FluidPort_b portCooCoiRet(redeclare package Medium
      = MediumW)
    "Coolin coil loop return"
    annotation (Placement(transformation(extent={{170,-410},{190,-390}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valHeaCoi(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0) "Valve for heating coil" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={90,-210})));
  Buildings.Fluid.FixedResistances.Junction splHeaRet(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,-170})));
  Buildings.Fluid.FixedResistances.Junction splHeaSup(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={130,-170})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valTerHea(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=wes.mHotWat_flow_nominal,
    from_dp=true,
    dpValve_nominal=10000,
    use_inputFilter=false) "Valve for terminal heater" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={1180,-98})));
  Buildings.Fluid.FixedResistances.Junction splHeaSupCor(
    redeclare package Medium = MediumW,
    m_flow_nominal={cor.mHotWat_flow_nominal + sou.mHotWat_flow_nominal + eas.mHotWat_flow_nominal
         + wes.mHotWat_flow_nominal + nor.mHotWat_flow_nominal,sou.mHotWat_flow_nominal +
        eas.mHotWat_flow_nominal + wes.mHotWat_flow_nominal + nor.mHotWat_flow_nominal,
        cor.mHotWat_flow_nominal},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = 1000*{0,1,1},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for heating supply water"
    annotation (Placement(transformation(extent={{500,-70},{520,-90}})));
  Buildings.Fluid.FixedResistances.Junction splHeaSupSou(
    redeclare package Medium = MediumW,
    m_flow_nominal={sou.mHotWat_flow_nominal + eas.mHotWat_flow_nominal + wes.mHotWat_flow_nominal
         + nor.mHotWat_flow_nominal,eas.mHotWat_flow_nominal + wes.mHotWat_flow_nominal +
        nor.mHotWat_flow_nominal,sou.mHotWat_flow_nominal},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = 1000*{0,1,1},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for heating supply water"
    annotation (Placement(transformation(extent={{700,-70},{720,-90}})));
  Buildings.Fluid.FixedResistances.Junction splHeaSupEas(
    redeclare package Medium = MediumW,
    m_flow_nominal={eas.mHotWat_flow_nominal + wes.mHotWat_flow_nominal + nor.mHotWat_flow_nominal,
        wes.mHotWat_flow_nominal + nor.mHotWat_flow_nominal,eas.mHotWat_flow_nominal},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = 1000*{0,1,1},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for heating supply water"
    annotation (Placement(transformation(extent={{880,-70},{900,-90}})));
  Buildings.Fluid.FixedResistances.Junction splHeaSupNor(
    redeclare package Medium = MediumW,
    m_flow_nominal={wes.mHotWat_flow_nominal + nor.mHotWat_flow_nominal,wes.mHotWat_flow_nominal,
        nor.mHotWat_flow_nominal},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = 1000*{0,1,1},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for heating supply water"
    annotation (Placement(transformation(extent={{1040,-70},{1060,-90}})));
  Buildings.Fluid.Sensors.RelativePressure dpHea(redeclare package Medium =
        MediumW) "Differential pressure sensor for heating system" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={1250,-98})));
  Buildings.Controls.OBC.CDL.Continuous.PID conValTerHea(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=10,
    Ti=10,
    r=0.1*(cor.mHotWat_flow_nominal + sou.mHotWat_flow_nominal + eas.mHotWat_flow_nominal
         + wes.mHotWat_flow_nominal + nor.mHotWat_flow_nominal))
    "Controller for static pressure and minimum flow in heating system"
    annotation (Placement(transformation(extent={{1320,-110},{1340,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant mFlowMin(k=0.1*(cor.mHotWat_flow_nominal
         + sou.mHotWat_flow_nominal + eas.mHotWat_flow_nominal + wes.mHotWat_flow_nominal
         + nor.mHotWat_flow_nominal)) "Minimum mass flow rate"
    annotation (Placement(transformation(extent={{1290,-110},{1310,-90}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloTerHea(redeclare package Medium
      = MediumW) "Mass flow rate sensor for terminal heaters" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={460,-212})));
protected
  constant Modelica.SIunits.SpecificHeatCapacity cpAir=
    Buildings.Utilities.Psychrometrics.Constants.cpAir
    "Air specific heat capacity";
  constant Modelica.SIunits.SpecificHeatCapacity cpWatLiq=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Water specific heat capacity";
  model Results "Model to store the results of the simulation"
    parameter Modelica.SIunits.Area A "Floor area";
    input Modelica.SIunits.Power PFan "Fan energy";
    input Modelica.SIunits.Power PPum "Pump energy";
    input Modelica.SIunits.Power PHea "Heating energy";
    input Modelica.SIunits.Power PCooSen "Sensible cooling energy";
    input Modelica.SIunits.Power PCooLat "Latent cooling energy";

    Real EFan(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Fan energy";
    Real EPum(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Pump energy";
    Real EHea(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Heating energy";
    Real ECooSen(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Sensible cooling energy";
    Real ECooLat(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Latent cooling energy";
    Real ECoo(unit="J/m2") "Total cooling energy";
  equation

    A*der(EFan) = PFan;
    A*der(EPum) = PPum;
    A*der(EHea) = PHea;
    A*der(ECooSen) = PCooSen;
    A*der(ECooLat) = PCooLat;
    ECoo = ECooSen + ECooLat;

  end Results;
equation
  connect(fanSup.port_b, dpDisSupFan.port_a) annotation (Line(
      points={{320,-40},{320,-10}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(TSup.port_a, fanSup.port_b) annotation (Line(
      points={{330,-40},{320,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(amb.ports[1], VOut1.port_a) annotation (Line(
      points={{-114,-42.8},{-94,-42.8},{-94,-40},{-90,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetRoo1.port_1, dpRetDuc.port_a) annotation (Line(
      points={{630,0},{430,0},{430,140},{400,140}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetNor.port_1, splRetEas.port_2) annotation (Line(
      points={{1142,0},{1110,0},{1110,0},{1078,0},{1078,0},{1012,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetEas.port_1, splRetSou.port_2) annotation (Line(
      points={{992,0},{952,0},{952,0},{912,0},{912,0},{832,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetSou.port_1, splRetRoo1.port_2) annotation (Line(
      points={{812,0},{650,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupRoo1.port_3, cor.port_aAir) annotation (Line(
      points={{590,-30},{590,-4},{590,22},{590,22}},
      color={0,127,255},
      thickness=0.5));
  connect(splSupRoo1.port_2, splSupSou.port_1) annotation (Line(
      points={{600,-40},{760,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupSou.port_3, sou.port_aAir) annotation (Line(
      points={{770,-30},{770,-6},{770,20},{770,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupSou.port_2, splSupEas.port_1) annotation (Line(
      points={{780,-40},{940,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupEas.port_3, eas.port_aAir) annotation (Line(
      points={{950,-30},{950,-6},{950,20},{950,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupEas.port_2, splSupNor.port_1) annotation (Line(
      points={{960,-40},{1100,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupNor.port_3, nor.port_aAir) annotation (Line(
      points={{1110,-30},{1110,-6},{1110,20},{1110,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupNor.port_2, wes.port_aAir) annotation (Line(
      points={{1120,-40},{1310,-40},{1310,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-320,180},{-302,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(amb.weaBus, weaBus) annotation (Line(
      points={{-136,-44.78},{-320,-44.78},{-320,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(splRetRoo1.port_3, flo.portsCor[2]) annotation (Line(
      points={{640,10},{640,118},{892,118},{892,472},{898,472},{898,520.667},{
          906.052,520.667}},
      color={0,127,255},
      thickness=0.5));
  connect(splRetSou.port_3, flo.portsSou[2]) annotation (Line(
      points={{822,10},{822,152},{900,152},{900,447.333},{906.052,447.333}},
      color={0,127,255},
      thickness=0.5));
  connect(splRetEas.port_3, flo.portsEas[2]) annotation (Line(
      points={{1002,10},{1002,120},{1068.63,120},{1068.63,520.667}},
      color={0,127,255},
      thickness=0.5));
  connect(splRetNor.port_3, flo.portsNor[2]) annotation (Line(
      points={{1152,10},{1152,214},{906.052,214},{906.052,583}},
      color={0,127,255},
      thickness=0.5));
  connect(splRetNor.port_2, flo.portsWes[2]) annotation (Line(
      points={{1162,0},{1188,0},{1188,346},{818,346},{818,484},{817.635,484},{
          817.635,520.667}},
      color={0,127,255},
      thickness=0.5));
  connect(weaBus, flo.weaBus) annotation (Line(
      points={{-320,180},{-320,671},{978.783,671}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flo.TRooAir, min.u) annotation (Line(
      points={{1107.13,515.167},{1164.7,515.167},{1164.7,450},{1198,450}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(flo.TRooAir, ave.u) annotation (Line(
      points={{1107.13,515.167},{1166,515.167},{1166,420},{1198,420}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TRooAir.u, flo.TRooAir) annotation (Line(
      points={{488,298},{488,538},{1164,538},{1164,515.167},{1107.13,515.167}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(cooCoi.port_b2, fanSup.port_a) annotation (Line(
      points={{210,-40},{300,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));

  connect(cor.port_bAir, flo.portsCor[1]) annotation (Line(
      points={{590,62},{590,120},{891.791,120},{891.791,520.667}},
      color={0,127,255},
      thickness=0.5));
  connect(sou.port_bAir, flo.portsSou[1]) annotation (Line(
      points={{770,60},{770,152},{891.791,152},{891.791,447.333}},
      color={0,127,255},
      thickness=0.5));
  connect(eas.port_bAir, flo.portsEas[1]) annotation (Line(
      points={{950,60},{950,120},{1054,120},{1054,506},{1054.37,506},{1054.37,
          520.667}},
      color={0,127,255},
      thickness=0.5));
  connect(nor.port_bAir, flo.portsNor[1]) annotation (Line(
      points={{1110,60},{1110,214},{926,214},{926,326},{891.791,326},{891.791,
          583}},
      color={0,127,255},
      thickness=0.5));
  connect(wes.port_bAir, flo.portsWes[1]) annotation (Line(
      points={{1310,60},{1310,344},{804,344},{804,424},{803.374,424},{803.374,
          520.667}},
      color={0,127,255},
      thickness=0.5));

  connect(senRetFlo.port_a, dpRetDuc.port_b)
    annotation (Line(points={{360,140},{380,140}}, color={0,127,255}));
  connect(TSup.port_b, senSupFlo.port_a)
    annotation (Line(points={{350,-40},{400,-40}}, color={0,127,255}));
  connect(senSupFlo.port_b, splSupRoo1.port_1)
    annotation (Line(points={{420,-40},{580,-40}}, color={0,127,255}));
  connect(dpDisSupFan.port_b, amb.ports[2]) annotation (Line(
      points={{320,10},{320,14},{-106,14},{-106,-48},{-110,-48},{-110,-47.2},{-114,
          -47.2}},
      color={0,0,0},
      pattern=LinePattern.Dot));
  connect(senRetFlo.port_b, TRet.port_a) annotation (Line(points={{340,140},{
          226,140},{110,140}}, color={0,127,255}));
  connect(freSta.u, TMix.T) annotation (Line(points={{-142,-90},{-148,-90},{-148,
          -70},{20,-70},{20,-20},{40,-20},{40,-29}},
                                                color={0,0,127}));
  connect(TMix.port_b, heaCoi.port_a2) annotation (Line(
      points={{50,-40},{98,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(heaCoi.port_b2, cooCoi.port_a2)
    annotation (Line(
      points={{118,-40},{190,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(VOut1.port_b, damOut.port_a)
    annotation (Line(points={{-70,-40},{-50,-40}}, color={0,127,255}));
  connect(damOut.port_b, TMix.port_a)
    annotation (Line(points={{-30,-40},{30,-40}}, color={0,127,255}));
  connect(damRet.port_a, TRet.port_b)
    annotation (Line(points={{0,0},{0,140},{90,140}}, color={0,127,255}));
  connect(damRet.port_b, TMix.port_a)
    annotation (Line(points={{0,-20},{0,-40},{30,-40}}, color={0,127,255}));
  connect(pumHeaCoi.port_b, heaCoi.port_a1) annotation (Line(points={{130,-108},
          {130,-52},{118,-52}}, color={0,127,255}));
  connect(cooCoi.port_b1,pumCooCoi. port_a) annotation (Line(points={{190,-52},{
          180,-52},{180,-110}}, color={0,127,255}));
  connect(splCooSup.port_2, cooCoi.port_a1) annotation (Line(points={{220,-156},
          {220,-52},{210,-52}}, color={0,127,255}));
  connect(splCooRet.port_3,splCooSup. port_3)
    annotation (Line(points={{190,-166},{210,-166}}, color={0,127,255}));
  connect(pumCooCoi.port_b, splCooRet.port_2)
    annotation (Line(points={{180,-130},{180,-156}}, color={0,127,255}));
  connect(valCooCoi.port_a, splCooRet.port_1)
    annotation (Line(points={{180,-200},{180,-176}}, color={0,127,255}));
  connect(valCooCoi.port_b, portCooCoiRet)
    annotation (Line(points={{180,-220},{180,-400}}, color={0,127,255}));
  connect(splCooSup.port_1, portCooCoiSup)
    annotation (Line(points={{220,-176},{220,-360},{260,-360},{260,-400}},
                                                     color={0,127,255}));
  connect(portHeaTerRet, cor.port_bHotWat) annotation (Line(points={{380,-400},{
          380,-120},{540,-120},{540,30},{570,30}}, color={0,127,255}));
  connect(portHeaTerRet, sou.port_bHotWat) annotation (Line(points={{380,-400},{
          380,-120},{732,-120},{732,28},{750,28}}, color={0,127,255}));
  connect(portHeaTerRet, eas.port_bHotWat) annotation (Line(points={{380,-400},{
          380,-120},{910,-120},{910,28},{930,28}}, color={0,127,255}));
  connect(portHeaTerRet, nor.port_bHotWat) annotation (Line(points={{380,-400},{
          380,-120},{1072,-120},{1072,28},{1090,28}}, color={0,127,255}));
  connect(portHeaTerRet, wes.port_bHotWat) annotation (Line(points={{380,-400},{
          380,-120},{1270,-120},{1270,28},{1290,28}}, color={0,127,255}));
  connect(splHeaRet.port_3,splHeaSup. port_3)
    annotation (Line(points={{100,-170},{120,-170}},color={0,127,255}));
  connect(valHeaCoi.port_a,splHeaRet. port_1)
    annotation (Line(points={{90,-200},{90,-180}}, color={0,127,255}));
  connect(heaCoi.port_b1,splHeaRet. port_2)
    annotation (Line(points={{98,-52},{90,-52},{90,-160}}, color={0,127,255}));
  connect(splHeaSup.port_2, pumHeaCoi.port_a)
    annotation (Line(points={{130,-160},{130,-128}}, color={0,127,255}));
  connect(portHeaCoiSup, splHeaSup.port_1) annotation (Line(points={{140,-400},{
          140,-220},{130,-220},{130,-180}}, color={0,127,255}));
  connect(valHeaCoi.port_b, portHeaCoiRet) annotation (Line(points={{90,-220},{90,
          -240},{60,-240},{60,-400}}, color={0,127,255}));
  connect(splHeaSupCor.port_3, cor.port_aHotWat)
    annotation (Line(points={{510,-70},{510,42},{570,42}}, color={0,127,255}));
  connect(splHeaSupCor.port_2, splHeaSupSou.port_1)
    annotation (Line(points={{520,-80},{700,-80}}, color={0,127,255}));
  connect(splHeaSupSou.port_3, sou.port_aHotWat)
    annotation (Line(points={{710,-70},{710,40},{750,40}}, color={0,127,255}));
  connect(splHeaSupSou.port_2, splHeaSupEas.port_1)
    annotation (Line(points={{720,-80},{880,-80}}, color={0,127,255}));
  connect(splHeaSupEas.port_3, eas.port_aHotWat)
    annotation (Line(points={{890,-70},{890,40},{930,40}}, color={0,127,255}));
  connect(splHeaSupEas.port_2, splHeaSupNor.port_1)
    annotation (Line(points={{900,-80},{1040,-80}}, color={0,127,255}));
  connect(splHeaSupNor.port_3, nor.port_aHotWat) annotation (Line(points={{1050,
          -70},{1048,-70},{1048,40},{1090,40}}, color={0,127,255}));
  connect(splHeaSupNor.port_2, wes.port_aHotWat) annotation (Line(points={{1060,
          -80},{1250,-80},{1250,40},{1290,40}}, color={0,127,255}));
  connect(splHeaSupNor.port_2, valTerHea.port_a) annotation (Line(points={{1060,
          -80},{1180,-80},{1180,-88}}, color={0,127,255}));
  connect(valTerHea.port_b, portHeaTerRet) annotation (Line(points={{1180,-108},
          {1180,-120},{382,-120},{382,-400},{380,-400}}, color={0,127,255}));
  connect(dpHea.port_a, wes.port_aHotWat) annotation (Line(points={{1250,-88},{1250,
          40},{1290,40}}, color={0,127,255}));
  connect(dpHea.port_b, valTerHea.port_b) annotation (Line(points={{1250,-108},
          {1250,-120},{1180,-120},{1180,-108}}, color={0,127,255}));
  connect(conValTerHea.u_s, mFlowMin.y)
    annotation (Line(points={{1318,-100},{1312,-100}}, color={0,0,127}));
  connect(conValTerHea.y, valTerHea.y) annotation (Line(points={{1342,-100},{
          1360,-100},{1360,-140},{1208,-140},{1208,-98},{1192,-98}}, color={0,0,
          127}));
  connect(portHeaTerSup, senMasFloTerHea.port_a)
    annotation (Line(points={{460,-400},{460,-222}}, color={0,127,255}));
  connect(senMasFloTerHea.port_b, splHeaSupCor.port_1) annotation (Line(points=
          {{460,-202},{460,-80},{500,-80}}, color={0,127,255}));
  connect(senMasFloTerHea.m_flow, conValTerHea.u_m) annotation (Line(points={{
          471,-212},{1330,-212},{1330,-112}}, color={0,0,127}));
  annotation (
      Icon(
      coordinateSystem(
        extent={{-400,-400},{1380,680}},
        preserveAspectRatio=true), graphics={Rectangle(
          extent={{-400,680},{1380,-400}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-400,-400},{1380,680}})),
        Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
The figure below shows the schematic diagram of the HVAC system
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
Most of the HVAC control in this model is open loop.
Two models that extend this model, namely
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>
and
<a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a>
add closed loop control. See these models for a description of
the control sequence.
</p>
<p>
To model the heat transfer through the building envelope,
a model of five interconnected rooms is used.
The five room model is representative of one floor of the
new construction medium office building for Chicago, IL,
as described in the set of DOE Commercial Building Benchmarks
(Deru et al, 2009). There are four perimeter zones and one core zone.
The envelope thermal properties meet ASHRAE Standard 90.1-2004.
The thermal room model computes transient heat conduction through
walls, floors and ceilings and long-wave radiative heat exchange between
surfaces. The convective heat transfer coefficient is computed based
on the temperature difference between the surface and the room air.
There is also a layer-by-layer short-wave radiation,
long-wave radiation, convection and conduction heat transfer model for the
windows. The model is similar to the
Window 5 model and described in TARCOG 2006.
</p>
<p>
Each thermal zone can have air flow from the HVAC system, through leakages of the building envelope (except for the core zone) and through bi-directional air exchange through open doors that connect adjacent zones. The bi-directional air exchange is modeled based on the differences in static pressure between adjacent rooms at a reference height plus the difference in static pressure across the door height as a function of the difference in air density.
Infiltration is a function of the
flow imbalance of the HVAC system.
</p>
<h4>References</h4>
<p>
Deru M., K. Field, D. Studer, K. Benne, B. Griffith, P. Torcellini,
 M. Halverson, D. Winiarski, B. Liu, M. Rosenberg, J. Huang, M. Yazdanian, and D. Crawley.
<i>DOE commercial building research benchmarks for commercial buildings</i>.
Technical report, U.S. Department of Energy, Energy Efficiency and
Renewable Energy, Office of Building Technologies, Washington, DC, 2009.
</p>
<p>
TARCOG 2006: Carli, Inc., TARCOG: Mathematical models for calculation
of thermal performance of glazing systems with our without
shading devices, Technical Report, Oct. 17, 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
August 24, 2021, by Michael Wetter:<br/>
Changed model to include the hydraulic configurations of the cooling coil,
heating coil and VAV terminal box.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2594\">issue #2594</a>.
</li>
<li>
June 30, 2021, by Antoine Gautier:<br/>
Changed cooling coil model. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2549\">issue #2549</a>.
</li>
<li>
May 6, 2021, by David Blum:<br/>
Change to <code>from_dp=false</code> for all mixing box dampers.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2485\">issue #2485</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class and introduced floor areas in base class
to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 16, 2021, by Michael Wetter:<br/>
Refactored model to implement the economizer dampers directly in
<code>Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop</code> rather than through the
model of a mixing box. Since the version of the Guideline 36 model has no exhaust air damper,
this leads to simpler equations.
<br/> This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2454\">issue #2454</a>.
</li>
<li>
March 11, 2021, by Michael Wetter:<br/>
Set parameter in weather data reader to avoid computation of wet bulb temperature which is need needed for this model.
</li>
<li>
February 03, 2021, by Baptiste Ravache:<br/>
Refactored the sizing of the heating coil in the <code>VAVBranch</code> (renamed <code>VAVReheatBox</code>) class.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2059\">#2024</a>.
</li>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Added design parameters for outdoor air flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>
</li>
<li>
November 25, 2019, by Milica Grahovac:<br/>
Declared the floor model as replaceable.
</li>
<li>
September 26, 2017, by Michael Wetter:<br/>
Separated physical model from control to facilitate implementation of alternate control
sequences.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"));
end PartialOpenLoop;