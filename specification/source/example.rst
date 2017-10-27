.. _sec_example:

Example application
-------------------

In this section, we compare the performance of two different
control sequences, applied to a floor of a prototypical office building.
The objective is to
demonstrate the setup for closed loop performance assessment and
demonstrate how to compare the control performance.


Methodology
^^^^^^^^^^^

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

Envelope heat transfer
......................

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

.. _sec_int_gai:

Internal loads
..............

.. _fig_internal_loads:

.. figure:: img/case_study1/results/internal_loads.*
   :scale: 80%

   Internal load schedule.

We use an internal load schedule as shown in
:numref:`fig_internal_loads`, of which
:math:`20\%` is radiant,
:math:`40\%` is convective sensible and
:math:`40\%` is latent.
Each zone has the same internal load per floor area.

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
The duct static pressure is adjusted
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
which is also shown in :numref:`fig_model_top_base`.

Our implementation differs from VAV 2A2-21232 in the following points:

* We removed the return air fan as the building static pressure is sufficiently
  large. With the return fan, building static pressure was not adequate.

* In order to have the identical mechanical system as for guideline 36,
  we do not have a minimum outdoor air damper, but rather controlled
  the outdoor air damper to allow sufficient outdoor air
  if the mixed air temperature control loop would yield too little outdoor
  air.


For the guideline 36 case, we implemented the multi-zone VAV control sequence.
:numref:`fig_vav_con_sch` shows the sequence diagram.

.. _fig_vav_con_sch:

.. figure:: img/case_study1/vavControlSchematics.*

   Control schematics of guideline 36 case.



Our implementation differs from guideline 36 in the following points:

* Guideline 36 prescribes "To avoid abrupt changes in equipment operation,
  the output of every control loop shall be capable of being limited
  by a user adjustable maximum rate of change, with
  a default of 25% per minute."

  We did not implement this limitation of the output as it leads to delays
  which can make control loop tuning more difficult if the output limitation
  is slower than the dynamics of the controlled process.
  We did however add a first order hold at the trim and response logic
  that outputs the duct static pressure setpoint for the fan speed.

* Not all alarms are included.

* Where guideline 36 prescribes that equipment is enabled if a controlled quantity
  is above or below a setpoint, we added a hysteresis. In real systems, this
  avoids short-cycling due to measurement noise, in simulation, this is needed
  to guard against numerical noise that may be introduced by a solver.


Site electricity use
....................

To convert cooling and heating energy as transferred by the coil to site electricity
use, we apply the conversion factors from EnergyStar :cite:`EnergyStar2013`.
Therefore, for an electric chiller, we assume an average coefficient of performance (COP) of
:math:`3.2` and for a geothermal heat pump, we assume a COP of :math:`4.0`.


Simulations
...........

:numref:`fig_model_top_base` shows the top-level of the system model of the base case, and
:numref:`fig_model_top_guideline` shows the same view for the guideline 36 model.

.. _fig_model_top_base:

.. figure:: img/case_study1/ASHRAE2006.*

   Top level view of Modelica model for the base case.

.. _fig_model_top_guideline:

.. figure:: img/case_study1/Guideline36.*

   Top level view of Modelica model for the guideline 36 case.

To illustrate the complexity of the control sequence for the guideline 36 case,
we show in :numref:`fig_model_zone_temperatures` the implementation
of the control sequence that computes the
zone air temperature setpoints for heating and cooling based on
occupancy, window status, setpoint adjustment, air handler unit operation mode
and cooling or heating demand limit signal. The implementation is
according to guideline 36, part 5.B.3.

.. _fig_model_zone_temperatures:

.. figure:: img/case_study1/ZoneTemperatures.*
   :scale: 50%

   Composite block that computes the zone air temperature setpoints
   for heating and cooling.

All simulations were done with Dymola 2018 FD01 beta3 using Ubuntu 16.04 64 bit.
We used the Radau solver with a tolerance of :math:`10^{-6}`.
This solver adaptively changes the time step to control the integration error.
Also, the time step is adapted to properly simulate :term:`time events<time event>`
and :term:`state events<state event>`.

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
detailed than what may otherwise be used for simulation of what the authors
believe represents a realistic implementation of a feedback control sequence.
The entry approximate number of control I/O connections
counts the number of input and output connections among the
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
   Time for annual simulation in minutes                100          180
   ============================================== ========= ============


Performance comparison
^^^^^^^^^^^^^^^^^^^^^^

.. _fig_cas_stu1_energy:

.. figure:: img/case_study1/results/energy_all.*
   :scale: 80%

   Comparison of energy use. For the cases labeled :math:`\pm 50\%`, the internal gains
   have been increased and decreased as described in :numref:`sec_int_gai`.

.. _tab_site_energy:

.. include:: img/case_study1/results/site_energy.rst


