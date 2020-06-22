Executive Summary
-----------------

.. |CDL| replace:: the Control Description Language

Introduction
^^^^^^^^^^^^

In the United States, commercial buildings account for just under 20%
of all energy use. Energy consumption is driven by systems that
include HVAC and lighting. Proper control of these systems, based on
factors such as building occupancy and weather conditions, can reduce
building energy use by 10 to 30%. However, few commercial buildings
have optimized control systems. Many existing buildings predate
current energy codes, standards and guidelines which require
optimized sequences. New construction
projects that are designed to implement such strategies frequently
struggle due to the inherently complicated process of traditional
design development, documentation, interpretation, implementation and
owner operation. This results in buildings that are inefficient and
often uncomfortable, which results in wasted energy and lost occupant
productivity.

OpenBuildingControl is a project whose aim is to improve the process
and tools necessary for the design, cost-effective implementation, and
validation of the control sequences used in commercial
buildings. The first phase of the project, reported here, has been
co-funded by the California Energy Commission and
the United States Department of Energy (DOE).
A second phase of the project is being funded by the DOE.

The Phase 1 work reported here has focused on providing the
capability to avoid major problems with the current process for the
design and implementation of controls in commercial buildings. Current
practice involves the HVAC designer writing a sequence, which depending
on the skill level of the HVAC designer can be ambiguous and error-prone.
The sequence is a verbose description of the control system operation,
which a project technician has to interpret to write the necessary code
for deployment of the sequence in a proprietary control system. This is
followed by a manual process to validate and confirm the operation.

The OpenBuildingControl project built the foundation to enable
the digitization of the
current paper-based delivery process. The project has
built tools for
system designers to select, model the performance of, and then specify
sequences for implementation, using a digitized workflow with
end-to-end verification, including formal testing of the installed
control sequences. The designer will be able to express the desired
sequence in an electronic format that can be readily implemented or translated to
programming code without the need for manual interpretation. The
project will also provide tools to automatically document the
sequences of operation implemented in a building and compare them to
the original design intent. Used together, this set of tools will have
the potential to substantially reduce energy use in both new
commercial buildings and in existing buildings with controls retrofits.
However, to be effective, these tools need to be widely adopted and
used by industry, including system engineers, designers, controls
manufacturers, controls subcontractors, owners, and to be required or
incentivized by other interested parties, including state energy
agencies and utilities.

The OpenBuildingControl project complements work by the
Standing
Guideline Project Committee 36 of
the American Society of Heating, Refrigerating and Air-Conditioning Engineers (ASHRAE),
which collects, develops and
publishes control sequences considered to be industry best-in-class
for improving system stability, energy performance, indoor air quality
and comfort. Current versions of energy standards and codes, such as
ASHRAE 90.1 and the California Energy Code, Title 24, require specific
algorithms documented in Guideline 36, and are anticipated to adopt or reference Guideline 36
sequences as awareness of the Guideline grows.


Project Purpose
^^^^^^^^^^^^^^^

The purpose of the OpenBuildingControl project is to substantially
reduce commercial building energy use by optimizing the design,
implementation, and validation of building controls. The project team
has documented existing buildings controls practices and developed
processes and tools to remove impediments to effective design and
correct implementation.

A key paradigm shift is the development of a process and supporting
software that paves the way for digitization of the controls delivery
process. The current process starts with the need for a design
engineer to write a “controls sequence” using a verbose format to
describe each part of the operation of a system. There are several
challenges with this process. The first is that many design engineers
are not well trained in controls and have difficulty writing sequences
that are appropriate and will result in efficient operation. The
second challenge is that a controls technician has to interpret what
was written and then express it in a proprietary controls programming
language. The project team has developed a formal end-to-end process
that starts with a library of optimized sequences expressed both in
English and in a  unambiguous digital format. The system designer can
select the sequences that will work best with the project's mechanical
system, using tools developed in this project. The digital sequence
specification allows the performance of building control sequences,
including annual energy, load flexibility, peak demand and comfort, to be assessed using
whole building simulation. The control sequences can then be used directly or be
translated for use in commercial building control product lines using
machine-to-machine translation. Finally, new tools will assist in
verifying proper implementation of the sequences.  Such a process will
allow error-free deployment of control sequences, thereby addressing
the situation that the current paper-based process fails to implement
high-performance control sequences at scale.

The main audience for the technology developed in this project
consists of:

* Building owners and operators, who are responsible for operating
  commercial buildings so that they are safe, productive, and efficient.

* Researchers and control companies who develop new HVAC systems and control sequences
  for building energy systems.

* Professional organizations such as ASHRAE who are developing
  guidelines for high performance building control sequences.

* Analysts who assess the performance of control sequences when
  updating energy codes such as California's Building Energy Efficiency Standard
  Title 24 or ANSI/ASHRAE/IES Standard 90.1,
  Energy Standard for Buildings Except Low-Rise Residential Buildings.

* Mechanical designers who specify control sequences for a particular building.

* Control companies and system integrators who implement control sequences
  in new construction or retrofit projects.

