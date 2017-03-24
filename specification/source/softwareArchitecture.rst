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

.. uml::
   :caption: Overall software architecture.

   skinparam componentStyle uml2

     package "Controls Design Tool" as ctl_des {
       [Sequence Generator]
       [CDL Exporter]
     }
     package "Functional Verification Tool" as vt{
       [I/O\nConfiguration]
       [Engine]
     }
     [CDL Parser]
     [JModelica]

   ctl_des -d-> [CDL Parser]: uses
   vt -d-> [CDL Parser]: uses
   [CDL Parser] -d-> [JModelica]: uses

:numref:`fig_architecture_overall_obc` shows the overall
system with the `Contorls Design Tool` and the
`Functional Verification Tool`. Both use
a `CDL Parser` which parses the CDL language,
using `JModelica` to parse the AST.
All these components will be made available through OpenStudio.
This allows using the OpenStudio model authoring
and simulation capability that is being developed
for the Spawn of EnergyPlus (SOEP).
See also
https://www.energy.gov/eere/buildings/downloads/spawn-energyplus-soep and
its development site
https://lbl-srg.github.io/soep/softwareArchitecture.html.

Controls Design Tool
^^^^^^^^^^^^^^^^^^^^

.. _fig_architecture_overall_ctrl_design:

.. uml::
   :caption: Overall software architecture of the Controls Design Tool.

   skinparam componentStyle uml2

   package OpenStudio {
     [HVAC System Editor]
     package "Controls Design Tool" as ctl_des {
       [Sequence Generator]
       [CDL Exporter]
     }
   }

   database "Modelica\nSystem\nModel" as sys_mod {
      database "Control\nModel" as ol_ctr
      database "Plant\nModel" as plt
   }

   database "CDL\nLibrary"

   [CDL Parser]
   ctl_des -r-> [CDL Parser]: uses

   [HVAC System Editor] -> sys_mod: manipulates
   [Sequence Generator] -> ol_ctr: generates initial\nblock diagram
   [CDL Exporter] -> [JModelica]: parses AST

   [JModelica] -> [CDL\nLibrary]: imports

   [CDL Exporter] -> [CDL-Compliant\nSpecification]: exports
   [CDL Exporter] -> [ol_ctr]: imports

   note "E.g., add point lists, connect control to plant, etc." as ex_use
   [ol_ctr] .. ex_use
   ex_use .. [HVAC System Editor]


:numref:`fig_architecture_overall_ctrl_design`
shows the overall
software architecture of the controls design tool.
The `OpenStudio` container indicates that the
`Controls Design Tool` will be part of OpenStudio,
thereby using the OpenStudio Modelica run-time
to evaluate the open-loop and closed-loop control
performance. This will also allow accessing the
`HVAC System Editor` that is being developed
for SOEP.

The `Controls Design Tool` will be contain two main modules:

 * A `Sequence Generator` that generates an initial control
   sequence that may later be adapted to a specific project, and
 * A `CDL Exporter` that exports a CDL-compliant specification.

The `Controls Design Tool` will use a `CDL Parser` that
parses the CDL library and CDL-compliant specifications.
The `Sequence Generator` will guide the user
through a series of questions about the plant and control,
and then generates a `Control Model` that contains
the open-loop control sequence.
Using the `HVAC System Editor`, the user will then connect
it to a plant model (which consist of the HVAC and building model
with exposed control inputs and sensor outputs).
This connection will allow testing
and modification of the `Control Model` as needed. Hence,
using the `HVAC System Editor`, the user can manipulate
the sequence to adapt it to the actual project.

.. note:: The `Modelica System Model` will appear to OpenStudio
          as any other Modelica model.
          This will allow using
          the OpenStudio SDK and OpenStudio measures. In fact,
          the `Sequence Generator` may use OpenStudio measures
          to instantiate the `Control Model`.

We will now explain how a `CDL-Compliant Specification` is exported.
The user (or a call from the OpenStudio SDK to the `Controls Design API`)
will invoke export of a `CDL-Compliant Specification`, to be
used for bidding, software implementation and verification testing.
Then, the `CDL Exporter` will import the `Control Model` and
parse its AST using JModelica. It will then export a
`CDL-Compliant Specification` that consists of

 * the Modelica models in CDL (see :numref:`sec_cdl`),
 * an English language description in HTML, and
 * a point lists in JSON (used for downstream
   applications, and optionally generated if the `Control Model`
   contains point list)

Note that from the `CDL-Compliant Specification`, only the
models in CDL can be manipulated and reused upstream as the
`Control Model`. The HTML and JSON are for information or further
downstream processing only.


Functional Verification Tool
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _fig_architecture_overall_verification:

.. uml::
   :caption: Overall software architecture of the Functional Verification Tool.

   skinparam componentStyle uml2

   package "Functional Verification Tool" as vt{
       [I/O\nConfiguration]
       [Engine]
       [Viewer]
   }
   [CDL Parser]
   [JModelica]
   database "Modelica\nControl\nModel" as mod_ctl
   [FMU]
   [Reports] <<htlm, json>>
   [HIL Module]

   vt -r-> [CDL Parser]: uses
   [I/O\nConfiguration] -> mod_ctl : updates point list
   [Engine] -> [FMU] : inserts point list
   [Engine] -> [JModelica] : invokes FMU export
   [JModelica] -l-> mod_ctl: imports
   [JModelica] -> [FMU] : exports
   [Engine] -> [HIL Module]: connect
   [Engine] -> [Reports]: writes
   [Viewer] -> [Reports]: imports

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
The `Engine` invokes `JModelica` to export an FMU of the control
blocks. As `JModelica` does not parse CDL information
that is stored in vendor annotations (such as the point mapping),
the `Engine` will insert point lists into the ``Resources`` directory
of the `FMU`.
To conduct the verification, the `Engine` will connect to a
`HIL Module`, such as Volttron or the BCVTB, and set up a
closed loop model, using the point list from the FMU's ``Resources``
directory.
During the verification, the `Engine` will write reports
that are displayed by the `Viewer`.
