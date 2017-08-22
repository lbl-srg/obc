.. _sec_glossary:

Glossary
--------

This section provides definitions for abbreviations and terms introduced in
the Open Building Controls project.

.. If you add new entries, keep the alphabetical sorting.

.. glossary::

   Analog Value
     In CDL, we say a value is analog if it represents a continuous
     number. The value may be presented by an analog signal such as
     voltage, or by a digital signal.

   Binary Value
     In CDL, we say a value is binary if it can take on the values
     0 and 1. The value may however be presented by an analog signal
     that can take on two values (within some tolerance) in order
     to communicate the binary value.

   Building Model
     Digital model of the physical behavior of a given building over time,
     which accounts for any elements of the building envelope and includes a
     representation of internal gains and occupancy. Building model has connectors
     to be coupled with an environment model and any HVAC and non-HVAC system models
     pertaining to the building.
     
   CDL
     See :term:`Controls Description Language`.

   Controls Description Language
     The Control Description Language (CDL) is the language
     that is used to express control sequences and requirements.
     It is a declarative language based on a subset of the
     Modelica language and specified at :ref:`sec_cdl`.

   Controls Design Tool
     The Controls Design Tool is a software that can be used to

     * design control sequences,
     * declare formal, executable requirements,
     * test the control sequences and the requirements with a model
       of the HVAC system and the building in the loop, and
     * export the control sequence and the verification test
       in the :term:`Controls Description Language`.

   Control Sequence Requirement
     A requirement is a condition that is tested and either passes, fails,
     or is untested. For example, a requirement would be that the actual
     actuation signal is within 2% of the signal computed using the CDL
     representation of a sequence, provided that they both receive the same
     input data.

   Control System
     Any software and hardware required to perform the control function for a plant.
     
   Controller
      A controller, or a compensator is an additional system that is added to the 
      plant to control the operation of the  plant. The system can have multiple 
      compensators, and they can appear anywhere in the system: Before the pick-off node, 
      after the summer, before or after the plant, and in the feedback loop. 

   Functional Verification Tool
     The Functional Verification Tool is a software that takes
     as an input the control sequence in CDL, requirements expressed in CDL,
     a list of I/O connections, and a configuration file,
     and then tests whether the measured control signals
     satisfy the requirements, violate them, or
     whether some requirements remain untested.

   G36 Sequence
     A control sequence specified by ASHRAE Guideline 36. See also control sequence.

   HVAC System
     Any HVAC plant coupled with the control system.

   HVAC System Model
     Consists of all components and connections used to model the behavior of an HVAC System.

   Open Building Controls
     Open Building Controls (OBC) is the name of project that develops
     open source software for building control sequences and for testing
     of requirements.

   OBC
     See :term:`Open Building Controls`.

   Mode
     In CDL, by mode we mean a signal that can take on multiple distinct
     values, such as ``On``, ``Off``, ``PreCool``.

   Non-HVAC System
     Any non-HVAC plant coupled with the control system.

   Plant
     The term Plant is a carry-over term from chemical engineering to refer to the main 
     system process. The plant is the preexisting system that does not (without the aid of 
     a controller or a compensator) meet the given specifications. Plants are usually given 
     "as is", and are not changeable.

   Standard control sequence
     A control sequence defined in the CDL control sequence library based on a standard or 
     any other document which contains a full English language description of the 
     implemented sequence.
