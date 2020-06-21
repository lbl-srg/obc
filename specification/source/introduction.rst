.. _sec_intro:

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

The overall goal of this project is to significantly improve building energy efficiency
through a robust workflow that allows deploying high performance building control sequence at scale.
In support of this, the project developed a process
with an integrated set of tools to enable design engineers to unambiguously
specify energy-efficient control sequences for commercial buildings and
then verify their correct implementation, providing end-to-end quality control.


Approach
~~~~~~~~

Our approach is to digitize the delivery of control. Rather than paper-based English language
specification, our process is fully digitized, allowing performance assessment in design,
electronic specification in a format that was designed to allow machine-to-machine translation to
control product lines, and formal verification of the control response relative
to its electronic specification.

Specifically, the project developed tools and process that allow for a digital control specification,
performance assessment using whole building energy simulation, and
delivery and implementation on existing building automation product lines.

The technical environment for such a digital control delivery starts to fall in place:
For communication of control signals, standards such as
BACnet and LonWorks are widely used.
For semantic modeling, Haystack and Brick Schema are increasingly used, and
the proposed ASHRAE Standard 223P attempts to standardize semantic modeling, building on these
previous efforts.


.. _fig_cdl_overview:

.. figure:: img/overview.*
   :width: 700 px

   Overview of process for control sequence design, export of
   a specification, implementation on a control platform and verification
   against the specification.


However, what is missing is a means to express control sequences
in a way that can be simulated during design,
exported for control specification and documentation,
used directly or
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
Therefore, CDL complements communication (ASHRAE 135 - BACnet) and semantic modeling
(ASHRAE 223P - Designation and Classification of Semantic Tags for Building Data) by
expressing the control logic, with the goal of standardizing this missing part of the
control representation.

We believe that the time for such an effort is ideal due to the convergence of various technologies
related to the digitization of the building design and operation, and related to emerging needs
of building energy systems.
Regarding digitization of the building design and operation,
declarative modeling (Modelica) progressed substantially over the last years,
getting to the point where fully coupled closed loop control simulation is possible
within annual energy simulation.
Furthermore, advances in code generation eases machine-to-machine translation of declarative languages and
semantic modeling (BRICK or ASHRAE 223p), putting in place the foundation to generate a semantic model
from a declarative Modelica model. This combination promises to allow the
semi-automatic connection of an actual building system to a digital twin of the
control and related algorithms that support building analytics (MORTAR~\cite{FieroPritoniEtAl2019}).
Regarding emerging needs of building energy systems,
there is a shift towards all electric buildings in various US states and various countries.
In these systems, heating and cooling
often includes the use of heat sources and heat storage that are close to ambient temperatures.
To increase the 2nd law efficiency of such systems, systems operate with low temperature lifts,
rather than the large temperature lifts that are customary in fossil-fuel based heating systems
and conventional cooling systems.
Moreover, building systems also have the added recent requirement to provide flexibility to the
electrical grid.
All of these lead to more complex HVAC and control systems.
The OpenBuildingControl process has been developed to support the transitions towards
such high performance systems.


Project Results
~~~~~~~~~~~~~~~

The project resulted in a process and a set of software tools that pave the way to a digitized control
delivery process. They enable the performance evaluation and improvement of building control sequences
using whole building energy simulation. Typical performance indices
are annual energy use, greenhouse gas emissions, peak demand and thermal comfort.
Such performance assessment can be done by researchers and control companies as part of developing
and evaluating new control sequences, or by mechanical designers as part of the building design process.
These control sequences can then be exported to a digital format for which we showed as a proof-of-concept
that it can be translated to a commercial building control platform, thereby running the control sequence
that was used in simulation natively on a commercial building control platform.
This intermediate format also provides control providers data needed to build digital cost estimation tools,
further streamlining the control procurement process.

As part of the project, we demonstrated each step of such a digitized control design, delivery and
verification process. We also started forming an ASHRAE Standards Committee whose purpose is to
turn the Control Description Language that has been developed in this project into an ASHRAE/ANSI standard.
Such a standard will then complete existing standards for building control *communication* (ASHRAE 135 - BACnet),
emerging standards for *semantic* data (ASHRAE 223P - Designation and Classification of Semantic Tags for Building Data)
with a standard that allows expressing the
control *logic* in a way that is independent of a particular control product line.

The potential energy savings of this project, if adopted widely,
are estimated to be in California,
4.03 TWh of electricity,
equivalent to 0.038 quads (11.28 TWh) of source energy, and 0.00764 quads (2.24 TWh) of natural gas.
In the US, the potenial savings are
74.4 TWh of electricity, equivalent to 0.71 quads (208 TWh) of source energy, and
0.135 quads (39.5 TWh) of natural gas.

If we assume 75% adoption of OpenBuildingControl over the next ten years, a controls retrofit rate of 10% per year and
a new building construction rate of 1.5% per year,
then, after 10 years, the fraction of the building stock, weighted by floor area,
that is impacted by OpenBuildingControl is 21%.
This would result in estimated benefits of $146M/yr for California electricity ratepayers.

The next sections provide more details about the results of this project.
They are structured as follows:

:numref:`sec_process` describes the overall process from control design to performance assessment,
export of control specification, cost-estimation, implementation by a control vendor and formal verification of the
implemented control sequences relative to the design specifications.

:numref:`sec_cdl` describes the Control Description Language (CDL), which is the key technology developed in this project.
This language is used to express control sequences digitally and in English language, in a format that is then translated
for simulation, for cost estimation, and for implementation in control product lines. This section is rather technical,
and is mainly of interest to developer who implement tools that use CDL. Less technical readers may skip this section.

:numref:`sec_con_lib` describes how the CDL language has been used to implement libraries of ready-to-use control sequence
that can be used within the process described in :numref:`sec_process`.

:numref:`sec_code_gen` describes various paths of how CDL can be translated for use in building control systems,
respecting the need for reusing existing control product lines, but also showing how established and emerging standards could be used
to streamline this process if a control provider develops a new control product line.

:numref:`sec_verification` describes how to formally verify that a control sequence that is implemented on a real
control hardware conforms to the CDL specification. It presents an actual example that illustrates the verification,
and closes with specifications for how to automate such a verification.

:numref:`sec_example` presents an example in which we compared the annual energy peformance of two different control sequences
applied to the same building and HVAC system. In this example, simply changing the control sequence led to about
30% annual savings in HVAC site electricity use.

:numref:`sec_benefit_rate_payers` describes the benefits to the California rate payers.

:numref:`sec_glossary` explains technical terms used throughout the report.
