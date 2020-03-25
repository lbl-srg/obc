.. _sec_library_of_sequences:

Library of Control Sequences
----------------------------

To make ready-to-use control sequences available to building designers,
researchers and control providers, we used the
Control Description Language described in :numref:`sec_cdl`
to implement control sequences.
Control sequences have been implemented
for secondary HVAC systems based on ASHRAE Guideline 36,
for outdoor lights and for building shades.

.. _fig_g36_pac_ove:

.. figure:: img/g36_package.*
   :width: 600px

   Overview of package that includes control sequences from ASHRAE Guideline 36.


For example, :numref:`fig_g36_pac_ove` shows an overview of the control sequences
that have been implemented based on ASHRAE Guideline 36.
The implementation is structured hierarchically into packages
for air handler units, into constants that indicate the mode of operation,
into generic sequences such as for a trim and respond logic,
and into sequences for terminal units.

.. _fig_g36_sin_zon:

.. figure:: img/vavSingleZoneSchema.*
   :width: 600px

   Schematic view of model that uses the CDL implementation of the
   single zone VAV controller based on ASHRAE Guideline 36.


Every sequence contains an English language description,
an implementation using block diagram modeling, and one or several examples
that illustrate the use of the sequence. These examples
are available in the ``Validation`` package in which the sequences are used,
typically with open-loop tests.
For top-level sequences, there are also closed loop tests
available. For example :numref:`fig_g36_sin_zon`
shows the schematic view of the model that evaluates the performance
of the single zone VAV controller
based on ASHRAE Guideline 36 :cite:`ZhangBlumEtAl2020`.
In this model, the controller output is connected to an HVAC system model,
which in turn is connected to a model of the building.
Sensor data from the HVAC system and the room air temperature
are fed back to the controller to form the closed loop test.

As of Spring 2020, additional sequences are being implemented
for chilled water plants and for boiler plants,
following the ASHRAE Research Project Report 1711,
and for optimal start-up (for heating) and cool down (for cooling).

To browse the implemented control sequences, visit
the Modelica Buildings Library model documentation at
`https://simulationresearch.lbl.gov/modelica <https://simulationresearch.lbl.gov/modelica>`_.
