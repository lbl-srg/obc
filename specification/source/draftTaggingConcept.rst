[fixme mg disclamer: Incorporate this into cdl.rst under annotations once we develop the concept. Language is occasionally loose since it serves as a base for discussion and should get combed through before moving to cdl.rst.]



Tagging Concept
------------

Before diving into tagging, let's get reminded that the tool, which we are developing in Modelica CDL, designs controls. In CDL physical system elements are present in the form of inputs and outputs, whereas the only physical component is the controller. For instance, there are no coils and dampers in CDL, instead these elements are represented by damper enable/disable status, damper position, cooling and heating signal, etc. CDL is agnostic of the performance of the actual damper motor and the thermodynamics of coils and only responds to the sensor/setpoint inputs.

Goals, Constraints, Benefits
----------------------

CDL

#. Utilize Modelica capabilities and consider constraints | evaluate development cost
#. Make it easier for the control designer to use the tool/learn how to use the tool [think education]
#. Reduce error rate by disallowing connections between values which are not compatible
#. Generate default tags and prompt/allow/encourage user to customize them for a specific project
#. Allow user to add optional tags that might be required by a specific project
#. Reduce design and commissioning workload/achieve savings [side idea: what are the savings achieved in design/commissioning]
#. Parsing - use tags to help translate sequence from CDL to english [let's just put this here]
#. Address both HVAC and non-HVAC equipments / extendability

Controls Design Tool

#. Introduce hierarchy and guidance for the user by the means of tags
#. Make it easier to navigate different parts of the control system

General

#. Make use of the Brick ontology [see references]
#. Enable extensions for future connectivity with third party tools/semantics

**Check if satisfied**

[mg - skip this for the first read]

From the Requirements -

7. When the control sequences are coupled to plant models, the controls design tool shall allow users to tag the thermofluid dependencies between different pieces of equipment in the object model. [For example, for any VAV box, the user can define which AHU provides the airflow, which boiler (or system) provides the hot water for heating, etc.]

10. The controls design tool shall prompt the user to provide necessary information when instantiating objects. For example, the object representing an air handler should include fan, filter, and optional coil and damper elements (each of which is itself an object). When setting up an AHU instance, the user should be prompted to define which of these objects exist.

From Software Architecture - check if satisfied

The Controls Design Tool will use a CDL Parser that parses the CDL library and CDL-compliant specifications. The Sequence Generator will guide the user through a series of questions about the plant and control, and then generates a Control Model that contains the open-loop control sequence. Using the HVAC System Editor, the user will then connect it to a plant model (which consist of the HVAC and building model with exposed control inputs and sensor outputs). This connection will allow testing and modification of the Control Model as needed. Hence, using the HVAC System Editor, the user can manipulate the sequence to adapt it to the actual project.

See CDL under 4, 5, 6, 7

