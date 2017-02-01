.. _sec_requirements:

Requirements
------------

This section describes the functional, mathematical and software requirements.
The requirements are currently in discussion and revision with the team.

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
#. The object model must be rigorous, extensible and flexible.
#. Common objects shall be predefined so that adding a device to the system model prompts
   the user to provide necessary information.
   For example, the object representing an air handler should include fan, filter,
   and optional coil and damper elements (each of which is itself an object).
   When setting up an AHU instance, the user should be prompted to define
   which of these objects exist.
#. To the extent feasible, mutually exclusive options should be excluded.
   For example, an air handler can have a dedicated minimum outside air intake,
   or it can have a combined economizer/minimum OA intake, but it cannot have both.
#. Each distinct piece of equipment (e.g. return air temperature sensor) shall be represented by a unique
   instance.
#. The object model must be relational, inherently defining connections between different objects.
   The system must support many-to-many relationships - simple hierarchy is not sufficient.
#. The complexity of the object model shall be hidden from the end user.
#. The controls design tool shall integrate with OpenStudio.
#. The controls design tool shall work on Windows, Linux Ubuntu
   and Mac OS X.
#. A design engineer should be able to easily modify the library of predefined
   control sequences by adding or removing sub-blocks, limiting the need to
   modify the elemental blocks that make up the visual programming language.


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
#. The CDL shall encompass (at least) actions and objects.  The HVAC system shall be described in terms of objects.
   Actions operate on objects and/or use data from objects to produce the desired control effects.
   [Comment mwetter: We need to discuss as actions are part of a tool that uses CDL,
   but CDL is declarative and does not need any actions defined.]


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
