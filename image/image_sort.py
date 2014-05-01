import Image
from ExifTags import TAGS
import datetime
import os
 

sort_directory = 'sort'
sorted_dir = 'sorted/'

def get_exif(fn):
    i = Image.open(fn)
    info = i._getexif()
    ret = {}
    for tag, value in info.items():
        decoded = TAGS.get(tag, tag)
        ret[decoded] = value
    return ret
 
def get_photo_datetime(exif_dict):
    dt = exif_dict['DateTime']
    object = datetime.datetime.strptime(dt, '%Y:%m:%d %H:%M:%S')
    return object
 
def get_files(directory):
    f = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            f.append(root + '/' + file)
    return f
 
def get_date_path(datetime):
    path = datetime.strftime('%Y/%m/%d/')
    return path
 
def makedir(path):
    os.system('mkdir -p %s%s' % (sorted_dir, path))
 
def move_file(source, dest):
    #os.system('mv %s %s' % (source,dest))
    os.rename(source,dest)
 

def main():
    files = get_files(sort_directory)
    for file in files:
        try:
            exif = get_exif(file)
            dt = get_photo_datetime(exif)
            print dt
            path = get_date_path(dt)
            print path
            makedir(path)
            destination = sorted_dir + path + file.split('/')[-1]
            print destination
            move_file(file,destination)
        except:
            none = None
main()