[mg Amy's list should be covered with this proposed implementation.]

Types of tags
----------------

#. Mandatory - preprogrammed tags required by the tool, populated by default values and customizable
#. Optional - preprogrammed tags that user may or may not populate. If not populated these tags will remain empty
#. Additional - tags that user can add and populate if required


Tagging: Functional Requirement
----------------------

Hierarchy: All blocks apart from the basic blocks are tagged with a level that corresponds to the Control Design Tool hierarchy (explained in following sections).

The only non-hierarchical elements are the basic blocks [inputs, outputs, logic, controller], etc. They inherit the level from the first composite block to which they belong. It would be beneficial to enable code parsing in order to pull all tags pertaining to a particular basic block.

**Basic block tag categories** are [note that these are categories, see proposed design section for actual tags and proposed implementation]:

#. Hardware | Software [includes Network, proposing no separate tag]
#. Analog | Digital
#. Mode [fixme: to complete the list check G36]: FreezeProtectionStage | AHUMode | ZoneState | Alarm | BoilerRequest | ChillerRequest
#. Physical value: Temperature | Pressure | DamperPosition | Humidity | Speed | Status (or Command or Request)

List of **relational tags** copied over from Brick [see ref] that we should allocate to applicable elements, where meaningful:

#. contains/isLocatedIn [physical location]
#. controls/isControlledBy [use for relations between Plant (Interface block) and Sequence block]
#. hasPart/isPartOf [this we could probably get rid of if we opt to keep the "Level" tags]
#. feeds/isFedBy [each basic block and connector, do we need unique IDs to populate these tags - see section before References]
#. hasInput/isInputOf [all non-basic blocks below project level and input blocks]
#. hasOutput/isOutputOf [all non-basic blocks below project level and output blocks]

[fixme: add an exhaustive list of mandatory and optional tags]

[modelica types and connector will take care of the units]


**Level00: Project**
--------------------

Definition: Overarching project for which the user designs the control sequences. It can scale from a small AHU control design to a complex multiple plant control system. [harmonize language with Paul/Brent/Steve]

Purpose in CDL: Referencing and documentation

Mandatory tags #used to refer to the project:

#. name (e.g. "Green Building")

Optional tags:

#. isLocatedIn (e.g. "Oakland West")
#. designedBy (e.g. "Brent Eubanks")

Additional tags:

#. projectID (e.g. "02-5165B")
#. deadline (e.g. "Nov_2019")
#. commissionedBy

**Level10: Plants**
--------------------

Definition: A plant is a CDL related model of the physical system (AHU: Coils, Fans, Dampers, VAV: Fans, [Coils]) controlled by a CDL sequence. There are no physical elements in the plant model and the plant is represented by sensors, actuators and averaging blocks packaged in InterfaceBlocks (Level11).

Contains sub-elements:
Level11: Interface blocks [mg this is a fresh idea which needs some thought]:

Definition: Interface blocks are blocks that are able to receive sensor output from the plant sensors and convert [and if needed average] the plant signals into CDL format, so that the values can be passed on to the CDL control system. In the first version of CDL we could have placeholder blocks that could handle any tag/format conversion between CDL and third party tools. For example, outdoor air temperature is an average over 3 temperature sensor outputs. InterfaceBlock can receive the three inputs, convert to CDL type, average, and output a CDL type averaged temperature, which can then be used as input to a number of CDL sequences. InterfaceBlock could hold all inputs and ouputs for a single plant.

Mandatory tags:

#. name (e.g. "Yellow AHU")
#. equipment (e.g. "AHU", "VAV", "Lighting", "Facade", "Fire Safety", "Water")
#. isControlledBy (e.g. "Control System 1" - a name tag of the Control System which controls the plant)
#. isPartOf (populate by project name)

Optional tags:

#. isLocatedIn (e.g. "First Floor")
#. feeds (e.g. "First Floor")

Additional tags:

#. brand (e.g. "noAddsHere")

**Level11: InterfaceBlocks**

Mandatory tags:

#. equipment (e.g. "AHU", "VAV", "Lighting", "Facade", "Fire Safety", "Water")
#. isControlledBy (populate by the name of the Control System that controls the given plant)
#. isPartOf (populate by project name)

Optional tags:

#. isLocatedIn (e.g. "First Floor")

Additional tags:

#. protocol (e.g. "BACnet")
#. network (e.g. "First Floor Network")

Plants can only contain interface blocks that send inputs to and receive outputs from CDL.


**Level20: Control System**
--------------------

Definition: Control System is a compilation of control sequences programmed in CDL, which provides all the required control signals to maintain desired plant operation. 

Contains the following sub-levels [mg These definitions are not the best. This can evolve as we develop the sequences]:

Level21: Full Sequence [this might be obsolete given the two levels below (22, 23)]

Definition: A full G36 sequence or an equivalent custom sequence. For simpler sequences this could be the same as the composite sequence.

Level22: Composite Sequence

Definition: A sequence that comprises several atomic sequences and traditionally controls one or more physical variables [damper position].

Level23: Atomic Sequence

Definition: Smallest control sequence which likely contains one controller or some on/off logic to control a variable/setpoint.

Level 20

Mandatory tags:

#. name (e.g. "Single Zone VAV 1", or use this for composite sequence and inherit plant name here)
#. feeds (inherit name of the plant controlled by this control system)
#. isPartOf (project name)
#. isInputOf (name of the plant interface block)
#. hasOutput (name of the plant interface block)

Optional tags:

#. contains (inherit names of Full, composite and atomic sequences?)
#. isLocatedIn (inherit location from the plant) [this tag could be just location, but make sure to use one or the other]

Additional tags:

#. implementation (e.g. "G36" [this could be mandatory for all G36 compliant sequences], "someCompany")


**Level21: Full Sequence** [G36 or custom]

Mandatory tags:

#. 

Optional tags:

#. 

Additional tags:

#. 


**Level22: Composite sequence**

Mandatory tags:

#. a

Optional tags:

#. a

Additional tags:

#. a

**Level23: Atomic sequence**

Mandatory tags:

#. a

Optional tags:

#. a

Additional tags:

#. a

- include tag that renders sequence G36 compliant, since Paul says people use other - it's a guideline


Tagging: Proposed Design
----------------------

This section discusses the software implementation. Modelica capabilities we can utilize to implement the tagging are:

#. Interfaces: inputs, outputs, and connectors (that carry type, unit, customize connectivity)
#. Block parameters
#. Block annotations
#. Further Modelica meta-data capabilities [see Refs 3]

Tag categories conveyed using Modelica interfaces (inputs, outputs and connectors)

**Interface Types**

The idea is to have most of the obvious tags built in within the interface. For example, the temperature is always analog and its unit/displayUnit are fixed, so that should be a part of the interface block by default, but one should be able to parse the block and get the information if need be [for documentation]).

