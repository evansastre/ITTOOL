# -*- coding: utf-8 -*-
import  os
os.system("title 即时通密码修改")
import time 
import getpass
import sys
from PyQt5.QtWidgets import *
from PyQt5 import QtCore
from selenium import webdriver
from selenium.webdriver.common.keys import Keys


sysCharType = sys.getfilesystemencoding()
username=getpass.getuser() #当前用户名

##对话框
import ctypes
import sys
sysCharType = sys.getfilesystemencoding() #获取系统的编码方式 
tip= 'tip'.encode(sysCharType)
def msg(tip, tip_main):
    tip_main= tip_main.encode(sysCharType)
    ctypes.windll.user32.MessageBoxA(0,tip_main,tip, 0) 
    

##记录
import os
def work_rec(recfilename):
    dest= "//ITTOOL_node1/ITTOOLS/Scripts/myIncludethings/work_rec.exe"
    os.popen(dest + " "+recfilename)

class Ui_Dialog(object):
    def setupUi(self, Dialog):
        #.setObjectName(_fromUtf8("Dialog"))
        Dialog.setObjectName("Dialog")
        Dialog.resize(415, 141)
        
        self.lineEdit = QLineEdit(Dialog)
        self.lineEdit.setGeometry(QtCore.QRect(100, 40, 201, 31))
        #self.lineEdit.setObjectName(_fromUtf8("lineEdit"))
        self.lineEdit.setObjectName("lineEdit")
        
        self.pushButton = QPushButton(Dialog)
        self.pushButton.setEnabled(True)
        self.pushButton.setGeometry(QtCore.QRect(100, 80, 75, 23))
        self.pushButton.setAutoDefault(True)
        self.pushButton.setDefault(True)
        self.pushButton.setObjectName("pushButton")
        
        self.cancel = QPushButton(Dialog)
        self.cancel.setGeometry(QtCore.QRect(230, 80, 75, 23))
        self.cancel.setObjectName("cancel")
        
        self.label = QLabel(Dialog)
        self.label.setGeometry(QtCore.QRect(100, 10, 151, 16))
        self.label.setMidLineWidth(0)
        self.label.setObjectName("label")
        
        self.label2 = QLabel(Dialog)
        self.label2.setGeometry(QtCore.QRect(100, 110, 270, 32))
        self.label2.setMidLineWidth(0)
        self.label2.setObjectName("label2")

        self.retranslateUi(Dialog)
       
        self.cancel.clicked.connect(Dialog.close)
        QtCore.QMetaObject.connectSlotsByName(Dialog)

    def retranslateUi(self, Dialog):
        Dialog.setWindowTitle( "即时通密码自助修改工具")
        self.pushButton.setToolTip( "点击确认后开始重置个人即时通账号密码。")
        self.cancel.setToolTip( "退出工具")
        self.pushButton.setText("确认")
        self.cancel.setText( "退出")
        self.label.setText("请输入要设置成的密码")
        self.label2.setText("密码长度6~16位，由区分大小写的字母、\n数字、特殊字符至少两种组成，且不可与帐号相同。")