:numref:`fig_cas_stu1_energy` and
:numref:`tab_site_energy` compare the annual
site electricity use between
the annual simulations with the base case control
and the Guideline 36 control.
The bars labeled "div. gains" were obtained with simulations in which we
changed the diversity of the internal loads.
Specifically, we reduced the internal loads for the north zone by :math:`50\%`
and increased them for the south zone by the same amount.

The Guideline 36 control saves around :math:`25\%`
site electrical energy. These are significant savings
that can be achieved through software only, without the need
for additional hardware or equipment.
Our experience, however, was that it is rather challenging to
program guideline 36 sequence due to their complex logic
that contains various mode changes, interlocks and timers.
Various programming errors and misinterpretations or ambiguities
of the guideline were only discovered in closed loop simulations.
We therefore believe it is important to provide robust, validated
implementations of guideline 36 that encapsulates the complexity for the
energy modeler and the control provider.


:numref:`fig_TRoom_base` to :numref:`fig_TRoom_g36`
compare time trajectories of the room air temperatures for
a period in winter, spring and summer for the base case and
guideline 36.
The figures show that the room air temperatures are controlled
within the setpoints for both cases. Small set point violations
have been observed due to the dynamic nature of the control sequence
and the controlled process.

.. _fig_TRoom_base:

.. figure:: img/case_study1/results/TRoom_base.*

   Room air temperatures for the base case.

.. _fig_TRoom_g36:

.. figure:: img/case_study1/results/TRoom_g36.*

   Room air temperatures for guideline 36.

.. _fig_vav_all:

.. figure:: img/case_study1/results/vav_all.*

   VAV control signals for the north and south zones.

:numref:`fig_vav_all` shows the control signals of the reheat coils :math:`y_{hea}`
and the VAV damper :math:`y_{vav}`
for the north and south zones.

.. _fig_TAHU_all:

.. figure:: img/case_study1/results/TAHU_all.*

   AHU temperatures.

:numref:`fig_TAHU_all` shows the temperatures of the air handler unit.
The figure shows the outside air temperature temperature :math:`T_{out}`,
the supply air temperature after the fan :math:`T_{sup}`,
the mixed air temperature after the economizer :math:`T_{mix}`
and the return air temperature from the building :math:`T_{ret}`.
A notable difference is that guideline 36 resets
the supply air temperature, whereas the base case is controlled
for a supply air temperature of :math:`10^\circ \mathrm C`
for heating and :math:`12^\circ \mathrm C` for cooling.

.. _fig_flow_signals_all:

.. figure:: img/case_study1/results/flow_signals_all.*

   Control signals for the supply fan, outside air damper and return air damper.

:numref:`fig_flow_signals_all` show reasonable fan speeds and economizer operation.
Note that during the winter days 5, 6 and 7, the outdoor air damper opens. However,
this is only to track the setpoint for the minimum outside air flow rate as the fan
speed is at its minimum.

.. _fig_normalized_flow_all:

.. figure:: img/case_study1/results/normalized_flow_all.*

   Fan and outside air volume flow rates, normalized by the room air volume.

:numref:`fig_normalized_flow_all` shows the volume flow rate of the fan
:math:`\dot V_{fan,sup}/V_{bui}`, where :math:`V_{bui}` is the volume of the building,
and of the outside air intake of the economizer :math:`\dot V_{eco,out}/V_{bui}`, expressed in air changes per hour.
Note that guideline 36 has smaller outside air flow rates in cold winter and hot summer days.
The system has relatively low air changes per hour. As fan
energy is low for this building, it may be more efficient to increase
flow rates and use higher cooling and lower heating temperatures,
in particular if heating and cooling is provided by a heat pump and chiller.
We have however not further analyzed this trade-off.



.. _fig_TRoom_load_diversity:

.. figure:: img/case_study1/results/TRoom_with_without_div_IHG.*

   Outdoor air and room air temperatures for the north and south zone with
   equal internal loads, and with diversity added to the internal loads.

:numref:`fig_TRoom_load_diversity` compares the room air temperatures for the
north and south zone for the standard internal loads, and the case where we
reduced the internal loads in the north zone by :math:`50\%` and increased it
by the same amount in the south zone.
The trajectories with subscript :math:`\pm 50\%` are the simulations with
the internal heat gains reduced or increased by :math:`50\%`.
The room air temperature trajectories
are practically on top of each other for winter and spring, but
the guideline 36 sequence shows somewhat better setpoint tracking
during summer.
Both control sequences are comparable in terms of compensating for this
diversity, and as we saw in :numref:`fig_cas_stu1_energy`,
their energy consumption is not noticeably affected.

Improvement to Guideline 36 specification
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This section describes improvements that we recommend for the Guideline 36
specification, based on the first public review draft :cite:`ASHRAE2016`.

.. _sec_fre_pro:

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

