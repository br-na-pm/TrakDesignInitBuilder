import os
import xml.etree.ElementTree as ETree
import math


def search_string_in_file(file_name, string_to_search):
    """Search for the given string in file and return lines containing that string,
    along with line numbers"""
    line_number = 0
    list_of_results = []
    # Open the file in read only mode
    with open(file_name, 'r') as read_obj:
        # Read all lines in the file one by one
        for line in read_obj:
            # For each line, check if line contains the string
            line_number += 1
            if string_to_search in line:
                # If yes, then add the line number & line as a tuple in the list
                list_of_results.append((line_number, line.rstrip()))
    # Return list of tuples containing line numbers and lines where string is found
    return list_of_results


def delete_multiple_lines(original_file, line_numbers):
    """In a file, delete the lines at line number in given list"""
    is_skipped = False
    counter = 0
    # Create name of dummy / temporary file
    dummy_file = original_file + '.bak'
    # Open original file in read only mode and dummy file in write mode
    with open(original_file, 'r') as read_obj, open(dummy_file, 'w') as write_obj:
        # Line by line copy data from original file to dummy file
        for line in read_obj:
            # If current line number exist in list then skip copying that line
            if counter not in line_numbers:
                write_obj.write(line)
            else:
                is_skipped = True
            counter += 1
    # If any line is skipped then rename dummy file as original file
    if is_skipped:
        os.remove(original_file)
        os.rename(dummy_file, original_file)
    else:
        os.remove(dummy_file)


def generate_func(init, hw, cable=5):
    tree = ETree.parse(hw)
    root = tree.getroot()
    ns = {'namespace': 'http://br-automation.co.at/AS/Hardware'}
    seg_dict = {}
    for module in root.findall('namespace:Module', ns):
        full_module = module.attrib['Type']
        part_module = full_module[0:4]
        if part_module == '8F1I':
            for segment in module.findall('namespace:Parameter', ns):
                seg_par_id = (segment.attrib['ID'])
                if seg_par_id == 'Shape':
                    if segment.attrib['Value'] == 'STRAIGHT660':
                        seg_shape = 'TYPE_AA'
                    elif segment.attrib['Value'] == 'CIRCULAR_TO_STRAIGHT105':
                        seg_shape = 'TYPE_BA'
                    elif segment.attrib['Value'] == 'STRAIGHT105_TO_CIRCULAR':
                        seg_shape = 'TYPE_AB'
                    elif segment.attrib['Value'] == 'CIRCULAR':
                        seg_shape = 'TYPE_BB'
                elif seg_par_id == 'SegmentReference':
                    seg_ref = segment.attrib['Value']
            seg_dict[seg_ref] = seg_shape

    # Find the existing segments in the file
    section_lines = search_string_in_file(init, 'TrakDesign.Segment')
    segment_list = list()
    for elem in section_lines:
        segment_list.append(elem[0])
    # account for empty lines when we delete by finding min and max of the entries
    segment_max = max(segment_list)
    segment_min = min(segment_list)
    segment_list2 = list(range(segment_min - 1, segment_max + 1))
    # delete the lines
    delete_multiple_lines(init, segment_list2)

    # search for our section header and find the index
    segment_assembly = search_string_in_file(init, '// segment assembly')
    for elem in segment_assembly:
        start_index = elem[0]

    with open(init, 'r') as f:
        contents = f.readlines()
    index = 1
    for key, value in seg_dict.items():
        cable_val = math.floor((index - 1) / cable) + 1
        write_value = "\tTrakDesign.Segment[" + str(index) + "].ParaName := '" + key + "';\t TrakDesign.Segment[" + str(index) \
                      + "].ParaType := " + value + ";\t TrakDesign.Segment[1].ParaIxCable := " + str(cable_val) + "; \n"
        contents.insert(start_index + index, write_value)
        index = index + 1

    with open(init, "w") as f:
        contents = "".join(contents)
        f.write(contents)
