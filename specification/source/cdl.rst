.. _sec_cdl:

Control Description Language
----------------------------

Introduction
^^^^^^^^^^^^


This section specifies
the Control Description Language (CDL),
a declarative language that can be used to express control sequences using block-diagrams.
It is designed in such a way that it can be used to conveniently specify building control sequences
in a vendor-independent format, use them within whole building energy simulation,
and translate them for use in building control systems.

To put CDL in context, and to introduce terminology, :numref:`fig_cdl_pro_lin` shows the translation of CDL to a control product line
or to English language documentation.
Input into the translation is CDL. An open-source tool called ``modelica-json`` translator
(see also :numref:`sec_cdl_to_json_simp` and https://github.com/lbl-srg/modelica-json)
translates CDL to an intermediate format that we call :term:`CDL-JSON`.
From CDL-JSON, further translations can be done to a control product line, or to
generate point lists or English language documentation of the control sequences.

.. _fig_cdl_pro_lin:

.. uml::
   :caption: Translation of CDL to the CDL-JSON intermediate format and to a product line or English language documentation.
   :width: 550 px

   skinparam componentStyle uml2

     [CDL]

     [CDL-JSON]

     [control product line]

     [point list]

     [English language documentation]

     [CDL] -d-> [CDL-JSON]

     [CDL-JSON] --> [control product line]

     [CDL-JSON] --> [point list]

     [CDL-JSON] --> [English language documentation]



This section describes the CDL language. Its translation using ``modelica-json``, or other means of translation, is described in
:numref:`sec_code_gen`.
A collection of control sequences, primarily from ASHRAE Guideline 36, is available
from the Modelica Buildings Library at https://simulationresearch.lbl.gov/modelica/.
A tool to export CDL into the CDL-JSON intermediate format that
can be used to translate to commercial building automation systems, a process that we have been prototyping in 2019/20, is
available at https://github.com/lbl-srg/modelica-json.


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

The next sections define the CDL language.


Syntax
^^^^^^

In order to use CDL with building energy simulation programs,
and to not invent yet another language with new syntax, we use
a subset of the Modelica 3.3 specification
for the implementation of CDL :cite:`Modelica2012:1`.
The selected subset is needed to instantiate
classes, assign parameters, connect objects and document classes.
This subset is fully compatible with Modelica, e.g., no other information that
violates the Modelica Standard has been added, thereby allowing users
to view, modify and simulate CDL-conformant control sequences with any
Modelica-compliant simulation environment.

To simplify the support of CDL for tools and control systems,
the following Modelica keywords are not supported in CDL:

#. ``extends``
#. ``redeclare``
#. ``constrainedby``
#. ``inner`` and ``outer``

Also, the following Modelica language features are not supported in CDL:

#. Clocks [which are used in Modelica for hybrid system modeling].
#. ``algorithm`` sections. [As the elementary building blocks are black-box
   models as far as CDL is concerned and thus CDL compliant tools need
   not parse the ``algorithm`` section.]
#. ``initial equation`` and ``initial algorithm`` sections.
#. ``connect`` statements that carry non-scalar values.


.. _sec_cld_per_typ:

Permissible Data Types
^^^^^^^^^^^^^^^^^^^^^^

The basic data types are, in addition to the elementary building blocks,
parameters of type
``Real``, ``Integer``, ``Boolean``, ``String``, and ``enumeration``.
[Parameters do not change their value as time progresses.]
See also the Modelica 3.3 specification, Chapter 3.
All specifications in CDL shall be declaration of blocks,
instances of blocks, or declarations of type ``parameter``,
``constant``, or ``enumeration``.
Variables are not allowed.
[Variables are used in the elementary building blocks,
but these can only be used as inputs to other blocks if they are declared
as an output.]

The declaration of such types is identical to the declaration
in Modelica.
[The keyword ``parameter`` is used
before the type declaration, and typically a graphical user interface
allows users to change the value of a parameter when the simulation
or control sequence is not running.
For example, to declare a real-valued parameter,
use ``parameter Real k = 1 "A parameter with value 1";``.
In contrast, a ``constant`` cannot be changed after the software is
compiled, and is typically not shown in a graphical user interface menu.
For example, a ``constant`` is used to define latent heat of evaporation
if used in a controller.
]

