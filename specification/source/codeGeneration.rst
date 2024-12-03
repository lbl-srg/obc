.. _sec_code_gen:

Code Generation
---------------

Introduction
^^^^^^^^^^^^

This section describes the translation of control sequences expressed
in CDL to a building automation system.

Translating the *CDL library* to a building automation system to make it
available as part of a product line needs to be done only when
the CDL library is updated, and hence only developers need
to perform this step.
However, translation of a *CDL-conforming control sequence* that has been developed
for a specific building will need to be done for each building project.

While translation from CDL to C code or to a :term:`Functional Mockup Unit` is
support by Modelica simulation environments, translation to
legacy building automation product lines is more difficult
as they typically do not allow executing custom C code. Moreover,
a building operator typically needs a graphical operator interface,
which would not be supported if one were to simply upload compiled C code to
a building automation system.


Use of CDL control sequences for building operation, or use of such sequences
in a verification test module, consists of the following steps:

1. Implementation of the control sequence using CDL.

2. Export of the Modelica model as a Functional Mockup Unit for Model Exchange (FMU-ME)
   or as a JSON specification.

3. Import of the FMU-ME in the runtime environment, or translation of the
   JSON specification to the language used by the building automation system.


:numref:`fig_cod_exp` shows the process of exporting and importing
control sequences.

.. _fig_cod_exp:

.. figure:: img/codeExport.*
   :width: 700 px

   Overview of the code export and import of control sequences and verification
   tests.


The next section describes three different approaches that can be used by control vendors
to translate CDL to their product line:

1. Translation of the CDL-compliant sequence to a JSON intermediate format, which can be translated
   to the format used by the control platform (:numref:`sec_cdl_to_json_simp`).
2. Export of the whole CDL-compliant sequence using the :term:`FMI standard<Functional Mockup Interface>`
   (:numref:`sec_cdl_to_fmi`),
   a standard for exchanging simulation models that can be simulated using a variety of open-source tools.
3. Translation of the CDL-compliant sequence to an xml-based standard called
   System Structure and Parameterization (SSP), which
   is then used to parameterize, link and execute pre-compiled elementary CDL blocks
   (:numref:`sec_cdl_ssp`).


The best approach will depend on the control platform.
While in the short-term, option 1) is likely preferred as it allows reusing existing
control product lines, the long term vision is that control product lines would
directly compile CDL using option 2) or 3).
Before explaining
these three approaches, we first discuss challenges of translation
of CDL sequences to building automation systems, as well as their implications.


Challenges and Implications for Translation of Control Sequences from and to Building Control Product Lines
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This section discusses challenges and implications
for translating CDL-conforming control
sequences to the programming languages used by building automation system.

First, we note that simply generating C code is not viable
for such applications because building automation systems generally do not
allow users to upload C code.
Moreover, they also need to provide an interface
for the building operator that allows editing the control parameters and control sequences.

Second, we note that the translation will for most, if not all,
systems only be possible from CDL to a building automation system,
but not vice versa. This is due to specific constructs that may exist
in building automation systems but not in CDL.  For example,
if Sedona (`https://www.sedona-alliance.org/ <https://www.sedona-alliance.org/>`_)
were the target platform, then
translating from Sedona to CDL will not be possible
because Sedona allows boolean variables
to take on the values ``true``, ``false`` and ``null``, but
CDL has no ``null`` value.


.. _sec_cdl_to_json_simp:

Translation of a Control Sequence using a JSON Intermediate Format
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Control companies that choose to not use C-code generation or the FMI standard to
execute CDL-compliant control sequences can develop translators from
CDL to their native language. To aid in this process, an intermediate 
Control eXchange Format (CXF) can be used. CXF is a JSON-LD representation
of a CDL sequence, serialized in JSON. `Modelica-json <https://github.com/lbl-srg/modelica-json>`_
is a reference implementation of such a CDL to CXF translator. 
This translator first parses CDL-compliant control sequences to a abstract 
syntax tree in JSON format and then generates a CXF representation from it. 
The ``modelica-json`` tool can also parse Modelica code and it
can generate the following output formats:

1. A JSON representation of the control sequence (CDL) or the Modelica 
   file(``raw-json``),
2. A simplified version of this JSON representation (``json``),
3. A semantic model from the control sequnce or the Modelica file 
   (``semantic``) and
4. A CXF representation of the control sequence (``cxf``).

To translate CDL-compliant control sequences to the language that is used
by the target building automation system, the Control eXchange Format (CXF) 
representation is most suited.

As an illustrative example, consider the composite control block shown in
:numref:`fig_custom_control_block` and reproduced in
:numref:`fig_exp_custom_control_block`.

.. _fig_exp_custom_control_block:

