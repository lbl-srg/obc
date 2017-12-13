package com.lbl.parser.domain;

import java.util.Collection;

/**
 * Created by JayHu on 07/21/2017
 */
public class Composition {
    private String external;
    private Collection<String> pub;
    private Collection<String> protect;
    private Element_list element_list;
    private Collection<Element_list> prefixed_element;
    private Collection<Equation_section> equation_section;
    private Collection<Algorithm_section> algorithm_section;
    private Language_specification language_specification;
    private External_function_call external_function_call;
    private Annotation ext_annotation;
    private Annotation comp_annotation;

    public Composition(String ext_dec,
                       Collection<String> public_dec,
                       Collection<String> protected_dec,
                       Element_list element_list1,
                       Collection<Element_list> element_list2,
                       Collection<Equation_section> equation_section,
                       Collection<Algorithm_section> algorithm_section,
                       Language_specification language_specification,
                       External_function_call external_function_call,
                       Annotation annotation1,
                       Annotation annotation2) {
    	this.element_list = element_list1;
    	this.pub = (public_dec.size()==0 ? null : public_dec);
    	this.protect = (protected_dec.size()==0 ? null : protected_dec);
    	this.prefixed_element = (element_list2==null ? null : element_list2);
    	this.equation_section = (equation_section.size()==0 ? null : equation_section);
    	this.algorithm_section = (algorithm_section.size()==0 ? null : algorithm_section);
    	this.external = ext_dec;
    	this.language_specification = language_specification;
        this.external_function_call = external_function_call;
        this.ext_annotation = annotation1;
        this.comp_annotation = annotation2;
    }  
    
    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Composition aComposition = (Composition) o;
//      if (final_dec != null ? !final_dec.equals(aStored_definition.final_dec) : aStored_definition.final_dec != null) return false;
//      return name != null ? name.equals(aStored_definition.name) : aStored_definition.name == null;
      return element_list != null ? element_list.equals(aComposition.element_list) : aComposition.element_list == null;
    }

    @Override
    public int hashCode() {
      int result = element_list != null ? element_list.hashCode() : 0;
      result = 31 * result + (pub != null ? pub.hashCode() : 0);
      result = 31 * result + (protect != null ? protect.hashCode() : 0);
      result = 31 * result + (prefixed_element != null ? prefixed_element.hashCode() : 0);
      result = 31 * result + (equation_section != null ? equation_section.hashCode() : 0);
      result = 31 * result + (algorithm_section != null ? algorithm_section.hashCode() : 0);
      result = 31 * result + (external != null ? external.hashCode() : 0);
      result = 31 * result + (language_specification != null ? language_specification.hashCode() : 0);
      result = 31 * result + (external_function_call != null ? external_function_call.hashCode() : 0);
      result = 31 * result + (ext_annotation != null ? ext_annotation.hashCode() : 0);
      result = 31 * result + (comp_annotation != null ? comp_annotation.hashCode() : 0);
      return result;
    }

    @Override
    public String toString() {   
      return "Composition{" +
             "\nelement_list=" + element_list + '\'' +
             "\npublic=" + pub + '\'' +
             "\nprotect=" + protect + '\'' +
             "\nprefixed_element=" + prefixed_element + '\'' +
             "\nequation_section=" + equation_section + '\'' +
             "\nalgorithm_section=" + algorithm_section + '\'' +
             "\nexternal=" + external + '\'' +
             "\nlanguage_specification=" + language_specification + '\'' +
             "\nexternal_function_call=" + external_function_call + '\'' +
             "\next_annotation=" + ext_annotation + '\'' +
             "\ncomp_annotation=" + comp_annotation + '\'' +
             '}';
    }
}
