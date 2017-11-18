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

#. ``redeclare``
#. ``constrainedby``
#. ``inner`` and ``outer``

Also, the following Modelica language features are not supported in CDL:

#. Clocks [which are used in Modelica for hybrid system modeling].
#. ``algorithm`` sections. [As the elementary building blocks are black-box
   models as far as CDL is concerned and thus CDL compliant tools need
   not parse the ``algorithm`` section.]
#. ``initial equation`` and ``initial algorithm`` sections.
#. package-level declaration of ``constant`` data types.


.. _sec_cld_per_typ:

Permissible data types
^^^^^^^^^^^^^^^^^^^^^^

The basic data types are, in addition to the elementary building blocks,
parameters of type
``Real``, ``Integer``, ``Boolean``, ``String``, and ``enumeration``.
[Parameters do not change their value as time progress.]
See also the Modelica 3.3 specification, Chapter 3.
All specifications in CDL shall be declaration of blocks,
instances of blocks, or declarations of type ``parameter``
or type ``constant``.
Variables are not allowed [they are used however in the elementary building blocks].

The declaration of such types is identical to the declaration
in Modelica.
[The keyword ``parameter`` is used
before the type declaration, and typically a graphical user interface
allows users to change the value of a parameter when the simulation
or control sequence is not running.
For example, to declare a real-valued parameter,
use ``parameter Real k = 1 "A parameter with value 1";``.
In contract, a ``constant`` cannot be changed after the software is
compiled, and is typically not shown in a graphical user interface menu.
For example, a ``constant`` is used to define latent heat of evaporation
if used in a controller.
]

Each of these data types, including the elementary building blocks,
can be a single instance or one-dimensional array.
Array indices shall be of type ``Integer`` only.
The first element of an array has index ``1``.
An array of size ``0`` is an empty array.
See the Modelica 3.3 specification Chapter 10 for array notation.

[``enumeration`` or ``Boolean`` data types are not permitted as array indices.]

.. note::

   We still need to define the allowed values for ``quantity``, for example
   ``ThermodynamicTemperature`` rather than ``Temp``.


.. _sec_enc_block:

Encapsulation of functionality
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

All computations are encapsulated in a ``block``.
Blocks exposes parameters (used to configure
the block, such as a control gain), and they
expose inputs and outputs using connectors_.

Blocks are either *elementary building blocks* (:numref:`sec_ele_bui_blo`)
or *composite blocks* (:numref:`sec_com_blo`).


.. _sec_ele_bui_blo:

Elementary building blocks
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. figure:: img/cdl/cdl_screen_shot.*
   :width: 300px

   Screenshot of CDL library.

The CDL contains elementary building blocks that are used to compose
control sequences.
The functionality of elementary building blocks, but not their implementation,
is part of the CDL specification. Hence, users are not allowed to add
new elementary building blocks. Rather, users can use them to implement
composite blocks (:numref:`sec_com_blo`).

.. note::

   The elementary building blocks can be browsed in any of these ways:

     * Open a web browser at
       http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Controls_OBC_CDL.html.
     * Download https://github.com/lbl-srg/modelica-buildings/archive/master.zip, unzip the file,
       and open ``Buildings/package.mo`` in the graphical model editor of
       `Dymola <https://www.3ds.com/products-services/catia/products/dymola/trial-version/>`_ or
       `OpenModelica <https://www.openmodelica.org/?id=78:omconnectioneditoromedit&catid=10:main-category>`_.
       All models in the `Examples` and `Validation` packages can be simulated with these tools.
       They can also be simulated with `JModelica <http://www.jmodelica.org/>`_.

[CDL implementations are allowed to use a different implementation of the elementary
building blocks, because the implementation is language specific. However,
implementations shall have the same inputs, outputs and parameters, and
they shall compute the same response for the same value of inputs and state variables.]

An actual implementation looks as follows, where we omitted
is used for graphical rendering:

