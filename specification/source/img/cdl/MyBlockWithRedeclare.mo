model MyBlockWithRedeclare
  extends SomeCompositeBlock(
    redeclare Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPID);

end MyBlockWithRedeclare;