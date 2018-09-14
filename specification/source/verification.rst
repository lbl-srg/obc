.. _sec_verification:

Verification
------------

This section describes how to formally verify whether
the control sequence is implemented according to specification.
This process would be done as part
of the commissioning, as indicated in step 9 in the process diagram
:numref:`fig_process`.
For the requirements, see :numref:`sec_requirements_verification_tool`.

For clarity, we remind that *verification* tests whether the implementation
of the control sequence conforms with its specification. In contrast,
*validation* would test whether the control sequence
is such that it meets the building owner's need. Hence,
validation would be done in step 2 in :numref:`fig_process`.

Scope of the verification
^^^^^^^^^^^^^^^^^^^^^^^^^

For OpenBuildingControl, we currently only verify the implementation of the control
sequence. Outside the scope of our verification are tests
that verify whether the I/O points are connected properly,
whether the mechanical equipment is installed and functions correctly,
and whether the building envelop is meeting its specification.
Therefore, with our tests, we aim to verify that the control provider
implemented the sequence as specified, and that it executes correctly.

Methodology
^^^^^^^^^^^

A typical usage would be as follows: Given a CDL specification,
a commissioning agent would export trended control inputs and outputs
and store them in a CSV file. The commissioning agent then executes the CDL specification
for the trended inputs, and compares the following:

1. Whether the trended outputs and the outputs computed by the CDL specification
   are close to each other.
2. Whether the trended inputs and outputs lead to the right sequence diagrams,
   for example, whether an airhandler's economizer outdoor air damper is fully open when
   the system is in free cooling mode.

Technically, step 2 is not needed if step 1 succeeds. However, as part of the commissioning,
it seems beneficial to confirm that the sequence diagrams are indeed correct
(and hence the original control specification is correct for the given system).

:numref:`fig_con_seq_ver` shows the flow diagram for the verification.
Rather than using real-time data through BACnet or other protocols,
set points, inputs and outputs of the actual controller
are stored in an archive such as a CSV file or a data base.
This allows to reproduce the verification tests, and it does
not require the verification tool to have access to the actual building
control system.
During the verification, the archived data are read into a Modelica
model that conducts the verification.
The verification will use three blocks.
The block labeled *input file reader* reads the archived data,
which may typically be in CSV format. As this data may be directly written
by a building automation system, its units will differ from the units
used in CDL. Therefore, the block called *unit conversion* converts
the data to the units used in the CDL control specification.
Next, the block labeled *control specification*
is the control sequence specification in CDL format.
This is the specification that was exported during design and sent
to the control provider.
Given the set point and measurement signals, it outputs the control signal
according to the specification.
The block labeled *time series verification* compares this output with
trended control signals, and indicates where the signals differ by more than
a prescribed tolerance in time and in signal value.
The block labeled *sequence chart* creates x-y or scatter plots. These
can be used to verify for example that an economizer outdoor air damper
has the expected position as a function of the outside air temperature.

Below, we will further describe the blocks in the box labeled *verification*.

.. _fig_con_seq_ver:

.. figure:: img/verification/overviewBlockDiagram.*
   :width: 700 px

   Overview of the verification that tests whether the installed
   control sequence meets the specification.


.. note:: We also considered testing for criteria such as "whether room temperatures
          are satisfactory" or "a damper control signal is not oscillating". However,
          discussions with design engineers and commissioning providers showed that
          there is currently no accepted method for turning such questions into
          hard requirements. We implemented software that tests
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


Modules of the verification test
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

CSV file reader
~~~~~~~~~~~~~~~

To read CSV files, the data reader ``Modelica.Blocks.Sources.CombiTimeTable``
from the Modelica Standard Library
can be used. It requires the CSV file to have the following structure:

.. code-block:: C

   #1
   # comment line
   double tab1(6,2)
   # time in seconds, column 1
     0   0
     1   0
     1   1
     2   4
     3   9
     4  16