.. code-block:: modelica

   block AddParameter "Output the sum of an input plus a parameter"

     parameter Real p "Value to be added";

     parameter Real k "Gain of input";

     Interfaces.RealInput u "Connector of Real input signal";

     Interfaces.RealOutput y "Connector of Real output signal";

   equation
     y = k*u + p;

     annotation(Documentation(info(
     <p>
     Block that outputs <code>y = k u + p</code>,
     where <code>k</code> and <code>p</code> are
     parameters and <code>u</code> is an input.
     </p>));
   end AddParameter;

For the complete implementation, see
the
`github repository <https://github.com/lbl-srg/modelica-buildings/blob/master/Buildings/Controls/OBC/CDL/Continuous/AddParameter.mo>`_.


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

In the assignment of ``parameters``, calculations are allowed.

[For example, a hysteresis block could be configured as follows

.. code-block:: modelica

   parameter Real pRel(unit="Pa") = 50 "Static pressure difference at damper";

   CDL.Logical.Hysteresis hys(
     uLow  = pRel-25,
     uHigh = pRel+25) "Hysteresis for fan control";

]

Instances can conditionally be removed by using an ``if`` clause.

[This allows to have one implementation for an economizer control sequence
that can be configured to take into account enthalpy rather than
temperature. A statement would be

.. code-block:: modelica

   parameter Boolean use_enthalpy = true
     "Set to true to evaluate outdoor air enthalpy in addition to temperature";

   CDL.Interfaces.RealInput hOut if use_enthalpy
      "Outdoor air enthalpy";

By the Modelica language definition, all connections (:numref:`sec_connections`)
to ``hOut`` will be removed if ``use_enthalpy = false``.]


.. _sec_connectors:

Connectors
^^^^^^^^^^

Blocks expose their inputs and outputs through input and output
connectors. The permissible connectors are defined in the
`CDL.Interfaces package
<http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Controls_OBC_CDL_Interfaces.html#Buildings.Controls.OBC.CDL.Interfaces>`_.

Connectors can only carry scalar variables.
For arrays, the connectors need to be explicitly declared as an array.

[ For example, to declare an array of ``nin`` input signals, use

.. code-block:: modelica

   parameter Integer nin(min=1) "Number of inputs";

   Interfaces.RealInput u[nin] "Connector for 2 Real input signals";

Hence, unlike in Modelica 3.2, we do not allow for automatic vectorization
of input signals.
]

.. _sec_connections:

Connections
^^^^^^^^^^^

Connections connect input to output connector (:numref:`sec_connectors`).
Each input connector of a block needs to be connected to exactly
one output connector of a block.
Connections are listed after the instantiation of the blocks in an equation
section. The syntax is

.. code-block:: modelica

   connect(port_a, port_b) annotation(...);

where ``annotation(...)`` is optional and may be used to declare
the graphical rendering of the connection.
The order of the connections and the order of the arguments in the
``connect`` statement does not matter.

[For example, to connect an input ``u`` of an instance ``gain`` to the output
``y`` of an instance ``timer``, one would declare

.. code-block:: modelica

   Continuous.Max maxValue "Output maximum value";
   Continous.Gain gain(k=60) "Gain";

   equation
     connect(gain.u, maxValue.y);

]

Signals shall be connected using a ``connect`` statement;
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
with the file extension ``.mo``, and with each package name being a directory.
The name shall be an allowed Modelica class name.

[For example, if a user specifies a new composite block ``MyController.MyAdder``, then it
shall be stored in the file ``MyController/MyAdder.mo`` on Linux or OS X, or ``MyController\\MyAdder.mo``
on Windows.]


[The following statement, when saved as ``CustomPWithLimiter.mo``, is the
declaration of the composite block shown in :numref:`fig_custom_control_block`


.. literalinclude:: img/cdl/CustomPWithLimiter.mo
   :language: modelica
   :linenos:

Composite blocks are needed to preserve grouping of control blocks and their connections,
and are needed for hierarchical composition of control sequences.]



Model of computation
^^^^^^^^^^^^^^^^^^^^

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


Tags
^^^^

CDL has sufficient information for tools that process CDL to
generate for example point lists that list all analog temperature sensors,
or to verify that a pressure control signal is not connected to a temperature
input of a controller.
Some, but not all, of these information can be inferred from the CDL language described above.
We will use tags, implemented through Modelica vendor annotations,
to provide this additional information.
In :numref:`sec_inf_pro`, we will explain the properties that can be inferred,
and in :numref:`sec_tag_pro`, we will explain how to use
tagging schemes in CDL.

.. note:: None of these information affects the computation of a control signal.
          Rather, it can be used for example to facilitate the implementation of cost estimation tools,
          or to detect incorrect connections between outputs and inputs.

.. _sec_inf_pro:

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
     quantity="PressureDifference",
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
* Unit: Unit and preferred display unit. (The display unit
  can be overwritten by a tool. This allows for example a control vendor
  to use the same sequences in North America displaying IP units, and in
  the rest of the world displaying SI units.)

]

