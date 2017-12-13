package com.lbl.parser.domain;

/**
 * Created by JayHu on 07/21/2017
 */
public class Modification {
    private Class_modification class_modification;
    private String symbol;
    private Expression expression;

    public Modification(Class_modification class_modification,
    					String eqSymb,
    					String colEqSymb,
                        Expression expression) {
      this.class_modification = class_modification;   
      this.symbol = 
    		  (eqSymb == null && colEqSymb == null) ? null : (eqSymb != null ? "=" : ":=");
      this.expression = expression;
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Modification aModification = (Modification) o;
      return class_modification != null ? class_modification.equals(aModification.class_modification) : aModification.class_modification == null;
    }

    @Override
    public int hashCode() {
      int result = class_modification != null ? class_modification.hashCode() : 0;
      result = 31 * result + (symbol != null ? symbol.hashCode() : 0);
      result = 31 * result + (expression != null ? expression.hashCode() : 0);
      return result;
    }

    @Override
    public String toString() {
      return "Modification{" +
              "\nclass_modification=" + class_modification + '\'' +
              "\nsymbol=" + symbol + '\'' +
              "\nexpression=" + expression + '\'' +
              '}';
    }
}
