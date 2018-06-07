.. _sec_requirements:

Requirements
------------

This section describes the functional, mathematical and software requirements.
The requirements are currently in discussion and revision with the team.

In these discussion, by :term:`plant`, we mean the controlled system, which may be a chiller plant,
an HVAC system, an active facade, a model of the building etc.

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
   energy cost, and comfort (for each instant of the simulation)
   of control sequences when connected to a building system model.
#. The controls design tool shall allow users to test control sequences coupled to the equipment that constitutes their HVAC system.
#. When the control sequences are coupled to plant models, the controls design tool shall allow users to tag the thermofluid dependencies between different pieces of equipment in the object model. [For example, for any VAV box, the user can define which AHU provides the airflow, which boiler (or system) provides the hot water for heating, etc.]
#. The control design tool shall include templates for common objects.
#. A design engineer should be able to easily modify the library of predefined
   control sequences by adding or removing blocks.
#. The controls design tool shall prompt
   the user to provide necessary information when instantiating objects.
   For example, the object representing an air handler should include fan, filter,
   and optional coil and damper elements (each of which is itself an object).
   When setting up an AHU instance, the user should be prompted to define
   which of these objects exist.
#. To the extent feasible, the control design tool shall prevent mutually exclusive options in the description of the physical equipment.
   [For example, an air handler can have a dedicated minimum outside air intake,
   or it can have a combined economizer/minimum OA intake, but it cannot have both.]
#. The controls design tool shall hide the complexity of the object model from the end user.
#. The controls design tool shall integrate with OpenStudio.
#. The controls design tool shall work on Windows, Linux Ubuntu
   and Mac OS X.
#. The controls design tool shall either run as a webtool (i.e. in a browser) or via a standalone executable that can be installed including all its dependencies.


CDL
^^^

#. The CDL shall be declarative.
#. CDL shall be able to express control sequences and their linkage to an object model which represents the plant.
#. CDL shall represent control sequences as a set of blocks (see :numref:`sec_enc_block`) with inputs and outputs
   through which blocks can be connnected.
#. It shall be possible to compose blocks hierarchically to form new blocks.
#. The elementary building blocks [such as an gain] are defined through their input, outputs, parameters, and their response to given outputs.
   The actual implementation is not part of the standard [as this is language dependent].
#. Each block shall have tags that provide information about its general function/application [e.g. this is an AHU control block] and its specific application [e.g. this particular block controls AHU 2].
#. It shall be possible to identify whether a block represents a physical sensor/actuator, or a logical signal source/sink. [As this is used for pricing.]
#. Blocks and their inputs and outputs shall be allowed to contain metadata.
   The metadata shall identify expected characteristics, including but not limited to the following.
   For inputs and outputs:

   #. units,
   #. a quantity [such as "return air temperature" or "heating requests" or "cooling requests"],
   #. analog or digital input or output, and
   #. for physical sensors or data input, the application
      (e.g. return air temperature, supply air temperature).

   For blocks:

   #. an equipment tag [e.g., air handler control],
   #. a location [e.g., 1st-floor-office-south], and
   #. if they represent a sensor or actuator, whether they are a physical device
      or a software point. [For physical sensors, the signal is read by
      a sensor element, which converts the physical signal into a software point.]

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
#. The object model must be rigorous, extensible and flexible.
#. The object model must be relational, inherently defining connections between different objects.
#. The system must support many-to-many relationships [For example, two parallel chilled water pumps
   can serve three parallel chillers (see also Brick's "isPartOf" and "feeds").]
#. Each distinct piece of equipment [e.g. return air temperature sensor]
   shall be represented by a unique instance.


Commissioning and Functional Verification Tool
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. The CDL tool shall import verification tests expressed in CDL, and a list
   of control points that are used for monitoring and active functional testing.
#. The commissioning and functional verification tool shall be able to
   read data from, and send data to, BACnet, possibly using a middleware such as
   VOLTTRON or the BCVTB.
#. It shall be possible to run the tool in batch mode as part of a real-time
   application that continuously monitors the functional verification tests.
#. The commissioning and functional verification tool shall work
   on Windows, Linux Ubuntu and Mac OS X.