.. _sec_tag_pro:

Tagged Properties
.................

The buildings industry uses different tagging schemes such as
Brick (http://brickschema.org/) and Haystack (http://project-haystack.org/).
CDL allows, but does not require, use of the Brick or Haystack tagging scheme.

CDL allows to tag declarations that instantiate

* elementary building blocks (:numref:`sec_ele_bui_blo`), and
* composite blocks (:numref:`sec_com_blo`).

[We currently do not see a use case that would require
adding a tag to a ``parameter`` declaration.]


To implement such tags, CDL blocks can contain
vendor annotations with the following syntax:

.. code-block:: modelica

   annotation :
     annotation "(" [annotations ","]
        __cdl "(" [ __cdl_annotation ] ")" ["," annotations] ")"

where ``__cdl__annotation`` is the annotation for CDL.

For Brick, the ``__cdl_annotation`` is

.. code-block:: modelica

   brick_annotation:
      brick "(" RDF ")"

where ``RDF`` is the RDF 1.1 Turtle
(https://www.w3.org/TR/turtle/) specification of the Brick object.

[Note that, for example
for a controller with two output signals :math:`y_1` and :math:`y_2`,
Brick seems to have no means to specify
that :math:`y_1` ``controls`` a fan speed and :math:`y_2` ``controls``
a heating valve, where ``controls`` is the Brick relationship.
Therefore, we allow the ``brick_annotation`` to only be at the
block level, but not at the level of instances of input or output
signals.

For example, the Brick specification

.. code-block:: modelica

   soda_hall:flow_sensor_SODA1F1_VAV_AV a brick:Supply_Air_Flow_Sensor ;
      bf:hasTag brick:Average ;
      bf:isLocatedIn soda_hall:floor_1 .

can be declared in CDL as

.. code-block:: modelica

   annotation(__cdl(brick(
     soda_hall:flow_sensor_SODA1F1_VAV_AV a brick:Supply_Air_Flow_Sensor ;
        bf:hasTag brick:Average ;
        bf:isLocatedIn soda_hall:floor_1 . )))

]

For Haystack, the ``__cdl_annotation`` is

.. code-block:: modelica

   haystack_annotation:
      haystack "(" JSON ")"

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

.. code::

   annotation(__cdl( haystack(
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
      "unit       : "degF"} )));


Tools that process CDL can interpret the ``brick`` or ``haystack`` annotation,
but CDL will ignore it. [This avoids potential conflict for entities that
are declared differently in Brick (or Haystack) and CDL, and may be conflicting.
For example, the above sensor input declares in Haystack that it belongs
to an ahu3. CDL, however, has a different syntax to declare such dependencies:
In CDL, the instance that declares this sensor
input already unambiguously declares to what entity it belongs to, and the
sensor input will automatically get the full name ``whitehouse.ahu3.TSup``.
Furthermore, through the ``connect(whitehouse.ahu3.TSup, ...)`` statement,
a tool can infer what upstream component sends the input signal.]
