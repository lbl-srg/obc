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
            {10,10}}, origin={-610,-10})));

  Modelica.Blocks.Continuous.Integrator PAllAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Meters total power consumption"
    annotation (Placement(transformation(extent={{-560,230},{-540,250}})));

  Modelica.Blocks.Continuous.Integrator QRooIntGaiAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Energy consumed by IT"
    annotation (Placement(transformation(extent={{-560,-20},{-540,0}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler samPAll(samplePeriod=60)
    "Total power consumption sampler"
    annotation (Placement(transformation(extent={{-560,200},{-540,220}})));

  Modelica.Blocks.Sources.RealExpression PCooTowFan1(y=PCooTowFan)
    "Cooling tower power consumption" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-610,92})));

  Modelica.Blocks.Continuous.Integrator PCooTowAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Cooling tower power consumption meter"
    annotation (Placement(transformation(extent={{-560,90},{-540,110}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler samPCooTow(samplePeriod=60)
    "Cooling tower power consumption sampler"
    annotation (Placement(transformation(extent={{-560,60},{-540,80}})));

  Modelica.Blocks.Sources.RealExpression PChiWatPum1(y=PChiWatPum)
    "Chilled water pump power consumption" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-510,232})));

  Modelica.Blocks.Continuous.Integrator PChiWatPumAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Chilled water pump power consumption meter"
    annotation (Placement(transformation(extent={{-460,230},{-440,250}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler samPChiWatPum(samplePeriod=60)
    "Chilled water pump power consumption sampler"
    annotation (Placement(transformation(extent={{-460,200},{-440,220}})));

  Modelica.Blocks.Sources.RealExpression PConWatPum1(y=PConWatPum)
    "Condensed water pump power consumption" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={-510,160})));

  Modelica.Blocks.Continuous.Integrator PConWatPumAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Condensed water pump power consumption meter"
    annotation (Placement(transformation(extent={{-460,160},{-440,180}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler samPConWatPum(samplePeriod=60)
    "Condensed water pump power consumption sampler"
    annotation (Placement(transformation(extent={{-460,130},{-440,150}})));

  Modelica.Blocks.Sources.RealExpression PChi1(y=PChi)
    "Chiller power consumption" annotation (Placement(transformation(extent={{-10,
            -10},{10,10}}, origin={-610,160})));

  Modelica.Blocks.Continuous.Integrator PChiAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Chiller power consumption meter"
    annotation (Placement(transformation(extent={{-560,160},{-540,180}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler samPChi(samplePeriod=60)
    "Chiller power consumption sampler"
    annotation (Placement(transformation(extent={{-560,130},{-540,150}})));

  Modelica.Blocks.Sources.RealExpression PSupFan1(y=PSupFan)
    "Supply air fan power consumption" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-510,90})));

  Modelica.Blocks.Continuous.Integrator PSupFanAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Supply air fan power consumption meter"
    annotation (Placement(transformation(extent={{-460,90},{-440,110}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler samPSupFan(samplePeriod=60)
    "Supply air fan power consumption sampler"
    annotation (Placement(transformation(extent={{-460,60},{-440,80}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler samQRooIntGai_flow(samplePeriod=60)
    "Cooling tower power consumption sampler"
    annotation (Placement(transformation(extent={{-560,-62},{-540,-42}})));

  Modelica.Blocks.Sources.RealExpression mConWat1_flow(y=mConWat_flow)
    "Flow in the condensed water loop" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-490,-10})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler sam_mConWat_flow(samplePeriod=60)
    "Condenser water flow loop sampler"
    annotation (Placement(transformation(extent={{-460,-20},{-440,0}})));

  Modelica.Blocks.Sources.RealExpression mChiWat1_flow(y=mChiWat_flow)
    "Flow in the chilled water loop" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-490,-50})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler sam_mChiWat_flow(samplePeriod=60)
    "Chiller water flow loop sampler"
    annotation (Placement(transformation(extent={{-460,-60},{-440,-40}})));

equation

  connect(PAll.y, PAllAgg.u) annotation (Line(
      points={{-599,232},{-580,232},{-580,240},{-562,240}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QRooIntGai1_flow.y, QRooIntGaiAgg.u) annotation (Line(
      points={{-599,-10},{-562,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PAll.y, samPAll.u) annotation (Line(points={{-599,232},{-580,232},{-580,
          210},{-562,210}},   color={0,0,127}));
  connect(PCooTowFan1.y, PCooTowAgg.u) annotation (Line(
      points={{-599,92},{-580,92},{-580,100},{-562,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PCooTowFan1.y, samPCooTow.u) annotation (Line(points={{-599,92},{-580,
          92},{-580,70},{-562,70}},       color={0,0,127}));
  connect(PChiWatPum1.y, PChiWatPumAgg.u) annotation (Line(
      points={{-499,232},{-480,232},{-480,240},{-462,240}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PChiWatPum1.y, samPChiWatPum.u) annotation (Line(points={{-499,232},{-480,
          232},{-480,210},{-462,210}},   color={0,0,127}));
  connect(PConWatPum1.y, PConWatPumAgg.u) annotation (Line(
      points={{-499,160},{-480,160},{-480,170},{-462,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PConWatPum1.y, samPConWatPum.u) annotation (Line(points={{-499,160},{-480,
          160},{-480,140},{-462,140}},    color={0,0,127}));
  connect(PChi1.y, PChiAgg.u) annotation (Line(
      points={{-599,160},{-580,160},{-580,170},{-562,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PChi1.y, samPChi.u) annotation (Line(points={{-599,160},{-580,160},{
          -580,140},{-562,140}},
                              color={0,0,127}));
  connect(PSupFan1.y, PSupFanAgg.u) annotation (Line(
      points={{-499,90},{-480,90},{-480,100},{-462,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PSupFan1.y, samPSupFan.u) annotation (Line(points={{-499,90},{-480,90},
          {-480,70},{-462,70}},     color={0,0,127}));
  connect(QRooIntGai1_flow.y, samQRooIntGai_flow.u) annotation (Line(points={{-599,
          -10},{-580,-10},{-580,-52},{-562,-52}}, color={0,0,127}));
  connect(mConWat1_flow.y, sam_mConWat_flow.u)
    annotation (Line(points={{-479,-10},{-462,-10}}, color={0,0,127}));
  connect(mChiWat1_flow.y, sam_mChiWat_flow.u)
    annotation (Line(points={{-479,-50},{-462,-50}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-360,-300},{360,
            300}}), graphics={
        Text(
          extent={{-620,286},{-534,262}},
          lineColor={28,108,200},
          textString="Power meters"),
        Text(
          extent={{-620,48},{-514,20}},
          lineColor={28,108,200},
          textString="Heat flow meters"),
        Text(
          extent={{-502,48},{-400,18}},
          lineColor={28,108,200},
          textString="Fluid flow meters")}),
Documentation(info="<HTML>
<p>
This model is the chilled water plant with discrete time control and
trim and respond logic for a data center. The model is described at
<a href=\"Buildings.Examples.ChillerPlant\">
Buildings.Examples.ChillerPlant</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2017, by Michael Wetter:<br/>
Set <code>from_dp = true</code> in <code>val6</code> and in <code>valByp</code>
which is needed for Dymola 2018FD01 beta 2 for
<a href=\"modelica://Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl\">
Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl</a>
to converge.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
January 13, 2015 by Michael Wetter:<br/>
Moved model to <code>BaseClasses</code> because the continuous and discrete time
implementation of the trim and respond logic do not extend from a common class,
and hence the <code>constrainedby</code> operator is not applicable.
Moving the model here allows to implement both controllers without using a
<code>replaceable</code> class.
</li>
<li>
January 12, 2015 by Michael Wetter:<br/>
Made media instances replaceable, and used the same instance for both
water loops.
This was done to simplify the numerical benchmarks.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 25, 2014, by Michael Wetter:<br/>
Updated model with new expansion vessel.
</li>
<li>
December 5, 2012, by Michael Wetter:<br/>
Removed the filtered speed calculation for the valves to reduce computing time by 25%.
</li>
<li>
October 16, 2012, by Wangda Zuo:<br/>
Reimplemented the controls.
</li>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Added comments and merge to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-360,-300},{360,300}})));
end EnergyMonitoring;
