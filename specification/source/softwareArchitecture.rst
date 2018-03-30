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
   :width: 600px

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
     [CDL-compliant Control Sequence]
     [CDL Library]

   ctl_des -d-> [CDL Parser]: uses
   vt -d-> [CDL Parser]: uses
   [CDL Parser] -d-> [CDL-compliant Control Sequence]: reads
   [CDL Parser] -d-> [CDL Library]: reads

:numref:`fig_architecture_overall_obc` shows the overall
system with the `Controls Design Tool` and the
`Functional Verification Tool`. Both use
a `CDL Parser` which parses the CDL language.
This parser is currently in development at https://github.com/lbl-srg/modelica-json. [#parser]_
The CDL parser reads a `CDL-compliant Control Sequence`,
which may be provided by the user or taken from
http://simulationresearch.lbl.gov/modelica/releases/v5.0.1/help/Buildings_Controls_OBC_ASHRAE.html
and the `CDL Library`, see http://simulationresearch.lbl.gov/modelica/releases/v5.0.1/help/Buildings_Controls_OBC_CDL.html
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
   :width: 600px

   skinparam componentStyle uml2


   package OpenStudio {
   }

   package "HVAC/controls tool" as edi {
     [Web-based GUI]
   }

   interface json as mod_jso_par

   database "Modelica libraries" as mod_lib

   edi <-> mod_jso_par : reads/writes json

   mod_jso_par <-> mod_lib

   package JModelica {
   }

   OpenStudio -d-> edi : invokes
   OpenStudio -d-> JModelica : invokes

   JModelica -u-> mod_lib: loads

   interface FMUs

   JModelica -d-> FMUs : generates

   package "Buildings Operating System" as BOS {
     database "I/O drivers" as dri2
     database "runtime environment" as rte2
     database "operator interface" as opi2
   }

   package "Buildings Automation System" as BAS {
     database "I/O drivers" as dri1
     database "runtime environment" as rte1
     database "operator interface" as opi1
   }

   BAS -u-> mod_jso_par : converts

   BOS -u-> FMUs : imports

   interface Hardware

   BOS -d-> Hardware : I/O
   BAS -d-> Hardware : I/O

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
invokes `JModelica` which generates an FMU of the sequence, or multiple FMUs
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

.. uml::
   :caption: Overall software architecture of the Functional Verification Tool.
   :width: 600px

   skinparam componentStyle uml2

   package "Functional Verification Tool" as vt{
       [I/O\nConfiguration]
       [Engine]
       [Viewer]
   }
   [CDL Parser]
   [JModelica]
   database "Modelica\nControl\nModel" as mod_ctl
   [FMU-ME]
   [Reports] <<htlm, json>>
   [HIL Module]

   vt -d-> [CDL Parser]: uses
   [I/O\nConfiguration] -d-> mod_ctl : updates point list
   [Engine] -> [FMU-ME] : inserts point list
   [Engine] -d-> [JModelica] : invokes FMU-ME export
   [JModelica] -d-> mod_ctl: imports
   [Engine] -l-> [HIL Module]: connects
   [JModelica] -> [FMU-ME] : exports
   [Engine] -d-> [Reports]: writes
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
The `Engine` invokes `JModelica` to export an FMU-ME of the control
blocks. As `JModelica` does not parse CDL information
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
             access to a JModelica installation.
