.. _sec_process:

Introduction
------------

Background
~~~~~~~~~~

More than 1 quad/yr of energy is wasted in the US because,
for most commercial building projects, control sequences are poorly specified and implemented.
The process to specify, implement and verify controls sequences is often only partially successful,
with efficiency being the most difficult part to accomplish.
This is particulary the case for
built-up HVAC systems, which require custom-control solutions and
which are common in large buildings.
For such systems, the current state is that, at best,
the mechanical designer specifies the building control sequences
in an English language specification. However, such a specification
cannot be tested formally for correctness.
It is also ambiguous, leaving room for different implementations,
including variants that were not intended by the designer or may not work
correctly.
The implementation of the sequences is often done by a controls
contractor who either attempts to implement the sequence as specified,
or use a sequence of a similar project that appears to have the same control intent.
During commissioning, the lack of an executable specification of the control sequence
against which the implementation can be tested makes commissioning of the
control sequences expensive and limited in terms of code coverage :cite:`GnerreFuller2017`.
Not surprisingly, programming errors are the dominating issue among control-related
problems that impact energy use in buildings :cite:`BarwigHouseEtAl2002`.

However, formal controls design and verification in other industries has led to
significant labor cost savings and performance improvements.


Project Goals
~~~~~~~~~~~~~

The overall goal of this project is to significantly improve the building energy efficiency
through a robust workflow that allows deploying at scale high performance building control sequence.
In support of this, the project developed a process
with an integrated set of tools to enable design engineers to unambiguously
specify energy-efficient control sequences for commercial buildings and
then verify their correct implementation, providing end-to-end quality control.


Approach
~~~~~~~~

Our approach is to digitize the control delivery. Rather than paper-based English language
specification, our process is fully digitized, allowing performance assessment in design,
electronic specification in a format that was designed to allow machine-to-machine translation to
control product lines, and formal verification of the control response relative
to its electronic specification.

Specifically, the project developed tools and process that allow for a digital control specification,
performance assessment using whole building energy simulation, and
delivery and implementation on existing building automation product lines.

The technical environment for such a digital control delivery starts to fall in place:
For communication of control signals, standards such as
BACnet, LonWorks and EIB/KNX are widely used.
For semantic modeling, Haystack and Brick are increasingly used, and
ASHRAE Standard 223P attempts to standardize semantic modeling, building on these
previous efforts.


.. __fig_cdl_overview:

.. figure:: img/overview.*
   :width: 700 px

   Overview of process for control sequence design, export of
   a specification, implementation on a control platform and verification
   against the specification.


However, what is missing is a means to express control sequences
in a way that can be simulated during design,
exported for control specification and documentation,
translated to commercial product lines and reused for formal verification of the correct
implementation of the control sequences. This gap is what the OpenBuildingControl project
attempts to close.
A key element of the OpenBuildingControl is the
Control Description Language (CDL) that has been developed in the project.
CDL is a declarative language for expressing control sequences through block diagram modeling.
To enable simulation of closed loop control as part of annual energy modeling during building design
or control research,
we designed CDL to be
a proper subset of the Modelica language, an open standard for an eqution-based object-oriented
modeling language :cite:`MattssonElmqvist1997:1,Modelica2012:1`.
As CDL is a declarative language,
the control specification can be exported in a vendor-independent json format
that serves as an intermediate format to produce English language documentation including point lists,
and that can serve as input to a code translator to a particular control product line.
The control specification can also be exported for use in a formal process that verifies
that the control signal of the actual implementation is within a user-selected tolerance
of the simulated control signal. This therefore provides a workflow with an end-to-end
verification as shown in :numref:`fig_cdl_overview`.
Therefore, CDL complements communication (BACnet) and semantic modeling (ASHRAE 223P) by
expressing the control logic, with the goal of standardizing this missing part of the
control representation.

We believe that the time for such an effort is ideal due to the convergence of various technologies
such as declarative modeling (Modelica) that allows closed loop control simulation in annual energy modeling,
advances in code generation that eases machine-to-machine translation of declarative languages,
semantic modeling (BRICK) that promises to generate a semantic model from a declarative Modelica model
for subsequent semi-automatical connection to an actual buildings in which a digital twin of the
control and of the building systems could be used to support building analytics (MORTAR~\cite{}).
Due to the trend towards all electric buildings, which, to increase 2nd law efficiency, should no longer
decouple subsystems through large temperature lifts (as is customary in fossil-fuel based heating systems),
and the resulting need for more complex control which, in addition, also need to provide grid flexibility,
we believe such a convergence of technology will help the industry achieving higher system-level performance.



Process workflow
~~~~~~~~~~~~~~~~


:numref:`fig_process` shows a more detailed view of the process of selecting, deploying and verifying a control sequence
that we developed in OpenBuildingControl.
First, given regulations and efficiency targets, labeled as (1) in :numref:`fig_process`,
a design engineer selects, configures, tests and evaluates the performance of a control sequence
using building energy simulation (2),
starting from a control sequence library that contains ASHRAE GPC 36 sequences,
as well as user-added sequences (3),
linked to a model of the mechanical system and the building (4).
If the sequences meet closed-loop performance requirements,
the designer exports a control specification,
including the sequences and functional verification tests expressed in
the Control Description Language CDL (5).
Optionally, for reuse in similar projects,
the sequences can be added to a user-library (6).
This specification is used by the control vendor to bid on the project (7)
and to implement the sequence (8) in product-specific code.
Prior to operation, a commissioning provider verifies
the correct functionality of these implemented sequences
by running functional tests against the electronic, executable specification
in the Commissioning and Functional Verification Tool (9).
If the verification tests fail, the implementation needs to be corrected.

For closed-loop performance assessment,
`Modelica models <http://simulationresearch.lbl.gov/modelica/>`_
of the HVAC systems and controls will be linked to
a Modelica envelope model :cite:`WetterZuoNouidui2011:2` or to
an EnergyPlus envelope model. The latter can be done through
Spawn of EnergyPlus :cite:`WetterBenneGautierEtAl2020`,
which is being developed in a related project at
`https://lbl-srg.github.io/soep/ <https://lbl-srg.github.io/soep/>`_.


.. _fig_process:

.. figure:: img/ControlsDesignVerficationFlow.*
   :width: 800px

   Process workflow for controls design, specification and
   functional verification.


Project Results
~~~~~~~~~~~~~~~

xxx Summarize main results.