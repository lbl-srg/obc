.. _sec_soft_arch:

Software Architecture
---------------------

This section describes the software architecture
of the controls design tool and the functional verification tool.
In the text below, we mean by *plant* the HVAC and building system,
and by *control* the controls other than product integrated controllers
(PIC).
Thus, the HVAC or building system model may, and likely will,
contain product integrated controllers, which will be out
of scope for CDL apart from reading measured values from PICs and
sending setpoints to PICs.


.. _fig_architecture_overall_obc:

.. figure:: img/uml/softwareArchitecture_01.*
   :width: 600px

   Overall software architecture.

:numref:`fig_architecture_overall_obc` shows the overall
system with the `Controls Design Tool` and the
`Functional Verification Tool`. Both use
a `CDL Parser` which parses the CDL language.
This parser is currently in development at https://github.com/lbl-srg/modelica-json. [#parser]_
The CDL parser reads a `CDL-compliant Control Sequence`,
which may be provided by the user or taken from
https://simulationresearch.lbl.gov/modelica/releases/v12.1.0/help/Buildings_Controls_OBC_ASHRAE.html
and the `CDL Library`, see https://simulationresearch.lbl.gov/modelica/releases/v12.1.0/help/Buildings_Controls_OBC_CDL.html
All these components will be made available through OpenStudio.
This allows using the OpenStudio model authoring
and simulation capability that is being developed
for the Spawn of EnergyPlus (SOEP).
See also
https://www.energy.gov/eere/buildings/articles/spawn-energyplus-spawn and
its development site
https://lbl-srg.github.io/soep/softwareArchitecture.html.

Controls Design Tool
^^^^^^^^^^^^^^^^^^^^

.. _fig_architecture_overall_ctrl_design:

.. figure:: img/uml/softwareArchitecture_02.*
   :width: 600px

   Overall software architecture of the Controls Design Tool.

:numref:`fig_architecture_overall_ctrl_design`
shows the overall
software architecture of the controls design tool.
The `OpenStudio` invokes a Modelica to json parser which
parses the Modelica libraries to `json`, and it invokes the `HVAC/controls tool`.
The `HVAC/controls tool` reads the json representation of the
Modelica libraries that are used.
The `HVAC/controls tool` updates the json reprensentation of the model,
and these changes will be merged into the Modelica model or Modelica package
that has been edited.
For exporting the sequence for simulation or for operation, `OpenStudio`
invokes `OPTIMICA` which generates an FMU of the sequence, or multiple FMUs
if the sequence is to be distributed to different field devices.
The `Building Operating System` then imports these FMUs.

If a `Building Automation System` prefers not to run FMUs to compute the control
signals, then it could convert the json format to a native implementation
of the control sequence.

Optionally, to aid the user in customizing sequences, a `Sequence Generator`
could be generated. This is currently not shown in
:numref:`fig_architecture_overall_ctrl_design`.
The `Sequence Generator` will guide the user
through a series of questions about the plant and control,
and then generates a `Control Model` that contains
the open-loop control sequence. This `Control Model` uses the CDL
language, and can be stored in the `Custom or Manufacturer Modelica Library`.
Using the `HVAC/controls tool`, the user will then connect
it to a plant model (which consist of the HVAC and building model
with exposed control inputs and sensor outputs).
This connection will allow testing
and modification of the `Control Model` as needed. Hence,
using the `Schematic editor`, the user can manipulate
the sequence to adapt it to the actual project.

How sequences can be exported to control systems is described
in :numref:`sec_code_gen`.



Functional Verification Tool
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _fig_architecture_overall_verification:

.. figure:: img/uml/softwareArchitecture_03.*
   :width: 600px

   Overall software architecture of the Functional Verification Tool.

The `Functional Verification Tool` consists of three modules:

 * An `I/O Configuration` module that adds I/O information to the
   point list,
 * a `Engine` that is used to conduct the actual verification, and
 * a `Viewer` that displays the results of the verification.

The `Functional Verification Tool` uses that same `CDL Parser` as is used
for the `Controls Design Tool`.
The `I/O Configuration` module will allow users (such as a
commissioning agent) to update the point list.
This is needed as not all
point mappings may be known during the design phase.
The `Engine` invokes `OPTIMICA` to export an FMU-ME of the control
blocks. As `OPTIMICA` does not parse CDL information
that is stored in vendor annotations (such as the point mapping),
the `Engine` will insert point lists into the ``Resources`` directory
of the `FMU-ME`.
To conduct the verification, the `Engine` will connect to a
`HIL Module`, such as Volttron or the BCVTB, and set up a
closed loop model, using the point list from the FMU's ``Resources``
directory.
During the verification, the `Engine` will write reports
that are displayed by the `Viewer`.


.. rubric:: Footnotes

.. [#parser] Using a parser that only requires Java has the advantage
             that it can be used in other applications that may not have
             access to a OPTIMICA installation.