Each of these data types, including the elementary building blocks,
can be a single instance, one-dimensional array or two-dimensional array (matrix).
Array indices shall be of type ``Integer`` only.
The first element of an array has index ``1``.
An array of size ``0`` is an empty array.

Arrays may be constructed with the array constructor
function ``array(x1,x2,...)`` or its shorthand ``{x1,x2,...}``,
for example ``parameter Integer k[3,2] = {{1,2},{3,4},{5,6}}``,
one or several iterators, for example
``parameter Real k[2,3] = {i*0.5+j for i in 1:3, j in 1:2};``,
and with a ``fill`` function.
Arrays may also be concatenated using ``cat``.

The size of arrays will be fixed at translation. It cannot be changed during run-time.

[``enumeration`` or ``Boolean`` data types are not permitted as array indices.]

See the Modelica 3.3 specification Chapter 10 for array notation and these
functions.


.. note::

   We still need to define the allowed values for ``quantity``, for example
   ``ThermodynamicTemperature`` rather than ``Temp``.


.. _sec_enc_block:

Encapsulation of Functionality
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

All computations are encapsulated in a ``block``.
Blocks expose parameters (used to configure
the block, such as a control gain), and they
expose inputs and outputs using connectors_.

Blocks are either *elementary building blocks* (:numref:`sec_ele_bui_blo`)
or *composite blocks* (:numref:`sec_com_blo`).


.. _sec_ele_bui_blo:

Elementary Building Blocks
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. figure:: img/cdl/cdl_screen_shot.*
   :width: 300px

   Screenshot of CDL library.

The CDL library contains elementary building blocks that are used to compose
control sequences.
The functionality of elementary building blocks, but not their implementation,
is part of the CDL specification.
Thus, in the most general form, elementary building blocks can be considered
as functions that for given parameters :math:`p`,
time :math:`t` and internal state :math:`x(t)`,
map inputs :math:`u(t)` to new values for the
outputs :math:`y(t)` and states :math:`x'(t)`, e.g.,

