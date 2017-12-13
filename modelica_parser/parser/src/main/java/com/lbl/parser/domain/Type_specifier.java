package com.lbl.parser.domain;

/**
 * Created by JayHu on 07/21/2017
 */
public class Type_specifier {
    private Name specifier;

    public Type_specifier(Name name) {
      this.specifier = name;
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Type_specifier aType_specifier = (Type_specifier) o;
      return specifier != null ? specifier.equals(aType_specifier.specifier) : aType_specifier.specifier == null;
    }

    @Override
    public int hashCode() {
      int result = specifier != null ? specifier.hashCode() : 0;
      return result;
    }

    @Override
    public String toString() {
      return "Type_specifier{" +
              "\nspecifier=" + specifier + '\'' +
              '}';
    }
}
