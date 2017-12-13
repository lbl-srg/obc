package com.lbl.parser.parser;

import com.lbl.antlr4.visitor.modelicaBaseVisitor;
import com.lbl.antlr4.visitor.modelicaLexer;
import com.lbl.antlr4.visitor.modelicaParser;

import com.lbl.parser.domain.*;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.misc.NotNull;

import java.util.List;

import static java.util.stream.Collectors.toList;

import java.util.ArrayList;

/**
 * Created by JayHu on 07/21/2017
 */
public class VisitorOrientedParser implements Parser {

    public Stored_definition parse(String modelicaSourceCode) {
        CharStream charStream = new ANTLRInputStream(modelicaSourceCode);
        modelicaLexer lexer = new modelicaLexer(charStream);
        TokenStream tokens = new CommonTokenStream(lexer);
        modelicaParser parser = new modelicaParser(tokens);

        Stored_definitionVisitor stored_definitionVisitor = new Stored_definitionVisitor();
        Stored_definition traverseResult = stored_definitionVisitor.visit(parser.stored_definition());
        return traverseResult;
    }

    private static class Stored_definitionVisitor extends modelicaBaseVisitor<Stored_definition> {
      @Override
      public Stored_definition visitStored_definition(@NotNull modelicaParser.Stored_definitionContext ctx) {
        List<String> within_dec = ctx.WITHIN() == null ? null : ctx.WITHIN()           		
                .stream() 
                .map(WITHIN -> WITHIN.getText())
                .collect(toList());
        NameVisitor nameVisitor = new NameVisitor();
        List<Name> names = ctx.name() == null ? null : ctx.name()
                .stream()
                .map(name -> name.accept(nameVisitor))
                .collect(toList());
        List<String> final_dec = ctx.FINAL() == null ? null : ctx.FINAL()
                .stream()
                .map(FINAL -> FINAL.getText())
                .collect(toList());
        Class_definitionVisitor class_definitionVisitor = new Class_definitionVisitor();
        List<Class_definition> class_definitions = ctx.class_definition()
                .stream()
                .map(class_definition -> class_definition.accept(class_definitionVisitor))
                .collect(toList());
        return new Stored_definition(within_dec, final_dec, names, class_definitions);
      }
    }

    private static class Class_definitionVisitor extends modelicaBaseVisitor<Class_definition> {
      @Override
      public Class_definition visitClass_definition(@NotNull modelicaParser.Class_definitionContext ctx) {
        String enca_dec = ctx.ENCAPSULATED() == null ? null : ctx.ENCAPSULATED().getText();       
        Class_prefixesVisitor class_prefixesVisitor = new Class_prefixesVisitor();
        Class_prefixes class_prefixes_1 = ctx.class_prefixes().accept(class_prefixesVisitor);
        Class_specifierVisitor class_specifierVisitor = new Class_specifierVisitor();
        Class_specifier class_specifier_1 = ctx.class_specifier().accept(class_specifierVisitor);
        return new Class_definition(enca_dec, class_prefixes_1, class_specifier_1);
      }
    }

    private static class Class_specifierVisitor extends modelicaBaseVisitor<Class_specifier> {
      @Override
      public Class_specifier visitClass_specifier(@NotNull modelicaParser.Class_specifierContext ctx) {
        Long_class_specifierVisitor long_class_specifierVisitor = new Long_class_specifierVisitor();
        Long_class_specifier long_class_specifier_1 = 
        		ctx.long_class_specifier() == null ? null : ctx.long_class_specifier().accept(long_class_specifierVisitor);
        Short_class_specifierVisitor short_class_specifierVisitor = new Short_class_specifierVisitor();
        Short_class_specifier short_class_specifier_1 = 
        		ctx.short_class_specifier() == null ? null : ctx.short_class_specifier().accept(short_class_specifierVisitor);
        Der_class_specifierVisitor der_class_specifierVisitor = new Der_class_specifierVisitor();
        Der_class_specifier der_class_specifier_1 = 
        		ctx.der_class_specifier() == null ? null : ctx.der_class_specifier().accept(der_class_specifierVisitor);
        return new Class_specifier(long_class_specifier_1, short_class_specifier_1, der_class_specifier_1);
      }
    }

    private static class Class_prefixesVisitor extends modelicaBaseVisitor<Class_prefixes> {
      @Override
      public Class_prefixes visitClass_prefixes(@NotNull modelicaParser.Class_prefixesContext ctx) {
        String partial_dec = 
        		ctx.PARTIAL() == null ? null : ctx.PARTIAL().getText();
        String class_dec = 
        		ctx.CLASS() == null ? null : ctx.CLASS().getText();
        String model_dec = 
        		ctx.MODEL() == null ? null : ctx.MODEL().getText();
        String block_dec = 
        		ctx.BLOCK() == null ? null : ctx.BLOCK().getText();
        String type_dec = 
        		ctx.TYPE() == null ? null : ctx.TYPE().getText();
        String package_dec = 
        		ctx.PACKAGE() == null ? null : ctx.PACKAGE().getText();
        String operator_dec = 
        		ctx.OPERATOR() == null ? null : ctx.OPERATOR().getText();
        String record_dec = 
        		ctx.RECORD() == null ? null : ctx.RECORD().getText();
        String expandable_dec = 
        		ctx.EXPANDABLE() == null ? null : ctx.EXPANDABLE().getText();
        String connector_dec = 
        		ctx.CONNECTOR() == null ? null : ctx.CONNECTOR().getText();
        String pure_dec = 
        		ctx.PURE() == null ? null : ctx.PURE().getText();
        String impure_dec = 
        		ctx.IMPURE() == null ? null : ctx.IMPURE().getText();
        String function_dec = 
        		ctx.FUNCTION() == null ? null : ctx.FUNCTION().getText();
        String other_dec;
        if ((function_dec != null) && (connector_dec == null) && (record_dec == null)) {
          other_dec = pure_dec + impure_dec + " " + operator_dec + " " + function_dec;
        } else if ((connector_dec != null) && (function_dec == null) && (record_dec == null)) {
          other_dec = expandable_dec + " " + connector_dec;
        } else if ((record_dec != null) && (function_dec == null) && (connector_dec == null)) {
          other_dec = operator_dec + " " + record_dec;
        } else {
          other_dec = (class_dec != null ? class_dec : "");
          other_dec = other_dec + (model_dec != null ? model_dec : "");
          other_dec = other_dec + (block_dec != null ? block_dec : "");
          other_dec = other_dec + (type_dec != null ? type_dec : "");
          other_dec = other_dec + (package_dec != null ? package_dec : "");
          other_dec = other_dec + (operator_dec != null ? operator_dec : "");
        }
        return new Class_prefixes(partial_dec, other_dec);
      }
    }

    private static class Long_class_specifierVisitor extends modelicaBaseVisitor<Long_class_specifier> {
      @Override
      public Long_class_specifier visitLong_class_specifier(@NotNull modelicaParser.Long_class_specifierContext ctx) {
        List<String> ident = ctx.IDENT()
        		.stream()
        		.map(IDENT -> IDENT.getText())
        		.collect(toList());
        String extends_dec = 
        		ctx.EXTENDS() == null ? null : ctx.EXTENDS().getText();
        String_commentVisitor string_commentVisitor = new String_commentVisitor();
        String_comment string_comment_1 = ctx.string_comment().accept(string_commentVisitor);
        CompositionVisitor compositionVisitor = new CompositionVisitor();
        Composition composition_1 = ctx.composition().accept(compositionVisitor);
        Class_modificationVisitor class_modificationVisitor = new Class_modificationVisitor();
        Class_modification class_modification_1 = 
        		ctx.class_modification() == null ? null : ctx.class_modification().accept(class_modificationVisitor);
        return new Long_class_specifier(extends_dec, ident.get(0), string_comment_1, composition_1, class_modification_1);
      }
    }

    private static class Short_class_specifierVisitor extends modelicaBaseVisitor<Short_class_specifier> {
      @Override
      public Short_class_specifier visitShort_class_specifier(@NotNull modelicaParser.Short_class_specifierContext ctx) {
        String enum_dec = 
        		ctx.ENUMERATION() == null ? null : ctx.ENUMERATION().getText();
        String ident = ctx.IDENT().getText();
        Base_prefixVisitor base_prefixVisitor = new Base_prefixVisitor();
        Base_prefix base_prefix_1 = 
        		ctx.base_prefix() == null ? null : ctx.base_prefix().accept(base_prefixVisitor);
        Array_subscriptsVisitor array_subscriptsVisitor = new Array_subscriptsVisitor();
        Array_subscripts array_subscripts_1 = 
        		ctx.array_subscripts() == null ? null : ctx.array_subscripts().accept(array_subscriptsVisitor);
        Class_modificationVisitor class_modificationVisitor = new Class_modificationVisitor();
        Class_modification class_modification_1 = 
        		ctx.class_modification() == null ? null : ctx.class_modification().accept(class_modificationVisitor);
        CommentVisitor commentVisitor = new CommentVisitor();
        Comment comment_1 = ctx.comment().accept(commentVisitor);
        Enum_listVisitor enum_listVisitor = new Enum_listVisitor();
        Enum_list enum_list_1 = 
        		ctx.enum_list() == null ? null : ctx.enum_list().accept(enum_listVisitor);
        NameVisitor nameVisitor = new NameVisitor();
        Name name_1 = 
        		ctx.name() == null ? null : ctx.name().accept(nameVisitor);
        return new Short_class_specifier(enum_dec, ident, base_prefix_1, name_1, array_subscripts_1,
                                         class_modification_1, comment_1, enum_list_1);
      }
    }

