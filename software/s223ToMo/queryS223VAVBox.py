import rdflib

def getAllVavs(g):
    s223NS = rdflib.Namespace('http://data.ashrae.org/standard223#')
    query = """
            SELECT DISTINCT ?vav
            WHERE {
                ?vav a s223:SingleDuctTerminal .
            }
            """
    res = g.query(query)
    result = []
    for row in res:
        result.append(row[0])
    return result

def checkIfReheatCoilPresent(g, vav):
    s223NS = rdflib.Namespace('http://data.ashrae.org/standard223#')
    query = """
            SELECT DISTINCT ?vav
            WHERE {
                ?vav a s223:SingleDuctTerminal .
                ?vav s223:contains ?reheat .
                ?reheat a s223:HeatingCoil .
            }
            """
    res = g.query(query)
    result = []
    for row in res:
        if row[0] == vav:
            return True
    return False

def getElectricHeatingCoil(g, vav):
    s223NS = rdflib.Namespace('http://data.ashrae.org/standard223#')
    g36 = rdflib.Namespace('http://data.ashrae.org/standard223/1.0/extensions/g36#')
    g.bind("s223", s223NS)  # bind an RDFLib-provided namespace to a prefix
    g.bind("g36", g36)
    query = "SELECT  ?vav ?coil \n"+\
            "WHERE { \n "+\
            "    ?coil a s223:HeatingCoil . \n"+\
            "    ?coil a g36:ElectricHeatingCoil . \n"+\
            "    ?vav s223:contains ?coil . \n"+\
            "    ?coil s223:hasRole ?role . \n"+\
            "    FILTER regex(STR(?vav), \"{0}\") . \n".format(vav)+\
            " }"
    res = g.query(query)
    result = []
    for row in res:
        if row[1] not in result:
            result.append(row[1])
    return result

def getAllPropertiesAndSensors(g, inputVAV):
    s223NS = rdflib.Namespace('http://data.ashrae.org/standard223#')
    query = "SELECT  ?vav ?air_out_cnx_point ?cnx_to_room ?air_in_cnx_point ?ds ?zone ?p ?sensor ?property_type ?substance_type \n"+\
            "WHERE { \n "+\
            "    ?vav a s223:SingleDuctTerminal . \n"+\
            "    ?vav s223:cnx ?air_out_cnx_point . \n"+\
            "    ?air_out_cnx_point a s223:OutletConnectionPoint . \n"+\
            "    ?air_out_cnx_point s223:hasMedium s223:Medium-Air . \n"+\
            "    ?air_out_cnx_point s223:cnx ?cnx_to_room . \n"+\
            "    ?cnx_to_room a s223:Connection . \n"+\
            "    ?air_in_cnx_point s223:cnx ?cnx_to_room . \n"+\
            "    ?air_in_cnx_point a s223:InletConnectionPoint . \n"+\
            "    ?ds a s223:DomainSpace . \n"+\
            "    ?ds s223:cnx ?air_in_cnx_point . \n"+\
            "    ?zone s223:contains ?ds . \n"+\
            "    ?zone a s223:Zone . \n"+\
            "    ?zone s223:hasProperty ?p . \n"+\
            "    OPTIONAL { \n"+\
            "        ?sensor s223:observes ?p . \n"+\
            "        ?sensor s223:hasObservationLocation ?ds . \n"+\
            "    } \n"+\
            "    ?p a ?property_type . \n"+\
            "    ?p s223:ofSubstance|s223:hasEnumerationKind ?substance_type . \n"+\
            "    FILTER regex(STR(?vav), \"{0}\") . \n".format(inputVAV)+\
            " }"
    res = g.query(query)
    result = {}
    for row in res:
        if row[0] == inputVAV:
            vav = row[0]
            zone = row[5]
            p = row[6]
            sensor = row[7]
            property_type = row[8]
            substance_type = row[9]
            if property_type == s223NS['EnumeratedObservableProperty']:
                if substance_type == s223NS['EnumerationKind-Occupancy']:
                    result['occupancy'] = {
                        'sensor': sensor,
                        'property': p,
                        'zone': zone
                    }
                if substance_type == s223NS['EnumerationKind-OnOff']:
                    result['window'] = {
                        'sensor': sensor,
                        'property': p,
                        'zone': zone
                    }
            elif property_type == s223NS['QuantifiableObservableProperty']:
                if substance_type == s223NS['Substance-CO2']:
                    result['CO2'] = {
                        'sensor': sensor,
                        'property': p,
                        'zone': zone
                    }
    return result