.. math::

   (p, t, u(t), x(t)) \mapsto (y(t), x'(t)).

Control providers who support CDL need to be able to implement the same
functionality as is provided by the elementary CDL blocks.


[CDL implementations are allowed to use a different implementation of the elementary
building blocks, because the implementation is language specific. However,
implementations shall have the same inputs, outputs and parameters, and
they shall compute the same response for the same value of inputs and state variables.]

Users are not allowed to add
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
       All models in the `Examples` and `Validation` packages can be simulated with these tools, as well
       as with `OPTIMICA <https://www.modelon.com/products-services/modelon-creator-suite/optimica-compiler-toolkit/>`_ and
       with `JModelica <http://www.jmodelica.org/>`_.

An actual implementation of an elementary building block
looks as follows, where we omitted the annotations that are
used for graphical rendering:

.. code-block:: modelica

   block AddParameter "Output the sum of an input plus a parameter"

     parameter Real p "Value to be added";
     parameter Real k "Gain of input";

     Interfaces.RealInput u "Connector of Real input signal";
     Interfaces.RealOutput y "Connector of Real output signal";

   equation
     y = k*u + p;

     annotation(Documentation(info("
     <html>
     <p>
     Block that outputs <code>y = k u + p</code>,
     where <code>k</code> and <code>p</code> are
     parameters and <code>u</code> is an input.
     </p>
     </html>"));
   end AddParameter;

For the complete implementation, see
the
`github repository <https://github.com/lbl-srg/modelica-buildings/blob/master/Buildings/Controls/OBC/CDL/Continuous/AddParameter.mo>`_.

.. _sec_instantiation:

Instantiation
^^^^^^^^^^^^^

.. _sec_ass_val_to_ins:

Declaration and Assigning Values to Parameters
..............................................

*Parameters* are values that do not depend on time.
The values of parameters can be changed during run-time through a user
interaction with the control program (such as to change a control gain),
unless a parameter is a :term:`structural parameter <Structural parameter>`.

The declaration of parameters and their values is identical to Modelica,
except that parameter assignment can only be
literals (such as ``Real``, ``Integer`` and ``Boolean``) and
arrays of literals. In addition, for ``Boolean`` parameters, expressions involving
``and``, ``or`` and ``not`` are allowed.
For ``Real`` and ``Integer``, expressions are allowed that involve

- the basic arithmetic functions ``+``, ``-``, ``*``, ``-``,
- the relations ``>``, ``>=``, ``<``, ``<=``, ``==``, ``<>``,
- calls to the functions listed in :numref:`tab_par_fun`.

.. _tab_par_fun:


.. table:: Functions that are allowed in parameter assignments. The functions
           are consistent with Modelica 3.3.
   :widths: 15 80

   ========================  ===========================================================
   Function                  Descrition
   ========================  ===========================================================
   ``abs(v)``                Absolute value of ``v``.
   ``sign(v)``               Returns ``if v>0 then 1 else if v<0 then –1 else 0``.
   ``sqrt(v)``               Returns the square root of ``v`` if ``v >=0``, or an error otherwise.
   ``div(x, y)``             Returns the algebraic quotient ``x/y`` with any fractional
                             part discarded (also known as truncation toward zero).
                             [Note: this is defined for ``/`` in C99; in C89 the result for
                             negative numbers is implementation-defined,
                             so the standard function ``div()`` must be used.].
                             Result and arguments shall have type ``Real`` or ``Integer``.
                             If either of the arguments is ``Real`` the result is ``Real``
                             otherwise it is ``Integer``.
   ``mod(x, y)``             Returns the integer modulus of ``x/y`` , i.e.
                             ``mod(x,y)=x-floor(x/y)*y``. Result and
                             arguments shall have type ``Real`` or ``Integer``.
                             If either of the arguments is ``Real`` the
                             result is ``Real`` otherwise it is ``Integer``.

                             [Examples are ``mod(3,1.4)=0.2``, ``mod(-3,1.4)=1.2`` and
                             ``mod(3,-1.4)=-1.2``.]
   ``rem(x,y)``              Returns the integer remainder of ``x/y``, such that
                             ``div(x,y)*y + rem(x, y) = x``.
                             Result and arguments shall have type ``Real`` or ``Integer``.
                             If either of the arguments is ``Real`` the result is ``Real``
                             otherwise it is ``Integer``.

                             [Examples are ``rem(3,1.4)=0.2`` and ``rem(-3,1.4)=-0.2``.]
   ``ceil(x)``               Returns the smallest integer not less than ``x``.
                             Result and argument shall have type ``Real``.
   ``floor(x)``              Returns the largest integer not greater than ``x``.
                             Result and argument shall have type ``Real``.
   ``integer(x)``            Returns the largest integer not greater than ``x``.
                             The argument shall have type Real.
                             The result has type Integer.
   ``min(A)``                Returns the least element of array expression ``A``.
   ``min(x, y)``             Returns the least element of the scalars ``x`` and ``y``.
   ``max(A)``                Returns the greatest element of array expression ``A``.
   ``max(x, y)``             Returns the greatest element of the scalars ``x`` and ``y``.
   ``sum(...)``              The expression ``sum( e(i, ..., j) for i in u, ..., j in v)``
                             returns the sum of the expression ``e(i, ..., j)`` evaluated for all
                             combinations of ``i`` in
                             ``u, ..., j in v: e(u[1], ... ,v[1]) + e(u[2], ... ,v[1])+... +e(u[end],... ,v[1])+...+e(u[end],... ,v[end])``

                             The type of ``sum(e(i, ..., j) for i in u, ..., j in v)`` is the same as the type of ``e(i,...j)``.
   ``fill(s, n1, n2, ...)``  Returns the :math:`n_1 \times n_2 \times n_3 \times \dots` array with all
                             elements equal to scalar or array
                             expression ``s`` (:math:`n_i \ge 0`).
                             The returned array has the same type as ``s``.

                             Recursive definition:
                             ``fill(s, n1, n2, n3, ...) = fill( fill(s, n2, n3, ...), n1);``,
                             ``fill(s,n)={s, s, ..., s}``

                             The function needs two or more arguments; that is ``fill(s)``
                             is not legal.
   ========================  ===========================================================



[For example, to instantiate a gain, one would write

.. code-block:: modelica

   Continuous.Gain gai(k=-1) "Constant gain of -1" annotation(...);

where the documentation string is optional.
The annotation is typically used
for the graphical positioning of the instance in a block-diagram.]

Using expressions in parameter assignments, and propagating values of parameters
in a hierarchical formulation of a control sequence, are convenient language constructs
to express relations between
parameters. However, most of today's building control product lines do not support
propagation of parameter values and evaluation of expressions in parameter assignments.
For CDL to be compatible with this limitation, the ``modelica-json`` translator
has optional flags, described below, that trigger the evaluation of propagated parameters,
and that evaluate expressions that involve parameters.
CDL also has a keyword called ``final`` that prevents a declaration to be changed by the user.
This can be used in a hierarchical controller to ensure that parameter values are propagated to lower level controller
in such a way that users can only change their value at the top-level location.
Again, most of today's building control product lines do not support such a language construct.
Therefore, CDL has been designed in such a way that optionally parameter propagations and expressions
that involve parameters can be preserved during the translation, or they can be evaluated.
To guarantee that the original intent is maintained even for building control product lines
that do not support the concept of a ``final`` declaration, certain
restrictions are imposed on how to use the ``final`` keyword.
The next sections describe the propagation of parameters without and with the ``final`` keyword.


Evaluation of propagated non-final parameters and evaluation of non-final parameter expressions
_______________________________________________________________________________________________

This section only applies to the assignment of parameter values that do not have the ``final`` keyword.


Consider the statement

.. code-block:: modelica

   parameter Real pRel(unit="Pa") = 50 "Pressure difference across damper";

   CDL.Continuous.Sources.Constant con(
     k = pRel) "Block producing constant output";
   CDL.Logical.Hysteresis hys(
     uLow  = pRel-25,
     uHigh = pRel+25) "Hysteresis for fan control";

Some building control product lines will need to evaluate this at translation because
they cannot propagate parameters and/or cannot evaluate expressions.

To lower the barrier for a CDL translator, the ``modelica-json`` translator has two flags.
One flag, called ``evaluatePropagatedParameters`` will cause the translator to evaluate the propagated parameter,
leading to a CDL-JSON declaration that is equivalent to the declaration

.. code-block:: modelica

   CDL.Continuous.Sources.Constant con(
     k(unit="Pa") = 50) "Block producing constant output";
   CDL.Logical.Hysteresis hys(
     uLow  = 50-25,
     uHigh = 50+25) "Hysteresis for fan control";

Note
  1. the ``parameter Real pRel(unit="Pa") = 50`` has been removed as it is no longer used anywhere.
  2. the parameter ``con.k`` has now the ``unit`` attribute set as this information would otherwise be lost.
  3. the parameter ``hys.uLow`` has the unit *not* set because the assignment involves an expression.

Another flag called ``evaluateExpressions`` will cause all mathematical expressions to be evaluated,
leading to a CDL-JSON declaration that is equivalent to the CDL declaration

.. code-block:: modelica

   parameter Real pRel(unit="Pa") = 50 "Pressure difference across damper";

   CDL.Continuous.Sources.Constant con(
     k = pRel) "Block producing constant output";
   CDL.Logical.Hysteresis hys(
     uLow  = 25,
     uHigh = 75) "Hysteresis for fan control";

If both ``evaluatePropagatedParameters`` and ``evaluateExpressions`` are set, the result would be
equivalent of the declaration

.. code-block:: modelica

   CDL.Continuous.Sources.Constant con(
     k(unit="Pa") = 50) "Block producing constant output";
   CDL.Logical.Hysteresis hys(
     uLow  = 25,
     uHigh = 75) "Hysteresis for fan control";

.. note::

   This is being implemented through https://github.com/lbl-srg/modelica-json/issues/102


Propagation of parameter values that use the final keyword
__________________________________________________________

If the assignment of parameter values involve the ``final`` keyword, then certain restrictions
must be placed to ensure that the declarations of CDL can be preserved when translated
to a control product line that does not support a ``final`` keyword.
Specifically, only one-to-one parameter assignment are allowed.
For example, consider

.. code-block:: modelica

   parameter Real s = 1;
   Continuous.Sources.Constant con(final k=s); // k cannot be set to anything else than s
   equation
   connect(con.y, someBlock.u);


A translator from CDL to the CDL-JSON intermediate format
can translate this in two possible ways, called *a)* and *b)* below.
Option *a)* is for translators that will preserve the ``parameter`` declaration and its dependencies after the translation,
such as any Modelica-based tool would. This option allows any Modelica GUI to expose to the
modeller the parameters so that she/he can change the values.
Option *b)* is for translators that will remove the dependencies, such as ALC Eikon. In these programs,
building operators would open the graphical panes and change the value in a ``Constant`` block.

