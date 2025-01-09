.. _sec_cxf:

Control eXchange Format (CXF)
-----------------------------

Introduction
^^^^^^^^^^^^

CXF is a representation of CDL in a format that is
intended to be readily imported and exported into 
building automation systems.  As an example, a commercial 
control provider might utilize it to import control logic 
from a design tool for use in a control logic being 
deployed on a project.  Structurally the content of a
logic in CDL and CXF are identical, in that both 
utilize the same ElementaryBlocks, CompositeBlocks, and
ExtensionBlocks as well as Constants, Parameters, 
InputConnectors, and OutputConnectors, although CDL has 
language constructs that are used to build library of 
sequences, while CXF was designed to only represent a 
specifically configured logic. The logic described in a 
CDL implementation is identical to the logic described 
in a CXF representation. But there are several key 
differences between CDL and CXF:

* CXF is defined utilizing the linked data format `JSON-LD <https://www.w3.org/TR/json-ld11/>`_, 
  while CDL utilizes the modeling language Modelica standard. 
  JSON-LD is a syntax to serialize linked data in JSON (`ECMA-404 <https://ecma-international.org/publications-and-standards/standards/ecma-404/>`_). 
  The JSON-LD representation is easier to interpret by computer
  programs than Modelica, which is designed to be human readable. 

* There is a translation process required to convert a 
  control sequence from CDL to CXF. 

* For ElementaryBlocks (:numref:`sec_ele_blo`), their
  CXF representation does not include the implementation 
  (``equation`` section).

* Like many scientific modeling languages, Modelica requires 
  tight casting of data types. 
  
  [For example, in Modelica, a data type needs to be declared as
  type ``Real`` or ``Integer``. ``Real`` data are not allowed to be 
  tested for equality since computations are prone to rounding 
  errors.
  ]

  .. note::

    When importing a CXF representation of a CDL logic
    into a commercial control system that does not support 
    ``Real`` or ``Integer`` data types, the commercial 
    entity's "CDL import" software tool
    for the commercial control system must  
    make a decision on how to handle the ``Real`` and
    ``Integer`` InputConnectors, OutputConnectors, 
    Parameters and Constants. 
    For example, the tool could change it
    to ``Analog``. Similarly, while exporting a CXF representation
    of a control logic implemented in a commercial control
    system, the commercial entity's 
    "CDL export" software tool must decide how
    to translate unsupported data types such as ``Analog`` into 
    ``Real`` or ``Integer`` InputConnectors, OutputConnectors, 
    Parameters and Constants. 

* Libraries which utilize matrices and vectors in CDL shall have
  the option to be modified (or "flattened") to result in an 
  instance of control logic which is then represented in CXF. 
  [For example: ``A[1]`` and ``B[1,2]`` after flattening
  shall become `A_1` and `B_1_2`. A similar 
  pattern applies for higher dimensional matrices.  
  ]

* Certain Blocks that are supported in CDL are not readily 
  supported in commercial control products. 
  [Some examples include:
   
  * Blocks that utilize vectors and matrices. These blocks are 
    used for the development and support of control sequence 
    libraries but may not be supported by 
    the commercial control product. 

  * The ``Pre`` Block which is used to break algebraic loops that
    involve Boolean variables during a simulation but is not 
    required in common building controllers.

  ]

Classes and Properties
^^^^^^^^^^^^^^^^^^^^^^

A valid CXF file contains Blocks (that is ElementaryBlocks, 
CompositeBlocks, ExtensionBlocks or a combination of these) and
each instance of a Block uses the set of InputConnectors and 
OutputConnectors, Parameters, and Constants as defined within
definition of the Block. To support this process, a Resource 
Description Framework (RDF) graph representation of the 
standard has been provided in a CXF-Core.jsonld file 
using the MIME type ``application/ld+json`` and it can be found 
`here <https://github.com/lbl-srg/modelica-json/blob/master/CXF-Core.jsonld>`_.
The key classes and properties present in CXF-Core.jsonld 
that can be used to created CXF classes are shown in
Table :numref:`tab_cxf_cla` and Table :numref:`tab_cxf_rel` respectively. 


.. _tab_cxf_cla:

.. table:: Key classes within ``CXF-Core.jsonld``
   :widths: 15 80

   ============================  ===========================================================
   Class                         Description
   ============================  ===========================================================
   Package                       A Package is a specialized class used to group multiple 
                                 Blocks.
   Blocks                        A Block is the abstract interface of a control sequence.
   ElementaryBlock               An ElementaryBlock defined by ASHRAE S231P (``subClassOf 
                                 Block``) (:numref:`sec_ele_blo`).
   CompositeBlock                A CompositeBlock is a collection of ElementaryBlocks or 
                                 other CompositeBlocks (``subClassOf Block``) and the 
                                 connections through their inputs and outputs (:numref:`sec_com_blo`).
   ExtensionBlock                An ExtensionBlock supports functionalities that cannot,
                                 or are hard to, implement with a CompositeBlock
                                 (``subClassOf Block``) (:numref:`sec_ext_blo`).
   InputConnector                An InputConnector provides an input to a Block.
   OutputConnector               An OutputConnector provides an output from a Block.
   Parameter                     A Parameter is a value that is time-invariant and cannot be changed 
                                 based on an input signal. A Block can have multiple Parameters.
   Constant                      A Constant is a value that is fixed at compilation time. A Block can 
                                 have multiple Constants.
   DataType                      A data type description for InputConnectors,
                                 OutputConnectors, Parameters and Constants.
   BooleanInput                  An InputConnector of the Boolean data type.
   BooleanOutput                 An OutputConnector of the Boolean data type.
   IntegerInput                  An InputConnector of the Integer data type.
   IntegerOutput                 An OutputConnector of the Integer data type.
   RealInput                     An InputConnector of the Real data type.
   RealOutput                    An OutputConnector of the Real data type.
   EnumerationType               An Integer enumeration starting with the value 1, each element 
                                 is mapped to a unique String.
   String                        A data type to represent text.
   ============================  ===========================================================								 
			 


.. _tab_cxf_rel:

.. table:: Key properties within ``CXF-Core.jsonld``
   :widths: 15 25 25 50

   =============================== ================= ================ =========================================
   Property                        Domain            Range            Description
   =============================== ================= ================ =========================================
   hasInput                        Block             InputConnector   A property that relates an instance of an
                                                                      InputConnector with a Block.
   hasOutput                       Block             OutputConnector  A property that relates an instance of an
                                                                      OutputConnector with a Block.
   hasParameter                    Block             Parameter        A property that relates an instance of a
                                                                      Parameter with a Block.
   hasConstant                     Block             Constant         A property that relates an instance of a
                                                                      Constant with a Block.
   hasInstance                     Block             Block,           A property that associates an 
                                                     InputConnector,  InputConnector, OutputConnector, Parameter 
                                                     OutputConnector, or Constant instance within a Block with
                                                     Parameter,       the instance of the Block itself. 
                                                     Constant
   hasFmuPath                      ExtensionBlock    String           A property that specifies the (local 
                                                                      or on the network)
                                                                      path to a Functional Mockup Unit
                                                                      implementation of an ExtensionBlock.
   isOfDataType                    InputConnector,   DataType         A property that specifies the data type for 
                                   OutputConnector,                   InputConnectors, OutputConnectors,
                                   Parameter,                         Parameters and Constants.
                                   Constant
   containsBlock                   Block   Block                      A property that specifies that an instance
                                                                      of a Block (subject) is composed in part 
                                                                      with an instance of another Block (object).
   connectTo                       OutputConnector,  InputConnector,  A property that relates the output of one Block
                                   InputConnector    OutputConnector  to the input of another Block (and vice-versa).
                                                                      Only InputConnectors and OutputConnectors that
                                                                      carry the same data type can be connected.
   translationSoftware             Package, Block    String           A property that specifies the name of the software
                                                                      used to generate the CXF representation of the
                                                                      control logic.
   translationSoftwareVersion      Package, Block    String           A property that specifies the version of the
                                                                      software used to generate CXF representation of
                                                                      the control logic.
   =============================== ================= ================ =========================================

All the ``ElementaryBlock`` within the standard have been 
defined and included in ``CXF-Core.jsonld``. However, CXF 
representation of elementary blocks does not contain 
the implementation details of the blocks. 

