package com.lbl.parser.domain;

/**
 * Created by JayHu on 07/21/2017
 */
public class Constraining_clause {
    private Name name;
    private Class_modification class_modification;

    public Constraining_clause(String constrain_dec,
                               Name name,
                               Class_modification class_modification) {
      this.name = name;
      this.class_modification = (class_modification == null ? null : class_modification);
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Constraining_clause aConstraining_clause = (Constraining_clause) o;
      if (name != null ? !name.equals(aConstraining_clause.name) : aConstraining_clause.name != null) return false;
      return class_modification != null ? class_modification.equals(aConstraining_clause.class_modification) : aConstraining_clause.class_modification == null;
    }

    @Override
    public int hashCode() {
      int result = name != null ? name.hashCode() : 0;
      result = 31 * result + (class_modification != null ? class_modification.hashCode() : 0);
      return result;
    }

    @Override
    public String toString() {
      return "Constrainedby{" +              
              "\nname=" + name + '\'' +
              "\nclass_modification=" + class_modification + '\'' +
              '}';
    }
}
