.. _sec_seq_doc:

Documentation of Control Sequences
----------------------------------

Introduction
^^^^^^^^^^^^

This section describes how to generate a control sequence description
based on a CDL specification.

There are two distinct situations:

  1. The control sequence could be from
     a publication such as ASHRAE Guideline 36 for which a Microsoft Word
     version exists, or
  2. The control sequence could be for a sequence that only exists in CDL.

The approach for 1. is currently being developed.
Approach 2 is described in :numref:`sec_seq_doc_cdl`.

Editing a Sequence that is Specified in a Word Document
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This is currently being specified and will be added later.


.. _sec_seq_doc_cdl:

Exporting the Control Logic from a CDL Model
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This section describes how a English language description of a sequence could be exported
from the CDL implementation.
This will allow developers and users to build libraries of control sequences
for which an English language specification can be exported without having to have
a template Word document (which generally does not exist for this use case).

Two different representations will be supported:

1. *Specifications for sequences of operations.* These specifications expresses the intent of the designer for the sequence.
   They contain text in the form of requirements, such
   as "The room temperature shall be maintained between ...".
   Such requirements leave room for different interpretations and resulting implementations of the control inputs
   and outputs, and the control logic,
   thereby making verification as in :numref:`sec_aut_con_ver` impractical.
   It also risk that the sequences do not satisfy the designer's intent.
   However, if encoded in a library that has been tested, the control sequence can be specified more precise.
2. *Documentation of the as-implemented sequences.* These typically serve the operator, and may contain text such as
   "The controller tracks the room temperature set point by ...".
   This type of formulation is also what is typically used to document the implementation of sequences in
   the Modelica Buildings Library.

Control sequences of the form 1) typically contain additional requirements
that are not part of the sequence description, such as what energy code to follow.
Such information can however be included in a section that precedes or
follows the actual sequence implementation.
Thus, the here described export
will document only the sequences, which can then be combined with these other documentation.

To export sequence specifications of the form 1), we introduce a new optional annotation
``annotation(__CDL(SequenceSpecification(info=STRING)))``
where ``STRING`` is an html formatted string that contains the sequence specification.
E.g., the annotation is in the same format as the CDL annotation
``annotation(Documentation(info=STRING)``.
The new optional annotation is introduced solely for the purpose that in the buildings industry,
control specifications use a different form than what is usually used in Modelica, i.e., to address
the differences between 1) and 2) above.
I.e., Modelica documentation describe what a sequence does, whereas for sequence specifications,
the sequence description must follow the structure dictated by the
Construction Specification Institute (CSI) and the American Institute of Architects (AIA)
because they become legal documents.

How to generate the sequence description that can be inserted into these construction
documents is described using a small example.
Consider the model
`Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingCooling <https://github.com/lbl-srg/modelica-buildings/blob/v8.1.0/Buildings/ThermalZones/EnergyPlus/Examples/SingleFamilyHouse/RadiantHeatingCooling.mo>`_.
This model has two sequences,
one for the radiant heating and one for the radiant cooling. These two sequences
are described in
`Buildings.Controls.OBC.RadiantSystems.Heating.HighMassSupplyTemperature_TRoom <https://github.com/lbl-srg/modelica-buildings/blob/v8.1.0/Buildings/Controls/OBC/RadiantSystems/Heating/HighMassSupplyTemperature_TRoom.mo#L238>`_
and in
`Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum <https://github.com/lbl-srg/modelica-buildings/blob/v8.1.0/Buildings/Controls/OBC/RadiantSystems/Cooling/HighMassSupplyTemperature_TRoomRelHum.mo#L273>`_
using html format.

To export sequences from these models, ``modelica-json`` will need to generate a
Microsoft Word document using the following procedure.

1. Read the top-level Modelica file and extract each block that is
   in the package ``Buildings.Controls.OBC``. Put the names of these blocks in a list.
2. Remove from this list all blocks that are in ``Buildings.Controls.OBC.CDL``.
   (These are are elementary blocks that need not be documented.)
3. Read the top-level Modelica file and extract all blocks that contain in their class
   definition the annotation ``__cdl(document=true)``. Add these blocks to the list.
   (This will allow users to add composite control blocks that will be documented.)
