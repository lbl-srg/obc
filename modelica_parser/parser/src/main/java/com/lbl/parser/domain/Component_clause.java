package com.lbl.parser.domain;

/**
 * Created by JayHu on 07/21/2017
 */
public class Component_clause {
    private Type_prefix type_prefix;
    private Type_specifier type_specifier;
    private Array_subscripts array_subscripts;
    private Component_list component_list;

    public Component_clause(Type_prefix type_prefix,
                            Type_specifier type_specifier,
                            Array_subscripts array_subscripts,
                            Component_list component_list) {
      this.type_prefix = type_prefix;
      this.type_specifier = type_specifier;
      this.array_subscripts = (array_subscripts==null ? null : array_subscripts);
      this.component_list = component_list;
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Component_clause aComponent_clause = (Component_clause) o;
      if (type_prefix != null ? !type_prefix.equals(aComponent_clause.type_prefix) : aComponent_clause.type_prefix != null) return false;
      if (type_specifier != null ? !type_specifier.equals(aComponent_clause.type_specifier) : aComponent_clause.type_specifier != null) return false;
      if (component_list != null ? !component_list.equals(aComponent_clause.component_list) : aComponent_clause.component_list != null) return false;
      return array_subscripts != null ? array_subscripts.equals(aComponent_clause.array_subscripts) : aComponent_clause.array_subscripts == null;
    }

    @Override
    public int hashCode() {
      int result = type_prefix != null ? type_prefix.hashCode() : 0;
      result = 31 * result + (type_specifier != null ? type_specifier.hashCode() : 0);
      result = 31 * result + (array_subscripts != null ? array_subscripts.hashCode() : 0);
      result = 31 * result + (component_list != null ? component_list.hashCode() : 0);
      return result;
    }

    @Override
    public String toString() {
      return "Component_clause{" +
              "\ntype_prefix=" + type_prefix + '\'' +
              "\ntype_specifier=" + type_specifier + '\'' +
              "\narray_subscripts=" + array_subscripts + '\'' +
              "\ncomponent_list=" + component_list + '\'' +
              '}';
    }
}
