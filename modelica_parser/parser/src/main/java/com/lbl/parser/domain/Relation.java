package com.lbl.parser.domain;

/**
 * Created by JayHu on 07/21/2017
 */
public class Relation {
    private Arithmetic_expression expression1;
    private Rel_op rel_op;
    private Arithmetic_expression expression2;

    public Relation(Arithmetic_expression arithmetic_expression1,
                    Rel_op rel_op,
                    Arithmetic_expression arithmetic_expression2) {
      this.expression1 = arithmetic_expression1;
      this.rel_op = rel_op;
      this.expression2 = arithmetic_expression2;
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Relation aRelation = (Relation) o;
      return expression1 != null ? expression1.equals(aRelation.expression1) : aRelation.expression1 == null;
    }

    @Override
    public int hashCode() {
      int result = expression1 != null ? expression1.hashCode() : 0;
      result = 31 * result + (rel_op != null ? rel_op.hashCode() : 0);
      result = 31 * result + (expression2 != null ? expression2.hashCode() : 0);
      return result;
    }

    @Override
    public String toString() {
      return "Relation{" +
              "\nexpression1=" + expression1 + '\'' +
              "\noperator=" + rel_op + '\'' +
              "\nexpression2=" + expression2 + '\'' +
              '}';
    }
}
