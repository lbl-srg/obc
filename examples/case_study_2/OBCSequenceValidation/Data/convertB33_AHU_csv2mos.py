import os
import numpy as np
import pandas as pd
import datetime
from dateutil import parser


# set manually: find earliest timestamp accross data sets
# used in the case study
earliest_timestamp_string = "10/8/2017 12:00:00 PDT"

earliest_timestamp_s = parser.parse(earliest_timestamp_string).timestamp()


def B33_trend_data_csv2mos(path2csv):
    """Reads trends in csv files downloaded from the web server.
    Raw data columns: "Date", "Excel Time", "Value", "Notes"
    Other manually added columns are permitted.
    This function:
        - reads the csv in, 
        - converts timestamp to relative timestamp in seconds and 
        places it into the first column,
        - appends a row before data if any of the observed trends 
        in other csv files used in the same simulation have 
        start times earlier than the file getting converted,
        - keeps relative timestamp in seconds and the associated 
        values,
        - writes a mos file readable by combiTimeTable model in 
	the folder where the script is run from (unless edited).
        
    Notes
    -----
    Units are kept as in the downloaded trends and should be converted as needed: 
        - T [F]
        - Flow [cfm] 
    """
    # read in all data
    raw_data = pd.read_csv(path2csv, header = 0)

    # set filename which indicates the contents of the file
    outfilename = raw_data.columns[0].replace(" ", "_").replace('_/_','_') + '.mos'
    # set table name for mos datafile
    tablename = raw_data.columns[0].split("/")[-1].strip().replace(" ", "_")


    # Clean data and prepare timestamp for usage in modelica data reader (combiTimeTable)

    # remove the row which carried information that already got extracted
    raw_data = pd.DataFrame(data = raw_data.loc[1:,:].values, columns = raw_data.loc[0,:])

    # if there is a Notes column, drop it
    if "Notes" in raw_data.columns:
        raw_data = raw_data.drop("Notes", axis = 1)
    # we use the string timestamp, so drop the excel date:
    if "Excel Time" in raw_data.columns:
        raw_data = raw_data.drop("Excel Time", axis = 1)

    # drop missing values, interpolation will fill it with the values recorded in previous timestep
    for column_label in raw_data.columns:
        null_values_index = pd.isnull(raw_data[column_label]) == True
        rows_to_drop = null_values_index.index[null_values_index]
        data = raw_data.drop(rows_to_drop)


    # Synchronize timeseries and convert to relative timestamp 

    # what is the first timestamp time?
    time_in_s_0 = parser.parse(data.loc[0, "Date"]).timestamp()

    # prepend timestamp for the case study earlies timestamp, if applicable
    if time_in_s_0 > earliest_timestamp_s:
        data = pd.DataFrame(data.loc[:0,:]).append(data).reset_index(drop = True)
        for column_label in raw_data.columns:
            data.loc[0,column_label] = data.loc[1,column_label]
        data.loc[0,"Date"] = earliest_timestamp_string

    # time elapsed in seconds, starting from the earliest timestamp in any of the datasets
    time_in_s = np.vectorize(return_unix_time)(data["Date"])

    # initiate delta time in seconds column 
    data["Seconds_Elapsed"] = 0
    data.loc[1:,"Seconds_Elapsed"] = time_in_s[1:] - time_in_s[:-1]


    # drop "Date" column and reorder columns
    data = data.drop("Date", axis = 1)
    data = data.reindex(data.columns[-1:].append(data.columns[:-1]), axis=1)

    # convert to floats
    data = data.astype(float)

    # all set, write mos file    
    print(write_mos(outfilename, tablename, data))


def return_unix_time(timestamp_string):
    """Converts a string timestamp into a flot timestamp in 
    seconds.
    
    Parameters
    ----------
    timestamp_string : str
	String timestamp in human-readable format.
    """
    return parser.parse(timestamp_string).timestamp()

    
def write_mos(outfilepath, tablename, data):
    """Writes contents to mos file with 
    appropriate header information
    
    Parameters
    ----------
    outfilepath : str
        Path to *.mos file, including the filename and the mos extension 
    tablename : str
        Table name to be entered into the data reader 
    data : array
        Comma-separated rows for each time instance containing timestamp and
        any data recorded
    """

    file = open(outfilepath,"w") 

    file.write("#1\n")
    file.write("# Recorded trend: " + outfilename + "\n")
    file.write("# Columns: " + ', '.join(list(data.columns)) + "\n") 
    file.write("double " + tablename + str(data.shape))
    for inx, row in data.iterrows():
        file.write(', '.join(list(row.astype(str))) + "\n")

    file.close()
    
    return "Wrote " + outfilename + ".\n"
