block ConditionalMax
  "Maximum between two inputs with one of them could be conditional removed"
  parameter Boolean u2_present = true "Flag to indicate if second input presents";
  Interfaces.RealInput u1 "Real input"
    annotation (...);
  Interfaces.RealInput u2 if u2_present "Real input"
    annotation (...);
  Interfaces.RealOutput y "Real output"
    annotation (...);
protected
  Interfaces.RealInput u_internal "Internal input needed to connect to conditional connector";
equation
  connect(u_internal, u2);
  if not u2_present then
    u_internal = 0;
  end if;
  y = if u2_present then max(u1, u_internal) else u1;
  annotation (...);
end ConditionalMax;
