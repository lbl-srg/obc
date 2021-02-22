within ChillerPlant.BaseClasses;
partial model EnergyMonitoring "Energy monitoring system"

  // control parameters used in both base and 1711 cases
  parameter Real cooTowAppDes(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=6
    "Design cooling tower approach"
    annotation(Dialog(group="Design parameters"));

  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal=roo.QRoo_flow/(1005
      *15) "Nominal mass flow rate at fan";
  parameter Modelica.SIunits.Power P_nominal=80E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal=3 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=2*roo.QRoo_flow/(
      4200*20) "Nominal mass flow rate at chilled water";

  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=2*roo.QRoo_flow/(
      4200*6) "Nominal mass flow rate at condenser water";

  parameter Modelica.SIunits.PressureDifference dp_nominal=500
    "Nominal pressure difference";
  Modelica.Blocks.Sources.RealExpression PAll(y=fan.P + pumCHW.P + pumCW.P +
        cooTow.PFan + chi.P)
    "Total power consumed by the data center chiller plant system" annotation (
      Placement(transformation(extent={{-10,-10},{10,10}}, origin={-548,-94})));
  Modelica.Blocks.Sources.RealExpression PIT(y=roo.QSou.Q_flow)
    "Power consumed by IT"   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-610,-6})));
  Modelica.Blocks.Continuous.Integrator PAllAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Meters total power consumption"
    annotation (Placement(transformation(extent={{-498,-96},{-478,-76}})));
  Modelica.Blocks.Continuous.Integrator EIT(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Energy consumed by IT"
    annotation (Placement(transformation(extent={{-560,-18},{-540,2}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samPAll(samplePeriod=1)
    "Total power consumption sampler"
    annotation (Placement(transformation(extent={{-498,-126},{-478,-106}})));
  Modelica.Blocks.Sources.RealExpression PCooTow(y=cooTow.PFan)
    "Cooling tower power consumption" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-548,-234})));
  Modelica.Blocks.Continuous.Integrator PCooTowAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Cooling tower power consumption meter"
    annotation (Placement(transformation(extent={{-498,-236},{-478,-216}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samPCooTow(samplePeriod=1)
    "Cooling tower power consumption sampler"
    annotation (Placement(transformation(extent={{-498,-266},{-478,-246}})));
  Modelica.Blocks.Sources.RealExpression PChiWatPum(y=pumCHW.P)
    "Chilled water pump power consumption" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-448,-96})));
  Modelica.Blocks.Continuous.Integrator PChiWatPumAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Chilled water pump power consumption meter"
    annotation (Placement(transformation(extent={{-398,-98},{-378,-78}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samPChiWatPum(samplePeriod=1)
    "Chilled water pump power consumption sampler"
    annotation (Placement(transformation(extent={{-398,-128},{-378,-108}})));
  Modelica.Blocks.Sources.RealExpression PConWatPum(y=pumCW.P)
    "Condensed water pump power consumption" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={-448,-168})));
  Modelica.Blocks.Continuous.Integrator PConWatPumAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Condensed water pump power consumption meter"
    annotation (Placement(transformation(extent={{-398,-168},{-378,-148}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samPConWatPum(samplePeriod=1)
    "Condensed water pump power consumption sampler"
    annotation (Placement(transformation(extent={{-398,-198},{-378,-178}})));
  Modelica.Blocks.Sources.RealExpression PChi(y=chi.P)
    "Chiller power consumption" annotation (Placement(transformation(extent={{-10,
            -10},{10,10}}, origin={-548,-164})));
  Modelica.Blocks.Continuous.Integrator PChiAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Chiller power consumption meter"
    annotation (Placement(transformation(extent={{-498,-166},{-478,-146}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samPChi(samplePeriod=1)
    "Chiller power consumption sampler"
    annotation (Placement(transformation(extent={{-498,-196},{-478,-176}})));
  Modelica.Blocks.Sources.RealExpression PSupFan(y=fan.P)
    "Supply air fan power consumption" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-448,-238})));
  Modelica.Blocks.Continuous.Integrator PSupFanAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Supply air fan power consumption meter"
    annotation (Placement(transformation(extent={{-398,-238},{-378,-218}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samPSupFan(samplePeriod=1)
    "Supply air fan power consumption sampler"
    annotation (Placement(transformation(extent={{-398,-268},{-378,-248}})));
equation

  connect(PAll.y, PAllAgg.u) annotation (Line(
      points={{-537,-94},{-518,-94},{-518,-86},{-500,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIT.y,EIT. u) annotation (Line(
      points={{-599,-6},{-580,-6},{-580,-8},{-562,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PAll.y, samPAll.u) annotation (Line(points={{-537,-94},{-518,-94},{
          -518,-116},{-500,-116}}, color={0,0,127}));
  connect(PCooTow.y, PCooTowAgg.u) annotation (Line(
      points={{-537,-234},{-518,-234},{-518,-226},{-500,-226}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PCooTow.y, samPCooTow.u) annotation (Line(points={{-537,-234},{-518,
          -234},{-518,-256},{-500,-256}}, color={0,0,127}));
  connect(PChiWatPum.y, PChiWatPumAgg.u) annotation (Line(
      points={{-437,-96},{-418,-96},{-418,-88},{-400,-88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PChiWatPum.y, samPChiWatPum.u) annotation (Line(points={{-437,-96},{
          -418,-96},{-418,-118},{-400,-118}}, color={0,0,127}));
  connect(PConWatPum.y, PConWatPumAgg.u) annotation (Line(
      points={{-437,-168},{-418,-168},{-418,-158},{-400,-158}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PConWatPum.y, samPConWatPum.u) annotation (Line(points={{-437,-168},{
          -418,-168},{-418,-188},{-400,-188}}, color={0,0,127}));
  connect(PChi.y, PChiAgg.u) annotation (Line(
      points={{-537,-164},{-518,-164},{-518,-156},{-500,-156}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PChi.y, samPChi.u) annotation (Line(points={{-537,-164},{-518,-164},{
          -518,-186},{-500,-186}}, color={0,0,127}));
  connect(PSupFan.y, PSupFanAgg.u) annotation (Line(
      points={{-437,-238},{-418,-238},{-418,-228},{-400,-228}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PSupFan.y, samPSupFan.u) annotation (Line(points={{-437,-238},{-418,
          -238},{-418,-258},{-400,-258}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-360,-300},{360,
            300}}), graphics={
        Text(
          extent={{-558,-42},{-472,-66}},
          lineColor={28,108,200},
          textString="Power meters"),
        Text(
          extent={{-636,44},{-530,16}},
          lineColor={28,108,200},
          textString="Heat flow meters"),
        Text(
          extent={{-476,46},{-374,16}},
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
