within SystemModel.VAV;
model Guideline36
  "Variable air volume flow system with terminal reheat that serves five thermal zones"
  extends Buildings.Examples.VAVReheat.BaseClasses.Guideline36(
    final mCooVAV_flow_nominal=sizDat.mVAV_flow_nominal,
    final mCooAir_flow_nominal=sizDat.mCooAHU_flow_nominal,
    final THeaWatInl_nominal=sizDat.THeaWatSup_nominal,
    final mHeaWat_flow_nominal=sizDat.mHeaWatAHU_flow_nominal,
    conVAV(
      final VDisCooSetMax_flow=sizDat.mCooVAV_flow_nominal/1.2,
      final VDisSetMin_flow=sizDat.mMinVAV_flow_nominal/1.2,
      final VDisHeaSetMax_flow=sizDat.mHeaVAV_flow_nominal/1.2,
      final VDisConMin_flow=sizDat.mMinVAV_flow_nominal/1.2,
      each dTDisZonSetMax=sizDat.THeaDisVAV_nominal - 293.15,
      each TDisMin=sizDat.TCooDisVAV_nominal,
      each have_heaPla=true),
    VAVBox(
      final mCooAir_flow_nominal=sizDat.mVAV_flow_nominal,
      each final THeaWatInl_nominal=sizDat.THeaWatSup_nominal,
      each final THeaWatOut_nominal=sizDat.THeaWatRet_nominal,
      each final THeaAirDis_nominal = sizDat.THeaDisAHU_nominal,
      each terHea(show_T=true),
      final QHea_flow_nominal=sizDat.QHeaVAV_flow_nominal),
    conAHU(
      final TSupSetMin=sizDat.TCooDisVAV_nominal,
      final TSupSetDes=sizDat.TCooDisVAV_nominal),
    heaCoi(
      final m2_flow_nominal=sizDat.mHeaAHU_flow_nominal,
      final dp2_nominal=0,
      final Q_flow_nominal=sizDat.QHeaAHU_flow_nominal,
      final T_a1_nominal=sizDat.THeaWatSup_nominal),
    cooCoi(
      dp2_nominal=200 + 200 + 100 + 40));

  parameter SystemModel.SizingParameters sizDat
    "Sizing data"
    annotation (Placement(transformation(extent={{-322,560},{-302,580}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaValTerReq
    "Hot water temperature reset requests from terminal boxes"
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

initial equation
  assert(abs(sizDat.mHeaWatAHU_flow_nominal - sizDat.xxx) < 1E-3, "Make sure sizDat.mHeaWatAHU_flow_nominal has value of sizDat.xxx = " + String(sizDat.xxx));
equation
  connect(valHeaCoi.y_actual, heaReq.uHeaVal) annotation (Line(points={{121,-205},
          {121,-190},{250,-190},{250,-84},{258,-84}}, color={0,0,127}));
  connect(TSup.T, heaReq.TDis) annotation (Line(points={{340,-29},{340,-20},{240,
          -20},{240,-80},{258,-80}}, color={0,0,127}));
  connect(conAHU.TSupSet, heaReq.TDisHeaSet) annotation (Line(points={{424,608},
          {428,608},{428,-60},{250,-60},{250,-76},{258,-76}}, color={0,0,127}));
  connect(mulSumHeaValReq.y,yHeaValTerReq)
    annotation (Line(points={{1382,-60},{1440,-60}}, color={255,127,0}));
  connect(mulSumHeaPlaReq.y, yHeaPlaReq)
    annotation (Line(points={{1382,-100},{1440,-100}}, color={255,127,0}));
  connect(heaReq.yHeaPlaReq, mulSumHeaPlaReq.u[1]) annotation (Line(points={{282,-84},
          {1338,-84},{1338,-102.917},{1358,-102.917}},
                                                    color={255,127,0}));
  connect(conVAV.yHeaValResReq, mulSumHeaValReq.u[1:5]) annotation (Line(points={{642,105},
          {648,105},{648,-57.2},{1358,-57.2}},           color={255,127,0}));
  connect(conVAV.yHeaPlaReq, mulSumHeaPlaReq.u[2:6]) annotation (Line(points={{642,
          101.667},{644,101.667},{644,-97.0833},{1358,-97.0833}},
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
