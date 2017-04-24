[mg disclamer: Incorporate this into cdl.rst under annotations once we develop the concept. Language is occasionally loose since it serves as a base for discussion and should get combed through before moving to cdl.rst.]

Tagging Concept
------------




Goals and constraints
----------------------
CDL

#. Utilize Modelica capabilities | evaluate development cost
#. Make it easier for the control designer to use the tool/learn how to use the tool [think education]/[side idea: what are the savings achieved in design/commissioning]
#. Reduce error rate by disallowing connections between values which are not compatible
#. Generate default tags and prompt/allow/encourage user to customize them for a specific project
#. Allow user to add optional tags that might be required by a specific project
#. Reduce design and commissioning workload/achieve savings
#. Parsing?
#. address both HVAC and non-HVAC equipments

Controls Design tool

#. Plant - levels - hierarchy - tool navigation, see section from below

Focusing on CLD having the brick and related ontologies in mind, see references. Integration with the higher level systems should include some further reading to enable integration with the current SOA of bui sys tagging.
+++++


From Requirements

Plant: controlled system, which may be a chiller plant, an HVAC system, an active facade, a model of the building etc.

7. When the control sequences are coupled to plant models, the controls design tool shall allow users to tag the thermofluid dependencies between different pieces of equipment in the object model. [For example, for any VAV box, the user can define which AHU provides the airflow, which boiler (or system) provides the hot water for heating, etc.]

10. The controls design tool shall prompt the user to provide necessary information when instantiating objects. For example, the object representing an air handler should include fan, filter, and optional coil and damper elements (each of which is itself an object). When setting up an AHU instance, the user should be prompted to define which of these objects exist.
++++++

Types of tags
----------------

Mandatory - required by the tool to process, populated by default values if omitted
Optional - preprogrammed tags that user may or may not populate. If not populated these tags will remain empty
Additional - tags that user can add and populate if required

Tagging: functional requirement
----------------------
Categories of tagged objects and categories of tags in CDL.

Let's focus on Controls Design. Note that in CDL physical system elements are present in the form of inputs and outputs. For instance, there are no coils and dampers in CDL, but these elements are represented by damper enable/disable status, damper position, cooling and heating signal. CDL is agnostic of the performance of the actual damper motor and the thermodynamics of coils and only cares about the sensor/setpoint inputs.

Inputs can be analogue and digital

Project--------------------------

Purpose in CDL:
*. Overarching project for which the user designs the control sequences

Mandatory tags
*. 'Location' (e.g. "Oakland West")
*. 'Name' (e.g. "High Efficiency Low Cost Housing")
*.

Optional tags
*. 'Project ID'
*. ''
*.


Plants----------------------------

*. Refers to physical system (AHU: Coils, Fans, Dampers, VAV Boxes: Fans, [Coils])
  *.
  *.
  *.

*. Plants can only contain interface blocks that send inputs and receive outputs from CDL.

*. Interface blocks:
  *. should be configured to output CDL readable values and, conversely, receive values from CDL and have "placeholders" to translate the values to a format required by actuators.
  *. should



Control System

-





- include tag that renders sequence G36 compliant, since Paul says people use other - it's a guideline


Tagging: proposed design (actual software implementation)
----------------------

Tag categories conveyed using Modelica interfaces (inputs, outputs and connectors)

Enumerated types
- inputs

Use Modelica meta-data capabilities, parameters and annotations to program the remainder of the tags
http://www.ep.liu.se/ecp/096/018/ecp14096018.pdf



Benefits
----------------------




Example Usage and Test against notes captured in requirements.rst under CDL
----------------------
From Software Architecture

The Controls Design Tool will use a CDL Parser that parses the CDL library and CDL-compliant specifications. The Sequence Generator will guide the user through a series of questions about the plant and control, and then generates a Control Model that contains the open-loop control sequence. Using the HVAC System Editor, the user will then connect it to a plant model (which consist of the HVAC and building model with exposed control inputs and sensor outputs). This connection will allow testing and modification of the Control Model as needed. Hence, using the HVAC System Editor, the user can manipulate the sequence to adapt it to the actual project.

Evaluate CDL 4, 5, 6, 7



Refs
-----
#. http://www.synergylabs.org/yuvraj/docs/Balaji_BuildSys16_Brick.pdf

#. L. Daniele, F. den Hartog, and J. Roes. Study on semantic
assets for smart appliances interoperability: D-S4: Final
report. Technical report, European Union, 2015.

#. On meta-data in Modelica
http://www.ep.liu.se/ecp/096/018/ecp14096018.pdf
