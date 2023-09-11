.. _sec_use_cases:

Use Cases
---------

This section describes use cases for end-user interaction, including the following:

* use the controls design tool to design a control sequence and export
  it as a CDL-compliant specification,
* use the CDL to bid on a project and, when selected for the project,
  implement the control sequence in a building automation system,
* use the control design tool to create control block diagrams in addition to control sequences
  and automatically produce a points list with a standard naming convention and/or tagging
  convention, a plain language sequence of operation,
  and verification that the control diagram includes
  all instrumentation required to complete the control sequence,
* use the commissioning and functional verification tool during commissioning


Controls Design
^^^^^^^^^^^^^^^

Loading a Standard Sequence from a Library
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use case describes how to load, edit and store a control
sequence from a library. For illustration, we use here
a sequence from the `Guideline 36 library <https://simulationresearch.lbl.gov/modelica/releases/v10.0.0/help/Buildings_Controls_OBC_ASHRAE_G36.html>`_.

.. table::
   :class: longtable

   ===========================  ===================================================
   **Use case name**            **Loading a standard sequence from Guideline 36**
   ===========================  ===================================================
   Related Requirements         User able to change the pre-set elements within
                                the standard sequence, with automatic download of
                                associated CDL block diagram.
   ---------------------------  ---------------------------------------------------
   Goal in Context              Enable fast adaptation of Guideline 36
   ---------------------------  ---------------------------------------------------
   Preconditions                All Guideline 36 sequences need to be pre-programmed
                                into visual block diagrams using CDL.
                                CDL and block diagrams need to be modular so that
                                they can be easily updated when key elements are changed/deleted/added.
   ---------------------------  ---------------------------------------------------
   Successful End Condition     User is able to download the CDL/block diagrams
                                using a specific reference to Guideline 36 sequences.
                                User is able to change/delete/add key elements using CDL.
   ---------------------------  ---------------------------------------------------
   Failed End Condition         Missing Guideline 36 sequence in library.

                                When a user changes/deletes/adds elements to CDL/visual block diagram,
                                no associated CDL/visual block diagram appears/disappears.
   ---------------------------  ---------------------------------------------------
   Primary Actors               Mechanical Designer/Consultant
   ---------------------------  ---------------------------------------------------
   Secondary Actors             Controls contractor
   ---------------------------  ---------------------------------------------------
   Trigger                      Designing control system using Guideline 36 as
                                default sequence or a starting point,
                                then needs to change key elements because the system
                                is different to Guideline 36 presumed system configuration.
   ---------------------------  ---------------------------------------------------
   **Main Flow**                **Action**
   ---------------------------  ---------------------------------------------------
   1                            User opens Guideline 36 library and sees a contents
                                menu of the standard sequences for selection.
   ---------------------------  ---------------------------------------------------
   2                            User selects a sequence
   ---------------------------  ---------------------------------------------------
   3                            The corresponding CDL and visual block diagram appears
                                in the controls design tool. Key mechanical elements
                                (e.g. fan, cooling coil valve, control damper)
                                controlled by the standard sequence are also displayed.
   ---------------------------  ---------------------------------------------------
   **Extensions**
   ---------------------------  ---------------------------------------------------
   1                            User saves copy of the imported sequence prior to editing
   ---------------------------  ---------------------------------------------------
   2                            User deletes/adds elementary blocks or composite blocks.
   ---------------------------  ---------------------------------------------------
   2                            User saves the modified sequence.
   ===========================  ===================================================


Customizing a Control Sequence for an HVAC System
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use case describes how to connect a control sequence to a system model and then customize the control sequence, using a VAV system as an example.

