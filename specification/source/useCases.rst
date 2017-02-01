.. _sec_use_cases:

Use Cases
---------

This section describes use cases for end-user interaction, including:

* use the controls design tool to design a control sequence and export
  it as a CDL-compliant specification,
* use the CDL to bid on a project and, when selected for the project,
  implement the control sequence in a building automation system, and
* use the commissioning and functional verification tool during commissioning.
* Use control design tool to create control diagrams in addition to control sequences 
  and automatically produce a points list with a standard naming convention and/or tagging 
  convention, a plain language SOO, and verification that the control diagram includes 
  all instrumentation required to complete the control sequence.
* Use control design tool during construction to assist the controls integration process by 
  identifying network protocol, communication protocol and points list discrepancies between 
  systems and equipment.   


Controls design
^^^^^^^^^^^^^^^


Use Case 1: Customizing a control sequence for a VAV system
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

This use case describes how to assess the peformance of a control sequence
in the controls design tool.

xxx.

Export of the control sequence in CDL
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx

Saving the control sequence in a library for use in future projects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx

Importing a CDL for trouble shooting an existing building
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx

**Use Case 2: As-Built Sequence Generator, Gerry Hamilton, Stanford**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use case describes how to customize a control sequence
for a VAV system.

===========================  ===================================================
**Use case name**            **Customizing a control sequence for a VAV system**
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
                             with Tool. Translation protocol must be established.
---------------------------  ---------------------------------------------------
Successful End Condition      
---------------------------  ---------------------------------------------------
Failed End Condition
---------------------------  ---------------------------------------------------
Primary Actors               Owners facilities engineers
---------------------------  ---------------------------------------------------
Secondary Actors             Owners HVAC technicians, new construction PMs
---------------------------  ---------------------------------------------------
Trigger                      Need for investigation of building performance.
                             Or, periodic snap-shot documentation of as-installed
                             controls sequences.
---------------------------  ---------------------------------------------------
**Main Flow**                **Action**
---------------------------  ---------------------------------------------------
1                            User opens Tool interface.
---------------------------  ---------------------------------------------------
2                            User configures Tool to connect with desired control
                             system. 
---------------------------  ---------------------------------------------------
3                            User initiates translation of installed control logic
                             to sequence documentation.
---------------------------  ---------------------------------------------------
**Extensions**
---------------------------  ---------------------------------------------------
1                            xxxx
---------------------------  ---------------------------------------------------
2                            xxxx
===========================  ===================================================


**Use Case 3: Controls Programming Status Verification, by Gerry Hamilton, Stanford**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


===========================  ===================================================
**Use case name**            **Controls Programming Status Verification**
===========================  ===================================================
Related Requirements          Tool can interpret as-installed programming.
---------------------------  ---------------------------------------------------
Goal in Context              An engineer wishes to confirm that the control logic
                             is ready for commissioning.  The Tool will identify
                             Improper sequences, logic errors, missing code/pts.
---------------------------  ---------------------------------------------------
Preconditions                Installed control system must be capable of communication
                             with Tool.  Translation protocol must be established.
---------------------------  ---------------------------------------------------
Successful End Condition      
---------------------------  ---------------------------------------------------
Failed End Condition
---------------------------  ---------------------------------------------------
Primary Actors               New construction PM, Owner’s representative
---------------------------  ---------------------------------------------------
Secondary Actors             Cx agent, engineer of record
---------------------------  ---------------------------------------------------
Trigger                      Contractor notifies owner or PM that system is ready
                             for Cx.
---------------------------  ---------------------------------------------------
**Main Flow**                **Action**
---------------------------  ---------------------------------------------------
1                            User opens Tool interface.
---------------------------  ---------------------------------------------------
2                            User configures Tool to connect with desired control
                             system. 
---------------------------  ---------------------------------------------------
3                            User initiates translation of installed control logic
                             to sequence documentation.
---------------------------  ---------------------------------------------------
**Extensions**
---------------------------  ---------------------------------------------------
1                            xxxx
---------------------------  ---------------------------------------------------
2                            xxxx
===========================  ===================================================

**Use Case 4: Loading a standard sequence from Guideline 36, by Amy Shen, Arup**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


===========================  ===================================================
**Use case name**            **Loading a standard sequence from Guideline 36**
===========================  ===================================================
Related Requirements         Direct reference/selection from Guideline 36’s corresponding chapter and narrative sequence to convert to CDL.
                             User able to change the pre-set elements within the standard sequence, with automatic download of associated CDL/visual block diagram of any new elements.
