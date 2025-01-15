package MultipleExtends

  block A0
    extends Buildings.Controls.OBC.CDL.Reals.Sources.Constant(k=0);
  end A0;

  block A1
    extends Buildings.Controls.OBC.CDL.Reals.Sources.Constant(k=1);
  end A1;

  block NotValid "Block that is not valid"
    extends A0;
    extends A1;
  end NotValid;

  annotation(
    uses(Buildings(version = "12.0.0")),
    Documentation(
      info = "<p>
Package with a block that is not valid CDL due to multiple extends statements.
</p>"));

end MultipleExtends;