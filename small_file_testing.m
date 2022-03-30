%small file testing

data = json.utils.examples.speedTokenTest('utf8_01.json',10000,2);
temp = json.utils.getMexC(data);

data1 = json.utils.examples.speedDataTest('utf8_01.json',10000,1);
data2 = json.utils.examples.speedDataTest('utf8_01.json',10000,2);
data5 = json.utils.examples.speedDataTest('utf8_01.json',10000,5);



%873 bytes %200 us
data = json.utils.examples.speedTokenTest('svg_menu.json',10000,2);
temp = json.utils.getMexC(data);
%250 us for data for TJ - now 150 us
data1 = json.utils.examples.speedDataTest('svg_menu.json',10000,1);
data2 = json.utils.examples.speedDataTest('svg_menu.json',10000,2);
%170 us for C++io json
data5 = json.utils.examples.speedDataTest('svg_menu.json',10000,5);



%Round 1
%                 elapsed_read_time: 0.027
%                      c_parse_time: 0.006
%          parsed_data_logging_time: 0.041
%          total_elapsed_parse_time: 0.051
%               object_parsing_time: 0.007
%                  object_init_time: 0.011
%                array_parsing_time: 0.003
%               number_parsing_time: 0
%     string_memory_allocation_time: 0.009
%               string_parsing_time: 0.001
%             total_elapsed_pp_time: 0.039
%            total_elapsed_time_mex: 0.122

%read - 30 us
%parse - 50 us
%pp - 40 us

%40 us to create data logging
%11 us to create objects
