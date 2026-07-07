.. _sec_code_gen:

Code Generation
---------------

Introduction
^^^^^^^^^^^^

This section describes the translation of control sequences expressed
in CDL to a building automation system (BAS). The translation needs to be
done only if the target BAS does not support CDL. 

Translating the *CDL library* to a BAS to make it
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
a BAS.


Use of CDL control sequences for building operation, or use of such sequences
in a verification test module, consists of the following steps:

1. Implementation of the control sequence using CDL.

2. Export of the CDL sequence as a Functional Mockup Unit for Model Exchange (FMU-ME)
   or as a CXF representation, which is serialized in JSON-LD.

3. Import of the FMU-ME in the runtime environment, or translation of the
   CXF representation of the control sequence to the language used by the 
   target BAS.


:numref:`fig_cod_exp` shows the process of creating a CDL control sequence
and translating it into different target platforms.

.. _fig_cod_exp:

.. figure:: img/codeExport.*
   :width: 700 px

   Overview of CDL control sequence creation, verification and 
   translation into differne target platforms.


The next section describes three different approaches that can be used by control vendors
to translate CDL to their product line:

1. Translation of the CDL-compliant sequence to intermediate CXF representation, which can be translated
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
of CDL sequences to a BAS, as well as their implications.


Challenges and Implications for Translation of Control Sequences from and to Building Control Product Lines
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This section discusses challenges and implications
for translating CDL-conforming control
sequences to the programming languages used by the target BAS.

First, we note that simply generating C code is not viable
for such applications because a BAS generally does not
allow users to upload C code.
Moreover, they also need to provide an interface
for the building operator that allows editing the control parameters and control sequences.

Second, we note that the translation will for most systems, if not all,
only be possible from CDL to a BAS,
but not vice versa. This is due to specific constructs that may exist
in the BAS but not in CDL.  For example,
if Sedona (`https://www.sedona-alliance.org/ <https://www.sedona-alliance.org/>`_)
were the target platform, then
translating from Sedona to CDL will not be possible
because Sedona allows boolean variables
to take on the values ``true``, ``false`` and ``null``, but
CDL has no ``null`` value.


.. _sec_cdl_to_json_simp:

Translation of a Control Sequence using a Intermediate CXF (JSON-LD) Format
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Control companies that choose to not use the C-code generation approach or 
the FMI standard to execute CDL-compliant control sequences can develop translators 
from CDL to their BAS's programming language. To aid in this process, an intermediate 
Control eXchange Format (CXF) can be used. As mentioned in :numref:`sec_cxf`
CXF is a JSON-LD representation of a CDL sequence, serialized in JSON. 
`Modelica-json <https://github.com/lbl-srg/modelica-json>`_
is an implementation of such a CDL to CXF translator. 
This translator first parses CDL-compliant control sequences to an abstract 
syntax tree in JSON format and then generates a CXF representation from it. 
``Modelica-json`` can also parse Modelica code and it
can generate the following output formats:

1. a JSON representation of the abstract syntax tree of the control sequence
   (CDL) or the Modelica file (``raw-json``),
2. a simplified version of this JSON representation (``json``),
3. a semantic model from the control sequence or the Modelica file (``semantic``),
4. a CXF representation of the control sequence (``cxf``) and
5. an html-formated documentation of the control sequence (``doc`` and ``doc+``).

Please refer to the ``modelica-json`` documentation for more information. 

To translate CDL-compliant control sequences to the programming language that is 
used by the target BAS, ``cxf`` output format is most 
suited. Developers can choose to treat the CXF representation as a 
simple JSON file or as a linked-data Resource Description Framework (RDF) graph.
The latter option is recommended if the target BAS
supports RDF or other semantic web technologies. 


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

This specification can be converted to CXF using the program
`modelica-json <https://github.com/lbl-srg/modelica-json>`_.
Executing the command

.. code-block:: bash

   node modelica-json/app.js -f CustomPWithLimiter.mo -o cxf -p

will produce a file called ``CustomPWithLimiter.jsonld`` that
looks as follows:

.. literalinclude:: img/codeGeneration/CustomPWithLimiter/CustomPWithLimiter.jsonld
   :language: json
   :linenos:

The CXF representation can then be parsed and converted to another block-diagram
language.
Note that ``CDL.Reals.MultiplyByParameter`` is an elementary CDL block
(see :numref:`sec_ele_blo`).
When ``modelica-json`` encounters an instance of a
composite CDL block (see :numref:`sec_com_blo`), it would be parsed recursively
until only elementary CDL blocks are present in the CXF file.
Various examples of CDL converted to CXF can be found at
https://github.com/lbl-srg/modelica-json/tree/master/test/FromModelica.

As shown in :numref:`fig_cod_exp`, the CXF representation has been used
to translate a CDL sequence into different target BAS such as Automted Logic
Corporation WebCTRL (CXF translated into ALC Eikon), Tridium Niagara,
IEC 61131-10 programming logic controller (`CDL-PLC <https://github.com/lbl-srg/cdl-plc>`_) and Normal framework
(CXF translated into JavaScript using `Modelica Translator <https://github.com/normalframework/obc>`_).

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
that is used is FMI for model exchange or FMI for co-simulation, as it is an 
open standard, and because FMI
can easily be integrated into tools for controls or verification
using a variety of languages.

.. note:: Also possible, but outside of the scope
          of this project, is the translation of the control sequences to
          JavaScript, which could then be executed in a BAS.
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
  Volttron (https://www.energy.gov/eere/buildings/volttron):

  * PyFMI (https://pypi.org/pypi/PyFMI)

* Tools based on Java:

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
  * SystemModeler (https://www.wolfram.com/system-modeler/)

See also https://fmi-standard.org/tools/ for other tools.

Note that Modelica models could also be compiled directly to a BAS
leveraging the FMI  for embedded systems `eFMI <https://www.efmi-standard.org/>`_
that was developed technologies
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

     [FMU (ME or CS)]

     [CDL-compliant\nsequence] -r-> [FMU (ME or CS)] : translate

     [FMU (ME or CS)] -r-> [SSP-compliant\nspecification] : translate

     fmu_lib -> [FMI Composer] : uses

     [SSP-compliant\nspecification] -d-> [FMI Composer] : import


In such a workflow, a control vendor would translate the elementary CDL blocks
(:numref:`sec_ele_blo`)
to a repository of FMU blocks. These blocks will then be used during operation.
For each project, its CDL-compliant control sequence could be translated
to the CXF, as described in :numref:`sec_cdl_to_json_simp`.
Using a template engine (similar as is used
by ``modelica-json`` to translate the CDL sequence to html),
the CXF representation could then be converted to the xml syntax
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

When translating CDL to a control product line, a translator may want to
conduct certain substitutions. Some of these substitutions can change the
control response, which can cause the verification that checks whether the
actual implementation conforms to the specification to fail.

This section therefore explains how certain substitutions can be performed
in a way that allows formal verification to pass. More details about
how verification will be conducted can be found in :numref:`sec_verification`.

Substitutions that Give Identical Control Response
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Consider the gain ``CDL.Reals.MultiplyByParameter`` used above. If a product line
uses different names for the inputs, outputs and parameters, then they can
be replaced.

Moreover, certain transformations that do not change the
response of the block are permissible: For example, consider the
`PID controller in the CDL library <https://simulationresearch.lbl.gov/modelica/releases/v12.1.0/help/Buildings_Controls_OBC_CDL_Reals.html#Buildings.Controls.OBC.CDL.Reals.PID>`_.
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