Interfaces are customized to have predefined units and types (e.g. type Temperature). We might be able to limit the interface selection to only those listed below, redefine real to Analog, boolean to Digital, and replace integer with enumerated types. [mg Remove any unused interfaces, not sure about integer, once we've covered all sequences)

There should be an Input, Output, and a Connector for each of the listed:

#. HardwareTemperature
#. SoftwareTemperature
#. HardwarePressure
#. SoftwarePressure
#. HardwareDamperPosition
#. SoftwareDamperPosition
#. HardwareHumidity
#. SoftwareHumidity
#. HardwareFanSpeed
#. SoftwareFanSpeed

**Enumeration types**

#. FreezeProtectionStage
#. ZoneState
#. AHUMode
#. AlarmStatus
#. [mg - I think there were more categories in G36]

**Generic Interfaces for extensions**

#. HardwareDigital [mg set it up with boolean]
#. SoftwareDigital [mg set it up with real]
#. HardwareAnalog
#. SoftwareAnalog
#. SoftwareStatus [mg boolean]
#. CustomEnumeration [mg or similar]


Discussion points [optional read, this was mostly to help me out with the above schema]
----------------------
Should we have standardized unique identifiers for each block in CDL? To develop the schema below, I've used the following

xy_f_n_s_ab

where:

xy - the level to which the element belongs (level20 - control system, level21 - atomic block, level22 - composite block, level10 - plant block, level11 - interface block, level00 - project block)

f - the function (interface-[input, output, connector], controller, logic, atomicBlock, compositeBlock, interfaceBlock, plantBlock, projectBlock)

n - block has 0:no parameters, 1:only protected parameters, 2: parameters user can edit, 3: both 1 and 2

I'm inclined to hide this "old school" standardized schema, since it might limit the ease of use and extendability. However we might want to store some unique identifier internally, if we can make use of it [e.g. pull all tagging info from a block that feeds into a block that we are observing and have that be a parameter value placed under "isFedBy" parameter [if parameter used as a tag]]

s - serial number

ab - unique identifier [integer]

References
---------

1. http://www.synergylabs.org/yuvraj/docs/Balaji_BuildSys16_Brick.pdf

2. L. Daniele, F. den Hartog, and J. Roes. Study on semantic
assets for smart appliances interoperability: D-S4: Final
report. Technical report, European Union, 2015.

3. On meta-data in Modelica
http://www.ep.liu.se/ecp/096/018/ecp14096018.pdf