Generating CXF from an instance of a CDL class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A CXF representation of a control logic will be able to be 
generated from a instance of a CDL class. When there 
are instances of a CDL class within a Modelica or 
another CDL class, if the instance has the CDL 
annotation ``__cdl(export=true)``, the corresponding CDL 
class shall be translated to CXF. Specifying the ``export`` 
annotation is optional, and if unspecified 
``export=false`` is assumed.

Source of CXF translation
^^^^^^^^^^^^^^^^^^^^^^^^^
The source and version of the tool that generated CXF
representation shall be optionally included using the 
properties ``translationSoftware`` and 
``translationSoftwareVersion`` respectively to the CXF
block representation. 

Representing Instances in CXF
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Instances of a CDL class shall contain the entire 
package path of the CDL class, the octothorpe character
(``#``) followed by the name of the instance in CXF. 
An instance ("child") of an instance ("parent") shall 
be referenced by the parent instance’s CXF 
representation, followed by a period character (``.``)
and then the child instance’s name. When such a child 
instance is present in a CDL logic, the CXF 
representation of the parent instance shall contain a 
``hasInstance`` property to the child instance. 

[Example of a CDL instance representation in CXF

CDL:
  
.. code-block:: modelica

    within ExamplePackage;
    block ExampleSeq
    CDL.Reals.MultiplyByParameter gain(k = 100000) 
        "My gain";
    end ExampleSeq;

CXF reference to ``gain`` instance: ``ExamplePackage.ExampleSeq#gain``

CXF reference to ``gain.k`` instance: ``ExamplePackage.ExampleSeq#gain.k``

CXF property linking ``gain`` and ``gain.k``: ``ExamplePackage.ExampleSeq#gain S231:hasInstance ExamplePackage.ExampleSeq#gain.k .``
]

Handling Arrays and Expressions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A CXF translation of a CDL control logic shall optionally 
include certain configuration options that specify 
how the translation will handle:

* Arrays (both one-dimensional (vectors) and 
  multi-dimensional arrays): A tool that generates 
  CXF translations from CDL shall optionally 
  include a configuration
  indicating whether or not to flatten or 
  preserve the array references. By default, 
  array references in CDL should be preserved 
  in CXF. If the aray references should be flattened, 
  the indices appearing within square 
  brackets (``[`` and ``]``) in CDL shall be 
  appended with the underscore (``_``) character
  and each index shall be concatenated
  with the underscore character (``_``).
  
  [For example, ``A[1]`` becomes ``A_1``, 
  ``B[1 ,2]`` becomes ``B_1_2`` 
  and ``C[4, 5, 6]`` becomes ``C_4_5_6``.
  ]

  Flattened array variables shall be serialized
  as row major: moving from left to
  right in each row before moving to the next row.
  Hence, the CDL statements where arrays
  are referenced shall be flattened in the 
  row-major approach.


  If there already exists an instance in the CDL
  logic with the same name as a flattened array
  instance, then the translation process must raise
  an error. 

  [For example, if in a CDL class, there is a parameter 
  instance ``A_1`` and a vector with 3 elements ``A[3]``, 
  upon flattening, references to the first element of 
  the vector (``A[1]``) would become ``A_1``. As this 
  instance already exists and the tool will raise 
  an error.]
  
* Expressions: A tool that generates CXF translations 
  from CDL shall optionally include a configuration 
  indicating whether or not to evaluate all 
  expressions in the CDL control logic such as those 
  within assignment operations, conditional 
  assignments and arithmetic operations. By default,
  the expressions shall be preseved in CXF. If the 
  expressions have to be evaluated and the expressions
  contain references to a parameter the value of the 
  parameter will be used in the expression. If the
  expressions have to be evaluated and expressions 
  contain references to parameter(s) that does not have 
  a value binding, then the translation should exit
  with an error. 


ExtensionBlocks
^^^^^^^^^^^^^^^^
Instances of ExtensionBlocks within a CDL classs
shall contain the annotation ``__cdl(extenstion=true)``. 
The location of the Functional Mockup Unit implementation
of the ExtensionBlock shall be included using the 
property ``hasFmuPath``.
