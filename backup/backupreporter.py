# -*- coding: utf-8 -*-
#!/usr/bin/python3
import datetime, os

PATH="/storage/backup"
NEWFILES={}
AGE=1

def get_all_files(path):
    files={}
    for root, dirs, names in os.walk(path):
        for i in names:
            if root in files:
                files[root].append(i)
            else:
                files[root] = []
                files[root].append(i)
    return files


def get_modified_time(path):
    return datetime.datetime.fromtimestamp(os.path.getmtime(path))

def get_mb_file_size(path):
    return float(os.path.getsize(path)/1048576)

def generate_new_list(filelist):
    for root in filelist:
        for files in filelist[root]:
            if ((datetime.datetime.now() - get_modified_time(root+"/"+files)).days < AGE):
                if root in NEWFILES:
                    NEWFILES[root].append(files)
                else:
                    NEWFILES[root] = []
                    NEWFILES[root].append(files)

def generate_pretty():
    txt = ""
    for root in NEWFILES:
        txt += root + "\n"
        for files in NEWFILES[root]:
            txt += files + "\t\t"+ str(format(get_mb_file_size(root+"/"+files), '.3f')) + " MB" + "\t" + "Date: " + get_modified_time(root+"/"+files).strftime("%d-%m-%Y %H:%M:%S") + "\n"
        txt += "\n"
    return txt        

def raidstat():
    print(os.popen("cat /proc/mdstat").read())
        

generate_new_list(get_all_files(PATH))
print(generate_pretty())
print(raidstat())

