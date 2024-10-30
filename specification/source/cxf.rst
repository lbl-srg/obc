.. _sec_cxf:

Control eXchange Format (CXF)
-----------------------------

Introduction
^^^^^^^^^^^^

CXF is a representation of CDL in a format that is
intended to be readily imported and exported into 
building automation systems.  As an example, a commercial 
control provider might utilize it to import control logic 
from a design tool for use in a control sequence being 
deployed on a project.  Structurally the content of a
sequence in CDL and CXF are identical, in that both 
utilize the same Elementary, Composite, and Extension 
Blocks as well as constants, parameters, input, and 
output connectors, although CDL has language constructs 
that are used to build library of sequences, while CXF
was designed to only represent a specifically configured
sequence. The logic described in a CDL sequence is identical
to the logic described in a CXF sequence. 
But there are several key differences between CDL and CXF:

* CXF is defined utilizing the linked data format `JSON-LD <https://www.w3.org/TR/json-ld11/>`_, 
  while CDL utilizes the modeling language Modelica standard. 
  JSON-LD is a syntax to serialize linked data in JSON (`ECMA-404 <https://ecma-international.org/publications-and-standards/standards/ecma-404/>`_). 
  The JSON-LD representation is easier to interpret by computer
  programs than Modelica, which is designed to be human readable. 

* There is a translation process required to convert a 
  sequence from CDL to CXF. 

* For Elementary Blocks (:numref:`sec_ele_blo`), their
  CXF representation does not include the implementation 
  (``equation`` section).

* Like many scientific modeling languages, Modelica requires 
  tight casting of data types. Commercial control products are 
  more flexible in the use of data types. 
  
  [For example, in Modelica, a data type needs to be declared as
  type ``Real`` or ``Integer``. ``Real`` data are not allowed to be 
  tested for equality since computations are prone to rounding 
  errors. Many commercial control systems define continuous 
  data types as ``analog``. 
  ]

* Libraries which utilize matrices and vectors in CDL shall have
  the option to be modified (or "flattened") to result in an 
  instance of control logic which is then represented in CXF. 
  [For example: A[1] and B[1,2] are elements of a matrix. Then, 
  after flattening, their names are A_1 and B_1_2. A similar 
  pattern applies for higher dimensional matrices.  
  ]

* Certain Blocks that are supported in CDL are not readily 
  supported in commercial control products. 
  [Some examples include:
   
  * Blocks that utilize vectors and matrices. These blocks are 
    used for the development and support of control sequence 
    libraries but are not easily utilized in graphical 
    programming tools. 
  * The “Pre” block which is used to break algebraic loops that
    involve Boolean variables during a simulation but is not 
    required in common building controllers.

  ]

Classes and Properties
^^^^^^^^^^^^^^^^^^^^^^

A valid CXF file contains Blocks (that is Elementary Blocks, 
Composite Blocks, Extension Blocks or a combination of these) and
each instance of a block uses the set of input and output 
connectors, parameters, and constants as defined within definition 
of the Block. To support this process, a Resource Description 
Framework (RDF) graph representation of the standard has been 
provided in a CXF-Core.jsonld file using the MIME type 
``application/ld+json`` and it can be found `here <https://github.com/lbl-srg/modelica-json/blob/master/CXF-Core.jsonld>`_.
The key classes and properties present in CXF-Core.jsonld 
that can be used to created CXF classes are shown in
Table :numref:`tab_cxf_cla` and Table :numref:`tab_cxf_rel` respectively. 


.. _tab_cxf_cla:

.. table:: Key classes within ``CXF-Core.jsonld``
   :widths: 15 80

   ============================  ===========================================================
   Class                         Description
   ============================  ===========================================================
   Package						 
   								 A package is a specialized class used to group multiple 
   								 blocks.
   Blocks   					 A block is the abstract interface of a control sequence.
   ElementaryBlock 
   								 An elementary block defined by ASHRAE S231P (subClassOf 
   								 Block) (:numref:`sec_ele_blo`).
   CompositeBlock 
   								 A composite block is a collection of elementary blocks or 
   								 other composite blocks (subclass of Block) and the 
   								 connections through their inputs and outputs (:numref:`sec_com_blo`).
   ExtensionBlock
   								 An extension block supports functionalities that cannot, 
   								 or are hard to, implement with a composite block (:numref:`sec_ext_blo`).
   InputConnector
   								 An input connector is a connector that provides an input to 
   								 a block.
   OutputConnector
   								 An output connector is a connector that provides an output 
   								 from a block.
   Parameter
   								 A parameter is a value that is time-invariant and cannot be changed 
   								 based on an input signal. A block can have multiple parameters.
   Constant
   								 A constant is a value that is fixed at compilation time. A block can 
   								 have multiple constants.
   DataType
   								 A data type description for function block connectors, parameters, 
   								 and constants.
   BooleanInput
   								 An input connector for boolean data type.
   BooleanOutput
   								 An output connector for boolean data type.
   IntegerInput
   								 An input connector for integer data type.
   IntegerOutput
   								 An output connector for integer data type.
   RealInput
   								 An input connector for real data type.
   RealOutput
   								 An output connector for real data type.
   EnumerationType
   								 An Integer enumeration starting with the value 1, each element 
   								 is mapped to a unique String.
   AnalogInput
   								 An input connector for analog data type.
   AnalogOutput
   								 An output connector for analog data type.
   String
   								 A data type to represent text.
   ============================  ===========================================================								 
			 


