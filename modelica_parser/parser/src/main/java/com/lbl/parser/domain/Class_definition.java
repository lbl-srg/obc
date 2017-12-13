package com.lbl.parser.domain;

/**
 * Created by JayHu on 07/21/2017
 */
public class Class_definition {
    private String encapsulated;
    private Class_prefixes class_prefixes;
    private Class_specifier class_specifier;

    public Class_definition(String enca_dec,
                            Class_prefixes class_prefixes,
                            Class_specifier class_specifier) {
      this.encapsulated = (enca_dec == null ? null : enca_dec);
      this.class_prefixes = class_prefixes;
      this.class_specifier = class_specifier;
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Class_definition aClass_definition = (Class_definition) o;
      if(class_prefixes != null ? !class_prefixes.equals(aClass_definition.class_prefixes) : aClass_definition.class_prefixes != null) return false;
      if(class_specifier != null ? !class_specifier.equals(aClass_definition.class_specifier) : aClass_definition.class_specifier != null) return false;
      return encapsulated != null ? encapsulated.equals(aClass_definition.encapsulated) : aClass_definition.encapsulated == null;
    }

    @Override
    public int hashCode() {
      int result = encapsulated != null ? encapsulated.hashCode() : 0;
      result = 31 * result + (class_prefixes != null ? class_prefixes.hashCode() : 0);
      result = 31 * result + (class_specifier != null ? class_specifier.hashCode() : 0);
      return result;
    }

    @Override
    public String toString() {
      return "Class_definition{" +
              "\nencapsulated=" + encapsulated + '\'' +
              "\nclass_prefixes=" + class_prefixes + '\'' +
              "\nclass_specifier=" + class_specifier + '\'' +
              '}';
    }
}
