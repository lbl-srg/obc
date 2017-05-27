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
      A requirement is a condition that is tested and either passes, fails,
      or is untested. For example, a requirement would be that the actual
      actuation signal is within 2% of the signal computed using the CDL
      representation of a sequence, provided that they both receive the same
      input data.

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

   Mode
     In CDL, by mode we mean a signal that can take on multiple distinct
     values, such as ``On``, ``Off``, ``PreCool``.
