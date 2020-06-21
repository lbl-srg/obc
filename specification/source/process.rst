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
the Control Description Language CDL (5).
Optionally, for reuse in similar projects,
the sequences can be added to a user-library (6).
This specification is used by the control vendor to bid on the project (7)
and to implement the sequence (8). For current control product lines,
step (8) involves a translation of CDL to their programming languages,
whereas in the future, control providers could build systems that directly use CDL.
Prior to operation, a commissioning provider verifies
the correct functionality of these implemented sequences
by running functional tests against the electronic, executable specification
in the Commissioning and Functional Verification Tool (9).
If the verification tests fail, the implementation needs to be corrected.

For closed-loop performance assessment,
`Modelica models <http://simulationresearch.lbl.gov/modelica/>`_
of the HVAC systems and controls can be linked to
a Modelica envelope model :cite:`WetterZuoNouidui2011:2` or to
an EnergyPlus envelope model. The latter can be done through
Spawn of EnergyPlus :cite:`WetterBenneGautierEtAl2020`,
which is being developed in a related project at
`https://lbl-srg.github.io/soep/ <https://lbl-srg.github.io/soep/>`_.

.. _fig_process:

.. figure:: img/ControlsDesignVerficationFlow.*
   :width: 800px

   Process workflow for controls design, specification and
   functional verification.