    private static class Der_class_specifierVisitor extends modelicaBaseVisitor<Der_class_specifier> {
      @Override
      public Der_class_specifier visitDer_class_specifier(@NotNull modelicaParser.Der_class_specifierContext ctx) {
    	List<String> idents = ctx.IDENT()
    			.stream()
    			.map(IDENT -> IDENT.getText())
    			.collect(toList());
        String ident1 = idents.get(0);
        List<String> ident2 = idents.subList(1, idents.size());    
        List<String> comma = ctx.SYMBOL_COMMA() == null ? null : ctx.SYMBOL_COMMA()
        		.stream()
        		.map(SYMBOL_COMMA -> SYMBOL_COMMA.getText())
        		.collect(toList());      
        NameVisitor nameVisitor = new NameVisitor();
        Name name_1 = ctx.name().accept(nameVisitor);
        CommentVisitor commentVisitor = new CommentVisitor();
        Comment comment_1 = ctx.comment().accept(commentVisitor);
        return new Der_class_specifier(ident1, comma, ident2, name_1, comment_1);
      }
    }

    private static class Base_prefixVisitor extends modelicaBaseVisitor<Base_prefix> {
      @Override
      public Base_prefix visitBase_prefix(@NotNull modelicaParser.Base_prefixContext ctx) {
        Type_prefixVisitor type_prefixVisitor = new Type_prefixVisitor();
        Type_prefix type_prefix_1 = ctx.type_prefix().accept(type_prefixVisitor);
        return new Base_prefix(type_prefix_1);
      }
    }

    private static class Enum_listVisitor extends modelicaBaseVisitor<Enum_list> {
      @Override
      public Enum_list visitEnum_list(@NotNull modelicaParser.Enum_listContext ctx) {
        Enumeration_literalVisitor enumeration_literalVisitor = new Enumeration_literalVisitor();
        List<Enumeration_literal> enumeration_literal_1 = ctx.enumeration_literal()
                .stream()
                .map(enumeration_literal -> enumeration_literal.accept(enumeration_literalVisitor))
                .collect(toList());
        return new Enum_list(enumeration_literal_1);
      }
    }

    private static class Enumeration_literalVisitor extends modelicaBaseVisitor<Enumeration_literal> {
      @Override
      public Enumeration_literal visitEnumeration_literal(@NotNull modelicaParser.Enumeration_literalContext ctx) {
        String ident = ctx.IDENT().getText();
        CommentVisitor commentVisitor = new CommentVisitor();
        Comment comment_1 = ctx.comment().accept(commentVisitor);
        return new Enumeration_literal(ident, comment_1);
      }
    }

    private static class CompositionVisitor extends modelicaBaseVisitor<Composition> {
      @Override
      public Composition visitComposition(@NotNull modelicaParser.CompositionContext ctx) {
        List<String> public_dec = ctx.PUBLIC() == null ? null : ctx.PUBLIC()
        		.stream()
        		.map(PUBLIC -> PUBLIC.getText())
        		.collect(toList());
        List<String> protected_dec = ctx.PROTECTED() == null ? null : ctx.PROTECTED()
        		.stream()
        		.map(PROTECTED -> PROTECTED.getText())
        		.collect(toList());
        String external_dec = 
        		ctx.EXTERNAL() == null ? null : ctx.EXTERNAL().getText();
        Element_listVisitor element_listVisitor = new Element_listVisitor();
        List<Element_list> element_lists = ctx.element_list()
                .stream()
                .map(element_list -> element_list.accept(element_listVisitor))
                .collect(toList());
        Element_list element_list1 = element_lists.get(0);        
        List<Element_list> element_list2 = 
        		element_lists.size() < 2 ? null : element_lists.subList(1,element_lists.size()); 
        Equation_sectionVisitor equation_sectionVisitor = new Equation_sectionVisitor();
        List<Equation_section> equation_section_1 = ctx.equation_section() == null ? null : ctx.equation_section()
                .stream()
                .map(equation_section -> equation_section.accept(equation_sectionVisitor))
                .collect(toList());
        Algorithm_sectionVisitor algorithm_sectionVisitor = new Algorithm_sectionVisitor();
        List<Algorithm_section> algorithm_section_1 = ctx.algorithm_section() == null ? null : ctx.algorithm_section()
                .stream()
                .map(algorithm_section -> algorithm_section.accept(algorithm_sectionVisitor))
                .collect(toList());
        Language_specificationVisitor language_specificationVisitor = new Language_specificationVisitor();
        Language_specification language_specification_1 = 
        		ctx.language_specification() == null ? null : ctx.language_specification().accept(language_specificationVisitor);
        External_function_callVisitor external_function_callVisitor = new External_function_callVisitor();
        External_function_call external_function_call_1 = 
        		ctx.external_function_call() == null ? null : ctx.external_function_call().accept(external_function_callVisitor);
        AnnotationVisitor annotationVisitor = new AnnotationVisitor();
        List<Annotation> annotations = ctx.annotation() == null ? null : ctx.annotation()
                .stream()
                .map(annotation -> annotation.accept(annotationVisitor))
                .collect(toList());
        Annotation annotation1 = null;
        Annotation annotation2 = null;
        if (annotations.size() == 2) {
        	annotation1 = annotations.get(0);
        	annotation2 = annotations.get(1);
        } else if (annotations.size() == 1 && external_dec != null) {
        	annotation1 = annotations.get(0);
        } else if (annotations.size() == 1 && external_dec == null) {
        	annotation2 = annotations.get(0);
        } else {
        	annotation1 = null;
            annotation2 = null;
        }
        return new Composition(external_dec, public_dec, protected_dec, element_list1, element_list2,
                               equation_section_1, algorithm_section_1, language_specification_1, external_function_call_1,
                               annotation1, annotation2);
      }
    }

    private static class Language_specificationVisitor extends modelicaBaseVisitor<Language_specification> {
      @Override
      public Language_specification visitLanguage_specification(@NotNull modelicaParser.Language_specificationContext ctx) {
        String ident = ctx.STRING().getText();
        return new Language_specification(ident);
      }
    }

    private static class External_function_callVisitor extends modelicaBaseVisitor<External_function_call> {
      @Override
      public External_function_call visitExternal_function_call(@NotNull modelicaParser.External_function_callContext ctx) {
        String ident = ctx.IDENT().getText();
        Component_referenceVisitor component_referenceVisitor = new Component_referenceVisitor();
        Component_reference component_reference_1 = 
        		ctx.component_reference() == null ? null : ctx.component_reference().accept(component_referenceVisitor);
        Expression_listVisitor expression_listVisitor = new Expression_listVisitor();
        Expression_list expression_list_1 = 
        		ctx.expression_list() == null ? null : ctx.expression_list().accept(expression_listVisitor);
        return new External_function_call(ident, component_reference_1, expression_list_1);
      }
    }

    private static class Element_listVisitor extends modelicaBaseVisitor<Element_list> {
      @Override
      public Element_list visitElement_list(@NotNull modelicaParser.Element_listContext ctx) {
        ElementVisitor elementVisitor = new ElementVisitor();
        List<Element> element_1 = ctx.element() == null ? null : ctx.element()
                .stream()
                .map(element -> element.accept(elementVisitor))
                .collect(toList());
        return new Element_list(element_1);
      }
    }

    private static class ElementVisitor extends modelicaBaseVisitor<Element> {
      @Override
      public Element visitElement(@NotNull modelicaParser.ElementContext ctx) {
        String red_dec = 
        		ctx.REDECLARE() == null ? null : ctx.REDECLARE().getText();
        String final_dec = 
        		ctx.FINAL() == null ? null : ctx.FINAL().getText();
        String inner_dec = 
        		ctx.INNER() == null ? null : ctx.INNER().getText();
        String outer_der = 
        		ctx.OUTER() == null ? null : ctx.OUTER().getText();
        String rep_dec = 
        		ctx.REPLACEABLE() == null ? null : ctx.REPLACEABLE().getText();
        Class_definition class_definition1;
        Class_definition class_definition2;
        Component_clause component_clause1;
        Component_clause component_clause2;
        if (rep_dec != null) {
          Class_definitionVisitor class_definitionVisitor = new Class_definitionVisitor();
          class_definition2 = 
        		  ctx.class_definition() == null ? null : ctx.class_definition().accept(class_definitionVisitor);
          Component_clauseVisitor component_clauseVisitor = new Component_clauseVisitor();
          component_clause2 = 
        		  ctx.component_clause() == null ? null : ctx.component_clause().accept(component_clauseVisitor);
          class_definition1 = null;
          component_clause1 = null;
        } else {
          Class_definitionVisitor class_definitionVisitor = new Class_definitionVisitor();
          class_definition1 = 
        		  ctx.class_definition() == null ? null : ctx.class_definition().accept(class_definitionVisitor);
          Component_clauseVisitor component_clauseVisitor = new Component_clauseVisitor();
          component_clause1 = 
        		  ctx.component_clause() == null ? null : ctx.component_clause().accept(component_clauseVisitor);
          class_definition2 = null;
          component_clause2 = null;
        }
        Import_clauseVisitor import_clauseVisitor = new Import_clauseVisitor();
        Import_clause import_clause_1 = 
        		ctx.import_clause() == null ? null : ctx.import_clause().accept(import_clauseVisitor);
        Extends_clauseVisitor extends_clauseVisitor = new Extends_clauseVisitor();
        Extends_clause extends_clause_1 = 
        		ctx.extends_clause() == null ? null : ctx.extends_clause().accept(extends_clauseVisitor);
        Constraining_clauseVisitor constraining_clauseVisitor = new Constraining_clauseVisitor();
        Constraining_clause constraining_clause_1 = 
        		ctx.constraining_clause() == null ? null : ctx.constraining_clause().accept(constraining_clauseVisitor);
        CommentVisitor commentVisitor = new CommentVisitor();
        Comment comment_1 = 
        		ctx.comment() == null ? null : ctx.comment().accept(commentVisitor);
        return new Element(red_dec, final_dec, inner_dec, outer_der, rep_dec, import_clause_1,
                           extends_clause_1, class_definition1, class_definition2,
                           component_clause1, component_clause2, constraining_clause_1, comment_1);
      }
    }