Using option *a)*, the translator will generate code such as the pseude-code below

.. code-block:: C

   s = value_from_gui(instanceName="s", startValue=1);
   con.k = s;
   someBlock.u = con.k;

In this case, stoping the simulation, setting a new value of ``s=2`` and continuing the simulation will
cause ``s = con.k = someBlock.u = 2``.
[The pseudo-function ``value_from_gui`` may show to the building operator
a window in which the value for ``s`` can be changed during run-time.]

Option *b)* is for building control product lines that do not support such a dependency.
In this case, the generated code will be equivalent to the declaration

.. code-block:: modelica

   Continuous.Sources.Constant s(k=1);
   equation
   connect(s.y, someBlock.u);

or using pseude-code

.. code-block:: C

  s = value_from_gui(instanceName="s", startValue=1);
  someBlock.u = s;

If option *b)* is used, then the translator must remove the declaration ``parameter Real s=1;``
because there is no longer anything dependent on the parameter ``s``, and rename the instance ``con`` to ``s``,
which will ensure that the documentation of the sequence, which may describe what ``s`` is, remains correct.
Note that for option *b)*, the propagation of the parameter value is through block-diagram modeling only.

For option *b)* to work, parameters must only be assigned to one instance
if this assignment is declared as ``final``. For example

.. code-block:: modelica
   :emphasize-lines: 2,3

   parameter Real samplePeriod = 60;
   Discrete.Sampler sam1(final samplePeriod = samplePeriod); // not valid
   Discrete.Sampler sam2(final samplePeriod = samplePeriod); // not valid