class Dialog(QDialog, Ui_Dialog):
    def __init__(self, parent=None):
        QDialog.__init__(self, parent)
        self.setupUi(self)
        
    
    #这个装饰器不能删，否则会运行两遍
    @QtCore.pyqtSlot()  
    def on_pushButton_clicked(self):
        def funa(ss):
            print(ss)
            self.label.setText(u"haha") 
        def resetEIPpsw(input_psw):
            #input_psw="wowgm#22"
            #print(type(input_psw))
            #print(input_psw)
            
            #启动selenium-server :  java -jar selenium-server-standalone-2.53.0.jar
            #java  -jar selenium-server-standalone-2.53.0.jar -Dwebdriver.firefox.bin="D:\Program Files (x86)\Mozilla Firefox\firefox.exe"
            #java  -jar selenium-server-standalone-2.53.0.jar -role node -hub http://127.0.0.1:4444/grid/register -browser browserName=htmlunit
            
            #browser = webdriver.Ie()
            #browser= webdriver.Remote("http://192.168.109.207:4444/wd/hub", webdriver.DesiredCapabilities.HTMLUNIT.copy())
            browser= webdriver.Remote(
                command_executor="http://192.168.112.245:4444/wd/hub", 
                desired_capabilities={'browserName': 'htmlunit',
                                             'version': '2',
                                             'javascriptEnabled': True})                                     
               # DesiredCapabilities.HTMLUNITWITHJS)
            #        webdriver.DesiredCapabilities.HTMLUNIT.copy())
            #browser = webdriver.Remote("http://127.0.0.1:4444/wd/hub", webdriver.DesiredCapabilities.FIREFOX.copy())
            
            try:
                browser.get('http://192.168.104.71:8080/admin/')
                browser.implicitly_wait(10)
            except:
                msg(tip, "载入页面失败，请重试或者联系IT")
                
                
            #self.label.setText(u"正在登入...") 
            print("正在登入...")
            #msg(tip,"admin/"+browser.title)
            #assert 'MyEIM' in browser.title
            browser.implicitly_wait(10)
            
	    #账号密码
            elem = browser.find_element_by_name('account_name')  # Find the search box
            elem.send_keys('TestUser1@battlenet.im' + Keys.TAB)
            elem2 = browser.find_element_by_name('password')  # Find the search box
            elem2.send_keys('即时通管理员密码写在这里' + Keys.RETURN)
            
            time.sleep(3)
            browser.implicitly_wait(30)
            
            url='http://192.168.104.71:8080/admin/account/'
            browser.get(url)
            
            #dlg.label.setText(u"正在搜索账号...") 
            print("正在搜索账号...")
            #msg(tip,"admin/account/"+browser.title)
            time.sleep(1)
            browser.implicitly_wait(5)
            #browser.maximize_window()#浏览器最大化
            
            try:
                browser.find_element_by_name('query').send_keys(username + Keys.RETURN) # Find the search box
                #browser.find_element_by_xpath("//input[@name='query']").send_keys(username + Keys.RETURN) # Find the search box
            except:
                #dlg.label.setText(u"query标志未找到")
                print ("query标志未找到")
                msg(tip, "query标志未找到")
                return 0
            
            try:
                select =browser.find_element_by_link_text('编辑')
                if select.get_attribute("class") == "js-unable" : 
                    print('当前帐号不可编辑')
                    work_rec("resetEIPpsw")
                    msg(tip, "当前帐号不可编辑")
                    return 0
                select.click()  # Find the search box
                
            except:
                #dlg.label.setText(username+"为不可编辑状态") 
                print (username+"为不可编辑状态")
                msg(tip, username+"为不可编辑状态")
                return 0
            
            time.sleep(3)
            browser.implicitly_wait(30)
            
            url='http://192.168.104.71:8080/admin/editAccount/?account_name='+username
            browser.get(url)
            #dlg.label.setText("正在修改"+username+"的密码") 
            print("正在修改"+username+"的密码")
            
            from selenium.webdriver.support.ui import WebDriverWait
            try:
                WebDriverWait(browser, 10).until( lambda the_driver:the_driver.find_element_by_name('nickname').is_displayed())
            except:
                print("没有查找到password字符")
                msg(tip,"没有查找到password字符")
                return 0
            
            browser.find_element_by_name('password').send_keys(input_psw)  # Find the search box
            browser.find_element_by_name('pass_re').send_keys(input_psw) # Find the search box
            browser.find_element_by_name('ok').click() # Find the search box
            
            #加入结果检测##############
            #return 0
            browser.quit()
            work_rec("resetEIPpsw")
            msg(tip,"已完成密码修改")   
            #dlg.label.setText("已完成密码修改") 
        
        input_psw= self.lineEdit.text()
        input_psw=str(input_psw)     #此处对samid的str转换是必须的，因为从QT中获取的类型为QSTRING
        psw_lenth=len(input_psw)
        
        
        if input_psw=="" : 
            self.label.setText(u"无输入") 
        elif psw_lenth > 16 or  psw_lenth<6 :
            msg(tip, u"密码长度6~16位，由区分大小写的字母、数字、特殊字符至少两种组成，且不可与帐号相同。") 
        else:
            self.close()    
            resetEIPpsw(input_psw)
            #funa(input_psw)
            
            #dlg.close()    
            

    
#import QIcon
if __name__ == "__main__":  
    app = QApplication(sys.argv)
    dlg = Dialog()   
    dlg.show()   
    sys.exit(app.exec_())  

