package ReplaceableExample
  block ReplaceableBlock
    replaceable Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=1)
      constrainedby Buildings.Controls.OBC.CDL.Reals.Sources.CivilTime
     "Replaceable block, constrained by a block that imposes as a requirement 
     that the redeclaration provides a block with output y (but no parameter k is needed)";
  end ReplaceableBlock;

  block MyNewBlock "Composite block, with sou replaced by a Pulse with period=0.1"
    ReplaceableBlock repBlo(
      redeclare Buildings.Controls.OBC.CDL.Reals.Sources.Pulse con(period=0.1));
  end MyNewBlock;
  annotation (
    uses(Buildings(version = "11.0.0")));
end ReplaceableExample;
