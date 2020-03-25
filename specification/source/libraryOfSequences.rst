.. _sec_library_of_sequences:

Library of Control Sequences
----------------------------

To make ready-to-use control sequences available to building designers,
researchers and control providers, we used the
Control Description Language described in :numref:`sec_cdl`
to build control sequences.
Control sequences for the following subsystems have been implemented
for secondary HVAC systems based on ASHRAE Guideline 36,
for outdoor lights and for building shades.

.. _fig_process:

.. figure:: img/g36_package.*
   :width: 800px

   Overview of package that includes control sequences from ASHRAE Guideline 36.


For example, Figure xxx shows an overview of the control sequences
that have been implemented based on ASHRAE Guideline 36.
The implementation is structured hierarchically into packages
for air handler units, into constants that indicate the mode of operation,
into generic sequences such as for a trim and respond logic,
and into sequences for terminal units.

For every sequence, there is a validation package that illustrates
the use of the sequence.

As of Spring 2020, additional sequences are being implemented
for chilled water plants and for boiler plants,
following the ASHRAE Research Project Report 1711.

To see an overview of the implemented control sequences, visit
the
<Modelica Buildings Library model documentation <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Controls_OBC.html>`_.
