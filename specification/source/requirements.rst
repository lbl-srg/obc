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
#. The controls design tool shall allow testing energy, peak demand,
   energy cost, and comfort of control sequences when connected to a building
   system model.
#. The controls design tool shall integrate with OpenStudio.
#. The controls design tool shall work on Windows, Linux Ubuntu
   and Mac OS X.


CDL
^^^

#. It shall be possible to translate control sequences that
   are expressed in the CDL
   to implementation of major control vendors.
#. It shall be possible to render in a visual editor and in a textual
   editor CDL-compliant control sequences.
#. CDL shall be a proper subset of Modelica 3.3 :cite:`Modelica2012:1`.
   [Section :ref:`sec_cdl` specifies what subset shall be supported. This will allow visualizing, editing and simulating
   CDL with Modelica tools rather than requiring a separate tool.
   It will also simplify the integration of CDL with the design and verification tools, since they use Modelica.]
#. It shall be possible to simulate CDL-compliant control sequences in an open-source, freely available
   Modelica environment.
#. It shall be possible to simulate CDL-compliant control sequences in the Spawn of EnergyPlus.


Commissioning and Functional Verification Tool
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. The CDL tool shall import verfication tests expressed in CDL, and a list
   of control points that are used for monitoring and active functional testing.
#. The commissioning and functional verification tool shall be able to
   read data from, and send data to, BACnet, possibly using a middleware such as
   VOLTTRON or the BCVTB.
#. It shall be possible to run the tool in batch mode as part of a real-time
   application that continuously monitors the functional verification tests.
#. The commissioning and functional verification tool shall work
   on Windows, Linux Ubuntu and Mac OS X.
