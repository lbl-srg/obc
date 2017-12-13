package com.lbl.parser.domain;

/**
 * Created by JayHu on 07/21/2017
 */
public class Mul_op {
    private String mul_op;

    public Mul_op(String ope_dec) {
      this.mul_op = ope_dec;
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Mul_op aMul_op = (Mul_op) o;
      return mul_op != null ? mul_op.equals(aMul_op.mul_op) : aMul_op.mul_op == null;
    }

    @Override
    public int hashCode() {
      int result = mul_op != null ? mul_op.hashCode() : 0;
      return result;
    }

    @Override
    public String toString() {
      return "Mul_op{" +
              "\nmul_op=" + mul_op + '\'' +
              '}';
    }
}
