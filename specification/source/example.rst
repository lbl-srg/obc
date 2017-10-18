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

The models are available from the branch
https://github.com/lbl-srg/modelica-buildings/tree/issue967_VAVReheat_CDL

.. todo:: Move models to the master branch.

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

.. figure:: img/case_study1/vavSchematics.*

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

Each thermal zone has air flow from the HVAC system,
through leakages of the building envelope (except for the core zone)
and through bi-directional air exchange through open doors that connect adjacent zones.
The bi-directional air exchange is modeled based on the differences
in static pressure between adjacent rooms at a reference height
plus the difference in static pressure across the door height
as a function of the difference in air density.
Air infiltration is a function of the
flow imbalance of the HVAC system.
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
see the model ``Buildings.Examples.VAVReheat.ASHRAE2006``,
which is also shown in xxxx.


Site electricity use
....................

To convert cooling and heating energy as transfered by the coil to site electricity
use, we apply the conversion factors from EnergyStar :cite:`EnergyStar2013`.
Therefore, for an electric chiller, we assume an average coefficient of performance (COP) of
:math:`3.2` and for a geothermal heat pump, we assume a COP of :math:`4.0`.


Simulations
...........

All simulations were done with Dymola 2018 FD01 beta3 using Ubuntu 16.04 64 bit.
We used the Radau solver with a tolerance of :math:`10^{-6}`.

The base case and the guideline 36 case use the same HVAC and building model,
which is implemented in the base class 
``Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop``.
The two cases differ in their implementation of the control sequence only,
which is implemented in the models
``Buildings.Examples.VAVReheat.BaseClasses.ASHRAE2006`` and
``Buildings.Examples.VAVReheat.BaseClasses.Guideline36``.

:numref:`tab_mod_sta` shows an overview of the model and simulation statistics.
The differences in the number of variables and in the number of time varying
variables reflect that the guideline 36 control is significantly more
detailed than what may otherwise be used for simulation of what the author
believe represents a realistic implementation of a feedback control sequence.
The entry approximate number of control I/O connections
counts the number of input and ouput connections among the
control blocks of the two implementations. For example,
If a P controller receives one set point, one measured quantity
and sends it signal to a limiter and the limiter output is
connected to a valve, then this would count as four connections.
Any connections inside the PI controller would not be counted,
as the PI controller is an elementary building block
(see :numref:`sec_ele_bui_blo`) of CDL.

.. _tab_mod_sta:
   
.. table:: Model and simulation statistics.

   ============================================== ========= ============
                                                  Base case Guideline 36
   ============================================== ========= ============
   Number of components                                2826         4400
   Number of variables (prior to translation)        33,700       40,400
   Number of continuous states                          178          190
   Number of time-varying variables                    3400         4800
   Approximate number of control I/O connections        TBD          TBD
   Time for annual simulation in minutes                100          180
   ============================================== ========= ============

.. todo:: Add number of connections.

Performance comparison
^^^^^^^^^^^^^^^^^^^^^^

.. _fig_cas_stu1_energy:

.. figure:: img/case_study1/results/energy.*

   Comparison of energy use.

:numref:`fig_cas_stu1_energy` compares the energy use between
the annual simulations with the base case control
and the Guideline 36 control.
The Guideline 36 control saves :math:`xxxx \mathrm{kWh/(m^2 \, a)}`
energy.

.. todo:: Add conversion between heating, cooling and electricity.


.. _fig_TRoom_base:

.. figure:: img/case_study1/results/TRoom_base.*

   Room air temperatures for the base case.

.. _fig_TRoom_g36:

.. figure:: img/case_study1/results/TRoom_g36.*

   Room air temperatures for guideline 36.


.. _fig_vav_base:

.. figure:: img/case_study1/results/vav_base.*

   VAV control signals for the base case.


.. _fig_vav_g36:

.. figure:: img/case_study1/results/vav_g36.*

   VAV control signals for guideline 36.


.. _fig_TAHU_base:

.. figure:: img/case_study1/results/TAHU_base.*

   AHU temperatures for the base case.


.. _fig_TAHU_g36:

.. figure:: img/case_study1/results/TAHU_g36.*

   AHU temperatures for guideline 36.


.. _fig_flow_signals_base:

.. figure:: img/case_study1/results/flow_signals_base.*

   Control signals for the base case.


.. _fig_flow_signals_g36:

.. figure:: img/case_study1/results/flow_signals_g36.*

   Control signals for guideline 36.


.. _fig_normalized_flow_base:

.. figure:: img/case_study1/results/normalized_flow_base.*

   Mass flow rates, normalized by the design flow rate, for the base case.


.. _fig_normalized_flow_g36:

.. figure:: img/case_study1/results/normalized_flow_g36.*

   Mass flow rates, normalized by the design flow rate, for guideline 36.


:numref:`tab_site_energy` shows that the control sequence of guideline 36
significantly reduces site electricity.
We believe that some of the savings can be attributed to the more sophisticated
set point reset algorithm in guideline 36, which in turn yields the more
complex sequence as reflected in the model statistics of :numref:`tab_mod_sta`.

.. _tab_site_energy:

.. include:: img/case_study1/results/site_energy.rst

Improvement to Guideline 36 specification
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This section describes improvements that we recommend for the Guideline 36
specification, based on the first public review draft :cite:`ASHRAE2016`.


Freeze protection for mixed air temperature
...........................................

The sequences have no freeze protection for the mixed air temperature.
For our simulation, we saw on the first day of January a mixed air temperature
of around :math:`-2^\circ` C entering the heating coil, which may freeze the coil.

The guideline states (emphasis added):
      
   If the supply air temperature drops below :math:`4.4^\circ \mathrm C` (:math:`40^\circ \mathrm F`) for :math:`5` minutes, send two
   (or more, as required to ensure that heating plant is active) Boiler Plant
   Requests, override the outdoor air damper to the minimum position, and
   *modulate the heating coil to maintain a supply air temperature* of at least :math:`5.6^\circ` C
   (:math:`42^\circ \mathrm F`). Disable this function when supply air temperature rises above :math:`7.2^\circ \mathrm C`
   (:math:`45^\circ \mathrm F`) for 5 minutes.

As shown in xxxx In our simulations, the supply air temperature was controlled by the heating coil
to around :math:`18^\circ \mathrm C`. Hence, this control would not have been active.
In plants with an oversized coil that has variable water mass flow rate, there
is a risk of freezing the coil. Hence we recommend controlling the heating coil
also for the mixed air temperature of around :math:`4^\circ \mathrm C`.

.. todo:: Add figure with mixed air setpoint set to -50 degC to disable the new loop
          and show the problem.


Describe issues with `uHea` in reheat box.

Discussion and conclusions
^^^^^^^^^^^^^^^^^^^^^^^^^^

xxx
