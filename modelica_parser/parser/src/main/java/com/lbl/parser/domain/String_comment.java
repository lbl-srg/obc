package com.lbl.parser.domain;

import java.util.Collection;

/**
 * Created by JayHu on 07/21/2017
 */
public class String_comment {
    private Collection<String> string;

    public String_comment(Collection<String> str_dec) {
      this.string = (str_dec.size()>0 ? str_dec : null);
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      String_comment aString_comment = (String_comment) o;
      return string != null ? string.equals(aString_comment.string) : aString_comment.string == null;
    }

    @Override
    public int hashCode() {
      int result = string != null ? string.hashCode() : 0;
      return result;
    }

    @Override
    public String toString() {
      return "String_comment{" +
             "\nstring=" + string + '\'' +
             '}';     
    }
}
