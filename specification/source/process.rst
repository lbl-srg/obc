.. _sec_process:

Process Workflow
----------------

The actual process work flow needs to be refined by the project team
with input from the Technical Advisory Group.
:numref:`fig_process` shows the proposed process:
First, given regulations and efficiency targets (1),
a design engineer selects, configures, tests and evaluates the performance of a control sequence
within the Controls Design Tool (2),
starting from a control sequence library that contains ASHRAE GPC 36 sequences,
as well as user-added sequences (3),
linked to a model of the mechanical system and the building (4).
If the sequences meet closed-loop performance requirements,
the designer exports a control specification,
including the sequences and functional verification tests expressed in
the Controls Description Language CDL (5).
Optionally, for reuse in similar projects,
the sequences can be added to a user-library (6).
This specification is used by the control vendor to bid on the project (7)
and to implement the sequence (8) in product-specific code.
Prior to operation, a commissioning provider verifies
the correct functionality of these implemented sequences
by running functional tests against the electronic, executable specification
in the Commissioning and Functional Verification Tool (9).
If the verification tests fail, the implementation needs to be corrected.

For closed-loop performance assessment and verification in the Controls Design Tool
and Commissioning and Functional Verification Tool,
`Modelica models <http://simulationresearch.lbl.gov/modelica/>`_
of the HVAC systems and controls will be linked to
a Modelica envelope model or to
an EnergyPlus envelope model through its
`External Interface <http://simulationresearch.lbl.gov/fmu/EnergyPlus/export/index.html>`_.
If a project-specific simulation model of the building
and its systems already exists,
it can be imported into the control design tool. Otherwise, a building model,
based on the most appropriate DOE prototype, can be used to evaluate control strategies
for the given climate and use patterns.


.. _fig_process:

.. figure:: img/ControlsDesignVerficationFlow.*
   :width: 800px

   Process workflow for controls design, specification and
   functional verification.
