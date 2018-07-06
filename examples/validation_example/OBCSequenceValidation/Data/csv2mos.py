import os
import numpy as np
import pandas as pd
import datetime
from dateutil import parser

from pdb import set_trace as bp

# set manually: find earliest timestamp across data sets, or choose a timestamp to start the data with
# earliest_timestamp_string = "10/8/2017 12:00:00 PDT"
# for the 5s cooling valve study
earliest_timestamp_string = "6/7/2018 17:00:00 PDT"

earliest_timestamp_s = parser.parse(earliest_timestamp_string).timestamp()


def trend_data_csv2mos(path2csv, outpath):
    """Reads trends in csv files downloaded from the web server.
    Raw data columns: "Date", "Excel Time", "Value", "Notes"
    Other manually added columns are permitted.
    This function:
        - reads the csv in, 
        - converts timestamp to unix time and a time elapsed from earliest_timestamp_s timestamp [s]
        - appends a row before data if any of the observed trends 
        in other csv files used in the same simulation have 
        start times earlier than the file getting converted,
        - keeps relative timestamp in seconds and the associated 
        values,
        - writes a mos file readable by combiTimeTable model.
        
    Notes
    -----
    Units are kept as in the downloaded trends and should be converted as needed: 
        - T [F]
        - Flow [cfm] 
    """
    # read in all data the first time to get the filename and table name info
    # from the first row
    raw_data_for_names = pd.read_csv(path2csv, header = 0)

    # set filename which indicates the contents of the file
    outfilename = raw_data_for_names.columns[0].replace(" ", "_").replace('_/_','_') + '.mos'
    # set table name for mos datafile
    tablename = raw_data_for_names.columns[0].split("/")[-1].strip().replace(" ", "_")
    
    # read in all data the second time time to get the dataframe
    raw_data = pd.read_csv(path2csv, header = 1)


    # Clean data and prepare timestamp for usage in modelica data reader (combiTimeTable)
    
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
    
    # time elapsed in seconds, starting from the earliest timestamp in any of the datasets
    time_in_s = np.vectorize(return_unix_time)(data["Date"])
    data['Unix_Time'] = time_in_s
    data = data.reindex(data.columns[-1:].append(data.columns[:-1]), axis = 1)

    # what is the first timestamp time?
    time_in_s_0 = parser.parse(data.loc[0, "Date"]).timestamp()
    
    # remove any data recorded prior to the desired earliest timestamp, if they exist
    if time_in_s_0 < earliest_timestamp_s:
        data = data.loc[data['Unix_Time']>=earliest_timestamp_s, :].reset_index(drop = True)
        # get the new first timestamp
        time_in_s_0 = parser.parse(data.loc[0, "Date"]).timestamp()
        time_in_s = np.vectorize(return_unix_time)(data["Date"])

    # prepend timestamp for the case study earliest timestamp, if applicable
    if time_in_s_0 > earliest_timestamp_s:
        # move data 1 row down
        data = pd.DataFrame(data.loc[:0,:]).append(data).reset_index(drop = True)
        # fill in the new 0th row with values from the 1st row 
        for column_label in raw_data.columns:
            data.loc[0,column_label] = data.loc[1,column_label]
        # replace the timestamp (string and unix) in the 0th row with the earliest timestamp
        data.loc[0,"Date"] = earliest_timestamp_string
        data.loc[0,"Unix_Time"] = earliest_timestamp_s
        time_in_s = np.vectorize(return_unix_time)(data["Date"])

    # initiate delta time in seconds column

    data["Seconds_Delta"] = 0
    data.loc[1:,"Seconds_Delta"] = time_in_s[1:] - time_in_s[:-1]
    data["Seconds_Elapsed"] = data["Seconds_Delta"].cumsum(axis = 0)
    data = data.reindex(data.columns[-1:].append(data.columns[:-1]), axis = 1)

    # drop "Date" and "Seconds_Delta" column and reorder columns
    data = data.drop(["Date", "Seconds_Delta"], axis = 1)

    # convert to floats
    data = data.astype(float)

    # all set, write mos file
    print(write_mos(outpath + outfilename, tablename, data))


def return_unix_time(timestamp_string):
    """Converts a string timestamp into a float timestamp in 
    seconds.
    
    Parameters
    ----------
    timestamp_string : str
        String timestamp in human-readable format.
        
    Returns
    -------
    float unix time timestamp, s
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
    file.write("# Recorded trend: " + outfilepath + "\n")
    file.write("# Columns: " + ', '.join(list(data.columns)) + "\n") 
    file.write("double " + tablename + str(data.shape) + "\n")
    for inx, row in data.iterrows():
        file.write(', '.join(list(row.astype(str))) + "\n")

    file.close()
    
    return "Wrote " + outfilepath + ".\n"



## Script to convert all trend csv files for the validation example study
## 5s data, June 18
#filenames = ["{AHU ID} VFD Fan Enable.csv", \
#             "{AHU ID} VFD Fan Feedback.csv", "OA Temp.csv", "{AHU ID} Supply Air Temp.csv", \
#             "SA Clg Stpt.csv", "{AHU ID} Clg Coil Valve.csv"]
#
#folderpath = ""
#outpath = ""
#
#for filename in filenames:
#    print("Initiated: ", filename)
#    path = folderpath + filename
#    print(path)
#    trend_data_csv2mos(path, outpath)