.. table::
   :class: longtable

   ===========================  ===================================================
   **Use case name**            **Customizing a control sequence for a VAV system**
   ===========================  ===================================================
   Related Requirements         n/a
   ---------------------------  ---------------------------------------------------
   Goal in Context              A mechanical engineer wants to customize a control
                                sequence, starting with a template.
   ---------------------------  ---------------------------------------------------
   Preconditions                System model of the HVAC and building, with sensor
                                output signals and actuator input signals exposed.

                                Preconfigured control sequence, stored in the
                                OpenBuildingControls library.

                                A set of performance requirements.
   ---------------------------  ---------------------------------------------------
   Successful End Condition     Implemented VAV sequence with customized control,
                                ready for performance assessment
                                (Use case :ref:`use_case_per_ass`) and
                                ready for export in CDL for subsequent implementation.
   ---------------------------  ---------------------------------------------------
   Failed End Condition         n/a
   ---------------------------  ---------------------------------------------------
   Primary Actors               A mechanical engineer.
   ---------------------------  ---------------------------------------------------
   Secondary Actors             The controls design tool with template control
                                sequences and a package with elementary CDL blocks.

                                The HVAC plant and control sequence library.
   ---------------------------  ---------------------------------------------------
   Trigger                      n/a
   ---------------------------  ---------------------------------------------------
   **Main Flow**                **Action**
   ---------------------------  ---------------------------------------------------
   1                            The user opens the controls design tool in OpenStudio
   ---------------------------  ---------------------------------------------------
   2                            The user drags and drops a
                                preconfigured VAV control sequence from the Buildings library.
   ---------------------------  ---------------------------------------------------
   3                            The user clicks on the pre-configured VAV control
                                sequence and selects in the tool a function that
                                will store the sequence in the project library
                                to allow further editing.
   ---------------------------  ---------------------------------------------------
   4                            The controls design tool saves the
                                sequence in the project library.
   ---------------------------  ---------------------------------------------------
   5                            The user connects sensors and actuators of the
                                :term:`plant` model to
                                control inputs and outputs of the :term:`controller`
                                model.

   ---------------------------  ---------------------------------------------------
   6                            The user opens the system model that is composed
                                of controls, HVAC system model and building envelope
                                in the controls design tool.
   ---------------------------  ---------------------------------------------------
   7                            The user opens in the project library
                                the composite sequence saved in step 4.
   ---------------------------  ---------------------------------------------------
   8                            The user adds and connects additional control blocks
                                from the elementary CDL-block library.
   ---------------------------  ---------------------------------------------------
   9                            The user selects "Check model" to verify that
                                the implemented sequence complies with the CDL
                                specification.
   ===========================  ===================================================


:numref:`fig_use_case_custom_vav` shows the sequence diagram for this use case.

.. _fig_use_case_custom_vav:

.. uml::
   :caption: Customizing a control sequence for a VAV system.

   title Customizing a control sequence for a VAV system

   "User" -> "OpenStudio" : Open control design tool.
   "OpenStudio" -> "Control Design Tool" : open()
   "User" -> "Control Design Tool" : Open HVAC and building model.
   "OpenStudio" <- "Control Design Tool" : Request HVAC and building model.
   "User" -> "Control Design Tool" : Drag & drop pre-configured control sequence.
   "User" -> "Control Design Tool" : Select to store the control sequence in the project library.
   "Control Design Tool" -> "Control Design Tool" : Write the sequence to new file in the project library.
   "User" -> "Control Design Tool" : Connect sensors and actuators to control inputs and outputs.
   "User" -> "Control Design Tool" : Open new composite control block in the project library.
   "User" -> "Control Design Tool" : Drag, drop and connect blocks from CDL library.
   "User" -> "Control Design Tool" : Check model.
   "OpenStudio" <- "Control Design Tool" : Invoke model check.
   "User" <- "Control Design Tool" : Report info, warning and error.


Customizing and Configuring a Control Sequence for a Single-Zone VAV System
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use case describes how to customize and configure a control sequence
for a single zone VAV system.

