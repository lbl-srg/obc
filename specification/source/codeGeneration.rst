.. _sec_code_gen:

Code Generation
---------------

This section describes the development of a proof-of-concept
translator from CDL to a building
automation system.
Translating CDL to a building automation system only needs to be done when
the CDL library is updated, and hence only developers need
to perform this step.
Translation of CDL-conforming control sequences will need
to be done for each building project.

The translation will for most if not all systems only be possible
from CDL to a building automation system. For example,
if Sedona were the target platform, then
translating from Sedona to CDL will not be possible
because Sedona allows for example, boolean variables
to have values ``true``, ``false`` and ``null``, but
CDL has no ``null`` value.


Most building automation product lines are based on very
old computing technologies. One may argue that to meet future process
requirements and user-friendliness, these may be updated in the near future.
Relatively recent or new product lines are

* Tridium Niagara, or its open version Sedona (http://www.sedonadev.org/),
* Distech control (http://www.distech-controls.com/en/us/), and
* Schneider Electric's EcoStruxture (https://www.schneider-electric.us/en/work/campaign/innovation/overview.jsp).

While Sedona has been designed for 3rd party developers to add
new functionality, the other seems rather closed. For example, detailed developer
documentation that describe

* the language specification for implementation of block diagrams,
* the model of computation, and
* how to simulate open loop control responses and implement regression testing,

are difficult to find, or maybe not even exist.
Although Sedona "is designed to make it easy to build smart, networked embedded devices"
and Sedona attempts to create an "Open Source Ecosystem" (http://www.sedonadev.org/),
developing block diagrams seem to require Tridium NiagaraAX, a commercial
product which is not free.
We thefore provide in
:numref:`tab_cod_gen_ove_sys` an overview of different paths for
implementation of a code generator. Here, we only included open-source
implementations, and for this purpose, also considered Sedona to be open-source,
although it seems to require proprietary software.
The entry Modelica/FMI/JavaScript consists of

* a block diagram editor based on CDL, which has to be developed for the
  Spawn of EnergyPlus and for the control design tool,
* a tool that exports these control sequences as an FMU for real-time control,
  such as JModelica, and
* a JavaScript-based GUI that visualizes the actual operation of the system
  for a building operator.

The Modelica/FMI/JavaScript approach has various synergies:
Regarding the design phase, it directly integrates with the
redesign of EnergyPlus, call SOEP and described at https://lbl-srg.github.io/soep/index.html.
Regarding the operation phase, it will
demonstrate how to add a control layer to efforts
that are targeted towards open-source building operating systems,
such as `xbos <https://docs.xbos.io/>`_ which typically cover
the communication layer but not the implementation of control sequences.
Therefore, the Modelica/FMI/JavaScript does not deal with how to link the sequences
with hardware, but rather will use efforts such as xbos for this layer.
For execution of control sequences, the FMI standard can be used,
for which bindings in C, Python and Java exists, and hence interfacing with
software such as developed through xbos, or interfacing with any control system
that can call C, is possible.
If for example JavaScript would be the preferred run-time language, such as due
to cybersecurity concerns, then Modelica code could be converted to JavaScript
as demonstrated in https://github.com/tshort/openmodelica-javascript.
Moreover, for running physical models in the production code software, which
may be attractive for FDD and some advanced control sequences, synergies
with the ongoing EMPHYSIS project (2017-20, Euro 14M) could be used.

.. _tab_cod_gen_ove_sys:

.. table:: Overview of different implementation possibilities for code-translation. The entry with TBD requires further investigation.

   +------------------------------------------+-----------------------------------+---------------------------------------+--------------------------------------+------------------------------------------------------------------+
   | Functionality                            | Sedona                            | BCVTB/Ptolemy II                      | Volttron                             | Modelica/FMI/JavaScript                                          |
   +==========================================+===================================+=======================================+======================================+==================================================================+
   | Hierarchical graphical components        | TBD                               | yes                                   | n/a (not a graphical modeling tool)  | yes                                                              |
   +------------------------------------------+-----------------------------------+---------------------------------------+--------------------------------------+------------------------------------------------------------------+
   | Simulation capability                    | requires emulation with special   | yes                                   | yes                                  | yes                                                              |
   |                                          | software                          |                                       |                                      |                                                                  |
   +------------------------------------------+-----------------------------------+---------------------------------------+--------------------------------------+------------------------------------------------------------------+
   | Adopted in industry                      | yes                               | no                                    | no                                   | not for building control, but automotive control in development. |
   |                                          |                                   |                                       |                                      | See https://itea3.org/project/emphysis.html.                     |
   +------------------------------------------+-----------------------------------+---------------------------------------+--------------------------------------+------------------------------------------------------------------+
   | Documentation                            | Technical details not clear       | yes                                   | yes                                  | yes                                                              |
   +------------------------------------------+-----------------------------------+---------------------------------------+--------------------------------------+------------------------------------------------------------------+
   | Open-source & freely adaptable           | Some, but requires commercial     | yes                                   | yes                                  | yes                                                              |
   |                                          | Niagara and drivers               |                                       |                                      |                                                                  |
   +------------------------------------------+-----------------------------------+---------------------------------------+--------------------------------------+------------------------------------------------------------------+
   | Demonstrate proof-of-concept translation | yes                               | only if it drives product line update | only as run-time environment w/o GUI | only if it drives product line update                            |
   +------------------------------------------+-----------------------------------+---------------------------------------+--------------------------------------+------------------------------------------------------------------+
   | Operating system                         | Niagara Workbench requires        | Any                                   | Any                                  | Any                                                              |
   |                                          | Windows (and a license)           |                                       |                                      |                                                                  |
   +------------------------------------------+-----------------------------------+---------------------------------------+--------------------------------------+------------------------------------------------------------------+
   | License                                  | Requires license payment          | free                                  | free                                 | free                                                             |
   +------------------------------------------+-----------------------------------+---------------------------------------+--------------------------------------+------------------------------------------------------------------+


Due to the synergies with SOEP, we will demonstrate how to export
control sequences using the Modelica/FMI/JavaScript approach
as shown in :numref:`fig_architecture_overall_ctrl_design`.