* Commissioning agents who verify whether the as-installed control
  sequences comply with the specification from the mechanical designer.


Project Approach
^^^^^^^^^^^^^^^^

The US Department of Energy’s Lawrence Berkeley National Laboratory
is leading this project, with regular reviews from the
US Department of Energy and the California
Energy Commission program management. The process started with the
establishment of a project team consisting of Lawrence Berkeley
National Laboratory staff and industry experts in the design and
implementation of control systems, along with an advisory panel that
includes design engineers, general contractors, mechanical
subcontractors, controls subcontractors, controls manufacturers,
commissioning agents, and building owners and operators.

The advisory panel provided industry input and feedback while the core
team was responsible for defining the new process and coding, testing,
validating, and documenting the associated tools.
Several presentations at ASHRAE also led to feedback that affected
the direction of the research and development, as did presentation
to the advisory panel, to selected companies and to the scientific community
at various conferences.

A key technical challenge encountered by the project was
that, due to a lack of standards, existing control product lines are
heterogeneous. They differ in their functionality for expressing
control sequences, in their semantics of how control output gets
updated, and in their programming syntax, which ranges from graphical languages to
textual languages. Code generation for a variety of products is common
in the Electronic Design Automation industry, which develops software
tools for designing electronic systems such as integrated circuits and
printed circuit boards. However, in the Electronic Design Automation
industry, engineers write models of the physical device and the
controls, using graphical and textual languages,
and actual controllers are then built to conform
to the models. If this process were to be applied to the buildings
industry, then control providers would need to update their product
lines. The project team
believes that once CDL becomes a standard, that suppliers consider
adding it to new or existing products.
That process may take 5 to 10 years to complete.
Therefore, for the immediate future, the OpenBuildingControl process
will need to involve the building of models of control sequences that
can conform to their implementation on existing control product lines,
while ensuring that, as new product lines are being developed, they
can invert the paradigm and build controllers that conform to the
models. The project team has, therefore, selected the path of
designing |CDL| in such a way that it provides a minimum set of
capabilities that can be expected to be supported by current control products.
As we have demonstrated with one commercial product, the
barrier to supporting this language is low, and we therefore expect
that suppliers may elect to develop and support translators.
We are also working with
industry to establish |CDL| as an ASHRAE/ANSI Standard
and, eventually, an ISO Standard. Getting industry support to make
|CDL| a standard would allow for products to be developed that use
|CDL| without the need for translation.


Project Results
^^^^^^^^^^^^^^^

The project achievements to date have been very positively received by
industry and by members of the ASHRAE Standing
Guideline Project Committee 36 which develops high
performance control sequences. The following items resulted from this
project phase:

* Definition of use cases and processes related to controls design and
  implementation.

* Definition and documentation of the semantics and syntax of |CDL| and
  of its JSON export format.

* A library of control sequences for building energy systems expressed
  in |CDL|.

* Modeling tools that can simulate sequences expressed in |CDL| coupled
  to heating, ventilation, and air-conditioning models from the Modelica
  Buildings library and linked to Spawn of EnergyPlus envelope models.

* Tools that verify that the control response from a Control
  Description Language–specified sequence and trended control outputs
  are within user-specified tolerances.

* Tools to translate |CDL| into open formats such as JSON and HTML, as
  well as to Microsoft Word.

* Demonstration of sequences expressed in |CDL| being translated to a
  proprietary language and uploaded into a working control system.

* Case studies that demonstrate the use of the tools and the
  energy savings obtained through the use of high performance control sequence.

* A commercialization and market transformation plan.

* The specification to develop a system design tool that will allow an
  engineer to specify the type of system to control and to select
  control options. The tool will then select and generate the proper
  control sequence using |CDL|. This tool will include a library of
  capabilities from sources such as ASHRAE Guideline 36 and the
  engineers’ current library and will make use of the Spawn of
  EnergyPlus simulation tool to compute the performance of the selected
  option using whole building energy simulation.

* The formation of an ASHRAE Standard Project Committee for making |CDL| an
  ASHRAE/ANSI Standard and, ultimately, an ISO Standard.

There is also a set of items that were not completed by the end of
Phase 1 of this project; partial follow-on funding to further develop
these items has been secured. These items include:

* The implementation of the systems design tool.

* An expanded library of control sequences, expressed in |CDL|, that can
  be used as input for the above system design tool.

* Tools and documentation that can be used by control systems
  suppliers to develop translators from the JSON representation of |CDL|
  to their proprietary control system.

* Provisions to add tagging to |CDL| so that it can be used with Brick,
  Project Haystack and other similar semantic tagging and data modeling
  standardization efforts.

* Programs for implementing market transformation.

* Tools for evaluating a current control system and developing
  documentation for installed sequences.


Technology/Knowledge Transfer/Market Adoption
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To build market adoption, the project team worked with key committees
of ASHRAE to align the developed technology with the needs of the industry.
Furthermore, all technology has been
developed in such a way that it directly integrates with the roadmap
of the US Department of Energy's Building Technologies Office
for energy simulation and for sensors and controls.