.. table::
   :class: longtable

   ===========================  ===================================================
   **Use case name**            **Customizing a control sequence for a single-zone VAV system**
   ===========================  ===================================================
   Related Requirements         n/a
   ---------------------------  ---------------------------------------------------
   Goal in Context              A mechanical engineer wants to customize a control
                                sequence, starting with a template.
   ---------------------------  ---------------------------------------------------
   Preconditions                A model of the :term:`plant` (consisting of HVAC and
                                building model).

                                Preconfigured control sequence, stored in an OpenBuildingControls-compatible library.

                                A set of performance requirements.
   ---------------------------  ---------------------------------------------------
   Successful End Condition     Implemented single zone VAV sequence with customized control,
                                ready for performance assessment
                                (Use case :ref:`use_case_per_ass`) and
                                ready for export in CDL.
   ---------------------------  ---------------------------------------------------
   Failed End Condition         n/a
   ---------------------------  ---------------------------------------------------
   Primary Actors               A mechanical engineer.
   ---------------------------  ---------------------------------------------------
   Secondary Actors             The controls design tool with template control
                                sequences and a package with elementary CDL blocks.

                                The HVAC and controls library.
   ---------------------------  ---------------------------------------------------
   Trigger                      n/a
   ---------------------------  ---------------------------------------------------
   **Main Flow**                **Action**
   ---------------------------  ---------------------------------------------------
   1                            The user opens the controls design tool in OpenStudio.
   ---------------------------  ---------------------------------------------------
   2                            The user opens the HVAC model and building model
                                in the controls design tool.
   ---------------------------  ---------------------------------------------------
   3                            The user drags and drops a single-zone VAV control sequence
                                from the Buildings library
                                into the tool.
   ---------------------------  ---------------------------------------------------
   4                            The user clicks on the pre-defined single-zone
                                VAV control sequence and selects a function
                                that will store a copy of the sequence
                                in the project library to allow further editing.
   ---------------------------  ---------------------------------------------------
   5                            The controls design tool stores a copy of the sequence in the project library.
   ---------------------------  ---------------------------------------------------
   6                            The user loads a copy of the sequence into the sequence editor.
   ---------------------------  ---------------------------------------------------
   7                            The user specifies the mapping of the control points
                                to HVAC system sensors and actuators, e.g. AHU
   ---------------------------  ---------------------------------------------------
   8                            The user initiates the saving of the composite
                                HVAC+building+control model, for use as a reference model
                                against which to compare alternative control sequences
   ---------------------------  ---------------------------------------------------
   9                            If necessary, the user executes the reference model and
                                inspects the resulting performance to identify
                                potential modifications
   ---------------------------  ---------------------------------------------------
   10                           The user makes a copy of the sequence prior to replication
                                and loads it into the sequence
                                editor.
   ---------------------------  ---------------------------------------------------
   11                           The user edits the sequence by deleting and/or moving elementary
                                and composite blocks and/or adding control
                                blocks from the elementary CDL-block library
   ---------------------------  ---------------------------------------------------
   12                           The user selects "Check model" to verify whether
                                the implemented sequence complies with the CDL
                                specification, editing and re-checking as necessary.
   ---------------------------  ---------------------------------------------------
   13                           The user connects the modified sequence to the HVAC
                                system and building models, using Step 7, and saves
                                the resulting composite model
   ---------------------------  ---------------------------------------------------
   15                           The user assesses the relative performance of the
                                modified and unmodified sequences using the procedure
                                defined in the 'Performance assessment of a control
                                sequence' use case below.
   ===========================  ===================================================



Customizing and Configuring a Control Sequence for a Multizone VAV System
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use case describes how to customize and configure a control sequence
for a multizone VAV system.