Note, that the first two characters in the file need to be ``#1``
(a line comment defining the version number of the file format).
Afterwards, the corresponding matrix has to be declared with type
``double``, name and dimensions.
Finally, in successive rows of the file, the elements
of the matrix have to be given.
The elements have to be provided as a sequence of numbers
in row-wise order (therefore a matrix row can span several
lines in the file and need not start at the beginning of a line).
Numbers have to be given according to C syntax
(such as 2.3, -2, +2.e4). Number separators are spaces,
tab, comma, or semicolon.
Line comments start with the hash symbol (#) and can appear everywhere.


Unit conversion
~~~~~~~~~~~~~~~

Building automation systems store physical quantities in various units.
To convert them to the units used by Modelica and hence also by CDL,
we developed the package ``Buildings.Controls.OBC.UnitConversions``.
This package provides blocks that convert between SI units
and units that are commonly used in the HVAC industry.


Comparison of time series data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We developed a tool called *funnel* to conduct time series data comparison.
The tool imports two CSV files, one containing the reference data set and
the other the test data set.
Both CSV files contain time series that need to be compared across the two
CSV files. The comparison is conducted by computing a funnel around the
reference curve. For this funnel, users can specify the tolerances with respect
to time and with respect to the recorded quantity. The tool then
checks whether the time series of the test data set is within the funnel.
It then generates a report that shows whether the test succeeded.
If the test data set is outside the funnel, the tool will report where and
for how long they differ.

The tool is available from
https://github.com/lbl-srg/funnel.
To see usage information, run ``funnel --help``. This produces the following:

.. code-block:: none

  ./funnel --help
   Usage: funnel [OPTION...]
    -a, --absolute             Set to absolute tolerance
    -b, --baseFile=FILE_PATH   Base CSV file path
    -c, --compareFile=FILE_PATH   Test CSV file path
    -o, --outputFile=DIR       Output directory.
    -t, --tolerance=TOLERANCE  Tolerance to generate data tube
    -x, --axes=AXES            Check if the tolerance value is set for half-width
                               or half-height of tube
    -?, --help                 Give this help list
        --usage                Give a short usage message


Verification of sequence diagrams
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To verify sequence diagrams we developed the Modelica package
``Buildings.Utilities.IO.Plotters``.
:numref:`fig_vav_sin_mod_ver` shows an example in which this block is used to produce the sequence
diagram shown in :numref:`fig_vav_sin_plo_dia_ver`. While in this example, we used the control
output of the CDL implementation of the control sequence, during commissioning,
one would use the control signal from the building automation system.
The model is available from the Modelica Buildings Library, see the model
``Buildings.Utilities.Plotters.Examples.SingleZoneVAVSupply_u``.

.. _fig_vav_sin_mod_ver:

.. figure:: img/verification/SingleZoneVAVSupply_u.*
   :width: 500 px

   Modelica model that verifies the sequence diagram.
   On the left are the blocks that generate the control input.
   In a real verification, these would be replaced with a file reader that
   reads data that have been archived by the building automation system.
   In the center is the control sequence implementation.
   Some of its output is converted to degree Celsius, and then fed to the
   plotters on the right that generate a scatter plot for the temperatures
   and a scatter plot for the fan control signal.
   The block labeled ``plotConfiguration`` configures
   the file name for the plots and the sampling interval.

.. _fig_vav_sin_plo_dia_ver:

.. figure:: img/verification/VAVSingleZoneTSupSet.*
   :width: 500 px

   Control sequence diagram for the VAV single zone control sequence
   from ASHRAE Guideline 36.

Simulating the model shown in :numref:`fig_vav_sin_mod_ver`
generates a file that contains the scatter plots shown in :numref:`fig_vav_sin_ger_ver`.

.. _fig_vav_sin_ger_ver:

.. figure:: img/verification/vavSingleZoneSeq.*
   :width: 500 px

   Scatter plots that show the control sequence diagram generated from
   the simulated sequence.

Example
^^^^^^^

In this example we validated a trended output of a control sequence that defines the cooling
coil valve position. The cooling coil valve sequence is a part of the ALC EIKON control logic
implemented in building 33 on the main LBNL campus in Berkeley, CA.
The subsequence is shown in :numref:`fig_alc_coo_seq`. It comprises a PI controller
that tracks the supply air temperature, an upstream subsequence that enables the
controller and a downstream output limiter that is active in case of low supply air temperatures.

We created a CDL specification of the same cooling coil valve position control sequence,
see :numref:`fig_coo_coi_val_seq`, to validate the recorded output.

.. _fig_alc_coo_seq:

.. figure:: img/verification/AlcEikon_CoolingControl_CHWValvePositionAndEnable.*
   :width: 800 px

   ALC EIKON specification of the cooling coil valve position control sequence.

.. _fig_coo_coi_val_seq:

.. figure:: img/verification/CoolingCoilValve.*
   :width: 800 px

   CDL specification of the cooling coil valve position control sequence.

Recorded 5 seconds input trends to the subsequence are:

* Supply air temperature [F]
* Supply air temperature setpoint [F]
* Outdoor air temperature [F]
* VFD fan enable status [0/1]
* VFD fan feedback [%]

Output of the subsequence is the cooling coil valve position in percentage.

The input and output trends were processed with a script that converts them to the
format required by the data readers. The data used in the example begins at
midnight on June 7 2018.

In addition to the input and output trends, we recorded all parameters, such as the
hysteresis offset (see :numref:`fig_alc_hys_par`) and controller gains
(see :numref:`fig_alc_con_par`), to utilize them in the CDL implementation.

.. _fig_alc_hys_par:

.. figure:: img/verification/AlcEikon_OATHysteresis.*
    :width: 300 px

    ALC EIKON outdoor air temperature hysteresis to enable/disable the controller

.. _fig_alc_con_par:

.. figure:: img/verification/AlcEikon_PIParameters.*
    :width: 500 px

    ALC EIKON PI controller parameters


We configured the CDL PID controller parameters such that they correspond to the parameters of the
ALC PI controller. The ALC PID controller implementation is described
in the ALC EIKON software help section, while CDL PID
controller is described in the info section of the model
`Buildings.Controls.OBC.CDL.Continuous.LimPID <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Controls_OBC_CDL_Continuous.html#Buildings.Controls.OBC.CDL.Continuous.LimPID>`_.
The ALC controller tracks the temperature in
degree Fahrenheit, while CDL uses SI units.
An additional implementation difference is that for cooling applications, the ALC
controller uses direct control action, whereas the CDL controller needs to be configured to use
reverse control action, which can be done by setting its parameter `reverseAction=true`.
Furthermore, the ALC controller outputs the control action in percentages, while the CDL controller outputs
a signal between :math:`0` and :math:`1`.
To reconcile the differences, the ALC controller gains were
converted for CDL as follows:
The proportional gain :math:`k_{p,cdl}` was set to
:math:`k_{p,cdl} = u \, k_{p,alc}`, where :math:`u=9/5` is a ratio of one degree Celsius 
(or kelvin) to one degree Fahrnheit of temperature difference.
The integrator time constant was converted
as
:math:`T_{i,cdl} = k_{p,cdl} \, I_{alc}/(u \, k_{i,alc})`.
Both controllers were enabled throughout the whole validation time.

:numref:`fig_coo_coi_val_tre` shows the
Modelica model that was used to conduct the verification. On the left hand side
are the data readers that read the input and output
trends from files. Next are unit converters, and a conversion for the fan status
between a real value and a boolean value. These data are fed into the instance labeled
``cooValSta``, which contains the control sequence
as shown in :numref:`fig_coo_coi_val_seq`. The plotters on the right hand side then
compare the simulated cooling coil valve position with the recorded data.

.. _fig_coo_coi_val_tre:

.. figure:: img/verification/CoolingCoilValve_Trends.*
   :width: 800 px

   Modelica model that conducts the verification.

:numref:`fig_coo_coi` shows the trended input temperatures for the
control sequence, the trended and simulated cooling valve control signal
for the same time period, which are practically on top of each other,
and a correlation error between the
trended and simulated cooling valve control signal.

.. _fig_coo_coi:

.. figure:: img/verification/cooling_valve.*
   :width: 800 px

   Verification of the cooling valve control signal between ALC EIKON computed
   signal and simulated signal.

The difference in modeled vs. trended results is due to the following factors:

* The difference in the integrator implementation.
  ALC EIKON uses a discrete time step for the time integration with a user-defined
  time step length, whereas CDL uses a continuous time integrator that adjusts the time step
  based on the integration error.
* The anti-windup implementation differs, with ALC EIKON using a proprietary algorithm.

.. _fig_coo_coi_val_fun:

.. figure:: img/verification/cooling_valve_withFunnel.*
   :width: 800 px

   Verification of the cooling valve control signal with the funnel software.


:numref:`fig_coo_coi_val_fun` shows the verification of the implemented control
sequence. It indicates that the control trajectory computed by ALC EIKON and CDL
are close to each other.
