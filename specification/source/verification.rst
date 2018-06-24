.. _sec_verification:

Verification
------------

This section describes the verification
of the control sequences that can be done as part
of the commissioning, e.g., step 9 in the process shown in
:numref:`fig_process`.
For the requirements, see :numref:`sec_requirements_verification_tool`.


Scope of the verification
^^^^^^^^^^^^^^^^^^^^^^^^^

For OpenBuildingControl, we currently only verify the control
sequence. Outside the scope of our verification are tests
that verify whether the I/O points are connected properly,
whether the mechanical equipment is installed and functions correctly,
and whether the building envelop is meeting the specifications.
Therefore, with our tests, we aim to verify that the control provider
implemented the sequence as specified, and that it executes correctly.

Methodology
^^^^^^^^^^^

A typical usage would be as follows: Given a CDL specification,
a commissioning agent would export trended control inputs and outputs
to a CSV file. The commissioning agent then executes the CDL specification
for the trended inputs, and compares the following:

* Whether the trended outputs and the outputs computed by the CDL specification
  are close to each other.
* Whether the trended inputs and outputs lead to the right sequence diagrams,
  for example, whether an airhandler's economizer outdoor air damper is fully open when
  the system is in free cooling mode.

:numref:`fig_con_seq_ver` shows the flow diagram for the verification.
Rather than using real-time data through BACnet or other protocols,
set points, inputs and outputs of the actual controller
are stored in an archive such as a CSV file or a data base.
This allows to reproduce the verification tests, and it does
not require the verification tool to have access to the actual building
control system.
During the verification, the archived data are read into a Modelica
model that conducts the verification. There are three main blocks.
One block, labeled *control specification*,
is the control sequence specification in CDL format.
This is the specification that was exported during design and sent
to the control provider.
Given the set point and measurement signals, it outputs the control signal
according to the specification.
The block labeled *time series verification* compares this output with
trended control signals, and indicates where the signals differ by more than
a prescribed tolerance, both, in time and in signal value.
The block labeled *sequence chart* creates x-y or scatter plots. These
can be used to verify for example that an economizer outdoor air damper
has the expected position as a function of the outside air temperature.

Below, we will further describe the blocks  *time series verification*
and *sequence chart*.

.. todo:: Do we also need a block to do unit conversion?
          A block to read CSV data is in development.

.. _fig_con_seq_ver:

.. figure:: img/verification/overviewBlockDiagram.*
   :width: 700 px

   Overview of the verification that tests whether the installed
   control sequence meets the specification.


.. note:: We also considered testing for criteria such as "whether room temperatures
          are satisfactory" or "a damper control signal is not oscillating". However,
          discussions with design engineers and commissioning providers showed that
          there is currently no accepted method for turning such questions into
          hard requirements. We implemented software that tests for example
          criteria such as
          "Room air temperature shall be within the setpoint +/- 0.5 Kelvin
          for at least 45 min within each 60 min window." and
          "Damper signal shall not oscillate more than 4 times per hour
          between a change of +/- 0.025 (for a 2 minute sample period)".
          Software implementations of such tests are available on
          the Modelica Buildings Library github repository, commit
          `454cc75 <https://github.com/lbl-srg/modelica-buildings/commit/454cc7521c0303d0a3f903acdda2132cc53fe45f>`_.

          Besides these tests, we also considered automatic fault detection and diagnostics methods
          that were proposed for inclusion in ASHRAE RP-1455 and Guideline 36,
          and we considered using methods such as in :cite:`Veronica2013`
          that automatically detect
          faulty regulation, including excessively oscillatory behavior.
          However, as it is not yet clear how sensitive these methods
          are to site-specific tuning, and because field tests are ongoing in a NIST project,
          we did not implement them.


Developed modules
^^^^^^^^^^^^^^^^^

Comparison of time series data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx

Verification of sequence diagrams
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

xxxx

Example
^^^^^^^

xxxxx
