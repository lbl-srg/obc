within SystemModel.VAV;
model Guideline36
  "Variable air volume flow system with terminal reheat that serves five thermal zones"
  extends Buildings.Examples.VAVReheat.BaseClasses.Guideline36(
    final mVAV_flow_nominal=sizDat.mVAV_flow_nominal,
    final m_flow_nominal=sizDat.m_flow_nominal,
    final THotWatInl_nominal=sizDat.THotWatInl_nominal,
    conVAV(each have_heaPla=true),
    VAVBox(
      m_flow_nominal=sizDat.mVAV_flow_nominal,
      ratVFloHea=sizDat.mVAVHea_flow_nominal ./ sizDat.mVAV_flow_nominal,
      QHea_flow_nominal=sizDat.QVAVHea_flow_nominal));

  parameter SizingParameters sizDat
    "Sizing data"
    annotation (Placement(transformation(extent={{-322,560},{-302,580}})));

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

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumHeaValReq(final nin=5)
    "Add hot water temperature reset requests from all heating coils"
    annotation (Placement(transformation(extent={{1360,-70},{1380,-50}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumHeaPlaReq(final nin=6)
    "Add boiler plant supply requests from all heating coils"
    annotation (Placement(transformation(extent={{1360,-110},{1380,-90}})));

equation
  connect(valHeaCoi.y_actual, heaReq.uHeaVal) annotation (Line(points={{121,-205},
          {121,-190},{250,-190},{250,-84},{258,-84}}, color={0,0,127}));
  connect(TSup.T, heaReq.TDis) annotation (Line(points={{340,-29},{340,-20},{240,
          -20},{240,-80},{258,-80}}, color={0,0,127}));
  connect(conAHU.TSupSet, heaReq.TDisHeaSet) annotation (Line(points={{424,608},
          {428,608},{428,-60},{250,-60},{250,-76},{258,-76}}, color={0,0,127}));
  connect(mulSumHeaValReq.y, yHeaValResReq)
    annotation (Line(points={{1382,-60},{1440,-60}}, color={255,127,0}));
  connect(mulSumHeaPlaReq.y, yHeaPlaReq)
    annotation (Line(points={{1382,-100},{1440,-100}}, color={255,127,0}));
  connect(heaReq.yHeaPlaReq, mulSumHeaPlaReq.u[1]) annotation (Line(points={{282,-84},
          {1338,-84},{1338,-94.1667},{1358,-94.1667}},
                                                    color={255,127,0}));
  connect(conVAV.yHeaValResReq, mulSumHeaValReq.u[1:5]) annotation (Line(points=
         {{642,105},{648,105},{648,-65.6},{1358,-65.6}}, color={255,127,0}));
  connect(conVAV.yHeaPlaReq, mulSumHeaPlaReq.u[2:6]) annotation (Line(points={{642,
          101.667},{644,101.667},{644,-105.833},{1358,-105.833}},
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