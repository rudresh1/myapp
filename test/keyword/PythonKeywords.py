
import json
import os
import sys
import re


def get_test_data_with_filter(fileName, testDataKey="", testDataValues="", excludeDataValue=""):
    """ Read JSON file and return test data.

        Examples:
            | getFilterTestData('fileName', 'scenario', {'scenario_1','scenario_5'}) | Return test set where value of key 'scenario' is scenario_1 and scenario_2 |
            | getFilterTestData('fileName', 'scenario', 'All') | Return all test set available in file |
            | getFilterTestData('fileName', 'scenario', '', {'scenario_5','scenario_10'}) | Return all test set except scenario_5 and scenario_10 |
    """
    root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__))) + '/testData/' + fileName + '.json'
    data = json.load(open(root_dir))
    dataString = ""
    if testDataKey == "":
        print('Either Key or Value is not provided. So all Test data were selected by default.')
        output_dict = data
    else:
        common_data = [x for x in data if x[testDataKey] in {''}]
 
        for y in common_data:
            common_Data_Dict = y

        if testDataValues == 'All':
            data_list = [x for x in data if not x[testDataKey] in {''}]

        elif excludeDataValue != "":
            print("else")
            data_list = [x for x in data if x[testDataKey] not in excludeDataValue and not x[testDataKey] in {''}]
        else:
            print("inelse")
            data_list = [x for x in data if x[testDataKey] in testDataValues and not x[testDataKey] in {''}]
        output_dict = []
        for x in data_list:
            temp = common_Data_Dict.copy()
            temp.update(x)
            output_dict.append(temp)
    return output_dict

