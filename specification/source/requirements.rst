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
#. The controls design tool shall allow (require) users to define the equipment that constitutes their HVAC system via the CDL's object model.
#. The controls design tool shall allow (require) users to define the dynamic and thermodynamic relationships between different peices of equipment in the object model.  For example, for any VAV box, the user can define which AHU provides the airflow, which boiler (or system) provides the hot water for heating, etc.
#. The control design tool shall include templates for common objects.
#. The controls design tool shall prompt
   the user to provide necessary information when populating the object database.
   For example, the object representing an air handler should include fan, filter,
   and optional coil and damper elements (each of which is itself an object).
   When setting up an AHU instance, the user should be prompted to define
   which of these objects exist.
#. To the extent feasible, the control design tool shall prevent mutually exclusive options or conflicts in the description of the physical equipment.
   For example, an air handler can have a dedicated minimum outside air intake,
   or it can have a combined economizer/minimum OA intake, but it cannot have both.
#. The controls design tool shall hide the complexity of the object model from the end user.
#. The controls design tool shall integrate with OpenStudio.
#. The controls design tool shall work on Windows, Linux Ubuntu
   and Mac OS X.
#. The controls design tool shall either run as a webtool (i.e. in a browser) or via a standalone executable.  It shall not require the installation/configuration of a full version of Modelica.  (Brent: I believe this is essential to adoption.  Engineers typically do not have the patience or the time to install a new software ecosystem.  Look how long it took Revit to penetrate, and that was being pushed by big dog Autodesk.  I realize this may be an issue technically; this is a topic for discussion.)
#. A design engineer should be able to easily modify the library of predefined
   control sequences by adding or removing sub-blocks, limiting the need to
   modify the elemental blocks that make up the visual programming language.


CDL
^^^

#. The CDL shall be declarative in nature.  It shall (at minimum) be able to express both control sequences and an object model which represents the physical HVAC system.
#. CDL shall represent control sequences as a set of functional logic blocks and sub-blocks ("bricks"?).
#. Each sequence shall be a functional logic block consisting of other functional logic blocks and sub-blocks connected via specified inputs and outputs.
#. The "brick" shall be the most elemental sub-block, which contains line-code programming and is typically hidden from the specifying engineer (see design tool above).
#. Each functional block shall have tags that provide information about its general function/application (e.g. this is an AHU control block) and its specific application (e.g. this particular block controls AHU 2)
#. Each input and output to a functional block shall be tagged.  This tag shall identify expected characteristics for that point, including (at least):

   #. input or output;
   #. analog or digital;
   #. units;
   #. physical sensor or data input (from another logic block);
   #. for physical sensors, the type of sensor (e.g. temperature, pressure);
   #. for physical sensors, the application of the sensor
      (e.g. return air temperature, supply air temperature)

#. It shall be possible to translate control sequences that
   are expressed in the CDL
   to implementation of major control vendors.
#. It shall be possible to render CDL-compliant control sequences in a visual editor and in a textual
   editor.
#. CDL shall be a proper subset of Modelica 3.3 :cite:`Modelica2012:1`.
   [Section :ref:`sec_cdl` specifies what subset shall be supported. This will allow visualizing, editing and simulating
   CDL with Modelica tools rather than requiring a separate tool.
   It will also simplify the integration of CDL with the design and verification tools, since they use Modelica.]
#. It shall be possible to simulate CDL-compliant control sequences in an open-source, freely available
   Modelica environment.
#. It shall be possible to simulate CDL-compliant control sequences in the Spawn of EnergyPlus.
#. The physical equipment of HVAC system shall be described in terms of objects which are expressed in the CDL.
#. The object model must be rigorous, extensible and flexible.
#. The object model must be relational, inherently defining connections between different objects.
   The system must support many-to-many relationships - simple hierarchy is not sufficient.
#. Each distinct piece of equipment (e.g. return air temperature sensor) shall be represented by a unique
   instance.


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
