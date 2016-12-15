.. _sec_requirements:

Requirements
------------

This section describes the functional, mathematical and software requirements.

Controls Design Tool
^^^^^^^^^^^^^^^^^^^^

#. The controls design tool shall contain a library of predefined
   control sequences for HVAC primary systems, HVAC secondary systems
   and active facades in a way that allows users to customize these
   sequences.
#. The controls design tool shall contain a library with
   functional and performance requirement tests
   that can be tested during design and during commissioning.
#. The controls design tool shall allow users to add
   libraries of custom control sequences.
#. The controls design tool shall allow users to add
   libraries of custom functional and performance requirement tests.
#. The controls design tool shall allow testing energy, peak demand
   and comfort of control sequences when connected to a building
   system model.
#. The controls design tool shall integrate with OpenStudio.
#. The controls design tool shall work on Windows, Linux Ubuntu
   and Mac OS X.


CDL
^^^

#. It should be possible to translate control sequences that
   are expressed in the CDL
   to implementation of major control vendors.
#. It shall be possible to render in a visual editor and in a textual
   editor CDL-compliant control sequences.
#. CDL shall be a proper subset of Modelica 3.2 :cite:`Modelica2012:1`.
   [Section :ref:`sec_specification` specifies what subset shall be supported. This will allow visualizing, editing and simulating
   CDL with Modelica tools rather than requiring a separate tool.
   It will also simplify CDL as there are no specification that
   contradict with Modelica, which is used by the design tool
   and verification tool.]
#. It shall be possible to simulate in an open-source free available
   Modelica environment CDL-compliant control sequences.
#. It shall be possible to simulate in the Spawn of EnergyPlus
   CDL-compliant control sequences.


Commissioning and Functional Verification Tool
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

xxx