    private static class Import_clauseVisitor extends modelicaBaseVisitor<Import_clause> {
      @Override
      public Import_clause visitImport_clause(@NotNull modelicaParser.Import_clauseContext ctx) {
        String import_dec = ctx.IMPORT().getText();
        String ident = 
        		ctx.IDENT() == null ? null : ctx.IDENT().getText();
        String dotStar = 
        		ctx.SYMBOL_DOTSTAR() == null ? null : ctx.SYMBOL_DOTSTAR().getText();
        Import_listVisitor import_listVisitor = new Import_listVisitor();
        Import_list import_list_1 = 
        		ctx.import_list() == null ? null : ctx.import_list().accept(import_listVisitor);
        CommentVisitor commentVisitor = new CommentVisitor();
        Comment comment_1 = ctx.comment().accept(commentVisitor);
        NameVisitor nameVisitor = new NameVisitor();
        Name name_1 = ctx.name().accept(nameVisitor);
        return new Import_clause(import_dec, ident, dotStar, name_1, import_list_1, comment_1);
      }
    }

    private static class Import_listVisitor extends modelicaBaseVisitor<Import_list> {
      @Override
      public Import_list visitImport_list(@NotNull modelicaParser.Import_listContext ctx) {
        List<String> ident = ctx.IDENT()
        		.stream()
        		.map(IDENT -> IDENT.getText())
        		.collect(toList());
        return new Import_list(ident);
      }
    }

    private static class Extends_clauseVisitor extends modelicaBaseVisitor<Extends_clause> {
      @Override
      public Extends_clause visitExtends_clause(@NotNull modelicaParser.Extends_clauseContext ctx) {
        String ext_dec = ctx.EXTENDS().getText();
        NameVisitor nameVisitor = new NameVisitor();
        Name name_1 = ctx.name().accept(nameVisitor);
        Class_modificationVisitor class_modificationVisitor = new Class_modificationVisitor();
        Class_modification class_modification_1 = 
        		ctx.class_modification() == null ? null : ctx.class_modification().accept(class_modificationVisitor);
        AnnotationVisitor annotationVisitor = new AnnotationVisitor();
        Annotation annotation_1 = 
        		ctx.annotation() == null ? null : ctx.annotation().accept(annotationVisitor);
        return new Extends_clause(ext_dec, name_1, class_modification_1, annotation_1);
      }
    }

    private static class Constraining_clauseVisitor extends modelicaBaseVisitor<Constraining_clause> {
      @Override
      public Constraining_clause visitConstraining_clause(@NotNull modelicaParser.Constraining_clauseContext ctx) {
        String constrain_dec = ctx.CONSTRAINEDBY().getText();
        NameVisitor nameVisitor = new NameVisitor();
        Name name_1 = ctx.name().accept(nameVisitor);
        Class_modificationVisitor class_modificationVisitor = new Class_modificationVisitor();
        Class_modification class_modification_1 = 
        		ctx.class_modification() == null ? null : ctx.class_modification().accept(class_modificationVisitor);
        return new Constraining_clause(constrain_dec, name_1, class_modification_1);
      }
    }

    private static class Component_clauseVisitor extends modelicaBaseVisitor<Component_clause> {
      @Override
      public Component_clause visitComponent_clause(@NotNull modelicaParser.Component_clauseContext ctx) {
        Type_prefixVisitor type_prefixVisitor = new Type_prefixVisitor();
        Type_prefix type_prefix_1 = 
        		ctx.type_prefix() == null ? null : ctx.type_prefix().accept(type_prefixVisitor);
        Type_specifierVisitor type_specifierVisitor = new Type_specifierVisitor();
        Type_specifier type_specifier_1 = ctx.type_specifier().accept(type_specifierVisitor);
        Array_subscriptsVisitor array_subscriptsVisitor = new Array_subscriptsVisitor();
        Array_subscripts array_subscripts_1 = 
        		ctx.array_subscripts() == null ? null : ctx.array_subscripts().accept(array_subscriptsVisitor);
        Component_listVisitor component_listVisitor = new Component_listVisitor();
        Component_list component_list_1 = ctx.component_list().accept(component_listVisitor);
        return new Component_clause(type_prefix_1, type_specifier_1, array_subscripts_1, component_list_1);
      }
    }

    private static class Type_prefixVisitor extends modelicaBaseVisitor<Type_prefix> {
      @Override
      public Type_prefix visitType_prefix(@NotNull modelicaParser.Type_prefixContext ctx) {
        String flow_dec = 
        		ctx.FLOW() == null ? null : ctx.FLOW().getText();
        String stream_dec = 
        		ctx.STREAM() == null ? null : ctx.STREAM().getText();
        String disc_dec = 
        		ctx.DISCRETE() == null ? null : ctx.DISCRETE().getText();
        String par_dec = 
        		ctx.PARAMETER() == null ? null : ctx.PARAMETER().getText();
        String con_dec = 
        		ctx.CONSTANT() == null ? null : ctx.CONSTANT().getText();
        String in_dec = 
        		ctx.INPUT() == null ? null : ctx.INPUT().getText();
        String out_dec = 
        		ctx.OUTPUT() == null ? null : ctx.OUTPUT().getText();
        return new Type_prefix(flow_dec, stream_dec, disc_dec, par_dec,
                               con_dec, in_dec, out_dec);
      }
    }

    private static class Type_specifierVisitor extends modelicaBaseVisitor<Type_specifier> {
      @Override
      public Type_specifier visitType_specifier(@NotNull modelicaParser.Type_specifierContext ctx) {
        NameVisitor nameVisitor = new NameVisitor();
        Name name_1 = ctx.name().accept(nameVisitor);
        return new Type_specifier(name_1);
      }
    }

    private static class Component_listVisitor extends modelicaBaseVisitor<Component_list> {
      @Override
      public Component_list visitComponent_list(@NotNull modelicaParser.Component_listContext ctx) {
        Component_declarationVisitor component_declarationVisitor = new Component_declarationVisitor();
        List<Component_declaration> component_declaration_1 = ctx.component_declaration()
                .stream()
                .map(component_declaration -> component_declaration.accept(component_declarationVisitor))
                .collect(toList());
        return new Component_list(component_declaration_1);
      }
    }

    private static class Component_declarationVisitor extends modelicaBaseVisitor<Component_declaration> {
      @Override
      public Component_declaration visitComponent_declaration(@NotNull modelicaParser.Component_declarationContext ctx) {
        DeclarationVisitor declarationVisitor = new DeclarationVisitor();
        Declaration declaration_1 = ctx.declaration().accept(declarationVisitor);
        Condition_attributeVisitor condition_attributeVisitor = new Condition_attributeVisitor();
        Condition_attribute condition_attribute_1 = 
        		ctx.condition_attribute() == null ? null : ctx.condition_attribute().accept(condition_attributeVisitor);
        CommentVisitor commentVisitor = new CommentVisitor();
        Comment comment_1 = ctx.comment().accept(commentVisitor);
        return new Component_declaration(declaration_1, condition_attribute_1, comment_1);
      }
    }

    private static class Condition_attributeVisitor extends modelicaBaseVisitor<Condition_attribute> {
      @Override
      public Condition_attribute visitCondition_attribute(@NotNull modelicaParser.Condition_attributeContext ctx) {
        String if_dec = ctx.IF().getText();
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        Expression expression_1 = ctx.expression().accept(expressionVisitor);
        return new Condition_attribute(if_dec, expression_1);
      }
    }

    private static class DeclarationVisitor extends modelicaBaseVisitor<Declaration> {
      @Override
      public Declaration visitDeclaration(@NotNull modelicaParser.DeclarationContext ctx) {
        String ident = ctx.IDENT().getText();
        Array_subscriptsVisitor array_subscriptsVisitor = new Array_subscriptsVisitor();
        Array_subscripts array_subscripts_1 = 
        		ctx.array_subscripts() == null ? null : ctx.array_subscripts().accept(array_subscriptsVisitor);
        ModificationVisitor modificationVisitor = new ModificationVisitor();
        Modification modification_1 = 
        		ctx.modification() == null ? null : ctx.modification().accept(modificationVisitor);
        return new Declaration(ident, array_subscripts_1, modification_1);
      }
    }

    private static class ModificationVisitor extends modelicaBaseVisitor<Modification> {
      @Override
      public Modification visitModification(@NotNull modelicaParser.ModificationContext ctx) {
        Class_modificationVisitor class_modificationVisitor = new Class_modificationVisitor();
        Class_modification class_modification_1 = 
        		ctx.class_modification() == null ? null : ctx.class_modification().accept(class_modificationVisitor);
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        Expression expression_1 = 
        		ctx.expression() == null ? null : ctx.expression().accept(expressionVisitor);
        String eqSymb = ctx.SYMBOL_EQUAL() == null ? null : ctx.SYMBOL_EQUAL().getText();
        String colEqSymb = ctx.SYMBOL_COLONEQUAL() == null ? null : ctx.SYMBOL_COLONEQUAL().getText();
        return new Modification(class_modification_1, eqSymb, colEqSymb, expression_1);
      }
    }

