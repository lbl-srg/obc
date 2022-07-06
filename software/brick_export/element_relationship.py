import json
import os
import subprocess

class Element_Relationship_Extractor:
    def __init__(self, mo_file=None, parent_element_name=None, config_file="config.json"):
        if mo_file is None:
            with open(config_file) as fp:
                config = json.load(fp)
        else:
            config = {'model': mo_file, 'generate_json': True}
        
        self.parent_element_name = parent_element_name
        self.model = config.get('model')
        self.generate_json = config.get('generate_json', True)
        self.output_dir = os.getcwd() + os.sep + 'test' # change this later
        self.elements = {}
        self.relationships = {}
        self.modelica_path = os.environ.get('MODELICAPATH').split(':')[1]
        
    def run_modelica_json(self):
        if self.generate_json: 
            model_path = self.model.replace('.', os.sep)
            modelica_json_path = os.environ.get('MODELICAJSONPATH', '.')
            app_js_path = os.path.join(modelica_json_path, 'app.js')
            
            if not self.model.endswith(".mo"):
                model_path = model_path + '.mo'
                
            top_level = True
            if not os.path.exists(os.path.join(self.modelica_path, model_path)):
                while not os.path.exists(os.path.join(self.modelica_path, model_path)):
                    print("model_path {} does not exist".format(model_path))
                    model_path = os.sep.join(model_path.split(os.sep)[:-1])+".mo"
                    top_level = False

#             print("Running modelica-json tool for {0}.".format(self.model))
#             print("node {0} -f {1} -d {2} -o json".format(app_js_path, model_path, self.output_dir))
            result = subprocess.run(['node', '{}'.format(app_js_path), '-f', '{}'.format(model_path),
                                     '-d', '{}'.format(self.output_dir), '-o', 'json'],
                                    stdout=subprocess.PIPE, shell=False)

            if result.returncode != 0:
                raise Exception("failed to run modelica_json. Error!!")
            else:
                pass
#                 print("Successfully generated json file for {}.".format(self.model))
        else:
            pass
#             print("generate_json flag is false")
            
        if top_level:
            json_model_path = os.path.join(self.output_dir, 'json', self.model.replace(".", os.sep) + ".json")
        else:
            ## TODO: check if 1 file, different models (different class definitions) or if 1 class_definition and different elements within it
            json_model_name = model_path.split('.')[0]+".json"
            json_model_path = os.path.join(self.output_dir, 'json', json_model_name)
        with open(json_model_path) as fp:
            json_op = json.load(fp)
        return json_op
    
    def extract_class_definition(self, json_op=None):
        """
        "class_definition": {
           "final": bool,
           "encapsulated": bool,
           "class_prefixes": class_prefixes,
           "class_specifier": class_specifier
        }
        """
        elements = {} # self.elements
        relationships = {} 
        if json_op is None:
            json_op = self.run_modelica_json()
        if 'class_definition' in json_op:
            for single_class_definition in json_op.get('class_definition'):
                class_specifier = single_class_definition.get('class_specifier', {})
                
                if 'short_class_specifier' in class_specifier:
                    short_class_specifier = class_specifier.get('short_class_specifier')
                    identifier = short_class_specifier.get('identifier', None)
                    value = short_class_specifier.get("value")
                    
                    name = value.get("name", None)
                    if name is not None:
                        if self.parent_element_name is not None:
                            identifier = self.parent_element_name+"."+identifier
                        new_element = {identifier: {'type_specifier': name}}
                        
                    enum_list = value.get("enum_list", [])
                    if len(enum_list) > 0:
                        enumerations = []
                        for item in enum_list:
                            enumerations.append(item.get("identifier", ""))

                        if self.parent_element_name is not None:
                            identifier = self.parent_element_name+"."+identifier
                        new_element = {identifier: {'type_specifier': 'Enumeration', 'values': enumerations}}
                    elements.update(new_element)
                    ## TODO: handle name[array_subscripts]

                if 'der_class_specifier' in class_specifier:
                    pass

                if 'long_class_specifier' in class_specifier:
                    long_class_specifier = class_specifier.get('long_class_specifier', {})
                    identifier = long_class_specifier.get('identifier', "")
                    composition = long_class_specifier.get('composition', {})
                    element_list = composition.get('element_list', [])

                    new_elements, new_relationships = self.parse_element_list(element_list)
                    elements.update(new_elements)
                    relationships = self.update_relationships(relationships, new_relationships)
                    
                    element_sections = composition.get('element_sections', [])
                    for element_section in element_sections:
                        ## Each element section only has 1 of public_element_list, protected_element_list, equation_section or algorithm_section
                        
                        public_element_list = element_section.get('public_element_list', [])
                        new_elements, new_relationships = self.parse_element_list(public_element_list)
                        elements.update(new_elements)
                        relationships = self.update_relationships(relationships, new_relationships)

                        protected_element_list = element_section.get('protected_element_list', [])
                        new_elements, new_relationships = self.parse_element_list(protected_element_list)
                        elements.update(new_elements)
                        relationships = self.update_relationships(relationships, new_relationships)

                        equation_section = element_section.get('equation_section', {})
                        new_relationships = self.parse_equation_section(equation_section)
                        relationships = self.update_relationships(relationships, new_relationships)

        return elements, relationships

    def parse_element_list(self, element_list):
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

        elements = {}
        relationships = {}
        for single_element in element_list:
            if 'extends_clause' in single_element:
                extended_from_model = single_element.get('extends_clause').get('name')
                if (extended_from_model.startswith("Buildings")):
                    extends_mo = Element_Relationship_Extractor(mo_file = extended_from_model, parent_element_name=self.parent_element_name)
                    new_elements, new_relationships = extends_mo.extract_class_definition()
                    elements.update(new_elements)
                    relationships = self.update_relationships(relationships, new_relationships)
                    

            if 'import_clause' in single_element:
                ## TODO: handle later
                pass

            if 'class_definition' in single_element:
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

                    if self.parent_element_name is not None:
                        identifier=self.parent_element_name+"."+identifier

                    if identifier not in new_elements:
                        new_elements[identifier] = {
                            'type_specifier': type_specifier,
                            'type_prefix': type_prefix
                        }
                    else:
                        pass
#                         print("{} already exists! ".format(identifier))
#                         print("exising element: ", model_all_elements[identifier])
#                         print("existing models_to_parse: ", models_to_parse[current_mo_file])
#                         print("new type: ", type_specifier)
#                         print("new file: ", current_mo_file)

#                     print("identifier = {}, type_specifier = {}".format(identifier, type_specifier))
                    if type_specifier.startswith("Buildings."):
                        # TODO: if parsed already, don't parse again
                        single_component_mo = Element_Relationship_Extractor(mo_file=type_specifier, parent_element_name=identifier)
                        new_elements2, new_relationships2 = single_component_mo.extract_class_definition()
                        new_elements.update(new_elements2)
                        new_relationships = self.update_relationships(new_relationships, new_relationships2)
                        
                elements.update(new_elements)
                relationships = self.update_relationships(relationships, new_relationships)

        return elements, relationships
    
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
                    from_id = self.parent_element_name+"."+ from_id
                    to_id = self.parent_element_name+"."+ to_id
                
                if from_id in relationships:
                    if to_id not in relationships[from_id]:
                        relationships[from_id].append(to_id)
                else: 
                    relationships[from_id] = [to_id]
                
                if to_id in relationships:
                    if from_id not in relationships[to_id]:
                        relationships[to_id].append(from_id)
                else: 
                    relationships[to_id] = [from_id]
                
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