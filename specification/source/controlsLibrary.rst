Controls Library
----------------

Introduction
^^^^^^^^^^^^

To implement control sequences that conform to the CDL specification
of :numref:`sec_cdl`, we implemented a library of elementary
control blocks, and a library of control sequences that are composed
of these elementary control blocks, using composition rules that are
specified in the CDL specification.
The next two sections give a brief overview of these library.
To see their implementation, browse the online documentation at
`https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Controls_OBC.html <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Controls_OBC.html>`_.


CDL Library
^^^^^^^^^^^

To implement control sequences in CDL, we created the CDL library.
This library contains all compositional elements of the CDL language,
such as connectors for input and output signals of various types (real, integer etc.),
type definitions such as for the day-of-week, and the
elementary control blocks that are described in :numref:`sec_ele_bui_blo`.
This library consist of about 130 elementary control blocks, such as a block
that adds two real-valued input signals and produces its sum as the output,
a block that implements a proportional-integral-derivative controller
with anti-windup, and blocks that perform basic operations on boolean signals.
Thus, the CDL library defines the necessary and sufficient set of models
that need to be supported by control product lines to which
control sequences that are expressed in CDL can be translated to, using
the process described in :numref:`sec_cdl_to_json_simp`.

These elementary blocks are used to compose control sequences for
mechanical systems, lighting systems and active facades that
are described in the next section.


.. _sec_library_of_sequences:

Library of Control Sequences
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
To make ready-to-use control sequences available to building designers,
researchers and control providers, we implemented control sequences
for secondary HVAC systems based on ASHRAE Guideline 36,
for lighting systems and for active facades.

.. _fig_g36_pac_ove:

.. figure:: img/g36_package.*
   :width: 600px

   Overview of package that includes control sequences from ASHRAE Guideline 36.


For example, :numref:`fig_g36_pac_ove` shows an overview of the control sequences
that have been implemented based on ASHRAE Guideline 36.
The implementation is structured hierarchically into packages
for air handler units, into constants that indicate the mode of operation,
into generic sequences such as for a trim and respond logic,
and into sequences for terminal units. Around 30 smaller sequences
are used to hierarchically compose controllers for single-zone and multi-zone
VAV systems.

.. Count the sequences with
   find . -name '*.mo' | grep -v package | grep -v Validation | grep -v Conversion | grep -v Types | grep -v Interfaces

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
The model is available in the Modelica Buildings Library as the model
``Buildings.Air.Systems.SingleZone.VAV.Examples.Guideline36``.

As of Spring 2020, additional sequences are being implemented
for chilled water plants and for boiler plants,
following the ASHRAE Research Project Report 1711,
and for optimal start-up (for heating) and cool down (for cooling).