    private static class Class_modificationVisitor extends modelicaBaseVisitor<Class_modification> {
      @Override
      public Class_modification visitClass_modification(@NotNull modelicaParser.Class_modificationContext ctx) {
        Argument_listVisitor argument_listVisitor = new Argument_listVisitor();
        Argument_list argument_list_1 = 
        		ctx.argument_list() == null ? null : ctx.argument_list().accept(argument_listVisitor);
        return new Class_modification(argument_list_1);
      }
    }

    private static class Argument_listVisitor extends modelicaBaseVisitor<Argument_list> {
      @Override
      public Argument_list visitArgument_list(@NotNull modelicaParser.Argument_listContext ctx) {
        ArgumentVisitor argumentVisitor = new ArgumentVisitor();
        List<Argument> argument_1 = ctx.argument()
                .stream()
                .map(argument -> argument.accept(argumentVisitor))
                .collect(toList());
        return new Argument_list(argument_1);
      }
    }

    private static class ArgumentVisitor extends modelicaBaseVisitor<Argument> {
      @Override
      public Argument visitArgument(@NotNull modelicaParser.ArgumentContext ctx) {
        Element_modification_or_replaceableVisitor element_modification_or_replaceableVisitor = new Element_modification_or_replaceableVisitor();
        Element_modification_or_replaceable element_modification_or_replaceable_1 = 
        		ctx.element_modification_or_replaceable() == null ? null : ctx.element_modification_or_replaceable().accept(element_modification_or_replaceableVisitor);
        Element_redeclarationVisitor element_redeclarationVisitor = new Element_redeclarationVisitor();
        Element_redeclaration element_redeclaration_1 = 
        		ctx.element_redeclaration() == null ? null : ctx.element_redeclaration().accept(element_redeclarationVisitor);
        return new Argument(element_modification_or_replaceable_1, element_redeclaration_1);
      }
    }

    private static class Element_modification_or_replaceableVisitor extends modelicaBaseVisitor<Element_modification_or_replaceable> {
      @Override
      public Element_modification_or_replaceable visitElement_modification_or_replaceable(@NotNull modelicaParser.Element_modification_or_replaceableContext ctx) {
        String each_dec = 
        		ctx.EACH() == null ? null : ctx.EACH().getText();
        String final_dec = 
        		ctx.FINAL() == null ? null : ctx.FINAL().getText();
        Element_modificationVisitor element_modificationVisitor = new Element_modificationVisitor();
        Element_modification element_modification_1 = 
        		ctx.element_modification() == null ? null : ctx.element_modification().accept(element_modificationVisitor);
        Element_replaceableVisitor element_replaceableVisitor = new Element_replaceableVisitor();
        Element_replaceable element_replaceable_1 = 
        		ctx.element_replaceable() == null ? null : ctx.element_replaceable().accept(element_replaceableVisitor);
        return new Element_modification_or_replaceable(each_dec, final_dec, element_modification_1, element_replaceable_1);
      }
    }

    private static class Element_modificationVisitor extends modelicaBaseVisitor<Element_modification> {
      @Override
      public Element_modification visitElement_modification(@NotNull modelicaParser.Element_modificationContext ctx) {
        NameVisitor nameVisitor = new NameVisitor();
        Name name_1 = ctx.name().accept(nameVisitor);
        ModificationVisitor modificationVisitor = new ModificationVisitor();
        Modification modification_1 = 
        		ctx.modification() == null ? null : ctx.modification().accept(modificationVisitor);
        String_commentVisitor string_commentVisitor = new String_commentVisitor();
        String_comment string_comment_1 = ctx.string_comment().accept(string_commentVisitor);
        return new Element_modification(name_1, modification_1, string_comment_1);
      }
    }

    private static class Element_redeclarationVisitor extends modelicaBaseVisitor<Element_redeclaration> {
      @Override
      public Element_redeclaration visitElement_redeclaration(@NotNull modelicaParser.Element_redeclarationContext ctx) {
        String red_dec = ctx.REDECLARE().getText();
        String each_dec = 
        		ctx.EACH() == null ? null : ctx.EACH().getText();
        String final_dec = 
        		ctx.FINAL() == null ? null : ctx.FINAL().getText();
        Short_class_definitionVisitor short_class_definitionVisitor = new Short_class_definitionVisitor();
        Short_class_definition short_class_definition_1 = 
        		ctx.short_class_definition() == null ? null : ctx.short_class_definition().accept(short_class_definitionVisitor);
        Component_clause1Visitor component_clause1Visitor = new Component_clause1Visitor();
        Component_clause1 component_clause1_1 = 
        		ctx.component_clause1() == null ? null : ctx.component_clause1().accept(component_clause1Visitor);
        Element_replaceableVisitor element_replaceableVisitor = new Element_replaceableVisitor();
        Element_replaceable element_replaceable_1 = 
        		ctx.element_replaceable() == null ? null : ctx.element_replaceable().accept(element_replaceableVisitor);
        return new Element_redeclaration(red_dec, each_dec, final_dec, short_class_definition_1, component_clause1_1, element_replaceable_1);
      }
    }

    private static class Element_replaceableVisitor extends modelicaBaseVisitor<Element_replaceable> {
      @Override
      public Element_replaceable visitElement_replaceable(@NotNull modelicaParser.Element_replaceableContext ctx) {
        String rep_dec = ctx.REPLACEABLE().getText();
        Short_class_definitionVisitor short_class_definitionVisitor = new Short_class_definitionVisitor();
        Short_class_definition short_class_definition_1 = 
        		ctx.short_class_definition() == null ? null : ctx.short_class_definition().accept(short_class_definitionVisitor);
        Component_clause1Visitor component_clause1Visitor = new Component_clause1Visitor();
        Component_clause1 component_clause1_1 = 
        		ctx.component_clause1() == null ? null : ctx.component_clause1().accept(component_clause1Visitor);
        Constraining_clauseVisitor constraining_clauseVisitor = new Constraining_clauseVisitor();
        Constraining_clause constraining_clause_1 = 
        		ctx.constraining_clause() == null ? null : ctx.constraining_clause().accept(constraining_clauseVisitor);
        return new Element_replaceable(rep_dec, short_class_definition_1, component_clause1_1, constraining_clause_1);
      }
    }

    private static class Component_clause1Visitor extends modelicaBaseVisitor<Component_clause1> {
      @Override
      public Component_clause1 visitComponent_clause1(@NotNull modelicaParser.Component_clause1Context ctx) {
        Type_prefixVisitor type_prefixVisitor = new Type_prefixVisitor();
        Type_prefix type_prefix_1 = ctx.type_prefix().accept(type_prefixVisitor);
        Type_specifierVisitor type_specifierVisitor = new Type_specifierVisitor();
        Type_specifier type_specifier_1 = ctx.type_specifier().accept(type_specifierVisitor);
        Component_declaration1Visitor component_declaration1Visitor = new Component_declaration1Visitor();
        Component_declaration1 component_declaration1_1 = ctx.component_declaration1().accept(component_declaration1Visitor);
        return new Component_clause1(type_prefix_1, type_specifier_1, component_declaration1_1);
      }
    }

    private static class Component_declaration1Visitor extends modelicaBaseVisitor<Component_declaration1> {
      @Override
      public Component_declaration1 visitComponent_declaration1(@NotNull modelicaParser.Component_declaration1Context ctx) {
        DeclarationVisitor declarationVisitor = new DeclarationVisitor();
        Declaration declaration_1 = ctx.declaration().accept(declarationVisitor);
        CommentVisitor commentVisitor = new CommentVisitor();
        Comment comment_1 = ctx.comment().accept(commentVisitor);
        return new Component_declaration1(declaration_1, comment_1);
      }
    }

    private static class Short_class_definitionVisitor extends modelicaBaseVisitor<Short_class_definition> {
      @Override
      public Short_class_definition visitShort_class_definition(@NotNull modelicaParser.Short_class_definitionContext ctx) {
        Class_prefixesVisitor class_prefixesVisitor = new Class_prefixesVisitor();
        Class_prefixes class_prefixes_1 = ctx.class_prefixes().accept(class_prefixesVisitor);
        Short_class_specifierVisitor short_class_specifierVisitor = new Short_class_specifierVisitor();
        Short_class_specifier short_class_specifier_1 = ctx.short_class_specifier().accept(short_class_specifierVisitor);
        return new Short_class_definition(class_prefixes_1, short_class_specifier_1);
      }
    }

    private static class Equation_sectionVisitor extends modelicaBaseVisitor<Equation_section> {
      @Override
      public Equation_section visitEquation_section(@NotNull modelicaParser.Equation_sectionContext ctx) {
        String init_dec = 
        		ctx.INITIAL() == null ? null : ctx.INITIAL().getText();
        String equ_dec = ctx.EQUATION().getText();
        EquationVisitor equationVisitor = new EquationVisitor();
        List<Equation> equation_1 = ctx.equation() == null ? null : ctx.equation()
                .stream()
                .map(equation -> equation.accept(equationVisitor))
                .collect(toList());
        return new Equation_section(init_dec, equ_dec, equation_1);
      }
    }