.. table::
   :class: longtable

   ===========================  ===================================================
   **Use case name**            **Customizing a control sequence for a multi-zone VAV system**
   ===========================  ===================================================
   Related Requirements         n/a
   ---------------------------  ---------------------------------------------------
   Goal in Context              A mechanical engineer wants to customize a control
                                sequence, starting with a template.
   ---------------------------  ---------------------------------------------------
   Preconditions                HVAC system model connected to building model.
                                The repeated elements in the HVAC system model (i.e. the terminal boxes) must be tagged and numbered.

                                Preconfigured control sequence, stored in an OpenBuildingControls-compatible library.
                                The terminal boxes control blocks must be tagged to indicate that they can be replicated by a predefined
                                function in the editor.

                                A set of performance requirements.
   ---------------------------  ---------------------------------------------------
   Successful End Condition     Implemented multi-zone VAV sequence with customized control,
                                ready for performance assessment
                                (Use case :ref:`use_case_per_ass`) and
                                ready for export in CDL.
   ---------------------------  ---------------------------------------------------
   Failed End Condition         n/a
   ---------------------------  ---------------------------------------------------
   Primary Actors               A mechanical engineer.
   ---------------------------  ---------------------------------------------------
   Secondary Actors             The controls design tool with template control
                                sequences and a package with elementary CDL blocks.

                                The HVAC and controls library.
   ---------------------------  ---------------------------------------------------
   Trigger                      n/a
   ---------------------------  ---------------------------------------------------
   **Main Flow**                **Action**
   ---------------------------  ---------------------------------------------------
   1                            The user opens the controls design tool in OpenStudio
   ---------------------------  ---------------------------------------------------
   2                            The user opens the HVAC model and building model
                                in the controls design tool.
   ---------------------------  ---------------------------------------------------
   3                            The user drags and drops a multi-zone VAV control sequence from the Buildings library
                                into the tool
   ---------------------------  ---------------------------------------------------
   5                            The user clicks on the pre-defined VAV control
                                sequence and selects a function that will store a copy of the sequence in the project library
                                to allow further editing.
   ---------------------------  ---------------------------------------------------
   6                            The controls design tool stores a copy of the sequence in the project library.
   ---------------------------  ---------------------------------------------------
   7                            The user loads a copy of the sequence into the sequence editor.
   ---------------------------  ---------------------------------------------------
   8                            The user specifies the number of zones (NZi) with each type of terminal box and selects a function that
                                will replicate and instantiate sets of NZi terminal box control blocks for each type of terminal box
   ---------------------------  ---------------------------------------------------
   9                            The tool replicates and instantiates NZi terminal box control blocks of each type
   ---------------------------  ---------------------------------------------------
   10                           The user initiates a tool function that maps zones with specific types of terminal box to the corresponding
                                terminal box control blocks and then applies a user-defined mapping of zone-level control points to
                                terminal box sensors and actuators and zone temperature and occupancy sensors
   ---------------------------  ---------------------------------------------------
   11                           The tool executes the actions described in Step 10
   ---------------------------  ---------------------------------------------------
   12                           The user specifies the mapping of the remaining control points to HVAC system sensors and actuators, e.g.
                                AHU
   ---------------------------  ---------------------------------------------------
   13                           The user initiates the saving of the composite HVAC+building+control model, for use as a reference model
                                against which to compare alternative control sequences
   ---------------------------  ---------------------------------------------------
   14                           If necessary, the user executes the reference model and inspects the resulting performance to identify
                                potential modifications
   ---------------------------  ---------------------------------------------------
   15                           The user makes a copy of the reference/library sequence prior to replication and loads it into the sequence
                                editor.
   ---------------------------  ---------------------------------------------------
   16                           The user edits the sequence by deleting and/or moving elementary
                                and composite blocks and/or adding control
                                blocks from the elementary CDL-block library

   ---------------------------  ---------------------------------------------------
   17                           The user selects "Check model" to verify whether
                                the implemented sequence complies with the CDL
                                specification, editing and re-checking as necessary.
   ---------------------------  ---------------------------------------------------
   18                           The user connects the modified sequence to the HVAC system and building models, using Steps 8-12, and saves
                                the resulting composite model
   ---------------------------  ---------------------------------------------------
   19                           The user assesses the relative performance of the modified and unmodified sequences using the procedure
                                defined in the 'Performance assessment of a control sequence' use case below.
   ===========================  ===================================================


.. _use_case_per_ass:

Performance Assessment of a Control Sequence
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use case describes how to assess the performance of a control sequence
using the controls design tool.

