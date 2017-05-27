.. _sec_cdl:

Control Description Language
----------------------------

This section specifies
the Control Description Language (CDL).

The CDL consists of the following elements:

* A list of elementary control blocks, such as a block that adds two signals and outputs the sum,
  or a block that represents a PID controller.
* Connectors through which these blocks receive values and output values.
* Permissible data types.
* Syntax to specify

  * how to instantiate these blocks and assign values of parameters, such as a proportional gain.
  * how to connect inputs of blocks to outputs of other blocks.
  * how to document blocks.
  * how to add annotations such as for graphical rendering of blocks
    and their connections.
  * how to specify composite blocks.

* A model of computation that describes when blocks are executed and when
  outputs are assigned to inputs.

The next sections explain the elements of CDL.


Syntax
^^^^^^

In order to easily process CDL, we will use
a subset of the Modelica 3.3 specification
for the implementation of CDL :cite:`Modelica2012:1`.
The syntax is a minimum subset of Modelica as needed to instantiate
classes, assign parameters, connect objects and document classes.
This subset is fully compatible with Modelica, e.g., no other information that
violates the Modelica Standard is added.

To simplify the implementation, the following Modelica keywords are not supported in CDL:

#. `redeclare`
#. `constrainedby`
#. `inner` and `outer`

Also, the following Modelica language features are not supported in CDL:

#. Clocks [which are used in Modelica for hybrid system modeling].
#. `algorithm` sections. [As the elementary building blocks are black-box
   models as far as CDL is concerned and thus CDL compliant tools need
   not parse the `algorithm` section.]
#. `initial equation` and `initial algorithm` sections.
#. package-level declaration of `constant` data types.


.. _sec_cld_per_typ:

Permissible data types
^^^^^^^^^^^^^^^^^^^^^^

The basic data types are, in addition to the elementary building blocks,
parameters of type
`Real`, `Integer`, `Boolean`, `String`, and `enumeration`.
[Parameters do not change their value as time progress.]
See also the Modelica 3.3 specification, Chapter 3.
All specifications in CDL shall be blocks or parameters.
Variables are not allowed [they are used however in the elementary building blocks].

The declaration of such types is identical to the declaration
in Modelica, e.g., the keyword ``parameter`` is used
before the type declaration.
[For example, to declare a real-valued parameter,
use ``parameter Real k = 1 "A parameter with value 1";``.]

Each of these data types, including the elementary building blocks,
can be a single instance or one-dimensional array.
Array indices shall be of type `Integer` only.
The first element of an array has index `1`.
An array of size `0` is an empty array.
See the Modelica 3.3 specification Chapter 10 for array notation.

[`enumeration` or `Boolean` data types are not permitted as array indices.]

.. note::

   We still need to define the allowed values for `quantity`, for example
   ``ThermodynamicTemperature`` rather than ``Temp``.


Encapsulation of functionality
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

All computations are encapsulated in a `block`.
Blocks exposes parameters (used to configure
the block, such as a control gain), and they
expose inputs and outputs using connectors_.

Blocks are either `elementary building blocks`_
or `composite blocks`_.


.. _sec_ele_bui_blo:

Elementary building blocks
^^^^^^^^^^^^^^^^^^^^^^^^^^

The CDL contains elementary building blocks that are used to compose
control sequences. The elementary building blocks can be
browsed at the CDL blocks web page
http://obc.lbl.gov/specification/cdl/latest/help/CDL.html.

An actual implementation looks as follows, where we omitted
is used for graphical rendering:

