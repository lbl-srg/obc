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

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput THotWatSupResReq
    "Hot water supply temperature reset requests"
    annotation (Placement(transformation(extent={{1420,-80},{1460,-40}}),
      iconTransformation(extent={{440,-100},{480,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    "Hot water plant requests"
    annotation (Placement(transformation(extent={{1420,-120},{1460,-80}}),
      iconTransformation(extent={{440,-140},{480,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput TChiWatSupResReq
    "Chilled water supply temperature reset requests"
    annotation (Placement(transformation(extent={{1420,20},{1460,60}}),
      iconTransformation(extent={{440,-20},{480,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiWatPlaReq
    "Chilled water plant requests"
    annotation (Placement(transformation(extent={{1420,-20},{1460,20}}),
      iconTransformation(extent={{440,-60},{480,-20}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumHeaValReq(
    final nin=6)
    "Add hot water temperature reset requests from all heating coils"
    annotation (Placement(transformation(extent={{1360,-70},{1380,-50}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumHeaPlaReq(
    final nin=6)
    "Add boiler plant supply requests from all heating coils"
    annotation (Placement(transformation(extent={{1360,-110},{1380,-90}})));

  SystemModel.VAV.PlantRequests mulAHUPlaReq
    "Generate hot water and chilled water requests from AHU"
    annotation (Placement(transformation(extent={{380,-100},{400,-80}})));

initial equation
  assert(abs(sizDat.mHeaWatAHU_flow_nominal - sizDat.xxx) < 1E-3, "Make sure sizDat.mHeaWatAHU_flow_nominal has value of sizDat.xxx = " + String(sizDat.xxx));
equation
  connect(mulSumHeaValReq.y, THotWatSupResReq)
    annotation (Line(points={{1382,-60},{1440,-60}}, color={255,127,0}));
  connect(mulSumHeaPlaReq.y, yHotWatPlaReq)
    annotation (Line(points={{1382,-100},{1440,-100}}, color={255,127,0}));
  connect(conVAV.yHeaValResReq, mulSumHeaValReq.u[1:5]) annotation (Line(points={{642,105},
          {648,105},{648,-63.5},{1358,-63.5}},           color={255,127,0}));
  connect(conVAV.yHeaPlaReq, mulSumHeaPlaReq.u[1:5]) annotation (Line(points={{642,
          101.667},{644,101.667},{644,-103.5},{1358,-103.5}},
                                                          color={255,127,0}));
  connect(TSup.T, mulAHUPlaReq.TAirSup) annotation (Line(points={{340,-29},{340,
          -20},{360,-20},{360,-82},{378,-82}}, color={0,0,127}));
  connect(conAHU.TSupSet, mulAHUPlaReq.TAirSupSet) annotation (Line(points={{
          424,608},{434,608},{434,0},{364,0},{364,-87},{378,-87}}, color={0,0,
          127}));
  connect(valCooCoi.y_actual, mulAHUPlaReq.uCooCoi_actual) annotation (Line(
        points={{213,-205},{213,-196},{364,-196},{364,-93},{378,-93}}, color={0,
          0,127}));
  connect(valHeaCoi.y_actual, mulAHUPlaReq.uHeaCoi_actual) annotation (Line(
        points={{121,-205},{121,-190},{368,-190},{368,-98},{378,-98}}, color={0,
          0,127}));
  connect(mulAHUPlaReq.yHotWatPlaReq, mulSumHeaPlaReq.u[6]) annotation (Line(
        points={{402,-98},{1358,-98},{1358,-105.833}}, color={255,127,0}));
  connect(mulAHUPlaReq.yHotWatResReq, mulSumHeaValReq.u[6]) annotation (Line(
        points={{402,-93},{552,-93},{552,-94},{634,-94},{634,-65.8333},{1358,
          -65.8333}}, color={255,127,0}));
  connect(mulAHUPlaReq.yChiWatResReq, TChiWatSupResReq) annotation (Line(points=
         {{402,-82},{1290,-82},{1290,40},{1440,40}}, color={255,127,0}));
  connect(mulAHUPlaReq.yChiPlaReq, yChiWatPlaReq) annotation (Line(points={{402,
          -87},{1300,-87},{1300,0},{1440,0}}, color={255,127,0}));
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
