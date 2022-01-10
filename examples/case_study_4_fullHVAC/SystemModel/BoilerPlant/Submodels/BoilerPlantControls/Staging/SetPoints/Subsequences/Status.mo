within SystemModel.BoilerPlant.Submodels.BoilerPlantControls.Staging.SetPoints.Subsequences;
block Status
  "Outputs current stage boiler index vector, current, next available lower and
  higher stage index and whether current stage is the lowest and/or the highest
  available stage"

  parameter Integer nSta = 5
    "Number of stages";

  parameter Integer nBoi = 3
    "Number of boilers";

  parameter Integer staMat[nSta, nBoi] = {{1,0,0},{0,1,1},{1,1,0},{0,1,1},{1,1,1}}
    "Staging matrix with stages in rows and boilers in columns";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva[nSta](
    final start = fill(true, nSta))
    "Stage availability status"
    annotation (Placement(transformation(extent={{-460,-100},{-420,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta,
    final start = 0)
    "Current boiler stage"
    annotation (Placement(transformation(extent={{-460,60},{-420,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHig
    "If true current stage is the highest available stage"
    annotation (Placement(transformation(extent={{440,20},{480,60}}),
      iconTransformation(extent={{100,-30},{140,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLow
    "If true current stage is the lowest available stage"
    annotation (Placement(transformation(extent={{440,-100},{480,-60}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAvaCur
    "Current stage availability status"
    annotation (Placement(transformation(extent={{440,-260},{480,-220}}),
      iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAvaUp(
    final min=0,
    final max=nSta)
    "Next available higher stage"
    annotation (Placement(transformation(extent={{440,60},{480,100}}),
      iconTransformation(extent={{100,50},{140,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAvaDow(
    final min=0,
    final max=nSta)
    "Next available lower stage"
    annotation (Placement(
      transformation(extent={{440,-60},{480,-20}}),
      iconTransformation(extent={{100,20},{140,60}})));

protected
  final parameter Integer staInd[nSta] = {i for i in 1:nSta}
    "Stage index vector";

  final parameter Integer staIndMat[nSta, nBoi] = {j for i in 1:nBoi, j in 1:nSta}
    "Matrix of staging matrix dimensions with stage indices in each column";

  final parameter Integer lowDia[nSta, nSta] = {if i<=j then 1 else 0 for i in 1:nSta, j in 1:nSta}
    "Lower diagonal unit matrix";

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Not unavailable"
    annotation (Placement(transformation(extent={{20,-250},{40,-230}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi2
    "Switch"
    annotation (Placement(transformation(extent={{100,-220},{120,-200}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi3
    "Switch"
    annotation (Placement(transformation(extent={{360,70},{380,90}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nSta)
    "Replicates signal to a length equal the stage count"
    annotation (Placement(transformation(extent={{-300,190},{-280,210}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt1[nSta]
    "Outputs a vector of stage indices for any available stage above the current stage"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staIndx[nSta](
    final k=staInd)
    "Stage index vector"
    annotation (Placement(transformation(extent={{-240,120},{-220,140}})));

  Buildings.Controls.OBC.CDL.Integers.Greater intGre[nSta]
    "Identifies stages that are above the current stage"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nSta](
    final integerTrue=fill(1, nSta),
    final integerFalse=fill(nSta + 1, nSta))
    "Type converter that outputs a value larger than the stage count for any false input"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Buildings.Controls.OBC.CDL.Logical.And and2[nSta]
    "Identifies any available stages above the current stage"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMin multiMin(
    final nin=nSta)
    "Minimum of a vector input"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Type converter"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

  Buildings.Controls.OBC.CDL.Integers.Less intLes[nSta]
    "Identifies stages that are below the current stage"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));

  Buildings.Controls.OBC.CDL.Logical.And and1[nSta]
    "Identifies any available stage below the current stage"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[nSta](
    final integerTrue=fill(1, nSta),
    final integerFalse=fill(0, nSta))
    "Type converter that outputs zero for any false input"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt2[nSta]
    "Outputs vector of stage indices for any available stage below the current stage"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea3[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(
    final nin=nSta)
    "Maximum of a vector input"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Type converter"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final t=nSta)
    "True if there are no higher available stages"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi
    "If no higher stage is available, output current stage"
    annotation (Placement(transformation(extent={{180,100},{200,120}})));

  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(
    final t=0)
    "If the current stage is the lowest available the input value equals 0"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi1
    "Logical switch"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaAva(
    final allowOutOfRange=true,
    final outOfRangeValue=nSta + 1,
    final nin=nSta)
    "Extracts stage availability for the current stage"
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=0.5)
    "Detects if the current stage becomes unavailable"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nSta](
    final realTrue=fill(1, nSta),
    final realFalse=fill(0, nSta))
    "Type converter"
    annotation (Placement(transformation(extent={{-240,-160},{-220,-140}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert cheStaAva1(
    final message="There are no available boiler stages. The staging cannot be performed.")
    "Checks if any stage is available"
    annotation (Placement(transformation(extent={{-340,-140},{-320,-120}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nSta)
    "Logical or"
    annotation (Placement(transformation(extent={{-380,-140},{-360,-120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Lowest allowed stage"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical And"
    annotation (Placement(transformation(extent={{220,70},{240,90}})));

equation
  connect(staIndx.y, intGre.u1) annotation (Line(points={{-218,130},{-200,130},{
          -200,90},{-182,90}},  color={255,127,0}));
  connect(intRep.y, intGre.u2) annotation (Line(points={{-278,200},{-260,200},{
          -260,82},{-182,82}},
                 color={255,127,0}));
  connect(intGre.y, and2.u1) annotation (Line(points={{-158,90},{-150,90},{-150,
          80},{-142,80}},color={255,0,255}));
  connect(uAva, and2.u2) annotation (Line(points={{-440,-80},{-280,-80},{-280,
          72},{-142,72}}, color={255,0,255}));
  connect(staIndx.y, proInt1.u1) annotation (Line(points={{-218,130},{-70,130},{
          -70,116},{-62,116}},  color={255,127,0}));
  connect(booToInt1.y, proInt1.u2) annotation (Line(points={{-78,80},{-70,80},{-70,
          104},{-62,104}},     color={255,127,0}));
  connect(proInt1.y, intToRea1.u)
    annotation (Line(points={{-38,110},{-22,110}}, color={255,127,0}));
  connect(intToRea1.y, multiMin.u) annotation (Line(points={{2,110},{18,110}},
          color={0,0,127}));
  connect(intRep.y, intLes.u2) annotation (Line(points={{-278,200},{-260,200},{
          -260,-78},{-182,-78}}, color={255,127,0}));
  connect(staIndx.y, intLes.u1) annotation (Line(points={{-218,130},{-200,130},{
          -200,-70},{-182,-70}},  color={255,127,0}));
  connect(uAva, and1.u2) annotation (Line(points={{-440,-80},{-280,-80},{-280,
          -98},{-142,-98}}, color={255,0,255}));
  connect(intLes.y, and1.u1) annotation (Line(points={{-158,-70},{-150,-70},{-150,
          -90},{-142,-90}},      color={255,0,255}));
  connect(proInt2.y, intToRea3.u)
    annotation (Line(points={{-38,-70},{-22,-70}}, color={255,127,0}));
  connect(intToRea3.y, multiMax.u) annotation (Line(points={{2,-70},{18,-70}},
    color={0,0,127}));
  connect(staIndx.y, proInt2.u1) annotation (Line(points={{-218,130},{-200,130},
          {-200,-40},{-70,-40},{-70,-64},{-62,-64}}, color={255,127,0}));
  connect(booToInt2.y, proInt2.u2) annotation (Line(points={{-78,-90},{-70,-90},
          {-70,-76},{-62,-76}}, color={255,127,0}));
  connect(multiMax.y, reaToInt1.u)
    annotation (Line(points={{42,-70},{58,-70}}, color={0,0,127}));
  connect(multiMin.y, reaToInt.u)
    annotation (Line(points={{42,110},{58,110}}, color={0,0,127}));
  connect(reaToInt.y, intGreThr.u)
    annotation (Line(points={{82,110},{98,110}}, color={255,127,0}));
  connect(intGreThr.y, intSwi.u2)
    annotation (Line(points={{122,110},{178,110}}, color={255,0,255}));
  connect(intGreThr.y, yHig) annotation (Line(points={{122,110},{140,110},{140,40},
          {460,40}},     color={255,0,255}));
  connect(reaToInt1.y, intLesEquThr.u)
    annotation (Line(points={{82,-70},{98,-70}}, color={255,127,0}));
  connect(intLesEquThr.y, intSwi1.u2)
    annotation (Line(points={{122,-70},{178,-70}}, color={255,0,255}));
  connect(intLesEquThr.y, yLow) annotation (Line(points={{122,-70},{140,-70},{140,
          -90},{340,-90},{340,-80},{460,-80}},     color={255,0,255}));
  connect(uAva, booToRea.u) annotation (Line(points={{-440,-80},{-280,-80},{
          -280,-150},{-242,-150}}, color={255,0,255}));
  connect(and2.y, booToInt1.u)
    annotation (Line(points={{-118,80},{-102,80}}, color={255,0,255}));
  connect(lesThr.y, intSwi2.u2) annotation (Line(points={{-138,-150},{0,-150},{0,
          -210},{98,-210}},   color={255,0,255}));
  connect(intGreThr.y, and4.u1)
    annotation (Line(points={{122,110},{140,110},{140,80},{218,80}},
                                  color={255,0,255}));
  connect(lesThr.y, and4.u2)
    annotation (Line(points={{-138,-150},{210,-150},{210,72},{218,72}},
                                                               color={255,0,255}));
  connect(and4.y, intSwi3.u2)
    annotation (Line(points={{242,80},{358,80}}, color={255,0,255}));
  connect(yAvaUp, yAvaUp)
    annotation (Line(points={{460,80},{460,80}}, color={255,127,0}));
  connect(uAva, mulOr.u) annotation (Line(points={{-440,-80},{-400,-80},{-400,-130},
          {-392,-130},{-392,-130},{-382,-130}}, color={255,0,255}));
  connect(mulOr.y, cheStaAva1.u)
    annotation (Line(points={{-358,-130},{-342,-130}},   color={255,0,255}));
  connect(booToRea.y, extStaAva.u)
    annotation (Line(points={{-218,-150},{-202,-150}}, color={0,0,127}));
  connect(extStaAva.y, lesThr.u)
    annotation (Line(points={{-178,-150},{-162,-150}}, color={0,0,127}));
  connect(and1.y, booToInt2.u)
    annotation (Line(points={{-118,-90},{-102,-90}}, color={255,0,255}));
  connect(u, intRep.u) annotation (Line(points={{-440,80},{-320,80},{-320,200},
          {-302,200}}, color={255,127,0}));
  connect(u, extStaAva.index) annotation (Line(points={{-440,80},{-300,80},{
          -300,-180},{-190,-180},{-190,-162}}, color={255,127,0}));
  connect(conInt.y, intSwi1.u1) annotation (Line(points={{122,-30},{160,-30},{160,
          -62},{178,-62}},     color={255,127,0}));
  connect(intSwi1.y, yAvaDow) annotation (Line(points={{202,-70},{320,-70},{320,
          -40},{460,-40}}, color={255,127,0}));
  connect(intSwi1.y, intSwi2.u1) annotation (Line(points={{202,-70},{220,-70},{220,
          -160},{80,-160},{80,-202},{98,-202}},     color={255,127,0}));
  connect(intSwi2.y, intSwi3.u1) annotation (Line(points={{122,-210},{350,-210},
          {350,88},{358,88}}, color={255,127,0}));
  connect(u, intSwi2.u3) annotation (Line(points={{-440,80},{-300,80},{-300,
          -218},{98,-218}}, color={255,127,0}));
  connect(intSwi.y, intSwi3.u3) annotation (Line(points={{202,110},{340,110},{340,
          72},{358,72}},     color={255,127,0}));
  connect(u, intSwi.u1) annotation (Line(points={{-440,80},{-300,80},{-300,160},
          {160,160},{160,118},{178,118}}, color={255,127,0}));
  connect(reaToInt.y, intSwi.u3) annotation (Line(points={{82,110},{90,110},{90,
          90},{160,90},{160,102},{178,102}}, color={255,127,0}));
  connect(reaToInt1.y, intSwi1.u3) annotation (Line(points={{82,-70},{90,-70},{90,
          -100},{170,-100},{170,-78},{178,-78}},    color={255,127,0}));
  connect(intSwi3.y, yAvaUp)
    annotation (Line(points={{382,80},{460,80}}, color={255,127,0}));
  connect(lesThr.y, not1.u) annotation (Line(points={{-138,-150},{0,-150},{0,-240},
          {18,-240}}, color={255,0,255}));
  connect(not1.y, yAvaCur)
    annotation (Line(points={{42,-240},{460,-240}}, color={255,0,255}));
  annotation (defaultComponentName = "sta",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-420,-280},{440,280}})),
  Documentation(info="<html>
    <p>
    This subsequence is not directly specified in 1711 as it provides a side
    calculation pertaining to generalization of the staging sequences for any number
    of boilers and stages provided by the user.
    </p>
    <p>
    Based on the current stage <span style=\"font-family: monospace;\">u</span>
    and stage availability vector <span style=\"font-family: monospace;\">uAva</span>
    the sequence outputs:
    </p>
    <ul>
    <li>
    Integer indices of: the current stage <span style=\"font-family: monospace;\">y</span>,
    first available higher stage <span style=\"font-family: monospace;\">yUp</span>
    and the first available lower stage <span style=\"font-family: monospace;\">yDown</span>.
    </li>
    <li>
    Boolean status outputs to show if the current operating stage 
    <span style=\"font-family: monospace;\">u</span> is:
    </li>
    <li>
    <ul>
    <li>
    Available, <span style=\"font-family: monospace;\">u</span>
    </li>
    <li>
    The highest available stage, <span style=\"font-family: monospace;\">yHig</span> 
    </li>
    <li>
    The lowest available stage, <span style=\"font-family: monospace;\">yLow</span>
    </li>
    </ul>
    </li>
    </ul>
    <p>
    The purpose of this sequence is to: 
    </p>
    <ul>
    <li>
    Provide inputs for the stage up and down conditionals such that staging into
    unavailable stages is avoided.
    </li>
    <li>
    Change the stage to the first available higher stage in an event that the
    current stage becomes unavailable. 
    </li>
    </ul>
    <p>
    The sequences are implemented according to 1711 March 2020 Draft, section 5.3.3.9.
    </p>
    <p align=\"center\">
    <img alt=\"Validation plot for Status\"
    src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Status.png\"/>
    <br/>
    Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Status\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Status</a>.
    </p>
    </html>",
    revisions="<html>
    <ul>
    <li>
    May 22, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end Status;
