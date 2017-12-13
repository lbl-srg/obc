package com.lbl.parser.domain;

import java.util.Collection;

/**
 * Created by JayHu on 07/21/2017
 */
public class Connect_clause {
    private Collection<Component_reference> component;

    public Connect_clause(Collection<Component_reference> component_reference) {
      this.component = (component_reference.size() > 0 ? component_reference : null);
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Connect_clause aConnect_clause = (Connect_clause) o;
      return component != null ? component.equals(aConnect_clause.component) : aConnect_clause.component == null;
    }

    @Override
    public int hashCode() {
      int result = component != null ? component.hashCode() : 0;
      return result;
    }

    @Override
    public String toString() {
      return "Connect_clause{" +
              "\ncomponent=" + component + '\'' +
              '}';
    }
}
