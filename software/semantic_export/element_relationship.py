import json
import os
import subprocess

parsed_files = {}

class Element_Relationship_Extractor:
    def __init__(self, mo_file=None, parent_element_name="", config_file="config.json"):
        global parsed_files

        if mo_file is None:
            with open(config_file) as fp:
                config = json.load(fp)
        else:
            config = {'model': mo_file, 'generate_json': True}
        
        if parent_element_name != "":
            self.parent_element_name = parent_element_name
            if not parent_element_name.endswith("."):
                self.parent_element_name+="."
        else: 
            self.parent_element_name = ""
        self.model = config.get('model')
        self.generate_json = config.get('generate_json', True)
        self.output_dir = os.getcwd() + os.sep + 'test' # change this later
        self.elements = {}
        self.relationships = {}
        self.modelica_path = os.environ.get('MODELICAPATH').split(':')[1]
        self.within = None
        
    def run_modelica_json(self):
        """

        """
        if self.model in parsed_files:
            json_op = parsed_files[self.model]
            self.within = json_op.get("within", None)
            return json_op

        if self.generate_json: 
            model_path = self.model.replace('.', os.sep)
            modelica_json_path = os.environ.get('MODELICAJSONPATH', '.')
            app_js_path = os.path.join(modelica_json_path, 'app.js')
            
            if not self.model.endswith(".mo"):
                model_path = model_path + '.mo'
                
            top_level = True
            if not os.path.exists(os.path.join(self.modelica_path, model_path)):
                while not os.path.exists(os.path.join(self.modelica_path, model_path)) and model_path!=".mo":
                    # print("model_path {} does not exist".format(model_path))
                    model_path = os.sep.join(model_path.split(os.sep)[:-1])+".mo"
                    top_level = False

            if model_path == ".mo":
                # print("File not found for {}".format(self.model))
                return False

            # print("Running modelica-json tool for {0}.".format(self.model))
            # print("node {0} -f {1} -d {2} -o json".format(app_js_path, model_path, self.output_dir))
            result = subprocess.run(['node', '{}'.format(app_js_path), '-f', '{}'.format(model_path),
                                     '-d', '{}'.format(self.output_dir), '-o', 'json'],
                                    stdout=subprocess.PIPE, shell=False)

            if result.returncode != 0:
                raise Exception("failed to run modelica_json. Error!!")
            else:
                pass
                # print("Successfully generated json file for {}.".format(self.model))
        else:
            pass
            # print("generate_json flag is false")
            
        if top_level:
            json_model_path = os.path.join(self.output_dir, 'json', self.model.replace(".", os.sep) + ".json")
        else:
            ## TODO: check if 1 file, different models (different class definitions) or if 1 class_definition and different elements within it
            json_model_name = model_path.split('.')[0]+".json"
            json_model_path = os.path.join(self.output_dir, 'json', json_model_name)
            # print("found model in {}".format(json_model_name))
        with open(json_model_path) as fp:
            json_op = json.load(fp)
            self.within = json_op.get("within", None)

        parsed_files[self.model] = json_op
        return json_op
    
    def extract_class_definition(self, json_op=None, elements=None, relationships=None):
        """
        function to extract elements and relationships from "class_definition" Modelica token
        "class_definition": {
           "final": bool,
           "encapsulated": bool,
           "class_prefixes": class_prefixes,
           "class_specifier": class_specifier
        }
        json_op: dict
                json translation of the model
        elements: dict
                dictionary of elements and their type in the form: {ele: {"type_specifier": type, "..."}}
        relationships: dict
                dictionary of elements and the elements they are connected to in the form of {ele: [ele1, ele2...], ele1: [ele, el3, ..]}
        """
        if elements is None:
            elements = {} # self.elements
        if relationships is None:
            relationships = {} 

        if json_op is None:
            json_op = self.run_modelica_json()
            if json_op == False:
                return {}, {}

        if 'class_definition' in json_op:
            for single_class_definition in json_op.get('class_definition'):
                ## TODO: handle replaceable
                class_specifier = single_class_definition.get('class_specifier', {})
                class_prefixes = single_class_definition.get('class_prefixes')
                
                if 'short_class_specifier' in class_specifier:
                    short_class_specifier = class_specifier.get('short_class_specifier')
                    identifier = short_class_specifier.get('identifier', None)
                    value = short_class_specifier.get("value")
                    
                    name = value.get("name", None)
                    if name is not None:
                        identifier = self.parent_element_name+identifier
                        new_element = {identifier: {'type_specifier': name}}
                        
                    enum_list = value.get("enum_list", [])
                    if len(enum_list) > 0:
                        enumerations = []
                        for item in enum_list:
                            enumerations.append(item.get("identifier", ""))

                        identifier = self.parent_element_name+identifier
                        new_element = {identifier: {'type_specifier': 'Enumeration', 'values': enumerations}}
                    elements.update(new_element)
                    ## TODO: handle name[array_subscripts]

                if 'der_class_specifier' in class_specifier:
                    pass

                if 'long_class_specifier' in class_specifier:
                    # TODO: handle long_class_specifier within a model, so not top level
                    long_class_specifier = class_specifier.get('long_class_specifier', {})
                    identifier = long_class_specifier.get('identifier', "")
                    composition = long_class_specifier.get('composition', {})
                    element_list = composition.get('element_list', [])

                    new_elements, new_relationships = self.parse_element_list(element_list, elements=elements, relationships=relationships)
                    elements.update(new_elements)
                    relationships = self.update_relationships(relationships, new_relationships)
                    
                    element_sections = composition.get('element_sections', [])
                    for element_section in element_sections:
                        ## Each element section only has 1 of public_element_list, protected_element_list, equation_section or algorithm_section
                        
                        public_element_list = element_section.get('public_element_list', [])
                        new_elements, new_relationships = self.parse_element_list(public_element_list, elements=elements, relationships=relationships)
                        elements.update(new_elements)
                        relationships = self.update_relationships(relationships, new_relationships)

                        protected_element_list = element_section.get('protected_element_list', [])
                        new_elements, new_relationships = self.parse_element_list(protected_element_list, elements=elements, relationships=relationships)
                        elements.update(new_elements)
                        relationships = self.update_relationships(relationships, new_relationships)

                        equation_section = element_section.get('equation_section', {})
                        new_relationships = self.parse_equation_section(equation_section)
                        relationships = self.update_relationships(relationships, new_relationships)

        return elements, relationships

    def parse_element_list(self, element_list, elements=None, relationships=None):
        """
            element_list: list(element)

            "element": {
            "import_clause": import_clause,
            "extends_clause": extends_clause,
            "redeclare": bool,
            "final": bool,
            "inner": bool,
            "outer": bool,
            "replaceable": bool,
            "constraining_clause": constraining_clause,
            "class_definition": class_definition,
            "component_clause": component_clause,
            "comment": comment
        }
        """ 
        if elements is None:
            elements = {}
        if relationships is None: 
            relationships = {}

        for single_element in element_list:
            if 'extends_clause' in single_element:
                extended_from_model = single_element.get('extends_clause').get('name')

                if (extended_from_model.startswith("Buildings")):
                    extends_mo = Element_Relationship_Extractor(mo_file = extended_from_model, parent_element_name=self.parent_element_name)
                    new_elements, new_relationships = extends_mo.extract_class_definition()
                    elements.update(new_elements)
                    relationships = self.update_relationships(relationships, new_relationships)
                elif not extended_from_model.startswith("Modelica"):
                    # if it is not buildings and not Modelica, should be within Buildings library
                    within = ""
                    new_elements = {}
                    new_relationships = {}
                    i = 1
                    while new_elements == {} and new_relationships == {} and within != self.within: 
                        within = '.'.join(self.within.split('.',i)[:i])
                        new_extended_from_model = within+"."+extended_from_model
                        extends_mo = Element_Relationship_Extractor(mo_file = new_extended_from_model, parent_element_name=self.parent_element_name)
                        new_elements, new_relationships = extends_mo.extract_class_definition()
                        i+=1
                    if new_elements == {} and new_relationships == {}:
                        new_extended_from_model = self.within+"."+extended_from_model
                        extends_mo = Element_Relationship_Extractor(mo_file = new_extended_from_model, parent_element_name=self.parent_element_name)
                        new_elements, new_relationships = extends_mo.extract_class_definition()

                    if new_elements != {} or new_relationships != {}:
                        # print("found new extends = {}".format(new_extended_from_model))
                        pass
                    else: 
                        # print("did not find extends = {} model={} parent = {}".format(extended_from_model, self.model, self.parent_element_name))
                        pass
                    elements.update(new_elements)
                    relationships = self.update_relationships(relationships, new_relationships)

                # handle redeclaration
                class_modifications = single_element.get("extends_clause").get("class_modification", [])
                for class_modification in class_modifications:
                    if class_modification.get("element_redeclaration", None) is not None:
                        type_specifier = class_modification.get("element_redeclaration",{}).get("component_clause1", {}).get("type_specifier", None)
                        identifier = class_modification.get("element_redeclaration",{}).get("component_clause1", {}).get("component_declaration1", {}).get("declaration", {}).get("identifier", None)
                        annotations = class_modification.get("element_redeclaration",{}).get("component_clause1", {}).get("component_declaration1", {}).get("description", {}).get('annotation', [])

                        semantic_info = ""

                        for annotation in annotations:
                            annotation_name = annotation.get('element_modification_or_replaceable', {}).get('element_modification', {}).get('name', None)
                            if annotation_name == "__semantic":
                                semantic_info = self.parse_semantic_annotation(annotation, standard='brick')

                        if type_specifier is not None and identifier is not None:
                            print("redeclaration element: {} of type {}".format(identifier, type_specifier))
                            identifier = self.parent_element_name+identifier
                            current_elements = elements.copy()
                            for item in current_elements:
                                # remove all items from the class that was redeclared
                                if item.startswith(identifier): 
                                    del elements[item]
                            new_elements, new_relationships = self.parse_single_component_list(type_specifier=type_specifier, type_prefix="", identifier=identifier, og_type_specifier="")
                            new_elements[identifier] = {"type_specifier": type_specifier, 
                                                        "type_prefix": class_modification.get("element_redeclaration",{}).get("component_clause1", {}).get("type_prefix", ""),
                                                        "semantic": semantic_info}
                            elements.update(new_elements)
                            relationships = self.update_relationships(relationships, new_relationships)

            if 'import_clause' in single_element:
                import_clause = single_element.get("import_clause", {})
                identifier = import_clause.get("identifier", None)
                name = import_clause.get("name", None)
                identifier = self.parent_element_name+identifier

                new_elements = {identifier: {"type_specifier": "import_clause", "name": name}}
                elements.update(new_elements)

            if 'class_definition' in single_element:
                if type(single_element.get("class_definition")) != list:
                    single_element["class_definition"] = [single_element.get("class_definition")]
                new_elements, new_relationships = self.extract_class_definition(json_op=single_element)
                elements.update(new_elements)
                relationships = self.update_relationships(relationships, new_relationships)

            if 'component_clause' in single_element:
                """
                    "component_clause": {
                        "type_prefix": type_prefix,x
                        "type_specifier": type_specifier,
                        "array_subscripts": array_subscripts, //nullable
                        "component_list": component_list
                    }
                """
                component_clause = single_element.get('component_clause')
                type_prefix = component_clause.get('type_prefix', None)
                type_specifier = component_clause.get('type_specifier', None)
                og_type_specifier = type_specifier

                ## check if type specifier is in import, if yes, change type_specifier to imported class
                extended_type_specifier = self.parent_element_name+type_specifier
                if extended_type_specifier in elements:
                    if elements.get(extended_type_specifier, {}).get("type_specifier", "") == "import_clause":
                        type_specifier = elements.get(extended_type_specifier, {}).get("name", None)
                    else: 
                        type_specifier = extended_type_specifier

                component_list = component_clause.get('component_list', [])
                
                new_elements = {}
                new_relationships = {}
                for single_component_list in component_list:
                    """
                        "component_list": list({
                            "declaration": declaration,
                            "condition_attribute": condition_attribute,
                            "comment": comment
                        })
                    """
                    identifier = single_component_list.get('declaration', {}).get('identifier', None)
                    identifier=self.parent_element_name+identifier
                    annotations = single_component_list.get('description', {}).get('annotation', [])
                    semantic_info = ""

                    for annotation in annotations:
                        annotation_name = annotation.get('element_modification_or_replaceable', {}).get('element_modification', {}).get('name', None)
                        if annotation_name == "__semantic":
                            semantic_info = self.parse_semantic_annotation(annotation, standard='brick')

                    if identifier not in new_elements:
                        # print("previous semantic = " + new_elements[identifier.rsplit('.', 1)[0]])
                        new_elements[identifier] = {
                            'type_specifier': type_specifier,
                            'type_prefix': type_prefix,
                            'semantic': semantic_info
                        }
                    else:
                        pass
                        # print("{} already exists! ".format(identifier))
                        # print("exising element: ", model_all_elements[identifier])
                        # print("existing models_to_parse: ", models_to_parse[current_mo_file])
                        # print("new type: ", type_specifier)
                        # print("new file: ", current_mo_file)

                    new_elements2, new_relationships2 = self.parse_single_component_list(type_specifier=type_specifier, type_prefix=type_prefix, identifier=identifier, og_type_specifier=og_type_specifier)
                    new_elements.update(new_elements2)
                    new_relationships = self.update_relationships(new_relationships, new_relationships2)
                        
                elements.update(new_elements)
                relationships = self.update_relationships(relationships, new_relationships)

        return elements, relationships

    def parse_single_component_list(self, type_specifier, type_prefix, identifier, og_type_specifier=None):
        new_elements2 = {}
        new_relationships2 = {}

        if self.parent_element_name != "" and type_specifier.startswith(self.parent_element_name):
            ## if type_specifier has been created in the same mo file (checked used same parent_element_name), then no need to parse model
            new_elements2 = {identifier: {"type_specifier": type_specifier}}
            ## TODO: what about relationships?
            new_relationships2 = {}
        elif type_specifier.startswith("Buildings.Examples"):
            # TODO: if parsed already, don't parse again
            single_component_mo = Element_Relationship_Extractor(mo_file=type_specifier, parent_element_name=identifier)
            new_elements2, new_relationships2 = single_component_mo.extract_class_definition()
        elif not type_specifier.startswith("Buildings") and not type_specifier.startswith("Modelica.") and type_specifier not in ["Real", "Integer", "Boolean", "String"] and not type_specifier.startswith("Medium"):
            ## assume type_specifier is in local package
            within = ""
            new_elements2 = {}
            new_relationships2 = {}
            i = 1
            while new_elements2 == {} and new_relationships2 == {} and within != self.within: 
                within = '.'.join(self.within.split('.',i)[:i])
                new_type_specifier = within+"."+type_specifier
                single_component_mo = Element_Relationship_Extractor(mo_file = new_type_specifier, parent_element_name=identifier)
                new_elements2, new_relationships2 = single_component_mo.extract_class_definition()
                i+=1
            if new_elements2 == {} and new_relationships2 == {}:
                new_type_specifier = self.within+"."+type_specifier
                single_component_mo = Element_Relationship_Extractor(mo_file = new_type_specifier, parent_element_name=identifier)
                new_elements2, new_relationships2 = single_component_mo.extract_class_definition()

            if new_elements2!={} or new_relationships2 != {}:
                # print("found new type_specifier = {} identifier = {} ".format(new_type_specifier, identifier))
                pass
            else: 
                print("did not find og_type_specifier={} type_specifier={} model={} parent={}".format(og_type_specifier, type_specifier, self.model, self.parent_element_name))
        return new_elements2, new_relationships2

    def update_relationships(self, relationships, new_relationships):
        for element in new_relationships:
            if element not in relationships:
                relationships[element] = new_relationships.get(element)
            else:
                for connected_element in new_relationships[element]:
                    if connected_element not in relationships[element]:
                        relationships[element].append(connected_element)
        return relationships
    
    def parse_equation_section(self, equation_section):
        equations = equation_section.get('equation', [])
        relationships = {}
        for equation in equations:
            connect_clause = equation.get('connect_clause', None)
            if connect_clause is not None:
                from_id = self.parse_component_reference(connect_clause.get("from"))
                to_id = self.parse_component_reference(connect_clause.get("to"))
                if self.parent_element_name is not None:
                    from_id = self.parent_element_name+ from_id
                    to_id = self.parent_element_name+ to_id
                
                if from_id in relationships:
                    if to_id not in relationships[from_id]:
                        relationships[from_id].append(to_id)
                else: 
                    relationships[from_id] = [to_id]
                
                # if to_id in relationships:
                #     if from_id not in relationships[to_id]:
                #         relationships[to_id].append(from_id)
                # else: 
                #     relationships[to_id] = [from_id]
                
        return relationships
    
    def parse_component_reference(self, component_reference):
        identifier = ""
        for item in component_reference:
            if item.get("dot_op", False):
                identifier+="."
            if item.get("identifier", None) is not None:
                identifier+=item.get("identifier")
            if item.get("array_subscripts") is not None:
                identifier+='[' + item.get("array_subscripts")[0].get("expression", {}).get("simple_expression") + ']'
        return identifier

    def parse_semantic_annotation(self, annotation, standard='brick'):
        class_modifications = annotation.get('element_modification_or_replaceable', {}).get('element_modification', {}).get('modification', {}).get('class_modification', [])
        semantic_data = ""
        for class_modification in class_modifications:
            element_modification = class_modification.get('element_modification_or_replaceable', {}).get('element_modification', {})
            standard_name = element_modification.get('modification', {}).get('expression', {}).get('simple_expression', None)
            standard_name = standard_name.replace('"', '')
            if standard_name is not None and standard_name == standard:
                semantic_data = element_modification.get('description_string', '')
        return semantic_data


def get_brick_type(semantic_info):
    if semantic_info != "":
        return BRICK[semantic_info.split(" ")[-1].split(":")[1]]
    return ""