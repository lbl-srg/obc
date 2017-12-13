package com.lbl.parser;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.lbl.parser.domain.*;
import com.lbl.parser.parser.VisitorOrientedParser;

import java.nio.charset.StandardCharsets;
import java.util.stream.Stream;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;


/**
 * Created by JayHu on 07/21/2017
 */
public class Main {
    private static final String modelicaSourceCode = readLineByLineJava8(
    		"/home/jianjun/proj/Maven_Folder/ModelicaAntlrVisitor_v0_refine/parser/src/main/java/com/lbl/parser/Guideline36.mo");

    private static String readLineByLineJava8(String filePath) {
            StringBuilder contentBuilder = new StringBuilder();
            Path path = Paths.get(filePath);
            try (Stream<String> lines = Files.lines(path, StandardCharsets.UTF_8)) {           
                lines.forEach(s -> contentBuilder.append(s).append("\n"));
            }
            catch (IOException e) {
                e.printStackTrace();
            }            
            return contentBuilder.toString();
        }

    public static void main(String[] args) {
        final Stored_definition antlrParseOut = new VisitorOrientedParser().parse(modelicaSourceCode); 
        //Gson gson = new GsonBuilder().setPrettyPrinting().create(); 
        Gson gson = new Gson();
        System.out.printf("======= Start parsing ...... ========%n");
        final String jsonOut = gson.toJson(antlrParseOut);       
        try {
            File newTextFile = new File("parsedResults.json");
            FileWriter fw = new FileWriter(newTextFile);
            fw.write(jsonOut);
            fw.close();

        } catch (IOException iox) {
            iox.printStackTrace();
        }    
        
        System.out.printf("%n======= Done! ========%n");
//        System.out.printf("code below: %n '%s' %n has been parsed to object: %n '%s'%n",modelicaSourceCode,json);
    }
}