.. code-block:: modelica

   block AddParameter "Outputs the sum of a parameter and a signal"
     parameter Real p "Value to be added to input";
     Interfaces.RealInput u "Connector for Real input signal";
     RealOuput y "Connector for Real output signal";

     annotation(Documentation(info(
     <p>
     Block that outputs <code>y = k u + p</code>,
     where <code>k</code> and <code>p</code> are
     parameters and <code>u</code> is an input.
     </p>));
   end AddParameter;

For the complete implementation, see
the
`github repository <https://github.com/lbl-srg/modelica-buildings/tree/issue609_cdl/Buildings/Experimental/OpenBuildingControl/CDL>`_.

.. todo::

   Various blocks still need to be added, see
   https://github.com/lbl-srg/modelica-buildings/issues/610.
   For example, the following blocks are missing
   in the current Modelica library:

   * Block that outputs the day of the week.
   * Block that outputs the temperature setback for heating.


.. todo::

   Should a GPC 36 sequence also be an elementary building block so
   that manufacturers can implement them in a library, or should
   they be only composed of smaller blocks and stored using
   `composite blocks`_?


Instantiation
^^^^^^^^^^^^^

Instantiation is identical to Modelica.

[For example, to instantiate a gain, one would write

.. code-block:: modelica

   Continuous.Gain myGain(k=-1) "Constant gain of -1" annotation(...);

where the documentation string and the annotation are both optional.
The optional annotations is typically used
for the graphical positioning of the instance in a block-diagram.
]

.. todo::

   We need to clarify whether

   #. We allow operations such as

      .. code-block:: modelica

         parameter Real p = 10;
         Continuous.Gain myGain(k=2*p);

   #. We allow conditional removal of blocks, such as
      such as

      .. code-block:: modelica

         parameter Boolean useGain = false;
         Continuous.Gain myGain(k=10*60) if useGain;

      [This would allow removing certain blocks and all their connections
      based on a boolean parameter.]


.. _sec_connectors:

Connectors
^^^^^^^^^^

Blocks expose their inputs and outputs through input and output
connectors. The permissible connectors are defined in the
`CDL.Intefaces package <cdl/latest/help/CDL_Interfaces.html>`_.

Connectors can only carry scalar variables.
For arrays, the connectors need to be explicitly declared as an array.

[ For example, to declare an array of `nin` input signals, use

.. code-block:: modelica

   parameter Integer nin(min=1) "Number of inputs";

   Interfaces.RealInput u[nin] "Connector for 2 Real input signals";

Hence, unlike in Modelica 3.2, we do not allow for automatic vectorization
of input signals.
]


Connections
^^^^^^^^^^^

Connections connect input to output connectors_.
Each input connector of a block needs to be connected to exactly
one output connector of a block.
Connections are listed after the instantiation of the blocks in an equation
section. The syntax is

.. code-block:: modelica

   connect(port_a, port_b) annotation(...);

where `annotation(...)` is optional and may be used to declare
the graphical rendering of the connection.
The order of the connections and the order of the arguments in the
`connect` statement does not matter.

[For example, to connect an input `u` of an instance `gain` to the output
`y` of an instance `timer`, one would declare

.. code-block:: modelica

   Continuous.Max maxValue "Output maximum value";
   Continous.Gain gain(k=60) "Gain";

   equation
     connect(gain.u, maxValue.y);

]

Signals shall be connected using a `connect` statement;
direct assigning the values of signals when instantiating
signals is not allowed.

[This ensures that all control sequences are expressed as block diagrams.
For example, the following model is valid

.. literalinclude:: img/cdl/MyAdderValid.mo
   :language: modelica
   :linenos:

whereas the following model is not valid in CDL, although it is valid in Modelica

.. literalinclude:: img/cdl/MyAdderInvalid.mo
   :language: modelica
   :linenos:
   :emphasize-lines: 4

]

Annotations
^^^^^^^^^^^

Annotations follow the same rules as described in the following
Modelica 3.3 Specification

* 18.2 Annotations for Documentation
* 18.6 Annotations for Graphical Objects, with the exception of

  * 18.6.7 User input

* 18.8 Annotations for Version Handling

[For CDL, annotations are primarily used to graphically visualize block layouts, graphically visualize
input and output signal connections, and declare
vendor annotation (Sec. 18.1 in Modelica 3.3 Specification).]

.. _sec_com_blo:

Composite blocks
^^^^^^^^^^^^^^^^

CDL allows building composite blocks such as shown in
:numref:`fig_custom_control_block`.

.. _fig_custom_control_block:

.. figure:: img/cdl/CustomPWithLimiter.*
   :width: 500px

   Example of a composite control block that outputs :math:`y = \max( k \, e, \, y_{max})`
   where :math:`k` is a constant.


Composite blocks can contain other composite blocks.

Each composite block shall be stored on the file system under the name of the composite block
with the file extension `.mo`, and with each package name being a directory.
The name shall be an allowed Modelica class name.

[For example, if a user specifies a new composite block `MyController.MyAdder`, then it
shall be stored in the file `MyController/MyAdder.mo` on Linux or OS X, or `MyController\\MyAdder.mo`
on Windows.]


[ The following statement, when saved as `CustomPWithLimiter.mo`, is the
declaration of the composite block shown in :numref:`fig_custom_control_block`


.. literalinclude:: img/cdl/CustomPWithLimiter.mo
   :language: modelica
   :linenos:

Composite blocks are needed to preserve grouping of control blocks and their connections,
and are needed for hierarchical composition of control sequences.]

[fixme: This might be a good spot to list the block hierarchically. Any blocks contained by the composite blocks can inherit appropriate relational tags from any higher level (details and example provided under Tags section)]


Tags
^^^^

CDL has sufficient information for tools that process CDL to
generate for example point lists that list all analog temperature sensors,
or to verify that a pressure control signal is not connected to a temperature
input of a controller.
Some of the required properties need to be tagged, for which we will
use vendor annotations, while other properties
can be inferred from the Modelica declarations.
Next, we explain the properties that can be inferred.

Inferred Properties
...................

In order to infer whether a signal is a hardware or a software point,
all input signals and output signals shall be retrieved from
the packages ``IO.Hardware`` and ``IO.Software``

.. note:: This package still needs to be implemented.

[Note that a differential pressure input signal with name ``u``
can be declared as

.. code-block:: modelica

   Interfaces.RealInput u(
     type="PressureDifference",
     unit="Pa") "Differential pressure signal" annotation (...);

Hence, tools can verify that the ``PressureDifference`` is not connected
to ``AbsolutePressure``, and they can infer that the input has units of Pascal.

Hence, tools that process CDL can infer the following information:

* Numerical value:
  :term:`Binary value <Binary Value>`
  (which in CDL are represented by a ``Boolean`` data types),
  :term:`analog value <Analog Value>`,
  (which in CDL are represented by a ``Real`` data type)
  :term:`mode <Mode>`
  (which in CDL are presented by an ``Integer`` data type or an enumeration,
  which allow for example encoding of the
  ASHRAE Guidline 36 Freeze Protection which has 4 stages).
* Source: Hardware point or software point.
* Quantity: such as Temperature, Pressure, Humidity, Speed or Command/Request/Status
* Unit: Unit and preferred display unit. (Th display unit
  can be overwritten by a tool. This allows for example a control vendor
  to use the same sequences in North America displaying IP units, and in
  the rest of the world displaying SI units.)

]

Tagged Properties
.................

CDL allows to tag declarations that instantiate

* parameters (:numref:`sec_cld_per_typ`),
* elementary building blocks (:numref:`sec_ele_bui_blo`), and
* composite blocks (:numref:`sec_com_blo`).

The buildings industry uses different tagging schemes such as
Brick (http://brickschema.org/) and Haystack (http://project-haystack.org/).
CDL shall allow, but not require, users to use their tagging scheme of choice.
In support of this, it provides syntax to allow optionally to add such tags so that they can
be carried from a CDL representation to tools that process such a tagging
scheme.

To implement such tags, vendor annotations with the following syntax are used:

**LEFT OFF HERE**

.. code-block:: modelica

   annotation :
     annotation "(" [annotations ","]
        __cdl (" [ __cdl_annotation ] ")" ["," annotations] ")"

where ``__cdl__annotation`` is the annotation for CDL.
Hence, annotations need to be at the top-level,
and can be part of other annotation declarations.
[The requirement to be at the top-level
could be relaxed if needed for a specific annotation.]


.. code:: modelica

   haystack_annotation:
      __cdl "(" haystack "=" JSON ")"

where ``JSON`` is the JSON encoding of the Haystack object.

[For example, the AHU discharge air temperature setpoint of the example
in http://project-haystack.org/tag/sensor, which is in Haystack declared as

.. code::

   id: @whitehouse.ahu3.dat
   dis: "White House AHU-3 DischargeAirTemp"
   point
   siteRef: @whitehouse
   equipRef: @whitehouse.ahu3
   discharge
   air
   temp
   sensor
   kind: "Number"
   unit: "degF"]

can be declared in CDL as

.. code-block:: modelica

   Interfaces.RealInput u(unit="K") "Discharge air temperature"
     annotation(__cdl( haystack =
     {"id"        : ""@whitehouse.ahu3.dat",
      "dis"       : "White House AHU-3 DischargeAirTemp",
      "point"     : "m:",
      "siteRef"   : "@whitehouse",
      "equipRef'  : "@whitehouse.ahu3",
      "discharge" : "m:",
      "air"       : "m:",
      "temp"      : "m:",
      "sensor"    : "m:",
      "kind       : "Number"
      "unit       : "degF"} ));


Tools that process CDL can interpret the ``haystack`` annotation,
but CDL will ignore it. [This avoids potential conflict for entities that
are declared differently in Haystack and CDL, and may be conflicting.
For example, the above sensor input declares in Haystack that it belongs
to an ahu3. CDL, however, has a different syntax to declare such dependencies:
In CDL, the instance that declares this sensor
input already unambiguously declares to what entity it belongs to, and the
sensor input will automatically get the full name ``whitehouse.ahu3.TSup``.
Furthermore, through the ``connect(whitehouse.ahu3.TSup, ...)`` statement,
a tool can infer what upstream component sends the input signal.]



CDL shall provide certain relational tags using a syntax which is not essencial to run the control software. CDL uses tag labels as defined by http://brickschema.org/ (see a full description of the Brick schema in the section on Optional External Tags). The function of these tags is to describe the hierarchy and define relations between CDL blocks and the controlled plant.

CDL shall provide the following tags:

.. code::

   name/ID
   contains/isLocatedIn
   controls/isControlledBy
   hasPart/isPartOf
   feeds/isFedBy
   hasInput/isInputOf
   hasOutput/isOutputOf

[fixme: add to the list above as we go along]

To implement the tags, Modelica vendor annotations are used. For example, an economizer enable/disable block is a part of the economizer sequence for "AHU-1" plant [fixme: how do we assign the plant name? Should the user create it or edit it as he instantates the AHU plant block?]:

.. code-block:: modelica

   AtomicSequences.EconEnableDisable econEnableDisable
   annotation (Placement(transformation(extent={{-20,-60},{0,-40}})),
    __cdl( {cdl_tags_name} =
      {"Name/ID"    : "Economizer Enable-Disable 1",
    "isLocatedIn": {inherit from AHU-1},
    "isPartOf"   : "AHU-1",
    "contains"   : "", [fixme: do we want to keep empty tags, seems easier to automate]
    "hasPart"    : "",
    "hasInput"   : "TOut",
    "hasInput"   : "FreezeProtectionStage",
    "hasInput"   : "@whitehouse.ahu3",
    "hasOutput"  : "EcoOnOffSta"));

[fixme: do we still need to leave this in:
The syntax is as follows:



]


Optional External Tags
......................

CDL shall declare a syntax that allows use of (certain) tagging schemes, such as Project Haystack (http://project-haystack.org/) and Brick http://brickschema.org/.


Project Haystack allows tagging of various objects. It is hierarchical
with the three entities *Site*, *Equip* and *Point*, see
http://project-haystack.org/doc/Structure.
These entities are linked to each other through references,
which allows that each instance (of an equipment *Equip*, for example)
can have a self-contained list of tags. Hence, for CDL, we
allow the following tagging to be applied to
instances of
*parameters* (:numref:`sec_cld_per_typ`),
*elementary building blocks* (:numref:`sec_ele_bui_blo`), and
*composite blocks* (:numref:`sec_com_blo`).




.. todo:: Check if we should use tags for alarms, or use a CDL block for this.

Brick, developed by UC Berkeley, is a uniform metadata schema for buildings. Quoting their website, "Brick is an open-source, BSD-licensed development effort to create a uniform schema for representing metadata in buildings. Brick has three components:

* An RDF class hierarchy describing the various building subsystems and the entities and equipment therein
* A minimal, principled set of relationships for connecting these entities together into a directed graph representing a building
* A method of encapsulation for composing complex components from a set of lower-level ones"

[fixme: add a set of examples which would explain how a Control Design hierarchy gets encapsulated using Brick relational tags.]

Tools that process CDL can interpret optional external annotations, such as ``haystack`` and ``brick``, but CDL will ignore it at runtime. [This avoids potential conflict for entities that
are declared differently in Haystack/Brick/{other schema} and CDL.]

[fixme

  .. note:: Other tagging standards worth considering in development of the CDL tagging strategy:

        - ASHRAE Guidline 13 Specifying Direct Digital Control (DDC) Systems
        - Manufacturer specific point tagging conventions, such as Taylor Engineering and Schneider Electric
        - Project Haystack
        - In progress: BSR/ASHRAE Standard 223P

]


[fixme: the following paragraphs are Michael's from an older version, do we want/need to keep them?

All instances of ``CDL.Interfaces.*Input`` and instances of ``CDL.Interfaces.*Output`` can have
the following annotation:
[mg we could add and/or modify tags for these optional point tags]

.. code:: modelica

   point_annotation:
      __cdl "(" analog   [ "(" voltage "=" 8 | 16  ")" ] |
                 digital  [ "(" address "=" address ")" ] ")"

   address:
      todo: specify how to declare the address. Is it only an IP address, or
      something else (in addition?)

Note that the specification of the voltage and the address is optional,
as these information may not yet be known at the design stage.

]


Model of computations
^^^^^^^^^^^^^^^^^^^^^

CDL uses the synchronous data flow principle and the single assignment rule,
which are defined below. [The definition is adopted from and consistent with the Modelica 3.3 Specification, Section 8.4.]

#. All variables keep their actual values until these values
   are explicitly changed. Variable values can be accessed at any time instant.
#. Computation and communication at an event instant does not take time.
   [If computation or communication time has to be simulated, this property has to be explicitly modeled.]
#. Every input connector shall be connected to exactly one output connector.

In addition, the dependency graph from inputs to outputs that directly depend
on inputs shall be directed and acyclic.
I.e., connections that form an algebraic loop are not allowed.
[To break an algebraic loop, one could place a delay block or an integrator
in the loop, because the outputs of a delay or integrator does *not* depend
directly on the input.]


.. todo::

   In simulation, we likely need to use discrete event or discrete time semantics
   for reasons of computing speed, but actual control systems use discrete time
   sampled systems. We need to address how to sample the control blocks in
   simulation, in the actual implementation, and in the verification tool [as
   they all have different needs on performance, predictability of computing time,
   and scheduling of execution].
