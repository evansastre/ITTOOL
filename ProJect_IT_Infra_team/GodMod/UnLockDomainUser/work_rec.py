import getpass
import shutil
import os

def work_rec(recfilename):
    user=getpass.getuser() 
    dest= r"C:/Users/"+ user + r"\AppData\Local\Temp\work_rec.exe"
    shutil.copyfile("//ITTOOL_node1/ITTOOLS/Scripts/myIncludethings/work_rec.exe",dest) 
    os.popen(dest + " "+recfilename)
#work_rec()
