.. _sec_use_cases:

Use Cases
---------

This section describes use cases for end-user interaction, including:

* use the controls design tool to design a control sequence and export
  it as a CDL-compliant specification,
* use the CDL to bid on a project and, when selected for the project,
  implement the control sequence in a building automation system,
* use the control design tool to create control block diagrams in addition to control sequences
  and automatically produce a points list with a standard naming convention and/or tagging
  convention, a plain language sequence of operation,
  and verification that the control diagram includes
  all instrumentation required to complete the control sequence,
* use the control design tool during construction to assist the controls integration process by
  identifying network protocol, communication protocol and points list discrepancies between
  systems and equipment,
* use the commissioning and functional verification tool during commissioning.


Controls design
^^^^^^^^^^^^^^^


Customizing a control sequence for a VAV system
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(Brent: this example appears to be "how to attach a VAV control sequence to a specific VAV box", as opposed to "how to modify/customize the pre-defined VAV control sequence".  I argue that they are distinct use cases and we need to consider both.

*Provided by Michael Wetter, LBNL.*

This use case describes how to customize a control sequence
for a VAV system.

===========================  ===================================================
**Use case name**            **Customizing a control sequence for a VAV system**
===========================  ===================================================
Related Requirements         n/a
---------------------------  ---------------------------------------------------
Goal in Context              A mechanical engineer wants to customize a control
                             sequence, starting with a template.
---------------------------  ---------------------------------------------------
Preconditions                HVAC system model connected to building model.

                             (Brent: What is the "system model"?  What is the "building model"?  Where do each of them reside?  In what format is the data held?)

                             Preconfigured control sequence, stored in the
                             OpenBuildingControls library.

                             A set of performance requirements.
---------------------------  ---------------------------------------------------
Successful End Condition     Implemented VAV sequence with customized control,
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
3                            The user connects sensors and actuators to
                             control inputs and outputs.

                             (Brent: Is this not already pre-defined in the library sequence?  The library sequence already has inputs and outputs defined.  The library sequence should define what types of input/output are expected/acceptable to each of its I/O points.  The engineer merely needs to note which ones do or do not apply. e.g. not all VAV boxes have a heating coil or a discharge air temp sensor)
---------------------------  ---------------------------------------------------
4                            The user drags and drops from the Buildings library
                             a pre-configured VAV control sequence.
---------------------------  ---------------------------------------------------
5                            The user clicks on the pre-configured VAV control
                             sequence and selects in the tool a function that
                             will store the sequence in the project library
                             to allow further editing.
---------------------------  ---------------------------------------------------
6                            The controls design tool stores the
                             sequence in the project library.
---------------------------  ---------------------------------------------------
7                            The user opens in the project library
                             the new composite control block.
---------------------------  ---------------------------------------------------
8                            The user adds and connects additional control blocks
                             from the elementary CDL-block library.
---------------------------  ---------------------------------------------------
9                            The user selects "Check model" to verify whether
                             the implemented sequence complies with the CDL
                             specification.
===========================  ===================================================

(Brent: Is the engineer expected to go through this process for every VAV box?  That might be OK for e.g. AHU or chillers, but there can be thousands of VAV boxes in a project)

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
   "User" -> "Control Design Tool" : Connect sensors and actuators to control inputs and outputs.
   "User" -> "Control Design Tool" : Select to store the control sequence in the project library.
   "Control Design Tool" -> "Control Design Tool" : Write the sequence to new file in the project library.
   "User" -> "Control Design Tool" : Open new composite control block in the project library.
   "User" -> "Control Design Tool" : Drag, drop and connect blocks from CDL library.
   "User" -> "Control Design Tool" : Check model.
   "OpenStudio" <- "Control Design Tool" : Invoke model check.
   "User" <- "Control Design Tool" : Report info, warning and error.


.. _use_case_per_ass:

Performance assessment of a control sequence
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use case describes how to assess the performance of a control sequence
in the controls design tool.

===========================  ===================================================
**Use case name**            **Customizing a control sequence for a VAV system**
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
                             building or system
---------------------------  ---------------------------------------------------
**Main Flow**                **Action**
---------------------------  ---------------------------------------------------
1                            User loads the building/system model for the project
                             or uses design information to configure a model template
---------------------------  ---------------------------------------------------
2                            User selects and loads weather data and operation
                             schedules.
---------------------------  ---------------------------------------------------
3                            User configures control sequence with project-specific
                             information, e.g. number of terminal units on an air
                             loop, and connects to building/system modeL
---------------------------  ---------------------------------------------------
4                            User selects short periods for initial testing and
                             performs predefined tests to verify basic functionality
                             (equivalent ot commissioning).
---------------------------  ---------------------------------------------------
5                            User initiates simulation of building/system
                             controlled performance over full reference year or
                             statistically-selected short reference year that
                             reports output variables required to evaluate
                             performance according to pre-defined metrics.
---------------------------  ---------------------------------------------------
6                            Compare metric values to requirements and/or targets
                             and determine whether acceptable as is, needs
                             modification or appears fundamentally flawed.
===========================  ===================================================



:numref:`fig_use_case_perf_assess` shows the sequence diagram for this use case.

.. _fig_use_case_perf_assess:

.. uml::
   :caption: Performance assessment of a control sequence.

   title Performance assessment of a control sequence (to be completed)

   "User" -> "OpenStudio" : Open control design tool.
   "OpenStudio" -> "Control Design Tool" : open()
   "User" -> "Control Design Tool" : Open HVAC and building model.
   "OpenStudio" <- "Control Design Tool" : Request HVAC and building model.
   "User" -> "Control Design Tool" : Drag & drop pre-configured control sequence.
   "User" -> "Control Design Tool" : Connect sensors and actuators to control inputs and outputs.



Export of the control sequence in CDL
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx

Saving the control sequence in a library for use in future projects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx

Importing a CDL for trouble shooting an existing building
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx


Loading a standard sequence from Guideline 36
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Provided by Amy Shen, Arup.*

This use case describes how to load, edit and store a control
sequence based on a Guideline 36 sequence.

===========================  ===================================================
**Use case name**            **Loading a standard sequence from Guideline 36**
===========================  ===================================================
Related Requirements         Direct reference/selection from Guideline 36’s
                             corresponding chapter and narrative sequence to convert to CDL.
                             User able to change the pre-set elements within
                             the standard sequence, with automatic download of
                             associated CDL/visual block diagram of any new elements.
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
Secondary Actors             Maintenance Engineer for retrofitting redesign
---------------------------  ---------------------------------------------------
Trigger                      Designing control system using Guideline 36 as
                             default sequence or a starting point,
                             then needs to change key elements as the system
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
                             in the controls design tool, key mechanical elements
                             (e.g. fan, cooling coil valve, control damper)
                             controlled by the standard sequence are also displayed.
---------------------------  ---------------------------------------------------
**Extensions**
---------------------------  ---------------------------------------------------
1                            User deletes/adds a key control element.
---------------------------  ---------------------------------------------------
2                            The corresponding sequence modification gets stored
                             in the original sequence.
===========================  ===================================================


Defining integration with non-HVAC systems such as lighting, façade and presence detection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Provided by Amy Shen, Arup.*

This use case describe the connection of a facade control with the HVAC
control in the control design tool.

===========================  ===================================================
**Use case name**            **Defining integration with non-HVAC systems such as
                             lighting, façade and presence detection**
===========================  ===================================================
Related Requirements         Representing non-HVAC systems and their associated
                             control blocks using CDL.
---------------------------  ---------------------------------------------------
Goal in Context              Integration actions between HVAC and non-HVAC systems
                             can be defined using CDL.

                             Optional goal - Tool to also configures and verifies
                             HVAC to non-HVAC integration.
---------------------------  ---------------------------------------------------
Preconditions                Examples of HVAC and non-HVAC integrations available
                             for adaptation using CDL, non-HVAC systems can be
                             façade louvre control,
                             lighting on/off or presence detection status.
---------------------------  ---------------------------------------------------
Successful End Condition     User able to use CDL to define common HVAC
                             and non-HVAC integrations
---------------------------  ---------------------------------------------------
Failed End Condition         Failure to include HVAC and façade/lighting/presence
                             detection interactions in CDL.
---------------------------  ---------------------------------------------------
Primary Actors               Mechanical Designer/Consultant
---------------------------  ---------------------------------------------------
Secondary Actors             Maintenance Engineer for retrofitting redesign
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



CDL processing for bidding and implementation in building automation system
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Generate control point schedule from sequences
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Provided by Amy Shen, Arup.*

This use case describes how to generate control points from a sequence specification.


===========================  ===================================================
**Use case name**            **Generate control points schedule from sequences**
===========================  ===================================================
Related Requirements         Optional - The points schedule can also be used by
                             third party software for specification generation.
---------------------------  ---------------------------------------------------
Goal in Context              The same control specification can be used to
                             generate controls points schedule
---------------------------  ---------------------------------------------------
Preconditions                Each control points needs to be defined using
                             AI/AO/DI/DO/Network interface types
                             and consistent tagging/naming
---------------------------  ---------------------------------------------------
Successful End Condition     Control points schedule can be automatically produced
                             by extracting from the sequences,
                             including tagging (AHU/TDX/1),
                             point name, point type and comments
                             (such as differential pressure to be installed at 2/3 down index leg)
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
                             the tool provides default values and allows the user to
                             change the values for tagging/point name/point type/comments
---------------------------  ---------------------------------------------------
2                            User clicks on a button to generate Points Schedule,
                             an Excel file is then generated listing all the
                             points and their details,
                             and also counts the total number of different type of points.
---------------------------  ---------------------------------------------------
3                            User clicks on a button to generate a tag list
                             of unique control devices within the project in Excel,
                             so that the associated specification
                             section can be extracted and populated within third party software.
===========================  ===================================================


Processing the CDL for cost-estimation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx

Processing the CDL for implementation in building automation system using code translation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx

Processing the CDL for implementation in building automation system using manual implementation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx

Commissioning
^^^^^^^^^^^^^

Verification of requirements
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx

Conducting verification test of a VAV Cooling-Only Terminal Unit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Provided by David Pritchard, Arup.*

This use case describes the verification of an installed control sequence
relative to the design intent.

===========================  ===================================================
**Use case name**            **Conducting verification test of a VAV Cooling-Only Terminal Unit**
===========================  ===================================================
Related Requirements
---------------------------  ---------------------------------------------------
Goal in Context              A commissioning agent wants to verify on site that
                             the controller operates in accordance with the
                             sequence of operation
---------------------------  ---------------------------------------------------
Preconditions                CDL code in vendor software is correct.

                             Field instrumentation is per spec.

                             Installation of field equipment is correct.

                             Point-point testing from point in field through
                             to graphic is correct.
---------------------------  ---------------------------------------------------
Successful End Condition     Control devices carry out the right sequence of actions,
                             and the verification tool recognizes compliance to the design intent.

                             Control devices carry out wrong sequence of actions,
                             and the verification tool recognizes incompliance to the design intent.
---------------------------  ---------------------------------------------------
Failed End Condition         The verification tool fails to recognize verification success/failure.
---------------------------  ---------------------------------------------------
Primary Actors               Commissioning agent
---------------------------  ---------------------------------------------------
Secondary Actors             BMS engineer (optional)

                             Approved vendor software which replicates uploaded CDL code
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
1                            Set VAV box to unoccupied
---------------------------  ---------------------------------------------------
2                            Set VAV box to occupied
---------------------------  ---------------------------------------------------
3                            Continue through sequence, commissioning agent
                             will get a report of control actions and
                             whether they were compliant with the design intent.
---------------------------  ---------------------------------------------------
**Main Flow 2**              **Commissioning Override Checks**
---------------------------  ---------------------------------------------------
1                            Force zone airflow setpoint to zero
---------------------------  ---------------------------------------------------
2                            Force zone airflow setpoint to Vmin
---------------------------  ---------------------------------------------------
3                            Force damper full closed/open
---------------------------  ---------------------------------------------------
4                            Reset request-hours accumulator point to zero
                             (provide one point for each reset type)
===========================  ===================================================

As-Built Sequence Generator
~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Provided by Gerry Hamilton, Stanford.*

This use case will confirm that the installed control sequence
is similar to the intended sequence.

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


Controls Programming Status Verification
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Provided by Gerry Hamilton, Stanford.*

This use case will verify whether an installed control system
is ready for commissioning.

===========================  ===================================================
**Use case name**            **Controls Programming Status Verification**
===========================  ===================================================
Related Requirements         Tool can interpret as-installed programming.
---------------------------  ---------------------------------------------------
Goal in Context              An engineer wishes to confirm that the control logic
                             is ready for commissioning. The tool will identify
                             improper sequences, logic errors, missing code and
                             missing control points.
---------------------------  ---------------------------------------------------
Preconditions                Installed control system must be capable of communication
                             with the tool. The translation protocol must be established.
---------------------------  ---------------------------------------------------
Successful End Condition
---------------------------  ---------------------------------------------------
Failed End Condition
---------------------------  ---------------------------------------------------
Primary Actors               New construction project manager, owner’s representative
---------------------------  ---------------------------------------------------
Secondary Actors             Cx agent, engineer of record
---------------------------  ---------------------------------------------------
Trigger                      Contractor notifies owner or PM that system is ready
                             for Cx.
---------------------------  ---------------------------------------------------
**Main Flow**                **Action**
---------------------------  ---------------------------------------------------
1                            User opens tool interface.
---------------------------  ---------------------------------------------------
2                            User configures tool to connect with desired
                             control system.
---------------------------  ---------------------------------------------------
3                            User initiates translation of installed control
                             logic to sequence documentation.
===========================  ===================================================

Performance assessment of a control sequence, including local loops
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Provided by Philip Haves, LBNL.*

===========================  ===================================================
**Use case name**            **Performance assessment of a control sequence,
                             including local loops**
===========================  ===================================================
Related Requirements
---------------------------  ---------------------------------------------------
Goal in Context              Evaluate the performance of a specific control sequence
                             in the context of a particular design project.
---------------------------  ---------------------------------------------------
Preconditions                1. Either a) whole building or system model for the particular design
                             project, or b) sufficient information about the current state of the design,
                             to enable the configuration of a model template based on a generic design
                             for the appropriate building type. The model must be complete down to the
                             required sensors and actuators.

                             2. Control sequence to be assessed must match, or be capable of being configured
                             to match, the building/system model in terms of sensing and actuation points
                             and modes of operation.

                             3. Relevant statutory requirements and design performance targets. Performance
                             metrics derived from these requirements and targets.
