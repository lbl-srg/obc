package com.lbl.parser.domain;


/**
 * Created by JayHu on 07/21/2017
 */
public class Declaration {
    private String name;
    private Array_subscripts array_subscripts;
    private Modification modification;

    public Declaration(String ident,
                       Array_subscripts array_subscripts,
                       Modification modification) {
      this.name = ident;
      this.array_subscripts = (array_subscripts == null ? null : array_subscripts);
      this.modification = (modification == null ? null : modification);
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Declaration aDeclaration = (Declaration) o;
      if (name != null ? !name.equals(aDeclaration.name) : aDeclaration.name != null) return false;
      if (array_subscripts != null ? !array_subscripts.equals(aDeclaration.array_subscripts) : aDeclaration.array_subscripts != null) return false;
      return modification != null ? modification.equals(aDeclaration.modification) : aDeclaration.modification == null;
    }

    @Override
    public int hashCode() {
      int result = name != null ? name.hashCode() : 0;
      result = 31 * result + (array_subscripts != null ? array_subscripts.hashCode() : 0);
      result = 31 * result + (modification != null ? modification.hashCode() : 0);
      return result;
    }

    @Override
    public String toString() {
      return "Declaration{" +
              "\nname=" + name + '\'' +
              "\narray_subscripts=" + array_subscripts + '\'' +
              "\nmodification=" + modification + '\'' +
              '}';
    }
}
