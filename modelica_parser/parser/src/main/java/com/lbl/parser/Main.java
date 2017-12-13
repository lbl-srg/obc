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
import java.util.List;
import java.util.ArrayList;

/**
 * Created by JayHu on 07/21/2017
 */
public class Main {

	private static final String modelicaSourceCode(String filePath) {
		return readLineByLineJava8(filePath);
	}

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

	private String fileNameToSearch;
	private List<String> result = new ArrayList<String>();
	public String getFileNameToSearch() {
		return fileNameToSearch;
	}
	public void setFileNameToSearch (String fileNameToSearch) {
		this.fileNameToSearch = fileNameToSearch;
	}
	public List<String> getResult() {
		return result;
	}

    public static void main(String[] args) {
    	String dirToBeSearched = System.getProperty("user.dir").concat("/" + "modelica_models");
    	Main fileSearch = new Main();
    	fileSearch.searchDirectory(new File(dirToBeSearched), ".mo");

    	int count = fileSearch.getResult().size();
    	if (count == 0) {
    		System.err.println("\nNo .mo files found.");
			System.exit(1);
    	} else {
   	    for (String matched : fileSearch.getResult()){
    	    	int dotInd = matched.indexOf(".");
    	    	String nameForJson = matched.substring(0, dotInd).replace("modelica_models", "json_files").concat(".json");
    	    	int dirRootEnd = nameForJson.lastIndexOf("/");
    	    	String dirRootStr = nameForJson.substring(0, dirRootEnd);

    	    	Path path = Paths.get(dirRootStr);
    	    	File dirRoot = new File(dirRootStr);
    	    	if (! dirRoot.exists()) {
    	    		try {
    	    		    Files.createDirectories(path);
    	    		} catch (IOException e) {
    	    		    System.err.println("Cannot create directories - " + e);
						System.exit(1);
    	    		}
    	    	}
    	    	//System.out.printf("%nrootWithName: '%s'", dirRoot);
    	    	final Stored_definition antlrParseOut = new VisitorOrientedParser().parse(modelicaSourceCode(matched));
    	    	Gson gson = new GsonBuilder().setPrettyPrinting().create();
    	    	//Gson gson = new Gson();
    	    	final String jsonOut = gson.toJson(antlrParseOut);
    	    	try {
    	    		File newTextFile = new File(nameForJson);
    	    		FileWriter fw = new FileWriter(newTextFile);
    	    		fw.write(jsonOut);
    	    		fw.close();

    	    	} catch (IOException iox) {
    	    		iox.printStackTrace();
					System.exit(1);
    	    	}
    	    }
			System.exit(0);
    	}
    }

    public void searchDirectory(File directory, String fileNameToSearch) {
    	setFileNameToSearch(fileNameToSearch);
    	if (directory.isDirectory()) {
    	    search(directory);
    	} else {
    	    System.out.println(directory.getAbsoluteFile() + " is not a directory!");
    	}
      }
    private void search(File file) {
    	if (file.isDirectory()) {
           //allowed to read this directory?
    	    if (file.canRead()) {
    	    	for (File temp : file.listFiles()) {
    	    		if (temp.isDirectory()) {
    	    			search(temp);
    	    		} else {
    	    			int dotInd = temp.getName().lastIndexOf(".");
    	    			int nameLen = temp.getName().length();
    	    			// some files don't have any extension so that dotInd will be -1
    	    			int indForExt = dotInd==(-1) ? 0 : dotInd;
    	    			//if (getFileNameToSearch().equals(temp.getName().toLowerCase())) {
    	    		    if (getFileNameToSearch().equals(temp.getName().substring(indForExt,nameLen))) {
    	    				result.add(temp.getAbsoluteFile().toString());
    	    			}
    	    		}
    	    	}
    	 } else {
    		System.out.println(file.getAbsoluteFile() + "Permission Denied");
    	 }
          }

      }

}
