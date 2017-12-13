package com.lbl.parser.domain;

/**
 * Created by JayHu on 07/21/2017
 */
public class Comment {
    private String_comment comment;
    private Annotation annotation;

    public Comment(String_comment string_comment,
                   Annotation annotation) {
      this.comment = string_comment;
      this.annotation = (annotation == null ? null : annotation);
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Comment aComment = (Comment) o;
      if (comment != null ? !comment.equals(aComment.comment) : aComment.comment != null) return false;
      return annotation != null ? annotation.equals(aComment.annotation) : aComment.annotation == null;
    }

    @Override
    public int hashCode() {
      int result = comment != null ? comment.hashCode() : 0;
      result = 31 * result + (annotation != null ? annotation.hashCode() : 0);
      return result;
    }

    @Override
    public String toString() {
      return "Comment{" +
              "\ncomment=" + comment + '\'' +
              "\nannotation=" + annotation + '\'' +
              '}';
    }
}
