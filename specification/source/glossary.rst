.. _sec_glossary:

Glossary
--------

This section provides definitions for abbreviations and terms introduced in
the Open Building Controls project.

.. If you add new entries, keep the alphabetical sorting.

.. glossary::

   Controls Description Language
     The Control Description Language (CDL) is the language
     that is used to express control sequences and requirements.
     It is a declarative language based on a subset of the
     Modelica language and specified at :ref:`sec_cdl`.

   CDL
     See :term:`Controls Description Language`.

   Controls Design Tool
     The Controls Design Tool is a software that can be used to

     * design control sequences,
     * declare formal, executable requirements,
     * test the control sequences and the requirements with a model
       of the HVAC system and the building in the loop, and
     * export the control sequence and the verification test
       in the :term:`Controls Description Language`.

   Control Sequence Requirement
     A control sequence requirement is a condition against which an 
     actual control sequence gets tested. It is expressed as a predefined 
     CDL control sequence and a set of tolerances.

   Functional Verification Tool
     The Functional Verification Tool is a software that takes
     as an input the control sequence in CDL, requirements expressed in CDL,
     a list of I/O connections, and a configuration file,
     and then tests whether the measured control signals
     satisfy the requirements, violate them, or
     whether some requirements remain untested.

   G36 Sequence
      A control sequence specified by ASHRAE Guideline 36.

   Open Building Controls
     Open Building Controls (OBC) is the name of project that develops
     open source software for building control sequences and for testing
     of requirements.

   OBC
     See :term:`Open Building Controls`.
