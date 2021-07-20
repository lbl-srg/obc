within ChillerPlant.BaseClasses;
partial model EnergyMonitoring "Energy monitoring system"

  Modelica.SIunits.Power PSupFan;
  Modelica.SIunits.Power PChiWatPum;
  Modelica.SIunits.Power PConWatPum;
  Modelica.SIunits.Power PCooTowFan;
  Modelica.SIunits.Power PChi;

  Modelica.SIunits.HeatFlowRate QRooIntGai_flow;

  Modelica.SIunits.MassFlowRate mConWat_flow;
  Modelica.SIunits.MassFlowRate mChiWat_flow;

  Modelica.Blocks.Sources.RealExpression PAll(y=PSupFan + PChiWatPum +
        PConWatPum + PCooTowFan + PChi)
    "Total power consumed by the data center chiller plant system" annotation (
      Placement(transformation(extent={{-10,-10},{10,10}}, origin={-610,232})));

  Modelica.Blocks.Sources.RealExpression QRooIntGai1_flow(y=QRooIntGai_flow)
    "Power consumed by IT" annotation (Placement(transformation(extent={{-10,-10},
            {10,10}}, origin={-610,-100})));

  Modelica.Blocks.Continuous.Integrator PAllAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Meters total power consumption"
    annotation (Placement(transformation(extent={{-560,230},{-540,250}})));

  Modelica.Blocks.Continuous.Integrator QRooIntGaiAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Energy consumed by IT"
    annotation (Placement(transformation(extent={{-560,-110},{-540,-90}})));

  Modelica.Blocks.Sources.RealExpression PCooTowFan1(y=PCooTowFan)
    "Cooling tower power consumption" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-610,92})));

  Modelica.Blocks.Continuous.Integrator PCooTowAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Cooling tower power consumption meter"
    annotation (Placement(transformation(extent={{-560,90},{-540,110}})));

  Modelica.Blocks.Sources.RealExpression PChiWatPum1(y=PChiWatPum)
    "Chilled water pump power consumption" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-510,232})));

  Modelica.Blocks.Continuous.Integrator PChiWatPumAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Chilled water pump power consumption meter"
    annotation (Placement(transformation(extent={{-460,230},{-440,250}})));

  Modelica.Blocks.Sources.RealExpression PConWatPum1(y=PConWatPum)
    "Condensed water pump power consumption" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={-510,160})));

  Modelica.Blocks.Continuous.Integrator PConWatPumAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Condensed water pump power consumption meter"
    annotation (Placement(transformation(extent={{-460,160},{-440,180}})));

  Modelica.Blocks.Sources.RealExpression PChi1(y=PChi)
    "Chiller power consumption" annotation (Placement(transformation(extent={{-10,
            -10},{10,10}}, origin={-610,160})));

  Modelica.Blocks.Continuous.Integrator PChiAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Chiller power consumption meter"
    annotation (Placement(transformation(extent={{-560,160},{-540,180}})));

  Modelica.Blocks.Sources.RealExpression PSupFan1(y=PSupFan)
    "Supply air fan power consumption" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-510,90})));

  Modelica.Blocks.Continuous.Integrator PSupFanAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Supply air fan power consumption meter"
    annotation (Placement(transformation(extent={{-460,90},{-440,110}})));

  Modelica.Blocks.Sources.RealExpression mConWat1_flow(y=mConWat_flow)
    "Flow in the condensed water loop" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-490,-100})));

  Modelica.Blocks.Sources.RealExpression mChiWat1_flow(y=mChiWat_flow)
    "Flow in the chilled water loop" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-490,-140})));

equation

  connect(PAll.y, PAllAgg.u) annotation (Line(
      points={{-599,232},{-580,232},{-580,240},{-562,240}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QRooIntGai1_flow.y, QRooIntGaiAgg.u) annotation (Line(
      points={{-599,-100},{-562,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PCooTowFan1.y, PCooTowAgg.u) annotation (Line(
      points={{-599,92},{-580,92},{-580,100},{-562,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PChiWatPum1.y, PChiWatPumAgg.u) annotation (Line(
      points={{-499,232},{-480,232},{-480,240},{-462,240}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PConWatPum1.y, PConWatPumAgg.u) annotation (Line(
      points={{-499,160},{-480,160},{-480,170},{-462,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PChi1.y, PChiAgg.u) annotation (Line(
      points={{-599,160},{-580,160},{-580,170},{-562,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PSupFan1.y, PSupFanAgg.u) annotation (Line(
      points={{-499,90},{-480,90},{-480,100},{-462,100}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-360,-300},{360,
            300}}), graphics={
        Text(
          extent={{-620,286},{-534,262}},
          lineColor={28,108,200},
          textString="Power meters"),
        Text(
          extent={{-620,-42},{-514,-70}},
          lineColor={28,108,200},
          textString="Heat flow meters"),
        Text(
          extent={{-502,-42},{-400,-72}},
          lineColor={28,108,200},
          textString="Fluid flow meters")}),
Documentation(info="<HTML>
<p>
Energy metering panel.
</p>
</html>", revisions="<html>
<ul>
<li>
April 18, 2021, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-360,-300},{360,300}})));
end EnergyMonitoring;