.. figure:: img/codeGeneration/CustomPWithLimiter/CustomPWithLimiter.*
   :width: 500px

   Example of a composite control block that outputs :math:`y = \max( k \, e, \, y_{max})`
   where :math:`k` is a parameter.

In CDL, this would be specified as

.. literalinclude:: img/codeGeneration/CustomPWithLimiter/CustomPWithLimiter.mo
   :language: modelica
   :linenos:

This specification can be converted to JSON using the program
`modelica-json <https://github.com/lbl-srg/modelica-json>`_.
Executing the command

.. code-block:: bash

   node modelica-json/app.js -f CustomPWithLimiter.mo -o cxf

will produce a file called ``CustomPWithLimiter.jsonld`` that
looks as follows:

.. literalinclude:: img/codeGeneration/CustomPWithLimiter/CustomPWithLimiter.jsonld
   :language: json
   :linenos:

The representation can then be parsed and converted to another block-diagram
language.
Note that ``CDL.Reals.MultiplyByParameter`` is an elementary CDL block
(see :numref:`sec_ele_blo`).
If it were a
composite CDL block (see :numref:`sec_com_blo`), it would be parsed recursively
until only elementary CDL blocks are present in the JSON file.
Various examples of CDL converted to JSON can be found at
https://github.com/lbl-srg/modelica-json/tree/master/test/FromModelica.

The simplified JSON representation of a CDL sequence must be compliant with the
corresponding JSON Schema. A JSON Schema describes the data format and file structure,
lists the required or optional properties, and sets limitations on values such as
patterns for strings or extrema for numbers.

The CDL Schema can be found at `https://github.com/lbl-srg/modelica-json/blob/master/schema-cdl.json <https://github.com/lbl-srg/modelica-json/blob/master/schema-cdl.json>`_ .

The program `modelica-json <https://github.com/lbl-srg/modelica-json>`_ automatically tests
the JSON representation parsed from a CDL file against the schema right after it is
generated.

The validation of an existing JSON representation of a CDL file against the schema
can be done executing the command

.. code-block:: bash

   node modelica-json/validation.js -f filename.json

Control providers can use the JSON Schema as a specification to develop a translator to a control product line.
If JSON files are the starting point, then they should first validate the JSON files
against the JSON Schema, as this ensures that the input files to the translator are valid.


.. _sec_cdl_to_fmi:

Export of a Control Sequence or a Verification Test using the FMI Standard
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This section describes how to export a control sequence, or a verification test,
using the :term:`FMI standard<Functional Mockup Interface>`.
In this workflow, the intermediate format
that is used is FMI for model exchange, as it is an open standard, and because FMI
can easily be integrated into tools for controls or verification
using a variety of languages.

.. note:: Also possible, but outside of the scope
          of this project, is the translation of the control sequences to
          JavaScript, which could then be executed in a building automation system.
          For a Modelica to JavaScript converter,
          see https://github.com/tshort/openmodelica-javascript.


To implement control sequences, blocks from the
CDL library (:numref:`sec_ele_blo`) can be used to compose sequences that conform
to the CDL language specification described in :numref:`sec_cdl`.
For verification tests, any Modelica block can be used.
Next, to export the Modelica model, a Modelica tool such as OpenModelica, Impact, OPTIMICA
or Dymola can be used.
For example, with OPTIMICA a control sequence can be exported using the Python commands

.. code-block:: python

   from pymodelica import compile_fmu
   compile_fmu("Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Controller")

This will generate an FMU-ME.
Finally, to import the FMU-ME in a runtime environment, various tools can be used, including:

* Tools based on Python, which could be used to interface with
  sMAP (https://pythonhosted.org/Smap/en/2.0/index.html) or
  Volttron (https://www.energy.gov/eere/buildings/volttron):

  * PyFMI (https://pypi.org/pypi/PyFMI)

* Tools based on Java:

  * Building Controls Virtual Test Bed (https://simulationresearch.lbl.gov/bcvtb)
  * JFMI (https://ptolemy.berkeley.edu/java/jfmi/)
  * JavaFMI (https://bitbucket.org/siani/javafmi/wiki/Home)

* Tools based on C:

  * FMI Library (https://github.com/modelon-community/fmi-library)

* Modelica tools, of which many if not all provide
  functionality for real-time simulation:

  * OpenModelica (https://openmodelica.org/)
  * Impact (https://www.modelon.com/modelon-impact/)
  * Dymola (https://www.3ds.com/products-services/catia/products/dymola/)
  * MapleSim (https://www.maplesoft.com/products/maplesim/)
  * SimulationX (https://www.esi-group.com/products/system-simulation)
  * SystemModeler (https://www.wolfram.com/system-modeler/index.html)

See also https://fmi-standard.org/tools/ for other tools.

Note that directly compiling Modelica models to building automation systems
also allows leveraging the ongoing `EMPHYSIS <https://itea4.org/project/emphysis.html>`_
project (2017-20, Euro 14M) that develops technologies
for running dynamic models on electronic control units (ECU),
micro controllers or other embedded systems.
This may be attractive for FDD and some advanced control sequences.


.. _sec_cdl_ssp:

Modular Export of a Control Sequence using the FMI Standard for Control Blocks and using the SSP Standard for the Run-time Environment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In 2019, a new standard called System Structure and Parameterization (SSP)
was released (https://ssp-standard.org/). The standard provides an xml scheme for the
specification of FMU parameter values, their input and output connections,
and their graphical layout. The SSP standard allows
for transporting complex networks of FMUs between different platforms for
simulation, hardware-in-the-loop and model-in-the-loop :cite:`KoehlerEtAl2016:1`.
Various tools that can simulate systems specified using the SSP standard
are available, see https://ssp-standard.org/tools/.

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
(:numref:`sec_ele_blo`)
to a repository of FMU-ME blocks. These blocks will then be used during operation.
For each project, its CDL-compliant control sequence could be translated
to the simplified JSON format, as described in :numref:`sec_cdl_to_json_simp`.
Using a template engine (similar as is used
by ``modelica-json`` to translate the simplified JSON to html),
the simplified JSON representation could then be converted to the xml syntax
specified in the SSP standard.
Finally, a tool such as the FMI Composer could import the
SSP-compliant specification, and execute the control sequence using
the elementary CDL block FMUs from the FMU repository.

.. note:: In this workflow, all key representations are based on standards:
          The CDL-specification uses a subset of the Modelica standard,
          the elementary CDL blocks are converted to the FMI standard,
          and finally the runtime environment uses the SSP standard.


Replacement of Elementary CDL Blocks during Translation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When translating CDL to a control product lines, a translator may want to
conduct certain substitutions. Some of these substitutions can change the
control response, which can cause the verification that checks whether the
actual implementation conforms to the specification to fail.

This section therefore explains how certain substitutions can be performed
in a way that allows formal verification to pass.
(How verification tests will be conducted will be specified later in 2018, but
essentially we will require that the control response from the actual control
implementation is within a certain tolerance of the control response
computed by the CDL specification, provided that both sequences receive
the same input signals and use the same parameter values.)

Substitutions that Give Identical Control Response
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Consider the gain ``CDL.Reals.MultiplyByParameter`` used above. If a product line
uses different names for the inputs, outputs and parameters, then they can
be replaced.

Moreover, certain transformations that do not change the
response of the block are permissible: For example, consider the
`PID controller in the CDL library <https://simulationresearch.lbl.gov/modelica/releases/v10.0.0/help/Buildings_Controls_OBC_CDL_Reals.html#Buildings.Controls.OBC.CDL.Reals.PID>`_.
The implementation has a parameter
for the time constant of the integrator block.
If a control vendor requires the specification of an integrator gain rather than
the integrator time constant, then such a parameter transformation can be done during
the translation, as both implementations yield an identical response.

.. _sec_cha_sub_cha:

Substitutions that Change the Control Response
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If a control vendor likes to use for example a different implementation of
the anti-windup in a PID controller, then such a substitution
will cause the verification to fail if the control responses differ
between the CDL-compliant specification and the vendor's implementation.

Therefore, if a customer requires the implemented control sequence to comply
with the specification, then the workflow shall be such that
the control provider provides an executable implementation of its controller,
and the control provider shall ask the customer to replace
in the control specification the PID controller from the CDL library with the PID controller
provided by the control provider. Afterwards, verification can be conducted as usual.

.. note:: Such an executable implementation of a vendor's PID controller can
          be made available by publishing the controller
          or by contributing the controller to the Modelica Buildings Library.
          The implementation of the control logic can be done either
          using other ``CDL`` blocks, which is the preferred approach,
          using the C language, or by providing
          a compiled library. See the Modelica Specification :cite:`ModelicaSpecification2023`
          for implementation details
          if C code or compiled libraries are provided.
          If a compiled library is provided, then binaries shall be provided for
          Windows 32/64 bit, Linux 32/64 bit, and OS X 64 bit.

Adding Blocks that are not in the CDL Library
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If a control vendor likes to use a block that is not in the CDL library,
such as a block that uses machine learning to schedule optimal warm-up,
then such an addition must be approved by the customer.
If the customer requires the part of the control sequence that contains this
block to be verified, then the block shall be made available as described in :numref:`sec_cha_sub_cha`.