---------------------------  ---------------------------------------------------
Successful End Condition     User is able to (i) compare the performance
                             of different control sequences in
                             terms of selected pre-defined criteria, and (ii) evaluate the ability of a selected
                             control sequence to enable the building/system to meet or exceed externally-defined
                             performance criteria.
---------------------------  ---------------------------------------------------
Failed End Condition         1. Building/system model or
                             configuration information for generic model template is incomplete.

                             2. Performance requirements or targets are incomplete or inconsistent wrt the specific
                             control sequence.
                             
                             3. Simulation fails to run to completion or fails convergence tests
---------------------------  ---------------------------------------------------
Primary Actors               Mechanical Designer/Consultant
---------------------------  ---------------------------------------------------
Secondary Actors
---------------------------  ---------------------------------------------------
Trigger                      Need to select or improve a control sequence for a
                             building or system
---------------------------  ---------------------------------------------------
**Main Flow**                **Action**
---------------------------  ---------------------------------------------------
1                            User loads the building/system model for the
                             project or uses design information
                             to configure a model template: building type, system type(s), size …(?).
---------------------------  ---------------------------------------------------
2                            User selects and loads weather data and operation
                             schedules.
---------------------------  ---------------------------------------------------
3                            User configures control sequence with
                             project-specific information, e.g. number
                             of terminal units on an air loop, and connects to building/system model.
