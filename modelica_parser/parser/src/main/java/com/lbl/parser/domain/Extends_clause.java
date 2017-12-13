package com.lbl.parser.domain;


/**
 * Created by JayHu on 07/21/2017
 */
public class Extends_clause {
    private Name name;
    private Class_modification class_modification;
    private Annotation annotation;

    public Extends_clause(String ext_dec,
                          Name name,
                          Class_modification class_modification,
                          Annotation annotation) {
      this.name = name;
      this.class_modification = (class_modification == null ? null : class_modification);
      this.annotation  = (annotation == null ? null : annotation);
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Extends_clause aExtends_clause = (Extends_clause) o;
      return name != null ? name.equals(aExtends_clause.name) : aExtends_clause.name == null;
    }

    @Override
    public int hashCode() {
      int result = name != null ? name.hashCode() : 0;
      result = 31 * result + (class_modification != null ? class_modification.hashCode() : 0);
      result = 31 * result + (annotation != null ? annotation.hashCode() : 0);
      return result;
    }

    @Override
    public String toString() {
      return "Extends_clause{" +
             "\nname=" + name + '\'' +
             "\nclass_modification=" + class_modification + '\'' +
             "\nannotation=" + annotation + '\'' +
             '}';
    }
}
