# turtle_json_benchmark #

Matlab benchmarking for Turtle JSON. 

This program can be used to compare the performance of Turtle JSON to four other program for reading JSON in Matlab:

1. Matlab's builtin JSON parsing
2. Matlab-JSON by Chrstian Panton
3. C-JSON-IO by Oliver Woodford
4. JSONLab by Qianqian Fang

Files for testing are located at:
https://drive.google.com/drive/folders/0B7to9gBdZEyGMExwTFA0ZWh1OTA

A writeup can be found at ...

# Setup # 

Currently a lot of manual setup is needed (~5 minutes).

1. Download the following Google Drive directory to the data folder.
    * Navitage to https://drive.google.com/drive/folders/0B7to9gBdZEyGMExwTFA0ZWh1OTA
    * At the top, right below search, click on json_examples and download all
    * Unzip the folder and place in the data folder
2. Download Christian Panton's Matlab-JSON
    * Navigate to https://github.com/christianpanton/matlab-json
    * download zip to progs folder
    * Unzip files
    * Navitage to bin folder and unzip "windows precompiled"
    * Move files into subfolder of progs e.g. "\progs\matlab-json-master\fromjson.mexw64"
    * on mac - brew install json-c then run make script
3. Download JSONLab
    * Navigate to https://github.com/fangq/jsonlab
    * Download zip to progs folder
    * Unzip files
4. Download C++ JSON IO
    * Navigate to https://www.mathworks.com/matlabcentral/fileexchange/59166-c-json-io
    * Download zip to progs folder
    * Go to: https://raw.githubusercontent.com/nlohmann/json/develop/single_include/nlohmann/json.hpp
    * Save the file in json_read.cpp
    * Change directory to that containing json_read.cpp
    * Run `mex json_read.cpp`
5. Add all the relevant folders to your path

```
%For example I have:
addpath('G:\repos\matlab_git\turtle_json_benchmark\progs\matlab-json-master')
addpath('G:\repos\matlab_git\turtle_json_benchmark\progs\c  _json_io\c++_json_io')
addpath('G:\repos\matlab_git\turtle_json_benchmark\progs\jsonlab-master\jsonlab-master')
%I also already have Turtle JSON on the path
```

# Test Programs #


## Native Matlab ##

- 2015b - matlab.internal.webservices.fromJSON
- 2016b - jsondecode

## Christian Panton's Matlab-JSON ##

https://github.com/christianpanton/matlab-json

- Relies on [JSON-C](https://github.com/json-c/json-c)

## JSONlab ##

https://github.com/fangq/jsonlab

- Written in Matlab only

## C++ JSON IO ##

https://www.mathworks.com/matlabcentral/fileexchange/59166-c++-json-io

- Relies on [nlohmann json](https://github.com/nlohmann/json), a C++ parser
- Copied json.hpp to download folder of FEX and then compiled