4. For each block in the list.

     a. If the block contains a section ``annotation(__CDL(SequenceSpecification(info=STRING)))``,
        use the value of this section as the sequence documentation of this block. Goto step d).

     b. If the block contains a section ``annotation(Documentation(info=STRING))``,
        write a warning that this block will be documented with as-implemented description rather than
        a sequence specification as no control sequence specification has been found, and
        use the value of this section as the sequence documentation of this block. Goto step d).

     c. Issue a warning that this block contains no control sequence description and proceed to
        the next block.

     d. In the sequence description of this block, for each parameter that is in the description,
        add the value and units. For example, an entry such as
        ``... between <code>TSupSetMin</code> and <code>TSupSetMax</code> based on ...``
        becomes
        ``... between <code>TSupSetMin</code> (=20&deg; adjustable) and <code>TSupSetMax</code> (=40&deg; adjustable) based on ...``.
        Note that the word "adjustable" must not be added if the parameter value is declared as ``final``.
        Proceed to the next block.

5. Collect the descriptions of each block and output it in a Word document. Configure the Word document to have automatic section numbering.

As an example, consider the following snippet of a composite control block.

.. code-block::

   HighMassSupplyTemperature_TRoom con(TSubSet_max=303.15, final TSubSet_min=293.15);

   block HighMassSupplyTemperature_TRoom
     "Room temperature controller for radiant heating with constant mass flow and variable supply temperature"

      parameter Real TSupSet_max(
        final unit="K",
        displayUnit="degC") "Maximum heating supply water temperature";
      parameter Real TSupSet_min(
        final unit="K",
        displayUnit="degC") = 293.15 "Minimum heating supply water temperature";

      parameter Controls.OBC.CDL.Types.SimpleController
        controllerType = Buildings.Controls.OBC.CDL.Types.SimpleController.P
        "Type of controller" annotation (Dialog(group="Control gains"));

      ... [omitted]

      annotation(
        Documentation(
          info="<html>
            <p>
            Controller for a radiant heating system.
            </p>
            <p>
            The controller tracks the room temperature set point <code>TRooSet</code> by
            adjusting the supply water temperature set point <code>TSupSet</code> linearly between
            <code>TSupSetMin</code> and <code>TSupSetMax</code>

            PI-controller likely saturate due to the slow system response.
            </p>
            </html>"
          ),
          __cdl(
            SequenceSpecification(
              info="<html>
                <p>
                Controller for a radiant heating system.
                </p>
                <p>
                The controller shall track the room temperature set point by
                adjusting the supply water temperature set point <code>TSupSet</code> linearly between
                <code>TSupSetMin</code> and <code>TSupSetMax</code>
                based on the output signal of the proportional controller.
                The pump shall be either off or be operating at full speed, in which case <code>yPum = 1</code>.
                The pump control shall be based on a hysteresis that switches the pump on when the output of the
                proportional controller <code>y</code> exceeds <i>0.2</i>, and the pump shall be commanded off when the output falls
                below <i>0.1</i>. See figure below for the control charts.
                </p>
                <p align="center">
                <img alt="Image of control output"
                src="modelica://Buildings/Resources/Images/Controls/OBC/RadiantSystems/Heating/HighMassSupplyTemperature_TRoom.png"/>
                </p>
                <p>
                <-- cdl(visible=(not (controllerType is final))) or controllerType <> CDL.Types.SimpleController.P -->
                <b>Note:</b>
                For systems with high thermal mass, this controller should be left configured
                as a P-controller, which is the default setting.
                PI-controller likely saturate due to the slow system response.
                </p>
                <-- end cdl -->
              </html>"
           )
        )
      );
   end HighMassSupplyTemperature_TRoom;

For this control block, ``modelica-json`` will produce content for the Word description that looks like

   "The controller shall track the room temperature set point by
   adjusting the supply water temperature set point ``TSupSet`` linearly between
   ``TSupSetMin`` (:math:`=20^\circ`) and ``TSupSetMax`` (:math:`=30^\circ` adjustable)
   based on the output signal of the proportional controller..."

``modelica-json`` will remove the notice at the end of the sequence description
if the ``controllerType`` is
declared as ``final`` (because then, no other choice can be made).
Through this mechanism, sections and images can be removed or enabled in the generated
sequence description.

To use IP units, ``modelica-json`` will have a configuration that specifies what units should be used.
The documentation will also include the figure as declared in the CDL specification.


The Control Sequence Selection and Configuration tool could make the section
``annotation(__CDL(SequenceSpecification(info=STRING)))`` editable, thereby allowing
users to customize the description of the sequence and add any other desired documentation.