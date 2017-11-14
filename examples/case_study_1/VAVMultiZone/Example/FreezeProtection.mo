within VAVMultiZone.Example;
model FreezeProtection "Model for freeze protection"
  extends Buildings.Examples.VAVReheat.Guideline36(
    weaDat(TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.Input,
           TDewPoiSou=Buildings.BoundaryConditions.Types.DataSource.Input),
           conAHU(use_TMix=false));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDatOri(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
      computeWetBulbTemperature=false)
    "Weather data reader for original TMY3 data"
    annotation (Placement(transformation(extent={{-520,180},{-500,200}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TDryBul(
   p=-10,
   k=1)
    "Drybulb temperature"
    annotation (Placement(transformation(extent={{-440,180},{-420,200}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBusOri
    "Weather data bus with original TMY3 data"
    annotation (Placement(transformation(extent={{-484,180},{-464,200}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TDewPoi(p=-10, k=1)
    "Dewpoint temperature"
    annotation (Placement(transformation(extent={{-440,220},{-420,240}})));
equation
  connect(weaDat.TDryBul_in, TDryBul.y) annotation (Line(points={{-391,189},{-406,
          189},{-406,190},{-419,190}}, color={0,0,127}));
  connect(weaDatOri.weaBus, weaBusOri) annotation (Line(
      points={{-500,190},{-474,190}},
      color={255,204,51},
      thickness=0.5));
  connect(TDryBul.u, weaBusOri.TDryBul)
    annotation (Line(points={{-442,190},{-474,190}}, color={0,0,127}));
  connect(TDewPoi.y, weaDat.TDewPoi_in) annotation (Line(points={{-419,230},{
          -404,230},{-404,191.2},{-391,191.2}}, color={0,0,127}));
  connect(TDewPoi.u, weaBusOri.TDewPoi) annotation (Line(points={{-442,230},{-474,
          230},{-474,190}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-540,-400},{1660,640}})), Icon(
        coordinateSystem(extent={{-540,-400},{1660,640}})));
end FreezeProtection;