---------------------------  ---------------------------------------------------
Goal in Context              Enable fast adaptation of Guideline 36
---------------------------  ---------------------------------------------------
Preconditions                All Guideline 36 sequences need to be pre-programmed into visual block diagrams and CDL.  
                             CDL and block diagrams need to be  modular so that CDL can be easily updated when key elements are changed/deleted/added.
---------------------------  ---------------------------------------------------
Successful End Condition     User is able to daownload the CDL/block diagrams using a specific reference to Guideline 36 sequences. 
                             User is able to change/delete/add key elements in CDL.
---------------------------  ---------------------------------------------------
Failed End Condition         Missing Guideline 36 sequence in library. When a user changes/deleted/adds elements to CDL/visual block diagram, 
                             no associated CDL/visual block diagram appears/disappears accordingly.
---------------------------  ---------------------------------------------------
Primary Actors               Mechanical Designer/Consultant
---------------------------  ---------------------------------------------------
Secondary Actors             Maintenance Engineer for retrofitting redesign
---------------------------  ---------------------------------------------------
Trigger                      Designing control system using Guideline 36 as default sequence or a starting point, 
                             then needs to change key elements as the system is different to Guideline 36 presumed system configuration.
---------------------------  ---------------------------------------------------
**Main Flow**                **Action**
---------------------------  ---------------------------------------------------
1                            User opens Guideline 36 library and see a contents menu of the standard sequences for selection
---------------------------  ---------------------------------------------------
2                            User selects a sequence
---------------------------  ---------------------------------------------------
3                            The corresponding CDL and visual block diagram appears in Tool, key control elements 
                             (e.g. fan, cooling coil valve, control damper) within the standard sequence is also displayed.
---------------------------  ---------------------------------------------------
**Extensions**
---------------------------  ---------------------------------------------------
1                            User deletes/adds a key control element.
---------------------------  ---------------------------------------------------
2                            The corresponding CDL gets added or deleted from the standard sequence.
===========================  ===================================================


**Use Case 5: Defining integration with non-HVAC systems such as lighting, façade and presence detection etc.**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


===========================  ===================================================
**Use case name**            **Defining integration with non-HVAC systems such as lighting, façade and presence detection etc.**
===========================  ===================================================
Related Requirements         Representing non-HVAC systems and their associated control blocks within CDL
---------------------------  ---------------------------------------------------
Goal in Context              Integration actions between HVAC and non-HVAC systems can be defined in CDL.
                             Optional goal - Tool to also configure and verify HVAC to non-HVAC integration
---------------------------  ---------------------------------------------------
Preconditions                Examples of HVAC and non-HVAC integrations available for adaptation into CDL, non-HVAC systems can be façade louvre control, 
                             lighting on/off, presence detection status.
---------------------------  ---------------------------------------------------
Successful End Condition     User able to use CDL to define common HVAC and non-HVAC integrations
---------------------------  ---------------------------------------------------
Failed End Condition         Failure to include HVAC and Façade/lighting/Presence detection interactions in CDL.
---------------------------  ---------------------------------------------------
Primary Actors               Mechanical Designer/Consultant
---------------------------  ---------------------------------------------------
Secondary Actors             Maintenance Engineer for retrofitting redesign
---------------------------  ---------------------------------------------------
Trigger
---------------------------  ---------------------------------------------------
**Main Flow**                **Action**
---------------------------  ---------------------------------------------------
1                            User opens a menu of the non-HVAC systems for selection
---------------------------  ---------------------------------------------------
2                            User selects the non-HVAC object and the visual block diagram and associated CDL appears.
---------------------------  ---------------------------------------------------
3                            User clicks on a non-HVAC object and a menu of status and actions pops up.
---------------------------  ---------------------------------------------------
4                            User selects the integration status or action of the non-HVAC system, and links it to HVAC system’s status or action block
---------------------------  ---------------------------------------------------
**Extensions**
---------------------------  ---------------------------------------------------
1                            xxxx
---------------------------  ---------------------------------------------------
2                            xxxx
===========================  ===================================================


