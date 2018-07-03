.. todo :: <50 as a fault, 15 s data, start data at midnight, ticks (0612, or date)?

Subsequence validation example
==============================

This documents an example control sequence validation test. The purpose of a validation test is to compare the recorded output trend of a control sequence installed in an actual building with the output of an identical control sequence programmed in CDL, given the same input trends. Inputs and outputs are provided as recorded 5s interval trends, recorded between 2018-06-07 17:00:00 PDT and 6/11/2018 08:41:50 PDT.


Control Sequence
----------------

The control sequence used in the validation example is a subsequence of the AHU control logic {in building fixme}. The subsequence defines the position of the cooling coil valve using a PI controller that tracks the supply air temperature.
+ low OAT as limiter

Input trends to the subsequence are:

- 
-
-
-
-
-

Output trend of the subsequence is:

-

Controller parameters:

-


.. note:: {fixme: add screenshot of the EIKON Logic}



Old notes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Summary: PI controller tracks SAT/SAT SP 

Inputs:

- SAT
- OAT
- SAT SP (HT SAT SP is 1F lower than the SAT SP)
- Manual override: Assume off at all times during the test period
- Flow (Fan Status)

Outputs:

- Heating valve status signal (33-HC-22 Heating Valve)

Notes, issues and assumptions:

- Manual override: Per correspondence with Chris W, assume it never got activated
- Supply fan is on all the time based on observed data
- take parameters from the ALC EIKON block diagram


Cooling Control - Coil Valve
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Similar to heating control valve. SAT SP trend is the SAT cooling SP trend.


33-AHU-03 (Roof)
----------------

Heating Control - Coil Valve
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Same as for AHU-1 and -2, but the OAT sensor used (AI 2, OA Temperature)
is not trended. This is a secondary OA sensor for AHU-1 and AHU-2, which use
AHU-1 OAT sensor as a primary OAT sensor. If we decide to use OA Temp AI0 trend
as a substitute, the PI controller enable signal may not be identical as the one
that generated the trended outputs.



Implementation notes, issues and assumptions:

PI Controller

- OBC reverse and direct action are in reverse compared to the ALC controller
(e.g. if setpoint is lower than the measurement )

- ALC has a proprietary PI controller algorithm. Proportional and integral
gains, as read from the ALC control logic diagram do not seem to correspond
the OBC PI controller parameters. Assuming that the proportional gain is
the same, well matched performance can be achieved only by scaling the
integral gain up by several orders of magnitude. *mg?
- OAT not directly trended, one could substitute with OAT AI0 or
AHU-1 OAT sensor


Memo
- It proved correct that TSupSetHea is TSupSet - 1 F
- ALC controller seems to sample each 10s and at each sampling instance it adds 10% of the total proportional addend as the integral addend,
so assuming that we set k_controller_gain_cdl = kp_alc ==> k_controller_gain_cdl/Ti_cdl = ki_alc/10 ==> Ti_cdl = 10 * k_controller_gain_cdl / ki_alc, with, for heating,
kp_alc = 5, ki_alc = .5
