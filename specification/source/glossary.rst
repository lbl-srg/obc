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
     Modelica language and specified in :numref:`sec_cdl`.

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
      A controller is a device that computes control signals for a plant.

   Co-simulation
     Co-simulation refers to a simulation in which different simulation programs
     exchange run-time data at certain synchronization time points.
     A master algorithm sets the current time, input and states,
     and request the simulator to advance time, after which the
     master will retrieve the new values for the state.
     Each simulator is responsible for integrating in time its
     differential equation. See also :term:`model-exchange`.

   Events
     An event is either a :term:`time event` if time triggers the change,
     or a :term:`state event` if a test on the state triggers the change.

   Functional Mockup Interface
     The Functional Mockup Interface (FMI) standard defines an open interface
     to be implemented by an executable called :term:`Functional Mockup Unit` (FMU).
     The FMI functions are called by a simulator to create one or more instances of the FMU,
     called models, and to run these models, typically together with other models.
     An FMU may either be self-integrating (:term:`co-simulation`) or require the simulator
     to perform the numerical integration (:term:`model-exchange`).
     The first are sometimes called FMU-CS, while the second are called FMU-ME.
     See further http://fmi-standard.org/.

   Functional Mockup Unit
     Compiled code or source code that can be executed using the
     application programming interface defined in the :term:`Functional Mockup Interface` standard.

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

   Model-exchange
     Model-exchange refers to a simulation in which different simulation programs
     exchange run-time data.
     A master algorithm sets time, inputs and states, and requests
     from the simulator the time derivative. The master algorithm
     integrates the differential equations in time.
     See also :term:`co-simulation`.

   Non-HVAC System
     Any non-HVAC plant coupled with the control system.

   Plant
     A plant is the physical system that is being controlled by a :term:`controller`.
     In our context, plant is not only used for example a chiller plant, but also
     for an HVAC system or an actuated shade.

   Standard control sequence
     A control sequence defined in the CDL control sequence library based on a standard or
     any other document which contains a full English language description of the
     implemented sequence.

   State event
     We say that a simulation has a state event if its model changes based on a test
     that depends on a state variable. For example, for some initial condition :math:`x(0)=x_0`,

     .. math::

        \frac{dx}{dt} =
        \begin{cases}
          1,  & \text{if } x < 1, \\
          0,  & \text{otherwise,}
        \end{cases}

     has a state event when :math:`x=1`.

   Time event
     We say that a simulation has a time event if its model changes based on a test
     that only depends on time. For example,

     .. math::

        y =
        \begin{cases}
          0, & \text{if } t < 1, \\
          1, & \text{otherwise,}
         \end{cases}

     has a time event at :math:`t=1`.
