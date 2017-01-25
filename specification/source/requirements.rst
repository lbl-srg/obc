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
#. The CDL shall encompass (at least) actions and objects.  The HVAC system shall be described in terms of objects.  Actions operate on objects and/or use data from objects to produce the desired control effects.
#. Each distinct piece of equipment (e.g. return air temperature sensor) shall be represented by a unique object.
#. The object model must be extensible.
#. The object model must be relational, ineherently defining connections between different objects.  The system must support many-to-many relationships - simple heirarchy is not sufficient.
#. The object model must be rigorous but flexible.  Common object types shall be predefined so that adding a device to the database prompt the user to provide necessary information.  For example, the object representing an air handler should include fan, filter, and optional coil and damper elements (each of which is itself an object).  When setting up an AHU object, the user should be prompted to define which of these objects exist.
#. To the extent feasible, mutually exclusive options should be excluded by the object model.  For example, an air handler can have a dedicated minmum outside air intake, or it can have a combined economizer/minimum OA intake, but it cannot have both.
#. The complexity of the object model shall be hidden from the end user.


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
