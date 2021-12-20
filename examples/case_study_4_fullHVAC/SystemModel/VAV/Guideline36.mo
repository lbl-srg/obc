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
        ACHEas*VRooEas + ACHNor*VRooNor + ACHWes*VRooWes)*conv,
    conVAVCor(have_heaPla=true),
    conVAVSou(have_heaPla=true),
    conVAVEas(have_heaPla=true),
    conVAVNor(have_heaPla=true),
    conVAVWes(have_heaPla=true));

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

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaValResReq
    "Hot water temperature reset requests"
    annotation (Placement(transformation(extent={{1420,-80},{1460,-40}}),
      iconTransformation(extent={{440,-80},{480,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaPlaReq
    "Heating plant request"
    annotation (Placement(transformation(extent={{1420,-120},{1460,-80}}),
      iconTransformation(extent={{440,-122},{480,-82}})));

  SystemModel.VAV.HeatingRequests heaReq
    "Heating request calculator for AHU heating coil"
    annotation (Placement(transformation(extent={{260,-90},{280,-70}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=6)
    "Add hot water temperature reset requests from all heating coils"
    annotation (Placement(transformation(extent={{1360,-70},{1380,-50}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt1(
    final nin=6)
    "Add boiler plant supply requests from all heating coils"
    annotation (Placement(transformation(extent={{1360,-110},{1380,-90}})));

equation
  connect(valHeaCoi.y_actual, heaReq.uHeaVal) annotation (Line(points={{121,-205},
          {121,-190},{250,-190},{250,-84},{258,-84}}, color={0,0,127}));
  connect(TSup.T, heaReq.TDis) annotation (Line(points={{340,-29},{340,-20},{240,
          -20},{240,-80},{258,-80}}, color={0,0,127}));
  connect(conAHU.TSupSet, heaReq.TDisHeaSet) annotation (Line(points={{424,608},
          {428,608},{428,-60},{250,-60},{250,-76},{258,-76}}, color={0,0,127}));
  connect(mulSumInt.y, yHeaValResReq)
    annotation (Line(points={{1382,-60},{1440,-60}}, color={255,127,0}));
  connect(mulSumInt1.y, yHeaPlaReq)
    annotation (Line(points={{1382,-100},{1440,-100}}, color={255,127,0}));
  connect(heaReq.yHeaValResReq, mulSumInt.u[1]) annotation (Line(points={{282,-76},
          {1340,-76},{1340,-54.1667},{1358,-54.1667}},
                                                 color={255,127,0}));
  connect(heaReq.yHeaPlaReq, mulSumInt1.u[1]) annotation (Line(points={{282,-84},
          {1340,-84},{1340,-94.1667},{1358,-94.1667}},
                                               color={255,127,0}));
  connect(conVAVCor.yHeaValResReq, mulSumInt.u[2]) annotation (Line(points={{552,89},
          {558,89},{558,-76},{1340,-76},{1340,-56.5},{1358,-56.5}},     color={255,
          127,0}));
  connect(conVAVSou.yHeaValResReq, mulSumInt.u[3]) annotation (Line(points={{724,89},
          {730,89},{730,-76},{1340,-76},{1340,-58.8333},{1358,-58.8333}},
        color={255,127,0}));
  connect(conVAVEas.yHeaValResReq, mulSumInt.u[4]) annotation (Line(points={{902,89},
          {910,89},{910,-76},{1340,-76},{1340,-61.1667},{1358,-61.1667}},
        color={255,127,0}));
  connect(conVAVNor.yHeaValResReq, mulSumInt.u[5]) annotation (Line(points={{1060,
          89},{1064,89},{1064,-76},{1340,-76},{1340,-63.5},{1358,-63.5}}, color=
         {255,127,0}));
  connect(conVAVWes.yHeaValResReq, mulSumInt.u[6]) annotation (Line(points={{1262,89},
          {1268,89},{1268,-76},{1340,-76},{1340,-65.8333},{1358,-65.8333}},
        color={255,127,0}));
  connect(conVAVCor.yHeaPlaReq, mulSumInt1.u[2]) annotation (Line(points={{552,
          85.6667},{554,85.6667},{554,-84},{1340,-84},{1340,-96.5},{1358,-96.5}},
                                                                         color={
          255,127,0}));
  connect(conVAVSou.yHeaPlaReq, mulSumInt1.u[3]) annotation (Line(points={{724,
          85.6667},{724,-84},{1340,-84},{1340,-98.8333},{1358,-98.8333}},
                                                                 color={255,127,
          0}));
  connect(conVAVEas.yHeaPlaReq, mulSumInt1.u[4]) annotation (Line(points={{902,
          85.6667},{904,85.6667},{904,-84},{1340,-84},{1340,-101.167},{1358,
          -101.167}},
        color={255,127,0}));
  connect(conVAVNor.yHeaPlaReq, mulSumInt1.u[5]) annotation (Line(points={{1060,
          85.6667},{1062,85.6667},{1062,-84},{1340,-84},{1340,-103.5},{1358,
          -103.5}},
        color={255,127,0}));
  connect(conVAVWes.yHeaPlaReq, mulSumInt1.u[6]) annotation (Line(points={{1262,
          85.6667},{1264,85.6667},{1264,-84},{1340,-84},{1340,-105.833},{1358,
          -105.833}},
        color={255,127,0}));
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
