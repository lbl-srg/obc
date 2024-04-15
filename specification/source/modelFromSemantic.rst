Generating a Modelica Model from Semantic Model
-----------------------------------------------------

In this section, we will specify how to generate a 
Modelica model from a semantic model of a building 
or an Heating, Ventilation and Air Conditioing (HVAC)
system. Building semantic models provide information
about the equipment topology, how they are connected
and uses standard definitions to describe the data 
sources and actuators. Such models enable assigning
machine-readable metadata to these points and enable
development portable analytics and control
applications. 

Workflow
^^^^^^^^
Note for reader: the software workflow described here
is subject to change. 

The current workflow for generating a Modelica model 
(along with the control sequences) leverages the 
Templates within the Modelica Buildings Library.
There are currently two system templates - one for an
Air Handling Unit (AHU) and other for a Variable Air
Volume box (VAV) and correspondingly, we can only 
generate Modelica models of these systems at this time.
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

From a ASHRAE S223P semantic model that describes
two VAV boxes,
:numref:`fig_s223ToVAVBox` describes the worfklow 
to query the necessary sensors and instantiate the
corresponding Modelica models using the VAVBox
template from Modelica Buildings Library.
 
.. _fig_s223ToVAVBox:

.. figure:: img/VAVworkflow.*
   :width: 700px
   :height: 1000px

   Flowchart describing the workflow of generating a
   Modelica model of two VAVBoxes described using
   ASHRAE S223P semantic standard. 

