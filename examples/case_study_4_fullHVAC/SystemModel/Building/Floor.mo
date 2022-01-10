within SystemModel.Building;
model Floor "Model of a floor of the building"
  extends
    Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.BaseClasses.Floor(
    idfName=Modelica.Utilities.Files.loadResource(
      "modelica://SystemModel/Resources/Data/VAV/BaseClasses/Floor/building_medium_5A.idf"),
    weaName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    sou(
      zoneName="Perimeter_bot_ZN_1", nPorts=6),
    eas(
      zoneName="Perimeter_bot_ZN_2", nPorts=6),
    nor(
      zoneName="Perimeter_bot_ZN_3", nPorts=6),
    wes(
      zoneName="Perimeter_bot_ZN_4", nPorts=6),
    cor(
      zoneName="Core_bottom", nPorts=12),
    att(
      zoneName="FirstFloor_Plenum",
      nPorts=6,
      T_start=293.15),
    final VRooCor=2698.04,
    final VRooSou=568.77,
    final VRooNor=568.77,
    final VRooEas=360.078,
    final VRooWes=360.055,
    final AFloCor=cor.AFlo,
    final AFloSou=sou.AFlo,
    final AFloNor=nor.AFlo,
    final AFloEas=eas.AFlo,
    final AFloWes=wes.AFlo,
    opeWesCor(
      wOpe=4),
    opeSouCor(
      wOpe=9),
    opeNorCor(
      wOpe=9),
    opeEasCor(
      wOpe=4),
    leaWes(
      s=buiAsp),
    leaSou(
      s=1/buiAsp),
    leaNor(
      s=1/buiAsp),
    leaEas(
      s=buiAsp));

  Modelica.Fluid.Interfaces.FluidPort_b portAtt(
    redeclare package Medium = Medium) "Fluid outlet of attic zone"
    annotation (Placement(transformation(extent={{274,-92},{298,-72}}),
        iconTransformation(extent={{292,-108},{308,-94}})));
protected
  constant Real buiAsp = 33.27/49.91 "Building aspect ratio";
equation
  connect(sou.ports[6], att.ports[1]) annotation (Line(points={{164,-43.1},{164,
          -66},{320,-66},{320,-59.1}},
                                     color={0,127,255}));
  connect(eas.ports[6], att.ports[2]) annotation (Line(points={{320,68.9},{320,62},
          {360,62},{360,-66},{320,-66},{320,-59.1}},
                                                   color={0,127,255}));
  connect(nor.ports[6], att.ports[3]) annotation (Line(points={{164,116.9},{164,
          108},{238,108},{238,-68},{320,-68},{320,-59.1}},
                                                         color={0,127,255}));
  connect(wes.ports[6], att.ports[4]) annotation (Line(points={{32,58.9},{32,40},
          {10,40},{10,-68},{320,-68},{320,-59.1}},
                                                 color={0,127,255}));
  connect(cor.ports[12], att.ports[5]) annotation (Line(points={{164,60.9},{164,
          20},{200,20},{200,-68},{320,-68},{320,-59.1}},
                                                       color={0,127,255}));
  connect(portAtt, att.ports[6]) annotation (Line(points={{286,-82},{286,-59.1},
          {320,-59.1}},
                      color={0,127,255}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-160,-100},{380,500}},
        initialScale=0.1)),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-80,-80},{380,180}})),
    Documentation(
      info="<html>
<p>
Model of one floor of the DOE reference office building.
</p>
<h4>Implementation</h4>
<p>
This model is identical to
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.BaseClasses.Floor\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.BaseClasses.Floor</a>
except for the idf file. The model is copied because the idf file is a protected parameter
and hence cannot be modified if the model were instantiated.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 7, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Floor;
