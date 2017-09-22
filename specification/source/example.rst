.. _sec_example:

Example application
-------------------

In this section, we compare the performance of two different
control sequences, applied to a floor of a prototypical office building.
The objective is to
demonstrate the setup for closed loop performance assessment and
demonstrate how to compare the control performance.


Method
^^^^^^

All models are implemented in Modelica, using models from
the Buildings library :cite:`WetterZuoNouiduiPang2014`.

.. todo:: add version of library, and where models can be accessed.

As a test case, we used a simulation model that consists
of five thermal zones that are representative of one floor of the
new construction medium office building for Chicago, IL,
as described in the set of DOE Commercial Building Benchmarks
:cite:`DeruEtAl2011:1`.
There are four perimeter zones and one core zone.
The envelope thermal properties meet ASHRAE Standard 90.1-2004.
The system model consist of an HVAC system, a building envelope model
and a model for air flow through building leakage
and through open doors based on wind pressure and
flow imbalance of the HVAC system.

HVAC model
..........

The HVAC system is a variable air volume (VAV) flow system
with economizer and a heating and cooling coil in the air handler unit.
There is also a reheat coil and an air damper in each of the five zone
inlet branches.

:numref:`fig_vav_schematics` shows the schematic diagram of the HVAC system.

.. _fig_vav_schematics:

.. figure:: img/examples/vavSchematics.*

   Schematic diagram of the HVAC system.

In the VAV model, all air flows are computed based on the
duct static pressure distribution and the performance curves of the fans.
The fans are modeled as described in :cite:`Wetter2013:1`.

Envelop heat transfer
.....................

The thermal room model computes transient heat conduction through
walls, floors and ceilings and long-wave radiative heat exchange between
surfaces. The convective heat transfer coefficient is computed based
on the temperature difference between the surface and the room air.
There is also a layer-by-layer short-wave radiation,
long-wave radiation, convection and conduction heat transfer model for the
windows. The model is similar to the
Window 5 model.
The physics implemented in the building model is further described in
:cite:`WetterZuoNouidui2011:2`.

There is no moisture buffering in the envelope, but the room volume
has a dynamic equation for the moisture content.


Multi-zone air exchange
.......................

Each thermal zone can have air flow from the HVAC system,
through leakages of the building envelope (except for the core zone)
and through bi-directional air exchange through open doors that connect adjacent zones.
The bi-directional air exchange is modeled based on the differences
in static pressure between adjacent rooms at a reference height
plus the difference in static pressure across the door height
as a function of the difference in air density.
There is also wind pressure acting on each facade. The wind pressure is a function
of the wind speed and wind direction. Therefore, infiltration is a function of the
flow imbalance of the HVAC system and of the wind conditions.
The multizone airflow models are further described in
:cite:`Wetter2006:2`.


Control sequences
.................

For the above models, we implemented two different control sequences, which
are described below. The control sequences are the only difference between
the two cases.

For the base case, we implemented the control sequence
*VAV 2A2-21232* of the Sequences of Operation for
Common HVAC Systems :cite:`ASHRAESeq2006:1`.
In this control sequence, the
supply fan speed is regulated based on the duct static pressure.
The return fan controller tracks the supply fan air flow rate
reduced by a fixed offset. The duct static pressure is adjusted
so that at least one VAV damper is 90% open. The economizer dampers
are modulated to track the setpoint for the mixed air dry bulb temperature.
Priority is given to maintain a minimum outside air volume flow rate.
In each zone, the VAV damper is adjusted to meet the room temperature
setpoint for cooling, or fully opened during heating.
The room temperature setpoint for heating is tracked by varying
the water flow rate through the reheat coil. There is also a
finite state machine that transitions the mode of operation of
the HVAC system between the modes
*occupied*, *unoccupied off*, *unoccupied night set back*,
*unoccupied warm-up* and *unoccupied pre-cool*.
Local loop control is implemented using proportional and proportional-integral
controllers, while the supervisory control is implemented
using a finite state machine.

For the detailed implementation of the control logic,
see the model ``Buildings.Examples.VAVReheat.ClosedLoop``,
which is also shown in xxxx


Performance comparison
^^^^^^^^^^^^^^^^^^^^^^

xxx

Discussion and conclusions
^^^^^^^^^^^^^^^^^^^^^^^^^^

xxx