---------------------------  ---------------------------------------------------
4                            User uses design information to identify operating
                             ranges at which the control sequence must function and identifies operating conditions/ranges for tuning of individual feedback control loops in the sequence.
---------------------------  ---------------------------------------------------
5                            User  selects initial values for supervisory
                             controller parameters and tunes the individual feedback control loops or initiates autotuning.
---------------------------  ---------------------------------------------------
6                            User selects short periods for initial testing
                             of control loop stability and responsiveness to disturbances and set-point changes and changes controller parameters as necessary.
---------------------------  ---------------------------------------------------
7                            User initiates simulation of building/system
                             controlled performance over full
                             reference year or statistically-selected short reference year that reports
                             output variables required to evaluate performance according to pre-defined metrics.
---------------------------  ---------------------------------------------------
8                            Compare metric values to requirements and/or
                             targets.
---------------------------  ---------------------------------------------------
**Main Flow 2**              **Commissioning Override Checks**
---------------------------  ---------------------------------------------------
1
---------------------------  ---------------------------------------------------
2
===========================  ===================================================

Template Use Case
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Provided by mg, lbnl.*

This use case will tell you how to fill out the table form with a new use case.

===========================  ===================================================
**Use case name**            **Name**
===========================  ===================================================
Related Requirements         xxx
---------------------------  ---------------------------------------------------
Goal in Context              xxx
                             xxx
                             xxx
---------------------------  ---------------------------------------------------
Preconditions                xxx
                             xxx
---------------------------  ---------------------------------------------------
Successful End Condition     xxx
---------------------------  ---------------------------------------------------
Failed End Condition         xxx
---------------------------  ---------------------------------------------------
Primary Actors               xxx
---------------------------  ---------------------------------------------------
Secondary Actors             xxx
---------------------------  ---------------------------------------------------
Trigger                      xxx
---------------------------  ---------------------------------------------------
**Main Flow**                **Action**
---------------------------  ---------------------------------------------------
1                            xxx
---------------------------  ---------------------------------------------------
2                            xxx
---------------------------  ---------------------------------------------------
3                            xxx
===========================  ===================================================
