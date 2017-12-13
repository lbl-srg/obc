package com.lbl.parser.domain;

/**
 * Created by JayHu on 07/21/2017
 */
public class Component_declaration {
    private Declaration declaration;
    private Condition_attribute condition_attribute;
    private Comment comment;

    public Component_declaration(Declaration declaration,
                                 Condition_attribute condition_attribute,
                                 Comment comment) {
      this.declaration = declaration;
      this.condition_attribute = (condition_attribute == null ? null : condition_attribute);
      this.comment = comment;
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Component_declaration aComponent_declaration = (Component_declaration) o;
      if (declaration != null ? !declaration.equals(aComponent_declaration.declaration) : aComponent_declaration.declaration != null) return false;
      if (comment != null ? !comment.equals(aComponent_declaration.comment) : aComponent_declaration.comment != null) return false;
      return comment != null ? comment.equals(aComponent_declaration.comment) : aComponent_declaration.comment == null;
    }

    @Override
    public int hashCode() {
      int result = declaration != null ? declaration.hashCode() : 0;
      result = 31 * result + (condition_attribute != null ? condition_attribute.hashCode() : 0);
      result = 31 * result + (comment != null ? comment.hashCode() : 0);
      return result;
    }

    @Override
    public String toString() {
      return "Component_declaration{" +
              "\ndeclaration=" + declaration + '\'' +
              "\ncondition_attribute=" + condition_attribute + '\'' +
              "\ncomment=" + comment + '\'' +
              '}';
    }
}
