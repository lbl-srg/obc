Generating a Modelica Model from Semantic Model
-----------------------------------------------------

In this section, we will specify how to generate a 
Modelica model from a semantic model of a building 
or a Heating, Ventilation and Air Conditioing (HVAC)
system. This Modelica model then serves as the format
from which control sequences (CDL and CXF), point lists,
etc. can be exported.

Building semantic models provide information
about the equipment topology and how they are connected.
Semantic models enable assigning
machine-readable metadata to control points and enable the
development of portable analytics and control
applications. 

Workflow
^^^^^^^^

The current workflow for generating a Modelica model 
(along with the control sequences) leverages the 
Templates package of in the Modelica Buildings Library
(https://simulationresearch.lbl.gov/modelica/releases/v11.0.0/help/Buildings_Templates.html).
As of Buildings version 11, there are three system templates - one for an
Air Handling Unit (AHU), one for a Variable Air
Volume (VAV) terminal and one for an air source heat pump plant.
As the templates are used to generate the Modelica models,
only these types of systems are covered.
The process is described in :numref:`fig_semanticToMo_flowchart`


.. _fig_semanticToMo_flowchart:

.. figure:: img/semanticToModel.*
   :width: 700px
   :height: 1000px

   Flowchart describing the workflow of generating a
   Modelica file from a semantic model of a HVAC 
   system.

Example
^^^^^^^

From a ASHRAE Standard 223P semantic model that describes
two VAV boxes,
:numref:`fig_s223ToVAVBox` describes the workflow
to query the necessary sensors and instantiate the
corresponding Modelica models using the VAVBox
template from the Modelica Buildings Library.
 
.. _fig_s223ToVAVBox:

.. figure:: img/VAVworkflow.*
   :width: 700px
   :height: 1000px

   Flowchart describing the workflow of generating a
   Modelica model of two VAVBoxes described using the proposed
   ASHRAE S223P semantic standard. 

