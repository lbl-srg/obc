package com.lbl.parser.domain;

import java.util.Collection;

/**
 * Created by JayHu on 07/21/2017
 */
public class For_statement {
    private For_indices loop_indices;
    private Collection<Statement> loop_statements;

    public For_statement(For_indices for_indices,
                         Collection<Statement> statement) {
      this.loop_indices = for_indices;
      this.loop_statements = (statement.size()>0 ? statement : null);
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      For_statement aFor_statement = (For_statement) o;

      if (loop_indices != null ? !loop_indices.equals(aFor_statement.loop_indices) : aFor_statement.loop_indices != null) return false;
      return loop_statements != null ? loop_statements.equals(aFor_statement.loop_statements) : aFor_statement.loop_statements == null;
    }

    @Override
    public int hashCode() {
      int result = loop_indices != null ? loop_indices.hashCode() : 0;
      result = 31 * result + (loop_statements != null ? loop_statements.hashCode() : 0);
      return result;
    }

    @Override
    public String toString() {
      return "For_statement{" +
              "\nloop_indices=" + loop_indices + '\'' +
              "\nloop_statements=" + loop_statements + '\'' +
              '}';
    }
}