Separate sequences are given below for the cases where local loop control is to be included in, or excluded from, the evaluation.

.. table::
   :class: longtable

   ===========================  ===================================================
   **Use case name**            **Performance assessment of a control sequence**
   ===========================  ===================================================
   Related Requirements         n/a
   ---------------------------  ---------------------------------------------------
   Goal in Context              Evaluate the performance of a specific control
                                sequence in the context of a particular design
                                project.
   ---------------------------  ---------------------------------------------------
   Preconditions                Either
                                a) whole building or system model for the particular
                                design project, or
                                b) sufficient information about the current state of
                                the design, to enable the configuration of a model
                                template based on a generic design for the
                                appropriate building type. The model must be complete
                                down to the required sensors and actuation points,
                                which may be actual actuators, if the sequence
                                includes local loop control, or set-points for local
                                loop control, if the sequence only performs supervisory
                                control.

                                Control sequence to be assessed must match, or be
                                capable of being configured to match, the building/system
                                model in terms of sensing and actuation points and modes
                                of operation.

                                Relevant statutory requirements and design performance
                                targets. Performance metrics derived from these
                                requirements and targets.

   ---------------------------  ---------------------------------------------------
   Successful End Condition     User is able to
                                (i) compare the performance of different control
                                sequences in terms of selected pre-defined criteria, and
                                (ii) evaluate the ability of a selected control sequence
                                to enable the building/system to meet or exceed
                                externally-defined performance criteria.
   ---------------------------  ---------------------------------------------------
   Failed End Condition         Building/system model or configuration information for
                                generic model template is incomplete.

                                Performance requirements or targets are incomplete or
                                inconsistent wrt the specific control sequence

                                Simulation fails to run to completion or fails convergence
                                tests.

   ---------------------------  ---------------------------------------------------
   Primary Actors               A mechanical engineer.
   ---------------------------  ---------------------------------------------------
   Secondary Actors
   ---------------------------  ---------------------------------------------------
   Trigger                      Need to select or improve a control sequence for a
                                building or system.
   ---------------------------  ---------------------------------------------------
   **Main Flow**                **Action**
   ---------------------------  ---------------------------------------------------
   1                            User loads the building/system model for the project
                                or uses design information to configure a model template.
   ---------------------------  ---------------------------------------------------
   2                            User selects and loads weather data and operation
                                schedules.
   ---------------------------  ---------------------------------------------------
   3                            User configures control sequence with project-specific
                                information, e.g. number of terminal units on an air
                                loop, and connects to building/system model.
   ---------------------------  ---------------------------------------------------
   3a                           If the sequence contains feedback loops that are to be included in the evaluation,
                                these loops must be tuned, either automatically or manually.
   ---------------------------  ---------------------------------------------------
   4                            User selects short periods for initial testing and
                                performs predefined tests to verify basic functionality,
                                similar to commissioning.
   ---------------------------  ---------------------------------------------------
   5                            User initiates simulation of building/system
                                controlled performance over full reference year or
                                statistically-selected short reference year that
                                reports output variables required to evaluate
                                performance according to pre-defined metrics.
   ---------------------------  ---------------------------------------------------
   6                            User compares metric values to requirements and/or targets
                                and determines whether the sequence is acceptable as is, needs
                                modification or appears fundamentally flawed.
   ===========================  ===================================================


Defining Integration with non-HVAC Systems such as Lighting, Façade and Presence Detection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use case describe the connection of a facade control with the HVAC
control in the control design tool.

