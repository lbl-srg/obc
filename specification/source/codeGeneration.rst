.. _sec_code_gen:

Code Generation
---------------

This section describes the development of a proof-of-concept
translator from CDL to a building
automation system.
Translating CDL to a building automation system only needs to be done when
the CDL library is updated, and hence only developers need
to perform this step.
Translation of CDL-conforming control sequences, as well as translation
of verification tests, will need
to be done for each building project.

Discussion of Different Translation Approaches
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This section compares different approaches for translation of control
sequences, and possibly verification tests, to execute them
for the case of a control sequence on a building automation system, or
to execute them for the case of a verification test on a computer that is connected to a building automation system.

First, we note that the translation will for most, if not all,
systems only be possible from CDL to a building automation system,
but not vice versa. For example,
if Sedona were the target platform, then
translating from Sedona to CDL will not be possible
because Sedona allows, boolean variables
to have values ``true``, ``false`` and ``null`` but
CDL has no ``null`` value.

Second, we note that most building automation product lines are based on
old computing technologies. One may argue that to meet future process
requirements and user-friendliness, these may be updated in the near future.
Relatively recent or new product lines are

* Tridium Niagara, or its open version Sedona (http://www.sedonadev.org/),
* Distech control (http://www.distech-controls.com/en/us/), and
* Schneider Electric's EcoStruxture (https://www.schneider-electric.us/en/work/campaign/innovation/overview.jsp).

While Sedona has been designed for 3rd party developers to add
new functionality, the others seem rather closed. For example, detailed developer
documentation that describe

* the language specification for implementation of block diagrams,
* the model of computation, and
* how to simulate open loop control responses and implement regression testing,

are difficult to find, or maybe not even exist.
Although Sedona "is designed to make it easy to build smart, networked embedded devices"
and Sedona attempts to create an "Open Source Ecosystem" (http://www.sedonadev.org/),
developing block diagrams requires Tridium NiagaraAX, a commercial
product which is not free.

To contrast the different approaches,
:numref:`tab_cod_gen_ove_sys` provides an overview of different approaches for
implementation of a code generator. Here, we only included open-source
implementations, and for this purpose, also considered Sedona to be open-source,
although it seems to require proprietary software.
The entry Modelica/FMI/JSON consists of

* a block diagram editor based on CDL, which has to be developed for the
  Spawn of EnergyPlus and for the control design tool,
* a tool that exports these control sequences as an FMU for real-time control,
  such as JModelica, and
* a JavaScript-based GUI that visualizes the actual operation of the system
  for a building operator.

The Modelica/FMI/JSON approach has various synergies:
Regarding the design phase, it directly integrates with the
redesign of EnergyPlus, called SOEP, and described at https://lbl-srg.github.io/soep/index.html.
Regarding the operation phase, the Modelica/FMI/JSON will
demonstrate how to add a control layer to efforts
that are targeted towards open-source building operating systems,
such as `xbos <https://docs.xbos.io/>`_. Such systems typically cover
the communication layer, but not the implementation of control sequences.
Therefore, the Modelica/FMI/JSON does not deal with how to link the sequences
with hardware, but rather will use efforts such as xbos to provide this functionality.
For execution of control sequences, the FMI standard can be used,
for which bindings in C, Python and Java exists.
These bindings simplify interfacing with
software such as developed through xbos, or interfacing with any control system
that can call C.
If, for example, JavaScript would be the preferred run-time language, such as due
to cyber-security concerns, then Modelica code could be converted to JavaScript
as demonstrated in https://github.com/tshort/openmodelica-javascript.
Moreover, for running physical models in the production code software, which
may be attractive for FDD and some advanced control sequences, synergies
with the ongoing `EMPHYSIS <https://itea3.org/project/emphysis.html>`_
project (2017-20, Euro 14M) could be used.

.. _tab_cod_gen_ove_sys:

.. table:: Overview of different implementation possibilities for code-translation. The entry with TBD requires further investigation.

   +------------------------------------------+-----------------------------------+---------------------------------------+--------------------------------------+------------------------------------------------------------------+
   | Functionality                            | Sedona                            | BCVTB/Ptolemy II                      | Volttron                             | Modelica/FMI/JSON                                                |
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


Due to the synergies with SOEP, we will export
control sequences and verification tests using the Modelica/FMI/JSON approach.
The software architecture of this approach is shown in :numref:`fig_architecture_overall_ctrl_design`.

Use of Control Sequences or Verification Tests in Realtime Applications
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use of control sequences or verification tests in realtime applications, such
as in a building automation system or in a verification test module, consists
of the following steps:

1. Implementation of the control sequence or verification test as a Modelica model.

2. Export of the Modelica model as a :term:`Functional Mockup Unit` for Model Exchange (FMU-ME).

3. Import of the FMU-ME in the runtime environment.


.. _fig_cod_exp:

.. figure:: img/codeExport.*

   Overview of the code export and import of control sequences and verification
   tests.


:numref:`fig_cod_exp` shows the process of exporting and importing
control sequences or verification tests.
The intermediate format that is used are FMU-ME, as these
are governed by an open standard, and because they
can easily be integrated into tools for controls or verification
using a variety of languages. Also possible, but outside of the scope
of this project, is the generation of JavaScript, which could then
be executed in a building automation system.

For step 1, to implement control sequences,
blocks from the
CDL library (:numref:`sec_ele_bui_blo`) can be used to compose sequences that conform
to the CDL language specification described in
:numref:`sec_cdl`.
For verification tests, any Modelica block can be used.

For step 2, to export the Modelica model, a Modelica tool such as JModelica, OpenModelica
or Dymola can be used.
For JModelica, this can be accomplished using a Python script such as

.. code-block:: python

   from pymodelica import compile_fmu
   compile_fmu("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Controller")

This will generate an FMU-ME.

For step 3, to import the FMU-ME in a runtime environment, various tools can be used, including:

* Tools based on Python, which could be used to interface with
  sMAP (http://people.eecs.berkeley.edu/~stevedh/smap2/intro.html) or
  Volttron (https://energy.gov/eere/buildings/volttron):

  * PyFMI (https://pypi.python.org/pypi/PyFMI)

* Tools based on Java:

  * Building Controls Virtual Test Bed (http://simulationresearch.lbl.gov/bcvtb)
  * JFMI (https://ptolemy.eecs.berkeley.edu/java/jfmi/)
  * JavaFMI (https://bitbucket.org/siani/javafmi/wiki/Home)

* Tools based on C:

  * FMI Library (http://www.jmodelica.org/FMILibrary)

* Modelica tools, of which many if not all provide
  functionality for real-time simulation:

  * JModelica (http://www.jmodelica.org)
  * OpenModelica (https://openmodelica.org/)
  * Dymola (https://www.3ds.com/products-services/catia/products/dymola/)
  * MapleSim (https://www.maplesoft.com/products/maplesim/)
  * SimulationX (https://www.simulationx.com/)
  * SystemModeler (http://www.wolfram.com/system-modeler/index.html)

See also http://fmi-standard.org/tools/ for other tools.