    private static class Algorithm_sectionVisitor extends modelicaBaseVisitor<Algorithm_section> {
      @Override
      public Algorithm_section visitAlgorithm_section(@NotNull modelicaParser.Algorithm_sectionContext ctx) {
        String init_dec = 
        		ctx.INITIAL() == null ? null : ctx.INITIAL().getText();
        String alg_dec = ctx.ALGORITHM().getText();
        StatementVisitor statementVisitor = new StatementVisitor();
        List<Statement> statement_1 = ctx.statement() == null ? null : ctx.statement()
                .stream()
                .map(statement -> statement.accept(statementVisitor))
                .collect(toList());
        return new Algorithm_section(init_dec, alg_dec, statement_1);
      }
    }

    private static class EquationVisitor extends modelicaBaseVisitor<Equation> {
      @Override
      public Equation visitEquation(@NotNull modelicaParser.EquationContext ctx) {
        Simple_expressionVisitor simple_expressionVisitor = new Simple_expressionVisitor();
        Simple_expression simple_expression_1 = 
        		ctx.simple_expression() == null ? null : ctx.simple_expression().accept(simple_expressionVisitor);
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        Expression expression_1 = 
        		ctx.expression() == null ? null : ctx.expression().accept(expressionVisitor);
        If_equationVisitor if_equationVisitor = new If_equationVisitor();
        If_equation if_equation_1 = 
        		ctx.if_equation() == null ? null : ctx.if_equation().accept(if_equationVisitor);
        For_equationVisitor for_equationVisitor = new For_equationVisitor();
        For_equation for_equation_1 = 
        		ctx.for_equation() == null ? null : ctx.for_equation().accept(for_equationVisitor);
        Connect_clauseVisitor connect_clauseVisitor = new Connect_clauseVisitor();
        Connect_clause connect_clause_1 = 
        		ctx.connect_clause() == null ? null : ctx.connect_clause().accept(connect_clauseVisitor);
        When_equationVisitor when_equationVisitor = new When_equationVisitor();
        When_equation when_equation_1 = 
        		ctx.when_equation() == null ? null : ctx.when_equation().accept(when_equationVisitor);
        NameVisitor nameVisitor = new NameVisitor();
        Name name_1 = 
        		ctx.name() == null ? null : ctx.name().accept(nameVisitor);
        Function_call_argsVisitor function_call_argsVisitor = new Function_call_argsVisitor();
        Function_call_args function_call_args_1 = 
        		ctx.function_call_args() == null ? null : ctx.function_call_args().accept(function_call_argsVisitor);
        CommentVisitor commentVisitor = new CommentVisitor();
        Comment comment_1 = ctx.comment().accept(commentVisitor);
        return new Equation(simple_expression_1, expression_1, if_equation_1, for_equation_1, connect_clause_1,
                            when_equation_1, name_1, function_call_args_1, comment_1);
      }
    }

    private static class StatementVisitor extends modelicaBaseVisitor<Statement> {
      @Override
      public Statement visitStatement(@NotNull modelicaParser.StatementContext ctx) {
        String bre_dec = 
        		ctx.BREAK() == null ? null : ctx.BREAK().getText();
        String ret_dec = 
        		ctx.RETURN() == null ? null : ctx.RETURN().getText();
        Component_referenceVisitor component_referenceVisitor = new Component_referenceVisitor();
        Component_reference component_reference_1 = 
        		ctx.component_reference() == null ? null : ctx.component_reference().accept(component_referenceVisitor);
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        Expression expression_1 = 
        		ctx.expression() == null ? null : ctx.expression().accept(expressionVisitor);
        Function_call_argsVisitor function_call_argsVisitor = new Function_call_argsVisitor();
        Function_call_args function_call_args_1 = 
        		ctx.function_call_args() == null ? null : ctx.function_call_args().accept(function_call_argsVisitor);
        Output_expression_listVisitor output_expression_listVisitor = new Output_expression_listVisitor();
        Output_expression_list output_expression_list_1 = 
        		ctx.output_expression_list() == null ? null : ctx.output_expression_list().accept(output_expression_listVisitor);
        If_statementVisitor if_statementVisitor = new If_statementVisitor();
        If_statement if_statement_1 = 
        		ctx.if_statement() == null ? null : ctx.if_statement().accept(if_statementVisitor);
        For_statementVisitor for_statementVisitor = new For_statementVisitor();
        For_statement for_statement_1 = 
        		ctx.for_statement() == null ? null : ctx.for_statement().accept(for_statementVisitor);
        While_statementVisitor while_statementVisitor = new While_statementVisitor();
        While_statement while_statement_1 = 
        		ctx.while_statement() == null ? null : ctx.while_statement().accept(while_statementVisitor);
        When_statementVisitor when_statementVisitor = new When_statementVisitor();
        When_statement when_statement_1 = 
        		ctx.when_statement() == null ? null : ctx.when_statement().accept(when_statementVisitor);
        CommentVisitor commentVisitor = new CommentVisitor();
        Comment comment_1 = ctx.comment().accept(commentVisitor);
        return new Statement(bre_dec, ret_dec, component_reference_1, expression_1, function_call_args_1,
                            output_expression_list_1, if_statement_1, for_statement_1, while_statement_1, when_statement_1, comment_1);
      }
    }

    // ========= need further refinements =========
    private static class If_equationVisitor extends modelicaBaseVisitor<If_equation> {   	
      @SuppressWarnings("unused")
	@Override
      public If_equation visitIf_equation(@NotNull modelicaParser.If_equationContext ctx) {
    	  //System.out.printf("token for if_expression 592: %n '%s' %n", ctx.equation(181));
    	  //System.out.printf("token for if_expression 592: %n '%s' %n", ctx.getChildCount());     //.getText()); 
        List<String> if_dec = ctx.IF()
        		.stream()
        		.map(IF -> IF.getText())
        		.collect(toList());
        List<String> elseif_dec = ctx.ELSEIF() == null ? null : ctx.ELSEIF()
        		.stream()
        		.map(ELSEIF -> ELSEIF.getText())
        		.collect(toList());
        String else_dec = 
        		ctx.ELSE() == null ? null : ctx.ELSE().getText();
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        List<Expression> expressions = ctx.expression()
                .stream()
                .map(expression -> expression.accept(expressionVisitor))
                .collect(toList());
        Expression expression1 = expressions.get(0);
        List<Expression> expression2 = null;
        if (elseif_dec.size() > 0) {
        	expression2 = expressions.subList(1, expressions.size());
        }       
        List<Equation> equation1 = null;
        List<Equation> equation2 = null;
        List<Equation> equation3 = null;
        if (if_dec != null) {
          EquationVisitor equationVisitor = new EquationVisitor();
          equation1 = ctx.equation() == null ? null : ctx.equation()
                  .stream()
                  .map(equation -> equation.accept(equationVisitor))
                  .collect(toList());
        } else if (elseif_dec != null) {
          EquationVisitor equationVisitor = new EquationVisitor();
          equation2 = ctx.equation() == null ? null : ctx.equation()
                  .stream()
                  .map(equation -> equation.accept(equationVisitor))
                  .collect(toList());
        } else if (else_dec != null) {
          EquationVisitor equationVisitor = new EquationVisitor();
          equation3 = ctx.equation() == null ? null : ctx.equation()
                  .stream()
                  .map(equation -> equation.accept(equationVisitor))
                  .collect(toList());
        }
        return new If_equation(expression1, equation1, expression2, equation2, equation3);
      }
    }

    // ========= need further refinements =========
    private static class If_statementVisitor extends modelicaBaseVisitor<If_statement> {
       @SuppressWarnings("unused")
	@Override
      public If_statement visitIf_statement(@NotNull modelicaParser.If_statementContext ctx) {
    	   //System.out.printf("token for if_expression 633: %n '%s' %n",ctx.getTokens(633));
        List<String> if_dec = ctx.IF()
        		.stream()
        		.map(IF -> IF.getText())
        		.collect(toList());
        List<String> elseif_dec = ctx.ELSEIF() == null ? null : ctx.ELSEIF()
        		.stream()
        		.map(ELSEIF -> ELSEIF.getText())
        		.collect(toList());        
        String else_dec = 
        		ctx.ELSE() == null ? null : ctx.ELSE().getText();
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        List<Expression> expressions = ctx.expression()
                .stream()
                .map(expression -> expression.accept(expressionVisitor))
                .collect(toList());
        Expression expression1 = expressions.get(0);
        List<Expression> expression2 = null;
        if (elseif_dec.size() > 0) {
        	expression2 = expressions.subList(1, expressions.size());
        }
        List<Statement> statement1 = null;
        List<Statement> statement2 = null;
        List<Statement> statement3 = null;      
        if (if_dec != null) {
          StatementVisitor statementVisitor = new StatementVisitor();
          statement1 = ctx.statement() == null ? null : ctx.statement()
                  .stream()
                  .map(statement -> statement.accept(statementVisitor))
                  .collect(toList());
        } else if (elseif_dec != null) {
          StatementVisitor statementVisitor = new StatementVisitor();
          statement2 = ctx.statement() == null ? null : ctx.statement()
                  .stream()
                  .map(statement -> statement.accept(statementVisitor))
                  .collect(toList());
        } else if (else_dec != null) {
          StatementVisitor statementVisitor = new StatementVisitor();
          statement3 = ctx.statement() == null ? null : ctx.statement()
                  .stream()
                  .map(statement -> statement.accept(statementVisitor))
                  .collect(toList());
        }
        return new If_statement(expression1, statement1, expression2, statement2, statement3);
      }
    }