.. _tab_cxf_rel:

.. table:: Key properties within ``CXF-Core.jsonld``
   :widths: 15 25 25 50

   =============================== ================= ================ =========================================
   Property                        Domain            Range            Description
   =============================== ================= ================ =========================================
   hasInput                        Block             InputConnector   Used to define an input connector for a 
                                                                      block.
   hasOutput                       Block             OutputConnector  Used to define an output connector for a 
                                                                      block.
   hasParameter                    Block             Parameter        Used to define a parameter for a block.
   hasConstant                     Block             Constant         Used to define a constant for a block.
   hasInstance                     Block             Block,           Used to define an instance (input, 
                                                     InputConnector,  output, parameter or constant) of a 
                                                     OutputConnector, block.
                                                     Parameter, 
                                                     Constant
   isOfDataType                    InputConnector,   DataType         Used to define the data type for input 
                                   OutputConnector,                   connectors, output connectors, parameters,
                                   Parameter,                         and constants.
                                   Constant
   containsBlock                   Block             Block            Used in composite block to include other
                                                                      blocks.
   connectTo                       OutputConnector,  InputConnector,  Used to connect the output of one block
                                   InputConnector    OutputConnector  to the input of a block. Only connectors
                                                                      that carry the same data type can be
                                                                      connected.
   translationSoftware             Package, Block    String           Used to include the name of the software
                                                                      used to CXF representation of the
                                                                      sequence.
   translationSoftwareVersion      Package, Block    String           Used to include the version of the
                                                                      software used to CXF representation of
                                                                      the sequence.		
   =============================== ================= ================ =========================================

All the ElementaryBlock within the standard have been 
defined and included in ``CXF-Core.jsonld``. However, CXF 
representation of elementary blocks does not contain 
the implementation details of the blocks. 

Generating CXF from an instance of a CDL class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A CXF representation of a sequence will be able to be 
generated from a instance of a CDL class. When there 
are instances of a CDL class within a Modelica or 
another CDL class, if the instance has the CDL 
annotation ``__cdl(export=true)``, the corresponding CDL 
class shall be translated to CXF. If there is no 
``export`` annotation attached to the instance, the 
default value would be false and no CXF will be 
generated for the class of that instance. 

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
instance is present in a CDL sequence, the CXF 
representation of the parent instance shall contain a 
``hasInstance`` property to the child instance. 

[Example of a CDL instance representation in CXF

CDL:
  
.. code-block:: modelica

    within ExamplePackage;
    block ExampleSeq
    CDL.Reals.MultiplyByParameter gain(k = 100000 
        "My gain";
    end ExampleSeq;

CXF reference to ``gain`` instance: ``ExamplePackage.ExampleSeq#gain``
CXF reference to ``gain.k`` instance: ``ExamplePackage.ExampleSeq#gain.k``
CXF property linking ``gain`` and ``gain.k``: ``ExamplePackage.ExampleSeq#gain S231:hasInstance ExamplePackage.ExampleSeq#gain.k .``

Handling Vectors and Expressions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A CXF translation of a CDL sequence shall optionally 
include certain configuration options that specify 
how the translation will handle:

* Vectors: A tool that generates CXF translations 
  from CDL shall optionally include a configuration
  indicating whether or not to flatten or 
  preserve the vector references. By default, 
  vector references in CDL should be flattened 
  in CXF. An index appearing within square 
  brackets (``[`` and ``]``) in CDL shall be 
  appended with the underscore (``_``) character. 
* Expressions: A tool that generates CXF translations 
  from CDL shall optionally include a configuration 
  indicating whether or not to evaluate all 
  expressions in the CDL sequence such as those 
  within assignment operations, conditional 
  assignments and arithmetic operations. 