**Use Case 6: CDL tool to have capability to generate controls points schedule from sequences**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 
===========================  ===================================================
**Use case name**            **CDL tool to have capability to generate controls points schedule from sequences**
===========================  ===================================================
Related Requirements         Optional - The points schedule can also be used by third party software for specification generation.
---------------------------  ---------------------------------------------------
Goal in Context              The same CDL can be used to generate controls points schedule
---------------------------  ---------------------------------------------------
Preconditions                Each control points needs to be defined under AI/AO/DI/DO/Network interface types and consistent tagging/naming
---------------------------  ---------------------------------------------------
Successful End Condition     Control points schedule can be automatically produced by extracting from the sequences, including tagging (AHU/TDX/1), 
                             point name, point type and comments (such as differential pressure to be installed at 2/3 down index leg)
---------------------------  ---------------------------------------------------
Failed End Condition         Control points schedule is inaccurate or doesn’t contain sufficient information.
---------------------------  ---------------------------------------------------
Primary Actors               Mechanical Designer/Consultant
---------------------------  ---------------------------------------------------
Secondary Actors             Controls contractor
---------------------------  ---------------------------------------------------
Trigger
---------------------------  ---------------------------------------------------
**Main Flow**                **Action**
---------------------------  ---------------------------------------------------
1                            When a user adds a control point in CDL, the tool provides default values and allows the user to 
                             change the values for tagging/point name/point type/comments
---------------------------  ---------------------------------------------------
2                            User clicks on a button to generate Points Schedule, an Excel file is then generated listing all the points and their details,
                             and also counts the total number of different type of points.
---------------------------  ---------------------------------------------------
3                            User clicks on a button to generate a tag list of unique control devices within the project in Excel, so that the associated spec 
                             section can be extracted and populated within third party software.
---------------------------  ---------------------------------------------------
**Extensions**
---------------------------  ---------------------------------------------------
1                            xxxx
---------------------------  ---------------------------------------------------
2                            xxxx
===========================  ===================================================


**Use Case 7: Conducting verfification test of a VAV Cooling-Only Terminal Unit**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

===========================  ===================================================
**Use case name**            **Conducting verfification test of a VAV Cooling-Only Terminal Unit**
===========================  ===================================================
Related Requirements            
---------------------------  ---------------------------------------------------
Goal in Context              A commissioning agent wants to verify on site that the controller operates in accordance with the SOP
---------------------------  ---------------------------------------------------
Preconditions                CDL code in vendor software is correct. Field instrumentation is per spec. Installation of field equipment is correct
                             Point-point testing from point in field through to graphic is correct
---------------------------  ---------------------------------------------------
Successful End Condition     Control devices carry out the right sequence of actions, and the tool recognizes compliance to CDL/design intent
                             Control devices carry out wrong sequence of actions, and the tool recognizes incompliance to CDL/design intent
---------------------------  ---------------------------------------------------
Failed End Condition         The tool fails to recognize verification success/failure.
---------------------------  ---------------------------------------------------
Primary Actors               Commissioning agent
---------------------------  ---------------------------------------------------
Secondary Actors             BMS engineer (optional)
                             Approved vendor software which replicates uploaded CDL code
---------------------------  ---------------------------------------------------
Trigger                      The tool is connected to the BMS and receives the following signals from the VAV box controller:
                             - occupied mode, unoccupied mode
                             - Vmin, Vcool-max etc.
                             - setpoints and timers
                             The control parameters of the VAV box are configured and the results are compared to the output of the CDL code in the tool.
---------------------------  ---------------------------------------------------
**Main Flow1**              **Automatic Control Functionality Checks**
---------------------------  ---------------------------------------------------
1                            Set VAV box to unoccupied
---------------------------  ---------------------------------------------------
2                            Set VAV box to occupied
---------------------------  ---------------------------------------------------
3                            Continue through sequence, commissioning agent will get a report of control actions and whether they were compliant with CDL/design intent.
---------------------------  ---------------------------------------------------
**Main Flow2**              **Commissioning Override Checks**
---------------------------  ---------------------------------------------------
1                            Force zone airflow setpoint to zero
---------------------------  ---------------------------------------------------
2                            Force zone airflow setpoint to Vmin
---------------------------  ---------------------------------------------------
3                            Force damper full closed/open
---------------------------  ---------------------------------------------------
4                            Reset request-hours accumulator point to zero (provide one point for each reset type listed below)
---------------------------  ---------------------------------------------------


**Extensions**
---------------------------  ---------------------------------------------------
1                            xxxx
---------------------------  ---------------------------------------------------
2                            xxxx
===========================  ===================================================



CDL processing for bidding and implementation in building automation system
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

Conducting functional verification tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx
