package com.lbl.parser.domain;

/**
 * Created by JayHu on 07/21/2017
 */
public class Equation {
    private Simple_expression simple_expression;
    private String operator;
    private Expression expression;
    private If_equation if_equation;
    private For_equation for_equation;
    private Connect_clause connect_clause;
    private When_equation when_equation;
    private Name name;
    private Function_call_args function_call_args;
    private Comment comment;

    public Equation(Simple_expression simple_expression,
                    Expression expression,
                    If_equation if_equation,
                    For_equation for_equation,
                    Connect_clause connect_clause,
                    When_equation when_equation,
                    Name name,
                    Function_call_args function_call_args,
                    Comment comment) {
      this.simple_expression = simple_expression;
      this.operator = (simple_expression==null ? null : "=");
      this.expression = expression;
      this.if_equation = if_equation;
      this.for_equation = for_equation;
      this.connect_clause = connect_clause;
      this.when_equation = when_equation;
      this.name = name;
      this.function_call_args = function_call_args;
      this.comment = comment;
    } 
    
    
    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Equation aEquation = (Equation) o;
      if (comment != null ? !comment.equals(aEquation.comment) : aEquation.comment != null) return false;
      return ((simple_expression != null ? simple_expression.equals(aEquation.simple_expression) : aEquation.simple_expression == null)
             || (if_equation != null ? if_equation.equals(aEquation.if_equation) : aEquation.if_equation == null)
             || (for_equation != null ? for_equation.equals(aEquation.for_equation) : aEquation.for_equation == null)
             || (connect_clause != null ? connect_clause.equals(aEquation.connect_clause) : aEquation.connect_clause == null)
             || (when_equation != null ? when_equation.equals(aEquation.when_equation) : aEquation.when_equation == null)
             || (name != null ? name.equals(aEquation.name) : aEquation.name == null));
    }

    @Override
    public int hashCode() {
      int result = simple_expression != null ? simple_expression.hashCode() : 0;
      result = 31 * result + (expression != null ? expression.hashCode() : 0);
      result = 31 * result + (if_equation != null ? if_equation.hashCode() : 0);
      result = 31 * result + (for_equation != null ? for_equation.hashCode() : 0);
      result = 31 * result + (connect_clause != null ? connect_clause.hashCode() : 0);
      result = 31 * result + (when_equation != null ? when_equation.hashCode() : 0);
      result = 31 * result + (name != null ? name.hashCode() : 0);
      result = 31 * result + (function_call_args != null ? function_call_args.hashCode() : 0);
      result = 31 * result + (comment != null ? comment.hashCode() : 0);
      return result;
    }

    @Override
    public String toString() {
      return "Equation{" +
             "\nsimple_expression=" + simple_expression + '\'' + 
             "\noperator=" + operator + '\'' +
             "\nexpression=" + expression + '\'' +
             "\nif_equation=" + if_equation + '\'' +
             "\nfor_equation=" + for_equation + '\'' +
             "\nconnect_clause=" + connect_clause + '\'' +
             "\nwhen_equation=" + when_equation + '\'' +
             "\nname=" + name + '\'' +
             "\nfunction_call_args=" + function_call_args + '\'' +
             "\ncomment=" + comment + '\'' +
             '}';
    }
}