    private static class For_equationVisitor extends modelicaBaseVisitor<For_equation> {
      @Override
      public For_equation visitFor_equation(@NotNull modelicaParser.For_equationContext ctx) {
        For_indicesVisitor for_indicesVisitor = new For_indicesVisitor();
        For_indices for_indices_1 = ctx.for_indices().accept(for_indicesVisitor);
        EquationVisitor equationVisitor = new EquationVisitor();
        List<Equation> equation_1 = ctx.equation() == null ? null : ctx.equation()
                .stream()
                .map(equation -> equation.accept(equationVisitor))
                .collect(toList());
        return new For_equation(for_indices_1, equation_1);
      }
    }

    private static class For_statementVisitor extends modelicaBaseVisitor<For_statement> {
      @Override
      public For_statement visitFor_statement(@NotNull modelicaParser.For_statementContext ctx) {
        For_indicesVisitor for_indicesVisitor = new For_indicesVisitor();
        For_indices for_indices_1 = ctx.for_indices().accept(for_indicesVisitor);
        StatementVisitor statementVisitor = new StatementVisitor();
        List<Statement> statement_1 = ctx.statement() == null ? null : ctx.statement()
                .stream()
                .map(statement -> statement.accept(statementVisitor))
                .collect(toList());
        return new For_statement(for_indices_1, statement_1);
      }
    }

    private static class For_indicesVisitor extends modelicaBaseVisitor<For_indices> {
      @Override
      public For_indices visitFor_indices(@NotNull modelicaParser.For_indicesContext ctx) {
        For_indexVisitor for_indexVisitor = new For_indexVisitor();
        List<For_index> for_index_1 = ctx.for_index()
                .stream()
                .map(for_index -> for_index.accept(for_indexVisitor))
                .collect(toList());
        return new For_indices(for_index_1);
      }
    }

    private static class For_indexVisitor extends modelicaBaseVisitor<For_index> {
      @Override
      public For_index visitFor_index(@NotNull modelicaParser.For_indexContext ctx) {
        String ident = ctx.IDENT().getText();
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        Expression expression_1 = 
        		ctx.expression() == null ? null : ctx.expression().accept(expressionVisitor);
        return new For_index(ident, expression_1);
      }
    }

    private static class While_statementVisitor extends modelicaBaseVisitor<While_statement> {
      @Override
      public While_statement visitWhile_statement(@NotNull modelicaParser.While_statementContext ctx) {
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        Expression expression_1 = ctx.expression().accept(expressionVisitor);
        StatementVisitor statementVisitor = new StatementVisitor();
        List<Statement> statement_1 = ctx.statement() == null ? null : ctx.statement()
                .stream()
                .map(statement -> statement.accept(statementVisitor))
                .collect(toList());
        return new While_statement(expression_1, statement_1);
      }
    }

    // ========= need further refinements =========
    private static class When_equationVisitor extends modelicaBaseVisitor<When_equation> {
      @Override
      public When_equation visitWhen_equation(@NotNull modelicaParser.When_equationContext ctx) {    	  
    	  //System.out.printf("token for When: %n '%s' %n",ctx.getTokens(728)); 	  
        List<String> when_dec = ctx.WHEN()
        		.stream()
        		.map(WHEN -> WHEN.getText())
        		.collect(toList());
        List<String> elsewhen_dec = ctx.ELSEWHEN() == null ? null : ctx.ELSEWHEN()
        		.stream()
        		.map(ELSEWHEN -> ELSEWHEN.getText())
        		.collect(toList());
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        List<Expression> expressions = ctx.expression()
                .stream()
                .map(expression -> expression.accept(expressionVisitor))
                .collect(toList());
        Expression expression1 = expressions.get(0);
        List<Expression> expression2 = 
        		elsewhen_dec.size() == 0 ? null : expressions.subList(1, expressions.size());
        List<Equation> equation1 = null;
        List<Equation> equation2 = null;       
        if (when_dec != null) {    
        	EquationVisitor equationVisitor = new EquationVisitor();
        	equation1 = ctx.equation() == null ? null : ctx.equation()
        			.stream()
        			.map(equation -> equation.accept(equationVisitor))
        			.collect(toList());
        	equation2 = null;
        } else {
        	EquationVisitor equationVisitor = new EquationVisitor();
        	//System.out.printf("%n I am here! %n");
        	equation1 = null;
        	equation2 = ctx.equation() == null ? null : ctx.equation()
        			.stream()
        			.map(equation -> equation.accept(equationVisitor))
        			.collect(toList());
        }        
        return new When_equation(expression1, equation1, expression2, equation2);
      }
    }

    // ========= need further refinements =========
    private static class When_statementVisitor extends modelicaBaseVisitor<When_statement> {
      @Override
      public When_statement visitWhen_statement(@NotNull modelicaParser.When_statementContext ctx) {
        List<String> when_dec = ctx.WHEN()
        		.stream()
        		.map(WHEN -> WHEN.getText())
        		.collect(toList());
        List<String> elsewhen_dec = ctx.ELSEWHEN() == null ? null : ctx.ELSEWHEN()
        		.stream()
        		.map(ELSEWHEN -> ELSEWHEN.getText())
        		.collect(toList());
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        List<Expression> expressions = ctx.expression()
                .stream()
                .map(expression -> expression.accept(expressionVisitor))
                .collect(toList());
        Expression expression1 = expressions.get(0);
        List<Expression> expression2 = null;
        if (elsewhen_dec.size() > 0) {
        	expression2 = expressions.subList(1, expressions.size());
        }
        List<Statement> statement1 = null;
        List<Statement> statement2 = null;
        if (when_dec != null) {     
          StatementVisitor statementVisitor = new StatementVisitor();
          statement1 = ctx.statement() == null ? null : ctx.statement()
                  .stream()
                  .map(statement -> statement.accept(statementVisitor))
                  .collect(toList());
        } else if (elsewhen_dec != null) {
          StatementVisitor statementVisitor = new StatementVisitor();
          statement2 = ctx.statement() == null ? null : ctx.statement()
                  .stream()
                  .map(statement -> statement.accept(statementVisitor))
                  .collect(toList());
        }
        return new When_statement(expression1, statement1, expression2, statement2);
      }
    }

    private static class Connect_clauseVisitor extends modelicaBaseVisitor<Connect_clause> {
      @Override
      public Connect_clause visitConnect_clause(@NotNull modelicaParser.Connect_clauseContext ctx) {
        Component_referenceVisitor component_referenceVisitor = new Component_referenceVisitor();
        List<Component_reference> component_reference_1 = ctx.component_reference()
                .stream()
                .map(component_reference -> component_reference.accept(component_referenceVisitor))
                .collect(toList());
        return new Connect_clause(component_reference_1);
      }
    }

    // ========= need further refinements to specify the expression3 and expression4 =========
    // ========= should be aware of using ".add" function =========
    private static class ExpressionVisitor extends modelicaBaseVisitor<Expression> {
	@Override
      public Expression visitExpression(@NotNull modelicaParser.ExpressionContext ctx) {
        Simple_expressionVisitor simple_expressionVisitor = new Simple_expressionVisitor();
        Simple_expression simple_expression_1 = 
        		ctx.simple_expression() == null ? null : ctx.simple_expression().accept(simple_expressionVisitor);
    	List<String> elseif_dec = ctx.ELSEIF() == null ? null : ctx.ELSEIF()
          		.stream()
          		.map(ELSEIF -> ELSEIF.getText())
          		.collect(toList());
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        List<Expression> expressions = ctx.expression() == null ? null : ctx.expression()
        		.stream()
        		.map(expression -> expression.accept(expressionVisitor))
        		.collect(toList());       
        Expression expression1 = 
        		expressions.size()>0 ? expressions.get(0) : null;
        Expression expression2 = 
        		expressions.size()>0 ? expressions.get(1) : null;
        List<Expression> expression3 = new ArrayList<>(); 
        List<Expression> expression4 = new ArrayList<>(); 
        //System.out.printf("elseif_dec: %n '%s'%n",elseif_dec);
        //System.out.printf("elseif_dec.size: %n '%s'%n",elseif_dec.size());
        if (elseif_dec.size() == 0) {
        	expression3 = null;
        	expression4 = null;
        } else if (elseif_dec.size() == 1) {
        	expression3 = expressions.subList(2,3);
        	expression4 = expressions.subList(3,4);
        } else {

        	for (int i=1; i<((expressions.size()-3)/2+1); i++) {
        		expression3.add(expressions.get(2*i));
        		expression4.add(expressions.get(2*i+1));
        	}       	
        }
        Expression expression5 = 
        		expressions.size()>0 ? expressions.get(expressions.size()-1) : null;
        return new Expression(simple_expression_1, expression1, expression2,
                              expression3, expression4, expression5);
      }
    }

    private static class Simple_expressionVisitor extends modelicaBaseVisitor<Simple_expression> {
      @Override
      public Simple_expression visitSimple_expression(@NotNull modelicaParser.Simple_expressionContext ctx) {
        Logical_expressionVisitor logical_expressionVisitor = new Logical_expressionVisitor();
        List<Logical_expression> logical_expressions = ctx.logical_expression()
        		.stream()
        		.map(logical_expression -> logical_expression.accept(logical_expressionVisitor))
        		.collect(toList());
        Logical_expression logical_expression1 = logical_expressions.get(0);
        Logical_expression logical_expression2 = 
        		logical_expressions.size() > 1 ? logical_expressions.get(1) : null;
        Logical_expression logical_expression3 = 
        		logical_expressions.size() > 2 ? logical_expressions.get(2) : null;
        return new Simple_expression(logical_expression1, logical_expression2, logical_expression3);
      }
    }

