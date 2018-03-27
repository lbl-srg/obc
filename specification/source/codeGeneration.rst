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
Relatively recent or new product lines include

* Tridium Niagara, or its open version Sedona (http://www.sedonadev.org/),
* Distech control (http://www.distech-controls.com/en/us/), and
* Schneider Electric's EcoStruxture (https://www.schneider-electric.us/en/work/campaign/innovation/overview.jsp).

While Sedona has been designed for 3rd party developers to add
new functionality, the others seem rather closed.
For example, detailed developer documentation that describe

* the language specification for implementation of block diagrams,
* the model of computation, and
* how to simulate open loop control responses and implement regression testing,

are difficult to find, or maybe not even exist.
Although Sedona "is designed to make it easy to build smart, networked embedded devices"
and Sedona attempts to create an "Open Source Ecosystem" (http://www.sedonadev.org/),
developing block diagrams requires Tridium NiagaraAX, a commercial
product which is not free.

Due to the synergies with SOEP, we will export
control sequences and verification tests using the Modelica/FMI/JSON approach.
The software architecture of this approach is shown in :numref:`fig_architecture_overall_ctrl_design`.

Use of Control Sequences or Verification Tests in Realtime Applications
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use of control sequences or verification tests in realtime applications, such
as in a building automation system or in a verification test module, consists
of the following steps:

1. Implementation of the control sequence or verification test as a Modelica model.

2. Export of the Modelica model as a :term:`Functional Mockup Unit` for Model Exchange (FMU-ME)
   or as a JSON specification.

3. Import of the FMU-ME in the runtime environment, or translation of the
   JSON specification to the language used by the building automation system.


.. _fig_cod_exp:

.. figure:: img/codeExport.*
   :width: 700 px

   Overview of the code export and import of control sequences and verification
   tests.


:numref:`fig_cod_exp` shows the process of exporting and importing
control sequences or verification tests.

We will now describe three different approaches that can be used by control vendors
to translate CDL to their product line:

1. Export of the whole CDL-compliant sequence to one FMU (:numref:`sec_cdl_to_fmi`),
2. Translation of the CDL-compliant sequence to a json intermediate format, and
   form this format to the format used by the control platform (:numref:`sec_cdl_to_json_simp`), and
3. Translation of the CDL-compliant sequence to a standard called SSP which
   is then used to parameterize, link and execute pre-compiled elementary CDL blocks
   (:numref:`sec_cdl_ssp`).

Which approach is best suited will depend on the control platform.

.. _sec_cdl_to_fmi:

Export of the whole control sequence using the FMI standard
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This section describes how to export a control sequence, or a verification test,
using the :term:`FMI standard<Functional Mockup Interface>`.
In this workflow, the intermediate format
that is used is FMU-ME, as these
are governed by an open standard, and because they
can easily be integrated into tools for controls or verification
using a variety of languages.

.. note:: Also possible, but outside of the scope
          of this project, is the generation of JavaScript, which could then
          be executed in a building automation system.
          For a Modelica to JavasScript converter, see https://github.com/tshort/openmodelica-javascript.


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

Note that directly compiling Modelica models to building automation systems
also allows leveraging the ongoing `EMPHYSIS <https://itea3.org/project/emphysis.html>`_
project (2017-20, Euro 14M) project that develops technologies
for running physical models the production code software.
This may be attractive for FDD and some advanced control sequences.

.. _sec_cdl_to_json_simp:

Translation of a control sequence using a JSON intermediate format
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Control companies that choose to not use C-code generation or the FMI standard to
execute CDL-compliant control sequences can develop translators from
CDL to their native language. To aid in this process, a CDL to JSON translator
can be used. Such a translator is currently being developed at
https://github.com/lbl-srg/modelica-json.
This translator parses CDL-compliant control sequences to a JSON format.
The parser generates the following output formats:

1. A JSON representation of the control sequence,
2. A simplified version of this JSON representation, and
3. an html-formated documentation of the control sequence.

To translate CDL-compliant control sequences to the language that is used
by the respective building automation system, the simplified JSON representation
is most suited.

Consider for example the composite control block shown in
:numref:`fig_exp_custom_control_block`.

.. _fig_exp_custom_control_block:

.. figure:: img/codeGeneration/CustomPWithLimiter/CustomPWithLimiter.*
   :width: 500px

   Example of a composite control block that outputs :math:`y = \max( k \, e, \, y_{max})`
   where :math:`k` is a parameter.

In CDL, this would be specified as

.. literalinclude:: img/codeGeneration/CustomPWithLimiter/CustomPWithLimiter.mo
   :linenos:

This specification can be converted with the program
`modelica-json <https://github.com/lbl-srg/modelica-json>`_
to produce the following json format.
Running a command such as

.. code-block:: bash

   node modelica-json/app.js -f CustomPWithLimiter.mo -o json-simplified

will produce a file called ``CustomPWithLimiter-simplified.json`` that
looks as follows:

.. literalinclude:: img/codeGeneration/CustomPWithLimiter/CustomPWithLimiter-simplified.json
   :linenos:

Note that the graphical annotations are not shown.
The JSON representation can then parsed and converted to another block-diagram
language.
Note that ``CDL.Continuous.Gain`` is an elementary CDL block
(see :numref:`sec_ele_bui_blo`).
If it were a
composite CDL block (see :numref:`sec_com_blo`), it would be parsed recursively
until only elementary CDL blocks are present in the JSON file.
Various examples of CDL converted to JSON can be found at
https://github.com/lbl-srg/modelica-json/tree/master/test/FromModelica.

.. todo:: Add a JSON-schema definition for the simplified JSON representation,
          see http://json-schema.org.

.. _sec_cdl_ssp:

Modular export of a control sequence using the FMI standard for control blocks and using the SSP standard as a run-time environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In early 2018, a new standard called System Structure and Parameterization (SSP)
will be released. The standard provides an xml scheme for the
specification of FMU parameter values, their input and output connections,
and their graphical layout. The SSP standard allows
to transport complex networks of FMUs between different platforms for
simulation, hardware-in-the-loop and model-in-the-loop :cite:`KoehlerEtAl2016:1`.
Various tools that can simulate systems specified using the SSP standard
are in development, with
FMI composer (http://www.modelon.com/products/modelon-deployment-suite/fmi-composer/)
from Modelon being commercially available.

CDL-compliant control sequences could be exported to the SSP standard as shown
in :numref:`fig_cdl_ssp`.

.. _fig_cdl_ssp:

.. uml::
   :caption: Translation of CDL to SSP.
   :width: 550 px

   skinparam componentStyle uml2

   scale 450 width

     database "CDL library" as cdl_lib {
     }
     database "FMU repository" as fmu_lib {
     }

     cdl_lib -r-> fmu_lib: generate

     [CDL-compliant\nsequence]

     [JSON-simplified\nrepresentation]

     [CDL-compliant\nsequence] -r-> [JSON-simplified\nrepresentation] : translate

     [JSON-simplified\nrepresentation] -r-> [SSP-compliant\nspecification] : translate

     fmu_lib -> [FMI Composer] : uses

     [SSP-compliant\nspecification] -d-> [FMI Composer] : import


In such a workflow, a control vendor would translate the elementary CDL blocks
(:numref:`sec_ele_bui_blo`)
to FMU-ME. These blocks will then be used during operation.
For each project, its CDL-compliant control sequence could be translated
to the simplified JSON format, as described in Section :numref:`sec_cdl_to_json_simp`.
Using a template engine (similar as is used
by ``modelica-json`` to translate the simplified JSON to html),
the simplified JSON representation could then be converted to the xml syntax
specified in the SSP standard.
Finally, a tool such as the FMI Composer could import the
SSP-compliant specification, and execute the control sequence using
the FMUs from the FMU repository.

.. note:: In this workflow, all key representations are based on standards:
          The CDL-specification uses a subset of the Modelica standard,
          the elementary CDL blocks are converted to the FMI standard,
          and finally the system structure and the parameterization uses
          the SSP standard.


Replacement of CDL blocks during translation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When translating CDL to a control product lines, a translator may want to
conduct certain substitutions. Some of these substitutions can change the
control response, in which case the verification that checks whether the
actual implementation conforms to the specification may fail.

This section therefore explains how certain substitutions can be performed
in a way that allows passing the certification tests.
(How verification tests will be conducted will be specified later in 2018, but
essentially we will require that the control response from the actual control
implementation is within a certain tolerance of the control response
computed by the CDL specification, provided that both sequences receive
the same input signals and use the same parameter values.)

Substitutions that do not change the response
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Consider the gain ``CDL.Continuous.Gain`` used above. If a product line
uses different names for the inputs, outputs and parameters, then they can
be replaced.

Moreover, certain transformations that do not change the
response of the block are permissible: For example, consider the PID controller in
CDL. The implementation has a parameter called ``Ti`` for the time constant of the integrator block.
If a control vendor requires the specification of an integrator gain rather than
the time constant, then such a parameter transformation can be done during the translation.

.. _sec_cha_sub_cha:

Substitutions that change the response
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If a control vendor likes to use for example a different implementation of
the anti-windup in a PID controller, then such a substitutions may result in a failure during the
verification test because the control response may differ between the CDL-compliant
specification and the vendor's implementation.

Therefore, if a customer requires that the control complies
to the specification, then the workflow shall be to provide an executable
implementation of the vendor's controller, and ask the customer to replace
in the control specification the PID controller from the CDL-library with the PID controller
provided by the vendor. Afterwards, verification can be conducted as usual.

.. note:: Such an executable implementation of a vendor's PID controller can
          be made available by publishing the controller
          or by contributing the controller to the Modelica Buildings Library.
          The implementation of the control logic can be done either
          using other ``CDL`` blocks, which is the preferred approach,
          using the C language, or by providing
          a compiled library. See the Modelica Specification :cite:`Modelica2012:1`
          for implementation details
          if C code or compiled libraries are provided.
          If a compiled library is provided, then binaries shall be provided for
          Windows 32/64 bit, Linux 32/64 bit, and OS X 64 bit.

Adding blocks that are not in the CDL library
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If a control vendor likes to use a block that is not in the CDL library,
such as a block that uses machine learning to schedule optimal warm-up,
then such an addition must be approved by the customer.
If the customer requires to verify the part of the control sequence that contains this
block, then the block shall be made available as described in :numref:`sec_cha_sub_cha`.
