[disclamer incorporate this into cdl.rst under annotations once we develop the concept]

Some title
------------

Address the following doc sections

From Software Architecture

The Controls Design Tool will use a CDL Parser that parses the CDL library and CDL-compliant specifications. The Sequence Generator will guide the user through a series of questions about the plant and control, and then generates a Control Model that contains the open-loop control sequence. Using the HVAC System Editor, the user will then connect it to a plant model (which consist of the HVAC and building model with exposed control inputs and sensor outputs). This connection will allow testing and modification of the Control Model as needed. Hence, using the HVAC System Editor, the user can manipulate the sequence to adapt it to the actual project.

From Requirements








Plant: controlled system, which may be a chiller plant, an HVAC system, an active facade, a model of the building etc.

7. When the control sequences are coupled to plant models, the controls design tool shall allow users to tag the thermofluid dependencies between different pieces of equipment in the object model. [For example, for any VAV box, the user can define which AHU provides the airflow, which boiler (or system) provides the hot water for heating, etc.]

10. The controls design tool shall prompt the user to provide necessary information when instantiating objects. For example, the object representing an air handler should include fan, filter, and optional coil and damper elements (each of which is itself an object). When setting up an AHU instance, the user should be prompted to define which of these objects exist.


Goals and constraints
----------------------



Tagging: functional requirement
----------------------



Tagging: proposed design
----------------------







Benefits
----------------------



Example Usage and Test against notes captured in requirements.rst under CDL
----------------------

CDL

4 - 6 and 7









