.. _sec_process:

Process Workflow
----------------

:numref:`fig_process` shows the process of selecting, deploying and verifying a control sequence
that we follow in OpenBuildingControl.
First, given regulations and efficiency targets, labeled as (1) in :numref:`fig_process`,
a design engineer selects, configures, tests and evaluates the performance of a control sequence
using building energy simulation (2),
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

For closed-loop performance assessment,
`Modelica models <http://simulationresearch.lbl.gov/modelica/>`_
of the HVAC systems and controls will be linked to
a Modelica envelope model or to
an EnergyPlus envelope model. This can currently be done through the
`External Interface <http://simulationresearch.lbl.gov/fmu/EnergyPlus/export/index.html>`_,
and a more direct coupling is in development through the
`Spawn of EnergyPlus <https://www.energy.gov/eere/buildings/downloads/spawn-energyplus-spawn>`_ project.

.. _fig_process:

.. figure:: img/ControlsDesignVerficationFlow.*
   :width: 800px

   Process workflow for controls design, specification and
   functional verification.
