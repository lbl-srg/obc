[mg disclamer: Incorporate this into cdl.rst under annotations once we develop the concept. Language is occasionally loose since it serves as a base for discussion and should get commed through before moving to cdl.rst.]

Tagging Concept
------------

Address the following doc sections


Goals and constraints
----------------------
CDL

#. Utilize Modelica capabilities | evaluate development cost
#. Make it easier for the control designer to use the tool/learn how to use the tool [think education]/[side idea: what are the savings achieved in design/commissioning]
#. Reduce error rate by disallowing connections between values which are not compatible
#. Generate default tags and prompt/allow/encourage user to customize them for a specific project
#. Allow user to add optional taggs that might be required by a specific project
#. Reduce design and commissioning workload/achieve savings
#. Parsing?
#. address both HVAC and non-HVAC equipments

Controls Design tool

#. Plant - levels - hierarchy - tool navigation, see section from below
+++++


From Requirements

Plant: controlled system, which may be a chiller plant, an HVAC system, an active facade, a model of the building etc.

7. When the control sequences are coupled to plant models, the controls design tool shall allow users to tag the thermofluid dependencies between different pieces of equipment in the object model. [For example, for any VAV box, the user can define which AHU provides the airflow, which boiler (or system) provides the hot water for heating, etc.]

10. The controls design tool shall prompt the user to provide necessary information when instantiating objects. For example, the object representing an air handler should include fan, filter, and optional coil and damper elements (each of which is itself an object). When setting up an AHU instance, the user should be prompted to define which of these objects exist.
++++++



Tagging: functional requirement
----------------------
The requirement boils down to enabling the user to attach the following tags to the following values




Tagging: proposed design
----------------------


Writte up from the paper schetches 


Explain what becomes mandatory and what preset optional and user can add optional


Benefits
----------------------




Example Usage and Test against notes captured in requirements.rst under CDL
----------------------
From Software Architecture

The Controls Design Tool will use a CDL Parser that parses the CDL library and CDL-compliant specifications. The Sequence Generator will guide the user through a series of questions about the plant and control, and then generates a Control Model that contains the open-loop control sequence. Using the HVAC System Editor, the user will then connect it to a plant model (which consist of the HVAC and building model with exposed control inputs and sensor outputs). This connection will allow testing and modification of the Control Model as needed. Hence, using the HVAC System Editor, the user can manipulate the sequence to adapt it to the actual project.

Evaluate CDL 4, 5, 6, 7