is not valid and ``modelica-json`` will stop with an error.
This is because a translator may translate this, using option *b)* above, to

.. code-block:: C

    sam1.samplePeriod = 60;
    sam2.samplePeriod = 60;

at which point a user cannot change the value anymore, causing the translated program to be less flexible.]

.. note::

   If ``sam1.samplePeriod = sam2.samplePeriod = samplePeriod`` must be enforced for the logic to work correctly,
   then the controller can be implemented using
   `CDL.Logical.Sources.SampleTrigger <https://simulationresearch.lbl.gov/modelica/releases/v6.0.0/help/Buildings_Controls_OBC_CDL_Logical_Sources.html#Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger>`_
   and connect its output to instances of
   `CDL.Discrete.TriggeredSampler <https://simulationresearch.lbl.gov/modelica/releases/v6.0.0/help/Buildings_Controls_OBC_CDL_Discrete.html#Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler>`_
   that sample the corresponding signals.


.. _sec_con_rem_ins:

Conditionally Removing Instances
................................

Instances can be conditionally removed by using an ``if`` clause.

This allows, for example, to have an implementation of a controller that optionally
takes as an input the number of occupants in a zone.

An example code snippet is

.. code-block:: modelica

   parameter Boolean have_occSen=false
     "Set to true if zones have occupancy sensor";

   CDL.Interfaces.IntegerInput nOcc if have_occSen
     "Number of occupants"
       annotation (__cdl(default = 0));

   CDL.Continuous.Sources.Constant con(
     k = VOutPerPer_flow) if have_occSen
       "Outdoor air per person";
   equation
   connect(nOcc, con.u);

By the Modelica language definition, all connections (:numref:`sec_connections`)
to ``nOcc`` will be removed if ``have_occSen = false``.

Some building automation systems do not allow to conditionally removing instances
of blocks, inputs and outputs, and their connections. Rather, these instances
are always present, and a value for the input must be present.
To accomodate this case, every input connector that can be conditionally removed
must declare a default value of the form ``__cdl(default = value)``,
where ``value`` is the default value that will be used
if the building automation system does not support conditionally removing instances.
The type of ``value`` must be the same as the type of the connector.
For ``Boolean`` connectors, the allowed values are ``true`` and ``false``.

Note that output connectors must not have a specification of a default value,
because if a building automation system cannot conditionally remove instances,
then the block (or input connector) upstream of the output will always be present
(or will have a default value).

.. _sec_connectors:

Connectors
^^^^^^^^^^

Blocks expose their inputs and outputs through input and output
connectors.

The permissible connectors are implemented in the package
``CDL.Interfaces``, and are
``BooleanInput``, ``BooleanOutput``,
``DayTypeInput``, ``DayTypeOutput``,
``IntegerInput``, ``IntegerOutput``,
``RealInput`` and ``RealOutput``.
``DayType`` is an ``enumeration`` for working day,
non-working day and holiday.

