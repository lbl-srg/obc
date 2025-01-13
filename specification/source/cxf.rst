.. _sec_cxf:

Control eXchange Format (CXF)
-----------------------------

Introduction
^^^^^^^^^^^^

CXF is a representation of CDL in a format that is
intended to be readily imported and exported into 
building automation systems.  For example, a commercial 
control provider might utilize it to import control logic 
from a design tool and deploy it their commercial
building automation system for a
particular project.  Structurally the content of a
logic in CDL and CXF are identical, in that both 
utilize the same ElementaryBlocks, CompositeBlocks, and
ExtensionBlocks as well as Constants, Parameters, 
InputConnectors and OutputConnectors. While CDL has 
language constructs that are used to build library of 
sequences, CXF was designed to only represent a 
specifically configured logic. The logic described in a 
CDL implementation is identical to the logic described 
in its CXF representation. But there are several key 
differences between CDL and CXF:

* CXF is defined utilizing the linked data format `JSON-LD <https://www.w3.org/TR/json-ld11/>`_, 
  while CDL utilizes the modeling language Modelica. 
  JSON-LD is a syntax to serialize linked data in JSON (`ECMA-404 <https://ecma-international.org/publications-and-standards/standards/ecma-404/>`_). 

* There is a translation process required to convert a 
  control logic from CDL to CXF. 

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
    entity's "CDL import" software tool must  
    determine on how to handle the ``Real`` and
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

* Control logic which utilize arrays (both one- and multi
  -dimensional) in CDL shall have
  the option to be modified (or "flattened") in CXF (more details
  provided in a later section). 

Classes and Properties
^^^^^^^^^^^^^^^^^^^^^^

A valid CXF file contains Blocks (ElementaryBlocks, 
CompositeBlocks, ExtensionBlocks or a combination of these) and
each instance of a Block uses the set of InputConnectors, 
OutputConnectors, Parameters, and Constants as defined within
definition of the Block. To support the translation of a 
CDL control logic to its CXF representation, a Resource 
Description Framework graph representation of the 
standard has been provided in a CXF-Core.jsonld file 
using the MIME type ``application/ld+json``. CXF-Core.jsonld can be found 
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
   Blocks                        A Block is the abstract interface of a control logic.
   ElementaryBlock               An ElementaryBlock defined by ASHRAE S231 (``subClassOf 
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
                                 based on an input signal.
   Constant                      A Constant is a value that is fixed at compilation time.
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
   hasInstance                     Block             Block,           A property that associates an instance of an
                                                     InputConnector,  InputConnector, OutputConnector, Parameter, 
                                                     OutputConnector, Constant or a Block within a 
                                                     Parameter,       Block with the instance of the 
                                                     Constant         Block itself.
   hasFmuPath                      ExtensionBlock    String           A property that specifies the (local 
                                                                      or on the network)
                                                                      path to a Functional Mockup Unit
                                                                      implementation of an ExtensionBlock.
   isOfDataType                    InputConnector,   DataType         A property that specifies the data type for 
                                   OutputConnector,                   instances of InputConnectors, OutputConnectors,
                                   Parameter,                         Parameters and Constants.
                                   Constant
   containsBlock                   Block             Block            A property that specifies that an instance
                                                                      of a Block is composed in part 
                                                                      with an instance of another Block.
   connectedTo                     OutputConnector,  InputConnector,  A property that relates the output of one Block
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

All the ElementaryBlocks within the standard have been 
defined and included in ``CXF-Core.jsonld``. However, CXF 
representation of elementary blocks does not contain 
the implementation details of the blocks. 

Generating CXF from an instance of a CDL class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
If the instantiation of a CDL block (within a Modelica 
or another CDL class) contains the annotation
``__cdl(export=true)``, the CDL class of the
instantiated block shall be translated to CXF. Specifying the
``export`` annotation is optional and if unspecified, 
``export=false`` is assumed.

Source of CXF translation
^^^^^^^^^^^^^^^^^^^^^^^^^
The CXF representation of a control logic shall 
optionally include the name and the version of the software
that generated it using the properties ``translationSoftware``
and ``translationSoftwareVersion`` respectively. 


Representing Instances in CXF
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
In the CXF representation of a CDL control logic,
the instances of the CDL class shall contain the entire 
package path of the CDL class, the octothorpe character
(``#``), followed by the name of the instance. 
An ("child") instance of an ("parent") instance shall 
be referenced in CXF by the parent instance’s CXF 
representation, followed by a period character (``.``)
and then the child instance’s name. Additionally,
the CXF representation of the parent instance shall 
contain a ``hasInstance`` property associating it
to the child instance. 

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
Arrays and expressions in a CDL class shall
be represented in CXF as specified below:

* Arrays (both one-dimensional (vectors) and 
  multi-dimensional): In the CXF translation,
  array references shall either be preserved 
  or flattened. If the array references are to 
  be flattened, the indices appearing within square 
  brackets (``[`` and ``]``) in CDL shall be 
  appended with the underscore (``_``) character
  and each index shall be concatenated
  with the underscore character (``_``).
  
  [For example, if there array references 
  are preserved, ``A[1]`` in CDL shall be 
  referenced as ``A[1]`` in CXF. If they are 
  flattened, ``A[1]`` shall be represented as
  ``A_1`` and ``B[1 ,2]`` shall be
  represented as ``B_1_2``.
  ]
  
  Array references in CDL shall be flattened in the 
  row-major approach in CXF. Flattened array references 
  shall be generated row-wise, starting from the left-most
  element of the first row to the right-most element of
  the first row, before advancing to the next row, until
  the right-most element of the last row.

  If there already exists an instance in the CDL
  logic with the same name as a flattened array
  reference, then the translation process shall raise
  an error.

  [For example, if in a CDL class, there exists a parameter 
  instance ``A_1`` and a vector with 3 elements ``A[3]``, 
  upon flattening, references to the first element of 
  the vector (``A[1]``) would become ``A_1``. As this 
  instance already exists, the CXF translator tool 
  shall raise an error.]
  
* Expressions: The CXF translation 
  of a CDL control logic shall either preserve or
  evaluate all the expressions present in the 
  CDL logic, such as those 
  within assignment operations, conditional 
  assignments and arithmetic operations. By default,
  the expressions shall be preserved in the CXF
  representation. If the 
  expressions have to be evaluated and the expressions
  contain references to a parameter, the value of the 
  parameter shall be used in the evaluating the expression. 
  If the expressions have to be evaluated and expressions 
  contain references to parameter(s) that does not have 
  a value binding, then the translation process shall
  raise an error. 

.. note::
  The determination of whether arrays should be
  flattened or expressions should be evaluated
  shall be made by the software tool that generates CXF 
  representations of the CDL control logic.


ExtensionBlocks
^^^^^^^^^^^^^^^^
Instances of ExtensionBlocks within a CDL classs
shall contain the annotation ``__cdl(extenstion=true)``. 
The location of the Functional Mockup Unit implementation
of the ExtensionBlock shall be included in the CXF
representation using the property ``hasFmuPath``.