.. table::
   :class: longtable

   ===========================  ===================================================
   **Use case name**            **Defining integration with non-HVAC systems such as
                                lighting, façade and presence detection**
   ===========================  ===================================================
   Related Requirements         The model represents the non-HVAC systems and the associated
                                control blocks are represented using CDL.
   ---------------------------  ---------------------------------------------------
   Goal in Context              Integration actions between HVAC and non-HVAC systems
                                can be defined using CDL.

                                Optional goal - Tool to also configures and verifies
                                HVAC to non-HVAC integration.
   ---------------------------  ---------------------------------------------------
   Preconditions                Examples of HVAC and non-HVAC integrations available
                                for adaptation using CDL, non-HVAC systems can be
                                façade louvre control, lighting on/off or
                                presence detection status.
   ---------------------------  ---------------------------------------------------
   Successful End Condition     User able to use CDL to define common HVAC
                                and non-HVAC integrations
   ---------------------------  ---------------------------------------------------
   Failed End Condition         Failure to include HVAC and façade/lighting/presence
                                detection interactions in CDL.
   ---------------------------  ---------------------------------------------------
   Primary Actors               Mechanical Designer/Consultant
   ---------------------------  ---------------------------------------------------
   Secondary Actors
   ---------------------------  ---------------------------------------------------
   Trigger
   ---------------------------  ---------------------------------------------------
   **Main Flow**                **Action**
   ---------------------------  ---------------------------------------------------
   1                            User opens a menu of the non-HVAC systems for selection.
   ---------------------------  ---------------------------------------------------
   2                            User selects the non-HVAC object and the
                                visual block diagram and associated CDL elements appear.
   ---------------------------  ---------------------------------------------------
   3                            User clicks on a non-HVAC object and
                                a menu of status and actions pops up.
   ---------------------------  ---------------------------------------------------
   4                            User selects the integration status or actions
                                of the non-HVAC system, and links it to HVAC
                                system status or action block
   ===========================  ===================================================


Bidding and BAS Implementation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Generate Control Point Schedule from Sequences
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use case describes how to generate control points
from a sequence specification.


.. table::
   :class: longtable

   ===========================  ===================================================
   **Use case name**            **Generate control points schedule from sequences**
   ===========================  ===================================================
   Goal in Context              The same control specification can be used to
                                generate controls points schedule
   ---------------------------  ---------------------------------------------------
   Preconditions                Each control points needs to be defined using
                                AI/AO/DI/DO/Network interface types
                                and consistent tagging/naming
   ---------------------------  ---------------------------------------------------
   Successful End Condition     Control points schedule can be automatically
                                produced
                                by extracting from the sequences,
                                including tagging (AHU/TDX/1),
                                point name, point type and comments
                                (such as differential pressure to be installed
                                at 2/3 down index leg)
   ---------------------------  ---------------------------------------------------
   Failed End Condition         Control points schedule is inaccurate or
                                doesn’t contain sufficient information.
   ---------------------------  ---------------------------------------------------
   Primary Actors               Mechanical Designer/Consultant
   ---------------------------  ---------------------------------------------------
   Secondary Actors             Controls contractor
   ---------------------------  ---------------------------------------------------
   Trigger
   ---------------------------  ---------------------------------------------------
   **Main Flow**                **Action**
   ---------------------------  ---------------------------------------------------
   1                            When a user adds a control point in the controls
                                design tool,
                                the tool provides default values and allows
                                the user to
                                change the values for tagging/point
                                name/point type/comments
   ---------------------------  ---------------------------------------------------
   2                            User clicks on a button to generate Points Schedule,
                                an Excel file is then generated listing all the
                                points and their details,
                                and also counts the total number of different
                                type of points.
   ---------------------------  ---------------------------------------------------
   3                            User clicks on a button to generate a tag list
                                of unique control devices within the project
                                in Excel,
                                so that the associated specification
                                section can be extracted and populated
                                within third party software.
   ===========================  ===================================================


Commissioning, Operation, and Maintenance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Conducting Verification Test of a VAV Cooling-Only Terminal Unit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use case describes the verification of an installed control sequence
relative to the design intent.