Connectors must be in a ``public`` section.

Connectors can only carry scalar variables.
For arrays, the connectors need to be explicitly declared as an array.

[ For example, to declare an array of ``nin`` input signals, use

.. code-block:: modelica

   parameter Integer nin(min=1) "Number of inputs";

   Interfaces.RealInput u[nin] "Connector for 2 Real input signals";

Hence, unlike in Modelica 3.3, we do not allow for automatic vectorization
of input signals.
]

.. _sec_equation:

Equations
^^^^^^^^^

After the instantiations (:numref:`sec_instantiation`),
a keyword ``equation`` must be present
to introduce the equation section.
The equation section can only contain
connections (:numref:`sec_connections`) and
annotations (:numref:`sec_annotations`).

Unlike in Modelica, an ``equation`` section shall not contain
equations such as ``y=2*u;`` or commands such as ``for``, ``if``,
``while`` and ``when``.

Furthermore, unlike in Modelica, there shall not be an ``initial equation``,
``initial algorithm`` or ``algorithm``
section. (They can however be part of a elementary building block.)


.. _sec_connections:

Connections
^^^^^^^^^^^

Connections connect input to output connector (:numref:`sec_connectors`).
For scalar connectors, each input connector of a block needs to be connected to exactly
one output connector of a block.
For vectorized connectors, each (element of an) input connector needs to be connected
to exactly one (element of an) output connector.
Unlike in Modelica, a ``connect`` statement can only connect scalar variables or an
individual element of a vectorized input/output port.

[Hence, the following is not valid:

.. code-block:: modelica

   CDL.Continuous.Sources.Constant con[2](k={1, 1}) "Constant producing the output [1, 1]";
   CDL.Continuous.MultiSum sum(nin=2) "Block that outputs the sum of its inputs";

   equation
   connect(con.y, sum.u); // Not valid

]

.. note:: In future extension, we will consider to allow vectorized input connectors
          to be connected to vectorized output connectors, using one connection statement provided that
          they have the same number of elements. This may be required for control sequences that
          stage multiple chillers as developed in ASHRAE RP 1711.

Connections are listed after the instantiation of the blocks in an ``equation``
section. The syntax is

.. code-block:: modelica

   connect(port_a, port_b) annotation(...);

where ``annotation(...)`` is used to declare
the graphical rendering of the connection (see :numref:`sec_annotations`).
The order of the connections and the order of the arguments in the
``connect`` statement does not matter.

[For example, to connect an input ``u`` of an instance ``gain`` to the output
``y`` of an instance ``maxValue``, one would declare

.. code-block:: modelica

   Continuous.Max maxValue "Output maximum value";
   Continous.Gain gain(k=60) "Gain";

   equation
     connect(gain.u, maxValue.y);

]

Signals shall be connected using a ``connect`` statement;
assigning the value of a signal in the instantiation of the
output connnector is not allowed.

[This ensures that all control sequences are expressed as block diagrams.
For example, the following model is valid

.. literalinclude:: img/cdl/MyAdderValid.mo
   :language: modelica

whereas the following implementation is not valid in CDL, although it is valid in Modelica

.. literalinclude:: img/cdl/MyAdderInvalid.mo
   :language: modelica
   :emphasize-lines: 4

]

.. _sec_annotations:

Annotations
^^^^^^^^^^^

Annotations follow the same rules as described in the following
Modelica 3.3 Specifications

* 18.2 Annotations for Documentation
* 18.6 Annotations for Graphical Objects, with the exception of

  * 18.6.7 User input

* 18.8 Annotations for Version Handling

[For CDL, annotations are primarily used to graphically visualize block layouts, graphically visualize
input and output signal connections, and to declare
vendor annotations, (Sec. 18.1 in Modelica 3.3 Specification), such as to specify default
value of connector as below.]

CDL also uses annotations to declare default values for conditionally removable input
connectors, see :numref:`sec_con_rem_ins`.

.. _sec_com_blo:

Composite Blocks
^^^^^^^^^^^^^^^^

CDL allows building composite blocks such as shown in
:numref:`fig_custom_control_block`.

.. _fig_custom_control_block:

.. figure:: img/cdl/CustomPWithLimiter.*
   :width: 500px

   Example of a composite control block that outputs :math:`y = \min( k \, e, \, y_{max})`
   where :math:`k` is a parameter.