As shown in :numref:`fig_freeze_protection`, in our simulations, the supply air temperature :math:`T_{sup}`
was controlled by the heating coil
to around :math:`18^\circ \mathrm C`, but the mixed air temperature :math:`T_{mix}` was below freezing.
Hence, this control would not have been active.
Adding a feedback control that regulates the economizer outdoor air damper such that the mixed air temperature
is above :math:`4^\circ \mathrm C` yields the trajectory labeled :math:`T_{mix,with}`.
In plants with an oversized coil that has variable water mass flow rate, there
is a risk of freezing the coil. Hence we recommend controlling the outdoor air damper
also for the mixed air temperature of :math:`4^\circ \mathrm C`.

.. _fig_freeze_protection:

.. figure:: img/case_study1/results/TMixFre.*

   Mixed air temperature and economizer control signal for guideline 36 case with
   and without freeze protection.


.. _sec_dea_har_swi:

Deadbands for hard switches
...........................

There are various sequences in which the set point changes as a step function of
the control signal, such as shown in :numref:`fig_dam_val_reh`.

.. _fig_dam_val_reh:

.. figure:: img/case_study1/DamperValveRehBox.*
   :scale: 50%

   Control sequence for VAV terminal unit.

In our simulations of the VAV terminal boxes, the switch in air flow rate caused
chattering. We circumvented the problem by checking if the heating control signal
remains bigger than :math:`0.05` for :math:`5` minutes. If it falls below :math:`0.01`,
the timer was switched off. This avoided the chattering.
We therefore recommend to be more explicit for when such mode switches are triggered.

Averaging air flow measurements
...............................

The guideline 36 does not seem to prescribe that outdoor airflow rate
measurements need to be time averaged. As such measurements can
fluctuate due to turbulence, we recommend to consider averaging
this measurement. In the simulations, we averaged the outdoor airflow
measurement over a :math:`2` minute moving window (in the simulation,
this was not to filter noise, but rather to avoid an algebraic system
of equations).

Minor editorial revision
........................

The guideline states:

   When a control loop is enabled or re-enabled, it and all its constituents (such as the
   proportional and integral terms) shall be set initially to a Neutral value.

This should be changed to "...such as the integral terms..." because the
proportional term cannot be reset.


Cross-referencing and modularization
....................................

For citing individual sections or blocks of the guideline,
it would be helpful if the guideline where available at a permanent web site
as html, with a unique url and anchor to each section.
This would allow cross-referencing the guideline from a particular implementation
in a way that allows the user to quickly see the original specification.

As part of such a restructuring, it would be helpful for the reader
to clearly state what are the input signals, what are configurable parameters,
such as the control gain, and what are the output signals.
This in turn would structure the guideline into distinct modules,
for which one could also provide a reference implementation
in software.

Discussion and conclusions
^^^^^^^^^^^^^^^^^^^^^^^^^^

The guideline 36 sequence reduced annual site energy by :math:`25\%`
compared to the baseline implementation, by comparable thermal comfort.
Such savings are significant, and have been achieved by software only
that can relatively easy be deployed to buildings.

Implementing the sequence was however rather challenging due to its
complexity caused by the various mode changes, interlocks and timers.
As a consequence, various programming errors and misinterpretations or ambiguities
of the guideline were only discovered in closed loop simulations,
despite of having implemented open-loop test cases for each block of the sequence.
We therefore believe it is important to provide robust, validated
implementations of the sequences published in guideline 36.
Such implementations would encapsulate the complexity and provide
assurances that energy modeler and control providers have correct implementations.
With the implementation in
the Modelica package `Buildings.Controls.OBC.ASHRAE.G36_PR1`, we made a start
for such an implementation and laid out the structure and conventions,
but have not covered all of the standard yet. Furthermore, conducting field validations
would be useful too.

A key short-coming from an implementer point of view was that the
sequence was only available in English language, and as an implementation
in ALC EIKON of sequences that are "close to the currently used version of the
guideline". Neither allowed a validation of the CDL implementation
because the English language version leaves room for interpretation (and cannot
be executed) and because EIKON has quite limited simulation support
that is cumbersome to use for testing the dynamic response of
control sequences for different input
trajectories. Therefore, a benefit of the Modelica implementation is that
such reference trajectories can now easily be generated to validate alternate
implementations.

A benefit of the simulation based assessment was that it allowed
detecting potential issues such as a mixed air temperature below the
freezing point (:numref:`sec_fre_pro`) and chattering due to hard switches
(:numref:`sec_dea_har_swi`).
Having a simulation model of the controlled process also allowed
verification of work-arounds for these issues.

One can, correctly, argue that the magnitude of the energy savings
are higher the worse the baseline control is. However, the baseline control was
carefully implemented, following the author's interpretation of
ASHRAE's Sequences of Operation for
Common HVAC Systems :cite:`ASHRAESeq2006:1`. While higher efficiency
of the baseline may be achieved through supply air temperature reset
or different economizer control, such potential improvements were only
recognized after seeing the results of the guideline 36 sequence.
Thus, regardless of whether a building is using guideline 36,
having a baseline control against which alternative implementations
can be compared and benchmarked is an immensely valuable feature
of a library of standardized control sequences. Without a benchmark,
one can easily claim to have a good control, while not recognizing what
potential savings one may miss.