    private static class Logical_expressionVisitor extends modelicaBaseVisitor<Logical_expression> {
      @Override
      public Logical_expression visitLogical_expression(@NotNull modelicaParser.Logical_expressionContext ctx) {
    	List<String> or_decs = ctx.OR() == null ? null : ctx.OR()
    			.stream()
        		.map(OR -> OR.getText())
        		.collect(toList());
        Logical_termVisitor logical_termVisitor = new Logical_termVisitor();
        List<Logical_term> logical_terms = ctx.logical_term()
        		.stream()
        		.map(logical_term -> logical_term.accept(logical_termVisitor))
        		.collect(toList());
        Logical_term logical_term_1 = logical_terms.get(0);
        List<Logical_term> logical_term_2 = 
        		logical_terms.size()>1 ? logical_terms.subList(1, logical_terms.size()) : null;
        return new Logical_expression(logical_term_1, or_decs, logical_term_2);
      }
    }

    private static class Logical_termVisitor extends modelicaBaseVisitor<Logical_term> {
      @Override
      public Logical_term visitLogical_term(@NotNull modelicaParser.Logical_termContext ctx) {
    	List<String> and_decs = ctx.AND() == null ? null : ctx.AND()
    			.stream()
        		.map(AND -> AND.getText())
        		.collect(toList());
        Logical_factorVisitor logical_factorVisitor = new Logical_factorVisitor();
        List<Logical_factor> logical_factors = ctx.logical_factor()
        		.stream()
        		.map(logical_factor -> logical_factor.accept(logical_factorVisitor))
        		.collect(toList());
        Logical_factor logical_factor_1 = logical_factors.get(0);
        List<Logical_factor> logical_factor_2 = 
        		logical_factors.size()>1 ? logical_factors.subList(1, logical_factors.size()) : null;
        return new Logical_term(logical_factor_1, and_decs, logical_factor_2);
      }
    }

    private static class Logical_factorVisitor extends modelicaBaseVisitor<Logical_factor> {
      @Override
      public Logical_factor visitLogical_factor(@NotNull modelicaParser.Logical_factorContext ctx) {
        String not_dec = 
        		ctx.NOT() == null ? null : ctx.NOT().getText();
        RelationVisitor relationVisitor = new RelationVisitor();
        Relation relation = ctx.relation().accept(relationVisitor);
        return new Logical_factor(not_dec, relation);
      }
    }

    private static class RelationVisitor extends modelicaBaseVisitor<Relation> {
      @Override
      public Relation visitRelation(@NotNull modelicaParser.RelationContext ctx) {
        Arithmetic_expressionVisitor arithmetic_expressionVisitor = new Arithmetic_expressionVisitor();
        List<Arithmetic_expression> arithmetic_expressions = ctx.arithmetic_expression()
        		.stream()
        		.map(arithmetic_expression -> arithmetic_expression.accept(arithmetic_expressionVisitor))
        		.collect(toList());  
        Arithmetic_expression arithmetic_expression1 = arithmetic_expressions.get(0);
        Arithmetic_expression arithmetic_expression2 = 
        		arithmetic_expressions.size()>1 ? arithmetic_expressions.get(1) : null;
        Rel_opVisitor rel_opVisitor = new Rel_opVisitor();
        Rel_op rel_op1 = 
        		ctx.rel_op() == null ? null : ctx.rel_op().accept(rel_opVisitor);
        return new Relation(arithmetic_expression1, rel_op1, arithmetic_expression2);
      }
    }

    private static class Rel_opVisitor extends modelicaBaseVisitor<Rel_op> {
      @Override
      public Rel_op visitRel_op(@NotNull modelicaParser.Rel_opContext ctx) {
    	//Rel_opVisitor rel_opVisitor = new Rel_opVisitor();   	
    	//Rel_op ope_dec = ctx.accept(rel_opVisitor);
    	String ope_dec = ctx.getText();  
        return new Rel_op(ope_dec);
      }
    }

    private static class Arithmetic_expressionVisitor extends modelicaBaseVisitor<Arithmetic_expression> {
      @Override
      public Arithmetic_expression visitArithmetic_expression(@NotNull modelicaParser.Arithmetic_expressionContext ctx) {
        Add_opVisitor add_opVisitor = new Add_opVisitor();
        List<Add_op> add_ops = ctx.add_op() == null ? null : ctx.add_op()
        		.stream()
        		.map(add_op -> add_op.accept(add_opVisitor))
        		.collect(toList());  
        TermVisitor termVisitor = new TermVisitor();
        List<Term> terms = ctx.term()
        		.stream()
        		.map(term -> term.accept(termVisitor))
        		.collect(toList());
        Add_op add_op1 = null;
        List<Add_op> add_op2 = null; // new ArrayList<>();
        if (terms.size()>1) {
        	if (terms.size() == add_ops.size()) {
        		add_op1 = add_ops.get(0);
            	add_op2 = add_ops.subList(1, add_ops.size());
        	} else {
        		add_op2 = add_ops;
        	}
        } else {
        	if (terms.size() == add_ops.size()) {
        		add_op1 = add_ops.get(0); 
        		add_op2 = null;
        	} 
        }        	             
        return new Arithmetic_expression(add_op1, terms, add_op2);
      }
    }

    private static class Add_opVisitor extends modelicaBaseVisitor<Add_op> {
      @Override
      public Add_op visitAdd_op(@NotNull modelicaParser.Add_opContext ctx) {
    	//Add_opVisitor add_opVisitor = new Add_opVisitor();   	
      	//Add_op add_dec = ctx.accept(add_opVisitor);
    	String add_dec = ctx.getText();  
        return new Add_op(add_dec);
      }
    }

    private static class TermVisitor extends modelicaBaseVisitor<Term> {
      @Override
      public Term visitTerm(@NotNull modelicaParser.TermContext ctx) {
        Mul_opVisitor mul_opVisitor = new Mul_opVisitor();
        List<Mul_op> mul_op_1 = ctx.mul_op() == null ? null : ctx.mul_op()
                .stream()
                .map(mul_op -> mul_op.accept(mul_opVisitor))
                .collect(toList());
        FactorVisitor factorVisitor = new FactorVisitor();
        List<Factor> factors = ctx.factor()
              .stream()
              .map(factor -> factor.accept(factorVisitor))
              .collect(toList());
        Factor factor_1 = factors.get(0);
        List<Factor> factor_2 = 
        		factors.size()>1 ? factors.subList(1, factors.size()) : null;
        return new Term(factor_1, mul_op_1, factor_2);
      }
    }

    private static class Mul_opVisitor extends modelicaBaseVisitor<Mul_op> {
      @Override
      public Mul_op visitMul_op(@NotNull modelicaParser.Mul_opContext ctx) {  			
    	//Mul_opVisitor mul_opVisitor = new Mul_opVisitor();   	
        String mul_dec = ctx.getText();       
        return new Mul_op(mul_dec);
      }
    }

    private static class FactorVisitor extends modelicaBaseVisitor<Factor> {
      @Override
      public Factor visitFactor(@NotNull modelicaParser.FactorContext ctx) {
        PrimaryVisitor primaryVisitor = new PrimaryVisitor();
        List<Primary> primarys = ctx.primary()
                .stream()
                .map(primary -> primary.accept(primaryVisitor))
                .collect(toList());
        String caret = 
        		ctx.SYMBOL_CARET()==null ? null : ctx.SYMBOL_CARET().getText();
        String dotCaret = 
        		ctx.SYMBOL_DOTCARET()==null ? null : ctx.SYMBOL_DOTCARET().getText();
        		
        return new Factor(primarys, caret, dotCaret);
      }
    }

    private static class PrimaryVisitor extends modelicaBaseVisitor<Primary> {
      @Override
      public Primary visitPrimary(@NotNull modelicaParser.PrimaryContext ctx) {
        String num_dec = 
        		ctx.UNSIGNED_NUMBER() == null ? null : ctx.UNSIGNED_NUMBER().getText();
        String str_dec = 
        		ctx.STRING() == null ? null : ctx.STRING().getText();
        String false_dec = 
        		ctx.FALSE() == null ? null : ctx.FALSE().getText();
        String true_dec = 
        		ctx.TRUE() == null ? null : ctx.TRUE().getText();
        String der_der = 
        		ctx.DER() == null ? null : ctx.DER().getText();
        String init_dec = 
        		ctx.INITIAL() == null ? null : ctx.INITIAL().getText();
        String end_dec = 
        		ctx.END() == null ? null : ctx.END().getText();
        NameVisitor nameVisitor = new NameVisitor();
        Name name1 = 
        		ctx.name() == null ? null : ctx.name().accept(nameVisitor);        
        Function_call_argsVisitor function_call_argsVisitor = new Function_call_argsVisitor();
        Function_call_args function_call_args1 = 
        		ctx.function_call_args() == null ? null : ctx.function_call_args().accept(function_call_argsVisitor);
        Component_referenceVisitor component_referenceVisitor = new Component_referenceVisitor();
        Component_reference component_reference1 = 
        		ctx.component_reference() == null ? null : ctx.component_reference().accept(component_referenceVisitor);
        Output_expression_listVisitor output_expression_listVisitor = new Output_expression_listVisitor();
        Output_expression_list output_expression_list1 = 
        		ctx.output_expression_list() == null ? null : ctx.output_expression_list().accept(output_expression_listVisitor);
        Expression_listVisitor expression_listVisitor = new Expression_listVisitor();
        List<Expression_list> expression_list_1 = ctx.expression_list() == null ? null : ctx.expression_list()
              .stream()
              .map(expression_list -> expression_list.accept(expression_listVisitor))
              .collect(toList());
        Function_argumentsVisitor function_argumentsVisitor = new Function_argumentsVisitor();
        Function_arguments function_arguments1 = 
        		ctx.function_arguments() == null ? null : ctx.function_arguments().accept(function_argumentsVisitor);
        return new Primary(num_dec, str_dec, false_dec, true_dec, name1, der_der, init_dec,
                           function_call_args1, component_reference1, output_expression_list1,
                           expression_list_1, function_arguments1, end_dec);
      }
    }