Composite blocks can contain other composite blocks.

Each composite block shall be stored on the file system under the name of the composite block
with the file extension ``.mo``, and with each package name being a directory.
The name shall be an allowed Modelica class name.

[For example, if a user specifies a new composite block ``MyController.MyAdder``, then it
shall be stored in the file ``MyController/MyAdder.mo`` on Linux or OS X, or ``MyController\MyAdder.mo``
on Windows.]


[The following statement, when saved as ``CustomPWithLimiter.mo``, is the
declaration of the composite block shown in :numref:`fig_custom_control_block`


.. literalinclude:: img/cdl/CustomPWithLimiter.mo
   :language: modelica

Composite blocks are needed to preserve grouping of control blocks and their connections,
and are needed for hierarchical composition of control sequences.]



Model of Computation
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
Some, but not all, of this information can be inferred from the CDL language described above.
We will use tags, implemented through Modelica vendor annotations,
to provide this additional information.
In :numref:`sec_inf_pro`, we will explain the properties that can be inferred,
and in :numref:`sec_tag_pro`, we will explain how to use
tagging schemes in CDL.

.. note:: None of this information affects the computation of a control signal.
          Rather, it can be used for example to facilitate the implementation of cost estimation tools,
          or to detect incorrect connections between outputs and inputs.

.. _sec_inf_pro:

Inferred Properties
...................

To avoid that signals with physically incompatible quantities
are connected, tools that parse CDL can infer the physical quantities
from the ``unit`` and ``quantity`` attributes.

[For example, a differential pressure input signal with name ``u``
can be declared as

.. code-block:: modelica

   Interfaces.RealInput u(
     quantity="PressureDifference",
     unit="Pa") "Differential pressure signal" annotation (...);

Hence, tools can verify that the ``PressureDifference`` is not connected
to ``AbsolutePressure``, and they can infer that the input has units of Pascal.

Therefore, tools that process CDL can infer the following information:

* Numerical value:
  :term:`Binary value <Binary Value>`
  (which in CDL is represented by a ``Boolean`` data type),
  :term:`analog value <Analog Value>`,
  (which in CDL is represented by a ``Real`` data type)
  :term:`mode <Mode>`
  (which in CDL is presented by an ``Integer`` data type or an enumeration,
  which allow for example encoding of the
  ASHRAE Guideline 36 Freeze Protection which has 4 stages).
* Source: Hardware point or software point.
* Quantity: such as Temperature, Pressure, Humidity or Speed.
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

CDL allows to add tags to declarations that instantiate

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
connectors.

For example, the Brick specification

.. code-block:: modelica

   soda_hall:flow_sensor_SODA1F1_VAV_AV a brick:Supply_Air_Flow_Sensor ;
      bf:hasTag brick:Average ;
      bf:isLocatedIn soda_hall:floor_1 .

can be declared in CDL as

.. code-block:: modelica

   annotation(__cdl(brick="soda_hall:flow_sensor_SODA1F1_VAV_AV a brick:Supply_Air_Flow_Sensor  ;
     bf:hasTag brick:Average ;
     bf:isLocatedIn soda_hall:floor_1 ."));

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
   unit: "degF"

can be declared in CDL as

.. code::

   annotation(__cdl( haystack=
     "{\"id\"   : \"@whitehouse.ahu3.dat\",
       \"dis\" : \"White House AHU-3 DischargeAirTemp\",
       \"point\" : \"m:\",
       \"siteRef\" : \"@whitehouse\",
       \"equipRef\" : \"@whitehouse.ahu3\",
       \"discharge\" : \"m:\",
       \"air\"       : \"m:\",
       \"temp\"      : \"m:\",
       \"sensor\"    : \"m:\",
       \"kind\"       : \"Number\"
       \"unit\"       : \"degF\"}"));


Tools that process CDL can interpret the ``brick`` or ``haystack`` annotation,
but for control purposes CDL will ignore it. [This avoids potential conflict for entities that
are declared differently in Brick (or Haystack) and CDL, and may be conflicting.
For example, the above sensor input declares in Haystack that it belongs
to an ahu3. CDL, however, has a different syntax to declare such dependencies:
In CDL, through the ``connect(whitehouse.ahu3.TSup, ...)`` statement,
a tool can infer what upstream component sends the input signal.]
