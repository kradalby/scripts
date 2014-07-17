# -*- coding: utf-8 -*-
#!/usr/bin/env python
import datetime, os

PATH = "/storage/backup"
BTRFS_MOUNT = [('/storage','/dev/sdd')]
NEWFILES = {}
AGE = 1

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

def diskInformation():

    print("-----------------------------------------------------------------------------------")
    for mount in BTRFS_MOUNT:
        print(os.popen("btrfs filesystem show %s" % mount[1]).read())
        print(os.popen("btrfs filesystem df %s" % mount[0]).read())
        print("-----------------------------------------------------------------------------------")
        

    disks = os.popen("ls -1 /dev/sd*").read().split("\n")[:-1]
    for disk in disks:
        if len(disk) == 8:
            lines = [x for x in os.popen("smartctl -H %s" % disk).read().split("\n") if x][2:]
            print(disk)
            print("\n".join(lines))
            print("-----------------------------------------------------------------------------------")
            
        

generate_new_list(get_all_files(PATH))
print(generate_pretty())
print(diskInformation())