    private static class NameVisitor extends modelicaBaseVisitor<Name> {
      @Override
      public Name visitName(@NotNull modelicaParser.NameContext ctx) {
    	List<String> dots = ctx.SYMBOL_DOT()==null ? null : ctx.SYMBOL_DOT()
    			.stream()
    			.map(SYMBOL_DOT -> SYMBOL_DOT.getText())
    			.collect(toList());
        List<String> ident = ctx.IDENT()
        		.stream()
        		.map(IDENT -> IDENT.getText())
        		.collect(toList());
        return new Name(dots, ident);
      }
    }

    private static class Component_referenceVisitor extends modelicaBaseVisitor<Component_reference> {
      @Override
      public Component_reference visitComponent_reference(@NotNull modelicaParser.Component_referenceContext ctx) {
    	List<String> dots = ctx.SYMBOL_DOT()==null ? null : ctx.SYMBOL_DOT()
    			.stream()
    			.map(SYMBOL_DOT -> SYMBOL_DOT.getText())
    			.collect(toList());
    	List<String> ident = ctx.IDENT()
          		.stream()
          		.map(IDENT -> IDENT.getText())
          		.collect(toList());
        Array_subscriptsVisitor array_subscriptsVisitor = new Array_subscriptsVisitor();
        List<Array_subscripts> array_subscripts_1 = ctx.array_subscripts() == null ? null : ctx.array_subscripts()
              .stream()
              .map(array_subscripts -> array_subscripts.accept(array_subscriptsVisitor))
              .collect(toList());
        return new Component_reference(ident, dots, array_subscripts_1);
      }
    }

    private static class Function_call_argsVisitor extends modelicaBaseVisitor<Function_call_args> {
      @Override
      public Function_call_args visitFunction_call_args(@NotNull modelicaParser.Function_call_argsContext ctx) {
        Function_argumentsVisitor function_argumentsVisitor = new Function_argumentsVisitor();
        Function_arguments function_arguments = 
        		ctx.function_arguments() == null ? null : ctx.function_arguments().accept(function_argumentsVisitor);
        return new Function_call_args(function_arguments);
      }
    }

    private static class Function_argumentsVisitor extends modelicaBaseVisitor<Function_arguments> {
      @Override
      public Function_arguments visitFunction_arguments(@NotNull modelicaParser.Function_argumentsContext ctx) {
        Function_argumentVisitor function_argumentVisitor = new Function_argumentVisitor();
        Function_argument function_argument = 
        		ctx.function_argument() == null ? null : ctx.function_argument().accept(function_argumentVisitor);
        Function_argumentsVisitor function_argumentsVisitor = new Function_argumentsVisitor();
        Function_arguments function_arguments = 
        		ctx.function_arguments() == null ? null : ctx.function_arguments().accept(function_argumentsVisitor);
        String for_dec = 
        		ctx.FOR() == null ? null : ctx.FOR().getText();
        For_indicesVisitor for_indicesVisitor = new For_indicesVisitor();
        For_indices for_indices = 
        		ctx.for_indices() == null ? null : ctx.for_indices().accept(for_indicesVisitor);
        Named_argumentsVisitor named_argumentsVisitor = new Named_argumentsVisitor();
        Named_arguments named_arguments = 
        		ctx.named_arguments() == null ? null : ctx.named_arguments().accept(named_argumentsVisitor);
        return new Function_arguments(function_argument, function_arguments, for_dec, for_indices, named_arguments);
      }
    }

    private static class Named_argumentsVisitor extends modelicaBaseVisitor<Named_arguments> {
      @Override
      public Named_arguments visitNamed_arguments(@NotNull modelicaParser.Named_argumentsContext ctx) {
        Named_argumentVisitor named_argumentVisitor = new Named_argumentVisitor();
        Named_argument named_argument = ctx.named_argument().accept(named_argumentVisitor);
        Named_argumentsVisitor named_argumentsVisitor = new Named_argumentsVisitor();
        Named_arguments named_arguments = 
        		ctx.named_arguments() == null ? null : ctx.named_arguments().accept(named_argumentsVisitor);
        return new Named_arguments(named_argument,named_arguments);
      }
    }

    private static class Named_argumentVisitor extends modelicaBaseVisitor<Named_argument> {
      @Override
      public Named_argument visitNamed_argument(@NotNull modelicaParser.Named_argumentContext ctx) {
        String ident = ctx.IDENT().getText();
        Function_argumentVisitor function_argumentVisitor = new Function_argumentVisitor();
        Function_argument function_argument = ctx.function_argument().accept(function_argumentVisitor);
        return new Named_argument(ident, function_argument);
      }
    }

    private static class Function_argumentVisitor extends modelicaBaseVisitor<Function_argument> {
      @Override
      public Function_argument visitFunction_argument(@NotNull modelicaParser.Function_argumentContext ctx) {
    	String fun_dec = 
    			ctx.FUNCTION() == null ? null : ctx.FUNCTION().getText();
        NameVisitor nameVisitor = new NameVisitor();
        Name name = 
        		ctx.name() == null ? null : ctx.name().accept(nameVisitor);
        Named_argumentsVisitor named_argumentsVisitor = new Named_argumentsVisitor();
        Named_arguments named_arguments = 
        		ctx.named_arguments() == null ? null : ctx.named_arguments().accept(named_argumentsVisitor);
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        Expression expression = 
        		ctx.expression() == null ? null : ctx.expression().accept(expressionVisitor);
        return new Function_argument(fun_dec, name, named_arguments, expression);
      }
    }

    private static class Output_expression_listVisitor extends modelicaBaseVisitor<Output_expression_list> {
      @Override
      public Output_expression_list visitOutput_expression_list(@NotNull modelicaParser.Output_expression_listContext ctx) {
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        List<Expression> expression_1 = ctx.expression() == null ? null : ctx.expression()
              .stream()
              .map(expression -> expression.accept(expressionVisitor))
              .collect(toList());
        return new Output_expression_list(expression_1);
      }
    }

    private static class Expression_listVisitor extends modelicaBaseVisitor<Expression_list> {
      @Override
      public Expression_list visitExpression_list(@NotNull modelicaParser.Expression_listContext ctx) {
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        List<Expression> expression_1 = ctx.expression()
              .stream()
              .map(expression -> expression.accept(expressionVisitor))
              .collect(toList());
        return new Expression_list(expression_1);
      }
    }

    private static class Array_subscriptsVisitor extends modelicaBaseVisitor<Array_subscripts> {
      @Override
      public Array_subscripts visitArray_subscripts(@NotNull modelicaParser.Array_subscriptsContext ctx) {
        SubscriptVisitor subscriptVisitor = new SubscriptVisitor();
        List<Subscript> subscript_1 = ctx.subscript()
              .stream()
              .map(subscript -> subscript.accept(subscriptVisitor))
              .collect(toList());
        return new Array_subscripts(subscript_1);
      }
    }

    private static class SubscriptVisitor extends modelicaBaseVisitor<Subscript> {
      @Override
      public Subscript visitSubscript(@NotNull modelicaParser.SubscriptContext ctx) {
        ExpressionVisitor expressionVisitor = new ExpressionVisitor();
        Expression expression = 
        		ctx.expression() == null ? null : ctx.expression().accept(expressionVisitor);
        return new Subscript(expression);
      }
    }

    private static class CommentVisitor extends modelicaBaseVisitor<Comment> {
      @Override
      public Comment visitComment(@NotNull modelicaParser.CommentContext ctx) {
        String_commentVisitor string_commentVisitor = new String_commentVisitor();
        String_comment string_comment1 = ctx.string_comment().accept(string_commentVisitor);
        AnnotationVisitor annotationVisitor = new AnnotationVisitor();
        Annotation annotation1 = 
        		ctx.annotation() == null ? null : ctx.annotation().accept(annotationVisitor);
        return new Comment(string_comment1, annotation1);
      }
    }

    private static class String_commentVisitor extends modelicaBaseVisitor<String_comment> {
      @Override
      public String_comment visitString_comment(@NotNull modelicaParser.String_commentContext ctx) {
        List<String> str_dec = ctx.STRING() == null ? null : ctx.STRING()
        		.stream()
        		.map(STRING -> STRING.getText())
        		.collect(toList());
        return new String_comment(str_dec);
      }
    }

    private static class AnnotationVisitor extends modelicaBaseVisitor<Annotation> {
      @Override
      public Annotation visitAnnotation(@NotNull modelicaParser.AnnotationContext ctx) {
    	String ann_dec = ctx.ANNOTATION().getText();
        Class_modificationVisitor class_modificationVisitor = new Class_modificationVisitor();
        Class_modification class_modification = ctx.class_modification().accept(class_modificationVisitor);
        return new Annotation(ann_dec, class_modification);
      }
    }
}