To align the developed technologies with industry needs, the project
team developed a detailed commercialization and market transformation
plan. This plan outlines the current state of the process
of control specification, delivery, commissioning and building operation.
It discusses the tools and workflow developed by the project team.
It lists benefits for mechanical designers, control providers,
building operators and building owners.
Lastly, it describes a path to establish
a digitized control delivery process.

Foundational work for this deployment started during this project:
A key part of the technology transfer
is the work that has started on making |CDL| an ASHRAE/ANSI standard,
thereby ensuring the industry that there is a robust foundation on
which industry can make further investments.
The tools developed in this project have become a key part of the
tool development sponsored by the US Department of Energy.
Specifically, Spawn of EnergyPlus is, in part,
being developed to support the design, deployment and operation of advanced
energy and controls for buildings,
for district heating and cooling systems and
for geothermal systems through its
Building Technologies Office, Advanced Manufacturing Office and
Geothermal Office, respectively.

To support the update of
energy codes, such as California's Building Energy
Efficiency Standard Title 24 and ANSI/ASHRAE/IES Standard 90.1,
we anticipate that analysts will use |CDL| together with Spawn of
EnergyPlus. This will allow analyzing the energy impacts of measures
related to building control across a portfolio of buildings in different
climate zones.
Moreover, prescriptive codes may state which control sequences need to
be used and they could then provide the specification of these control sequences in
|CDL| for use in project specifications and for implementation on the
building’s control system.


Benefits to California
^^^^^^^^^^^^^^^^^^^^^^

This project will benefit both the State of California and the rest of
the US — and, ideally, the world. The key benefits are as follows:

* *Reduced cost to design and implement advanced controls*. This
  project will make the use of these advanced controls sequences more cost
  effective for new construction and, even more importantly, for
  retrofit, where costs and complexity are often impediments to
  implementation.

* *Improved energy efficiency*. The project team has documented the
  potential to reduce heating, ventilation, and air-conditioning system
  energy use by 30% through the use of advanced controls sequences for airside
  HVAC systems. The team is confident that this approach can be extended
  to other building systems, including primary systems, lighting
  systems, and active façade systems. The ability to reduce building
  energy use is a significant benefit for the state and is essential to
  achieving California’s 2030 goal of having all new commercial
  buildings, and 50% of commercial buildings being retrofitted, to be net
  zero energy.

The adoption of OpenBuildingControl will result in improved design and
implementation of commercial building controls
without requiring major retraining or process changes to how controls are designed or delivered.
The energy savings from widespread adoption of the processes and tools can be estimated as follows.
A major barrier to achieving the state’s statutory energy goals is
the failure of most commercial buildings to perform close to the technical potential
of the design and its associated equipment. An LBNL meta-study identified 16% median actual savings
from retro-commissioning and a study of 481 operational issues identified in existing commercial buildings
found that control problems accounted for more than 75% of the potential energy savings.
Therefore, we assume that around 75% of the 16% energy savings, equal to a total of 12% of energy savings,
associated with commissioning are related to controls.
Assuming that the technologies to be developed in the project can save 12% in the 50% of
commercial building floor area higher than 50,000 sf, we will assume our technology can reduce energy consumption
on average across all commercial buildings by 6%.

The California savings are estimated as follows:
The annual energy consumption of California commercial buildings is about 67.1 TWh of electricity,
equivalent to 0.64 quads (188 TWh) of source energy,
and 1278.6 Mtherms (0.13 quads, 37.4 TWh) of natural gas.
The estimated 6% savings correspond to 4.03 TWh of electricity,
equivalent to 0.038 quads (11.28 TWh) of source energy, and 0.00764 quads (2.24 TWh) of natural gas.
Assuming a price of 0.17 $/kWh for electricity and 8 $/(1000 ft3) for natural gas (corresponding to 0.027 $/kWh),
the cost savings would be $0.69B in electricity and $0.064B in natural gas.

The US national savings are estimated as follows:
The annual energy consumption of US commercial buildings is about 1240 TWh of electricity,
equivalent to 11.9 quads (3472 TWh) of source energy, and about 22,500 MTherms (2.25 quads, 659 TWh) of natural gas.
The estimated 6% savings correspond to 74.4 TWh of electricity, equivalent to 0.71 quads (208 TWh) of source energy, and
0.135 quads (39.5 TWh) of natural gas.
Assuming a price of 0.11 $/kWh for electricity and 8 $/(1000 ft3) for natural gas, the electricity cost savings would be $8.2B and
the natural gas savings $1.07B.

These electricity savings correspond to
25 Rosenfelds in the US and
1.5 Rosenfelds in California.

If we assume 75% adoption of OpenBuildingControl over the next ten years, a controls retrofit rate of 10% per year and
a new building construction rate of 1.5% per year,
then, after 10 years, the fraction of the building stock, weighted by floor area,
that is impacted by OpenBuildingControl is 21%.
Assuming the potential benefit of $0.69B savings in electricity,
the estimated benefits are $146M/yr savings for California ratepayers.