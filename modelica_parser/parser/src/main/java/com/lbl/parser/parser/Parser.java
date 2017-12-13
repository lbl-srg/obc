package com.lbl.parser.parser;

import com.lbl.parser.domain.Stored_definition;

/**
 * Created by JayHu on 07/21/2017
 */
public interface Parser {
    Stored_definition parse(String modelicaSourceCode);
}
