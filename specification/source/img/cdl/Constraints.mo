model Constraints
  record BaseRecord
    parameter Integer param=0;
  end BaseRecord;

  record Record
    extends BaseRecord(final param=1);
  end Record;

  model Model
    parameter Integer param=2;
    // OpenModelica errors because param is declared final
    replaceable parameter BaseRecord rec constrainedby BaseRecord(param=param);
  end Model;

  // Overriding by param=param from the constraining clause:
  // OpenModelica and Dymola errors,
  // Modelon OPTIMICA evaluates to 2.
  Model component1(redeclare Record rec);

   // Precedence of declaration over constraining clause from
   // https://specification.modelica.org/maint/3.5/inheritance-modification-and-redeclaration.html#constraining-type:
   // Dymola and Modelon OPTIMICA return 1.
  Model component2(rec(final param=1));

  // Precedence of declaration over constraining clause: Dymola and OCT return 1.
  Model component3(rec=Record());
end Constraints;