.. table::
   :class: longtable

   ===========================  ===================================================
   **Use case name**            **Conducting verification test of a VAV Cooling-Only Terminal Unit**
   ===========================  ===================================================
   Related Requirements
   ---------------------------  ---------------------------------------------------
   Goal in Context              A commissioning agent wants to verify on site that
                                the controller operates in accordance with the
                                sequence of operation
   ---------------------------  ---------------------------------------------------
   Preconditions                CDL-conformant control sequence and verification tests
                                are imported into verification tool.

                                Field instrumentation is per spec.

                                Installation of field equipment is correct.

                                Point-to-point testing from point in field through
                                to graphic is correct.
   ---------------------------  ---------------------------------------------------
   Successful End Condition     Control devices carry out the right sequence of actions,
                                and the verification tool verifies compliance
                                with the design intent.

                                Control devices carry out wrong sequence of actions,
                                and the verification tool shows non-compliance
                                with the design intent.
   ---------------------------  ---------------------------------------------------
   Failed End Condition         The verification tool fails to recognize verification success/failure.
   ---------------------------  ---------------------------------------------------
   Primary Actors               Commissioning agent
   ---------------------------  ---------------------------------------------------
   Secondary Actors             BMS engineer (optional)

                                Vendor software which replicates uploaded CDL code
   ---------------------------  ---------------------------------------------------
   Trigger                      The verification tool is connected to the BMS and receives the
                                following signals from the VAV box controller:

                                - occupied mode, unoccupied mode
                                - Vmin, Vcool-max etc.
                                - setpoints and timers

                                The control parameters of the VAV box are configured
                                and the results are compared to the output of the CDL
                                code in the tool.
   ---------------------------  ---------------------------------------------------
   **Main Flow 1**              **Automatic Control Functionality Checks**
   ---------------------------  ---------------------------------------------------
   1                            Set VAV box to unoccupied.
   ---------------------------  ---------------------------------------------------
   2                            Set VAV box to occupied.
   ---------------------------  ---------------------------------------------------
   3                            Continue through sequence, commissioning agent
                                will get a report of control actions and
                                whether they were compliant with the design intent.
   ---------------------------  ---------------------------------------------------
   **Main Flow 2**              **Commissioning Override Checks**
   ---------------------------  ---------------------------------------------------
   1                            Force zone airflow setpoint to zero.
   ---------------------------  ---------------------------------------------------
   2                            Force zone airflow setpoint to minimum flow.
   ---------------------------  ---------------------------------------------------
   3                            Force damper full closed/open.
   ---------------------------  ---------------------------------------------------
   4                            Reset request-hours accumulator point to zero
                                (provide one point for each reset type).
   ===========================  ===================================================

As-Built Sequence Generator
~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use case will confirm that the installed control sequence
is similar to the intended sequence.

.. table::
   :class: longtable

   ===========================  ===================================================
   **Use case name**            **As-Built Sequence Generator**
   ===========================  ===================================================
   Related Requirements         Tool can translate sequence logic to controls programming
                                logic. Below would do this in reverse.
   ---------------------------  ---------------------------------------------------
   Goal in Context              An owner’s facilities engineer wishes to confirm the
                                actual installed controls sequences in an existing
                                building.  This could be done as a Q/C step for new
                                construction or to periodically document as-operating
                                conditions.
   ---------------------------  ---------------------------------------------------
   Preconditions                Installed control system must be capable of communication
                                with the tool. Translation protocol must be established.
   ---------------------------  ---------------------------------------------------
   Successful End Condition
   ---------------------------  ---------------------------------------------------
   Failed End Condition
   ---------------------------  ---------------------------------------------------
   Primary Actors               Owners facilities engineers
   ---------------------------  ---------------------------------------------------
   Secondary Actors             Owners HVAC technicians, new construction project managers
   ---------------------------  ---------------------------------------------------
   Trigger                      Need for investigation of building performance.
                                Or, periodic snap-shot documentation of as-installed
                                controls sequences.
   ---------------------------  ---------------------------------------------------
   **Main Flow**                **Action**
   ---------------------------  ---------------------------------------------------
   1                            User opens tool interface.
   ---------------------------  ---------------------------------------------------
   2                            User configures tool to connect with desired control
                                system.
   ---------------------------  ---------------------------------------------------
   3                            User initiates translation of installed control logic
                                to sequence documentation.
   ===========================  ===================================================
