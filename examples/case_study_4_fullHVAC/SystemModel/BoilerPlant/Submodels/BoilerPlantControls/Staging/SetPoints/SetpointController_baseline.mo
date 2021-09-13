within SystemModel.BoilerPlant.Submodels.BoilerPlantControls.Staging.SetPoints;
block SetpointController_baseline
  "Calculates the boiler stage status setpoint signal"

  parameter Boolean have_priOnl = false
    "Is the boiler plant a primary-only, condensing boiler plant?"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer nBoi = 2
    "Number of boilers"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer boiTyp[nBoi]={SystemModel.BoilerPlant.Submodels.BoilerPlantControls.Types.BoilerTypes.condensingBoiler,
      SystemModel.BoilerPlant.Submodels.BoilerPlantControls.Types.BoilerTypes.nonCondensingBoiler}
    "Boiler type"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer nSta = 3
    "Number of boiler plant stages"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer staMat[nSta, nBoi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stage as row index and boiler as column index"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real boiDesCap[nBoi](
    final unit=fill("W",nBoi),
    displayUnit=fill("W",nBoi),
    final quantity=fill("Power",nBoi))
    "Design boiler capacities vector"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real boiFirMin[nBoi](
    final unit=fill("1",nBoi),
    displayUnit=fill("1",nBoi))
    "Boiler minimum firing ratio"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real boiMinPriPumSpeSta[nSta](
    final unit=fill("1",nSta),
    displayUnit=fill("1",nSta),
    final max=fill(1,nSta),
    final min=fill(0,nSta)) = {0,0,0}
    "Minimum primary pump speed for the boiler plant stage"
    annotation(Evaluate=true,
      Dialog(enable=not
                       (have_priOnl),
        tab="General",
        group="Boiler plant configuration parameters"));

  parameter Real delStaCha(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Hold period for each stage change"
    annotation(Dialog(tab="Staging parameters", group="General parameters"));

  parameter Real avePer(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Time period for the capacity requirement rolling average"
    annotation(Dialog(tab="Staging parameters", group="Capacity requirement calculation parameters"));

  parameter Real fraNonConBoi(
    final unit="1",
    displayUnit="1") = 0.9
    "Fraction of current stage design capacity at which efficiency condition is 
    satisfied for non-condensing boilers"
    annotation(Dialog(tab="Staging parameters", group="Efficiency condition parameters"));

  parameter Real fraConBoi(
    final unit="1",
    displayUnit="1") = 1.5
    "Fraction of higher stage design capacity at which efficiency condition is 
    satisfied for condensing boilers"
    annotation(Dialog(tab="Staging parameters", group="Efficiency condition parameters"));

  parameter Real delEffCon(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for heating capacity requirement condition"
    annotation(Dialog(tab="Staging parameters", group="Efficiency condition parameters"));

  parameter Real TDif(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 10
    "Required temperature difference between setpoint and measured temperature"
    annotation(Dialog(tab="Staging parameters", group="Failsafe condition parameters"));

  parameter Real delFaiCon(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 900
    "Enable delay for temperature condition"
    annotation(Dialog(tab="Staging parameters", group="Failsafe condition parameters"));

  parameter Real sigDif(
    final unit="1",
    displayUnit="1") = 0.1
    "Signal hysteresis deadband"
    annotation (Dialog(tab="Advanced", group="Efficiency condition parameters"));

  parameter Real TDifHys(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Temperature deadband for hysteresis loop"
    annotation(Dialog(tab="Advanced", group="Failsafe condition parameters"));

  parameter Real fraMinFir(
    final unit="1",
    displayUnit="1") = 1.1
    "Fraction of boiler minimum firing rate that required capacity needs to be
    to initiate stage-down process"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real delMinFir(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Delay for staging based on minimum firing rate of current stage"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real fraDesCap(
    final unit="1",
    displayUnit="1") = 0.8
    "Fraction of design capacity of next lower stage that heating capacity needs
    to be for staging down"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real delDesCapNonConBoi(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for capacity requirement condition for non-condensing boilers"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real delDesCapConBoi(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for capacity requirement condition for condensing boilers"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real delBypVal(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for bypass valve condition for primary-only plants"
    annotation (
      Evaluate=true,
      Dialog(
        enable=have_priOnl,
        tab="Staging parameters",
        group="Staging down parameters"));

  parameter Real TCirDif(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 3
    "Required return water temperature difference between primary and secondary
    circuits for staging down"
    annotation (
      Evaluate=true,
      Dialog(
        enable=not
                  (have_priOnl),
        tab="Staging parameters",
        group="Staging down parameters"));

  parameter Real delTRetDif(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for measured hot water return temperature difference condition"
    annotation (
      Evaluate=true,
      Dialog(
        enable=not
                  (have_priOnl),
        tab="Staging parameters",
        group="Staging down parameters"));

  parameter Real bypValClo(
    final unit="1",
    displayUnit="1") = 0
    "Adjustment for signal received when bypass valve is closed"
    annotation (
      Evaluate=true,
      Dialog(
        enable=have_priOnl,
        tab="Advanced",
        group="Staging down parameters"));

  parameter Real dTemp(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.1
    "Hysteresis deadband for measured temperatures"
    annotation (Dialog(tab="Advanced", group="Failsafe condition parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaChaProEnd
    "Signal indicating end of stage change process"
    annotation (Placement(transformation(extent={{-440,-280},{-400,-240}}),
      iconTransformation(extent={{-140,150},{-100,190}},
        rotation=90,
        origin={80,-80})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiAva[nBoi]
    "Boiler availability status vector"
    annotation (Placement(transformation(extent={{-440,-190},{-400,-150}}),
      iconTransformation(extent={{-140,-180},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-440,-100},{-400,-60}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSupSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-440,270},{-400,310}}),
      iconTransformation(extent={{-140,150},{-100,190}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSup(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-440,150},{-400,190}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatRet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Hot water return temperature"
    annotation (Placement(transformation(extent={{-440,230},{-400,270}}),
      iconTransformation(extent={{-140,120},{-100,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    displayUnit="1")
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-440,-50},{-400,-10}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaUpEdg
    "Boiler stage change higher edge signal"
    annotation (Placement(transformation(extent={{120,-90},{160,-50}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaDowEdg
    "Boiler stage change lower edge signal"
    annotation (Placement(transformation(extent={{120,-210},{160,-170}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoi[nBoi]
    "Boiler status setpoint vector for the current boiler stage setpoint"
    annotation (Placement(transformation(extent={{120,-280},{160,-240}}),
      iconTransformation(extent={{100,-120},{140,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaEdg
    "Boiler stage change edge signal"
    annotation (Placement(transformation(extent={{120,-150},{160,-110}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(
    final min=0,
    final max=nSta) "Boiler stage integer setpoint"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yStaTyp[nSta]
    "Boiler stage type vector"
    annotation (Placement(transformation(extent={{120,40},{160,80}}),
      iconTransformation(extent={{100,80},{140,120}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-200,-226},{-180,-206}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-260,-226},{-240,-206}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(samplePeriod=1)
    annotation (Placement(transformation(extent={{-228,-226},{-208,-206}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt(k2=-1)
    annotation (Placement(transformation(extent={{-160,-226},{-140,-206}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt1
    annotation (Placement(transformation(extent={{-160,-186},{-140,-166}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=1)
    annotation (Placement(transformation(extent={{-200,-256},{-180,-236}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{-260,160},{-240,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=6, uHigh=6.1)
    annotation (Placement(transformation(extent={{-220,160},{-200,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=0.3, uHigh=0.35)
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(t=300)
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-260,280},{-240,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(uLow=1, uHigh=2)
    annotation (Placement(transformation(extent={{-220,280},{-200,300}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(t=600)
    annotation (Placement(transformation(extent={{-140,280},{-120,300}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    annotation (Placement(transformation(extent={{-100,280},{-80,300}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    annotation (Placement(transformation(extent={{-70,140},{-50,160}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[2]
    annotation (Placement(transformation(extent={{-120,-200},{-100,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter lim[2](uMax=fill(nSta, 2), uMin
      =fill(1, 2))
    annotation (Placement(transformation(extent={{-90,-200},{-70,-180}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1[2]
    annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-180,240},{-160,260}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    annotation (Placement(transformation(extent={{-220,240},{-200,260}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
protected
  SystemModel.BoilerPlant.Submodels.BoilerPlantControls.Staging.SetPoints.Subsequences.Change
    cha(final nSta=nSta, final delStaCha=delStaCha) "Stage change assignment"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

  SystemModel.BoilerPlant.Submodels.BoilerPlantControls.Staging.SetPoints.Subsequences.BoilerIndices
    boiInd(
    final nSta=nSta,
    final nBoi=nBoi,
    final staMat=staMat) "Boiler index generator"
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));

  SystemModel.BoilerPlant.Submodels.BoilerPlantControls.Staging.SetPoints.Subsequences.Configurator
    conf(
    final nSta=nSta,
    final nBoi=nBoi,
    final boiTyp=boiTyp,
    final staMat=staMat,
    final boiDesCap=boiDesCap,
    final boiFirMin=boiFirMin)
    "Configurator to decide stage availability based on boiler availability"
    annotation (Placement(transformation(extent={{-360,-180},{-340,-160}})));

equation
  connect(uPla, cha.uPla) annotation (Line(points={{-420,-80},{-60,-80},{-60,
          -165},{-22,-165}},                 color={255,0,255}));
  connect(cha.ySta, ySta) annotation (Line(points={{2,-164},{20,-164},{20,0},{
          140,0}},   color={255,127,0}));
  connect(boiInd.yBoi,yBoi)
    annotation (Line(points={{62,-200},{80,-200},{80,-260},{140,-260}},
                                                     color={255,0,255}));
  connect(cha.ySta,boiInd. u) annotation (Line(points={{2,-164},{20,-164},{20,
          -200},{38,-200}},  color={255,127,0}));
  connect(conf.uBoiAva,uBoiAva)  annotation (Line(points={{-362,-170},{-420,-170}},
                                    color={255,0,255}));
  connect(uStaChaProEnd, cha.uStaChaProEnd) annotation (Line(points={{-420,-260},
          {-19,-260},{-19,-182}}, color={255,0,255}));
  connect(cha.yChaEdg, yChaEdg) annotation (Line(points={{2,-172},{110,-172},{
          110,-130},{140,-130}}, color={255,0,255}));
  connect(cha.yChaUpEdg, yChaUpEdg) annotation (Line(points={{2,-168},{100,-168},
          {100,-70},{140,-70}}, color={255,0,255}));
  connect(cha.yChaDowEdg, yChaDowEdg) annotation (Line(points={{2,-176},{100,
          -176},{100,-190},{140,-190}}, color={255,0,255}));
  connect(conf.yAva, cha.uStaAva) annotation (Line(points={{-338,-178},{-320,
          -178},{-320,-162},{-22,-162}},                       color={255,0,255}));
  connect(conf.yTyp, yStaTyp) annotation (Line(points={{-338,-174},{-336,-174},
          {-336,60},{140,60}}, color={255,127,0}));
  connect(reaToInt.u, uniDel.y)
    annotation (Line(points={{-202,-216},{-206,-216}}, color={0,0,127}));
  connect(uniDel.u, intToRea.y)
    annotation (Line(points={{-230,-216},{-238,-216}}, color={0,0,127}));
  connect(cha.ySta, intToRea.u) annotation (Line(points={{2,-164},{20,-164},{20,
          -272},{-270,-272},{-270,-216},{-262,-216}}, color={255,127,0}));
  connect(reaToInt.y, addInt1.u1) annotation (Line(points={{-178,-216},{-172,
          -216},{-172,-170},{-162,-170}},
                                  color={255,127,0}));
  connect(reaToInt.y, addInt.u1) annotation (Line(points={{-178,-216},{-172,
          -216},{-172,-210},{-162,-210}},
                                  color={255,127,0}));
  connect(conInt.y, addInt1.u2) annotation (Line(points={{-178,-246},{-166,-246},
          {-166,-182},{-162,-182}},
                                  color={255,127,0}));
  connect(conInt.y, addInt.u2) annotation (Line(points={{-178,-246},{-166,-246},
          {-166,-222},{-162,-222}},
                                 color={255,127,0}));
  connect(THotWatSup, add2.u1) annotation (Line(points={{-420,170},{-288,170},{
          -288,176},{-262,176}}, color={0,0,127}));
  connect(THotWatRet, add2.u2) annotation (Line(points={{-420,250},{-270,250},{
          -270,164},{-262,164}}, color={0,0,127}));
  connect(hys.u, add2.y)
    annotation (Line(points={{-222,170},{-238,170}}, color={0,0,127}));
  connect(uPumSpe, hys1.u) annotation (Line(points={{-420,-30},{-240,-30},{-240,
          130},{-222,130}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-198,170},{-182,170}}, color={255,0,255}));
  connect(hys1.y, not2.u)
    annotation (Line(points={{-198,130},{-182,130}}, color={255,0,255}));
  connect(not1.y, or2.u1) annotation (Line(points={{-158,170},{-150,170},{-150,
          150},{-142,150}}, color={255,0,255}));
  connect(not2.y, or2.u2) annotation (Line(points={{-158,130},{-150,130},{-150,
          142},{-142,142}}, color={255,0,255}));
  connect(THotWatSupSet, add1.u1) annotation (Line(points={{-420,290},{-380,290},
          {-380,296},{-262,296}}, color={0,0,127}));
  connect(THotWatSup, add1.u2) annotation (Line(points={{-420,170},{-360,170},{
          -360,284},{-262,284}}, color={0,0,127}));
  connect(add1.y, hys2.u)
    annotation (Line(points={{-238,290},{-222,290}}, color={0,0,127}));
  connect(tim1.passed, edg.u) annotation (Line(points={{-118,282},{-110,282},{
          -110,290},{-102,290}}, color={255,0,255}));
  connect(edg.y, cha.uUp) annotation (Line(points={{-78,290},{-30,290},{-30,
          -175},{-22,-175}}, color={255,0,255}));
  connect(tim.passed, edg1.u) annotation (Line(points={{-78,142},{-74,142},{-74,
          150},{-72,150}}, color={255,0,255}));
  connect(edg1.y, cha.uDow) annotation (Line(points={{-48,150},{-34,150},{-34,
          -178},{-22,-178}}, color={255,0,255}));
  connect(addInt1.y, intToRea1[1].u) annotation (Line(points={{-138,-176},{-130,
          -176},{-130,-190},{-122,-190}}, color={255,127,0}));
  connect(addInt.y, intToRea1[2].u) annotation (Line(points={{-138,-216},{-130,
          -216},{-130,-190},{-122,-190}}, color={255,127,0}));
  connect(intToRea1.y, lim.u)
    annotation (Line(points={{-98,-190},{-92,-190}}, color={0,0,127}));
  connect(lim.y, reaToInt1.u)
    annotation (Line(points={{-68,-190},{-62,-190}}, color={0,0,127}));
  connect(reaToInt1[1].y, cha.uAvaUp) annotation (Line(points={{-38,-190},{-26,
          -190},{-26,-168},{-22,-168}}, color={255,127,0}));
  connect(reaToInt1[2].y, cha.uAvaDow) annotation (Line(points={{-38,-190},{-26,
          -190},{-26,-172},{-22,-172}}, color={255,127,0}));
  connect(hys2.y, and2.u2) annotation (Line(points={{-198,290},{-190,290},{-190,
          242},{-182,242}}, color={255,0,255}));
  connect(and2.y, tim1.u) annotation (Line(points={{-158,250},{-152,250},{-152,
          290},{-142,290}}, color={255,0,255}));
  connect(uStaChaProEnd, not3.u) annotation (Line(points={{-420,-260},{-280,
          -260},{-280,256},{-240,256},{-240,250},{-222,250}}, color={255,0,255}));
  connect(not3.y, and2.u1)
    annotation (Line(points={{-198,250},{-182,250}}, color={255,0,255}));
  connect(not3.y, and1.u1) annotation (Line(points={{-198,250},{-194,250},{-194,
          210},{-122,210}}, color={255,0,255}));
  connect(or2.y, and1.u2) annotation (Line(points={{-118,150},{-114,150},{-114,
          180},{-130,180},{-130,202},{-122,202}}, color={255,0,255}));
  connect(and1.y, tim.u) annotation (Line(points={{-98,210},{-90,210},{-90,180},
          {-108,180},{-108,150},{-102,150}}, color={255,0,255}));
  annotation (defaultComponentName = "staSetCon",
        Icon(coordinateSystem(extent={{-100,-180},{100,180}}),
             graphics={
        Rectangle(
        extent={{-100,-180},{100,180}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,210},{110,172}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-400,-300},{120,320}})),
Documentation(info="<html>
<p>
The sequence is a boiler stage status setpoint controller that outputs the 
boiler stage integer index <code>ySta</code>, boiler stage change trigger signals
<code>yChaEdg</code>, <code>yChaUpEdg</code>, <code>yChaDowEdg</code>, and a boiler
status vector for the current stage <code>yBoi</code>.
</p>
<p>
Implemented according to ASHRAE RP-1711 March 2020 Draft, section 5.3.3.10.
</p>
<p>
The controller contains the following subsequences:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement</a> to calculate
the capacity requirement.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Configurator\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Configurator</a> to allow the user 
to provide the boiler plant configuration parameters such as boiler design and minimal capacities and types. It 
calculates the design and minimal stage capacities, stage type and stage availability.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Status\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Status</a> to calculate
the next higher and lower available stages.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities</a> to calculate
design and minimal stage capacities for current and next available higher and lower stage.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Up</a> to generate
a stage up signal.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down</a> to generate
a stage down signal.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Change\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Change</a> to set the stage
based on the initial stage signal and stage up and down signals.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.BoilerIndices\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.BoilerIndices</a> to generate
the boiler index vector for a given stage.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
June 22, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end SetpointController_baseline;
