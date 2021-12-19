import os
import shutil

folderindex = 0
input_folder = os.path.dirname(os.path.abspath(__file__)) + "\input"
output_folder = os.path.dirname(os.path.abspath(__file__)) + "\output"

def get_size(path):
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            total_size += os.path.getsize(fp)
    return total_size

if not os.path.isdir(input_folder):
	os.mkdir(input_folder)

if not os.path.isdir(output_folder):
	os.mkdir(output_folder)

folderindex += 1
if not os.path.isdir(output_folder + "\\folder" + str(folderindex)):
	os.mkdir(output_folder + "\\folder" + str(folderindex))

for file in os.listdir(input_folder):
	size = get_size(output_folder  + "\\folder" + str(folderindex)) + os.path.getsize(input_folder + "\\" + file)
	if size < 12000000:
		shutil.move(os.path.join(input_folder, file), output_folder  + "\\folder" + str(folderindex))
	else:
		folderindex += 1
		if not os.path.isdir(output_folder + "\\folder" + str(folderindex)):
			os.mkdir(output_folder + "\\folder" + str(folderindex))

		shutil.move(os.path.join(input_folder, file), output_folder  + "\\folder" + str(folderindex))








