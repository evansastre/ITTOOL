# -*- coding: utf-8 -*-

import time 
import getpass
import sys
from PyQt5.QtWidgets import *
from PyQt5 import QtCore
sysCharType = sys.getfilesystemencoding()


from selenium import webdriver
from selenium.webdriver.common.keys import Keys

sysCharType = sys.getfilesystemencoding()

def resetEIPpsw(input_psw):
    input_psw="Dcasjs123"
    print(type(input_psw))
    #import chardet
    #is=chardet.detect(input_psw.unicode("utf-8"))
   
    #input_psw=list(input_psw)
    print(input_psw)
    #return 0
    
    
    #input_psw=input_psw.encode("utf-8")
    #print(type(input_psw))
    username=getpass.getuser() #当前用户名
    username="it_test2"
    
    #启动selenium-server :   java  -jar selenium-server-standalone-2.48.2.jar
    #java  -jar selenium-server-standalone-2.48.2.jar -Dwebdriver.firefox.bin="D:\Program Files (x86)\Mozilla Firefox\firefox.exe"
    #java  -jar selenium-server-standalone-2.48.2.jar -role node -hub http://127.0.0.1:4444/grid/register -browser browserName=htmlunit

    #browser = webdriver.Ie()
    #from selenium import webdriver
    #browser= webdriver.Remote("http://192.168.109.207:4444/wd/hub", webdriver.DesiredCapabilities.HTMLUNIT.copy())
    browser= webdriver.Remote("http://127.0.0.1:4444/wd/hub", webdriver.DesiredCapabilities.HTMLUNIT.copy())
   
    #browser = webdriver.Remote("http://127.0.0.1:4444/wd/hub", webdriver.DesiredCapabilities.FIREFOX.copy())
    #browser.get("http://www.douban.com/")
    #print(driver.title)
    #driver.quit()
    
    #try:
    browser.get('http://192.168.104.71:8080/admin/')
    #assert 'MyEIM' in browser.title
    
    elem = browser.find_element_by_name('account_name')  # Find the search box
    elem.send_keys('TestUser1@battlenet.im' + Keys.TAB)
    elem2 = browser.find_element_by_name('password')  # Find the search box
    elem2.send_keys('Dcacdsj1989' + Keys.RETURN)
    #browser.quit()

    time.sleep(3)
    browser.implicitly_wait(30)
    url='http://192.168.104.71:8080/admin/account/'
    browser.get(url)

    #browser.get('http://192.168.104.71:8080/admin/main/')
    
    time.sleep(1)
    browser.implicitly_wait(30)
    elem = browser.find_element_by_name('query')  # Find the search box
    elem.send_keys(username + Keys.RETURN)
    #elem.send_keys("it_test2" + Keys.RETURN)
    
    
    elem = browser.find_element_by_link_text('编辑')  # Find the search box
    #elem.send_keys(Keys.RETURN)
    elem.click()
    
    #browser.get('http://192.168.104.71:8080/admin/editAccount/?account_name='+'it_test2')
    time.sleep(10)
    #browser.maximize_window()#浏览器最大化
    browser.implicitly_wait(30)
    
    browser.get('http://192.168.104.71:8080/admin/editAccount/?account_name=it_test2')

    #browser.get('http://192.168.104.71:8080/admin/main/')

    '''
    try:
        #browser.get('http://192.168.104.71:8080/admin/editAccount/?account_name='+username)
        url='http://192.168.104.71:8080/admin/editAccount/?account_name=it_test2'
        browser.get(url)
    except:
        print("wrong")            
          '''
    print(browser.title)
    
    from selenium.webdriver.support.ui import WebDriverWait
    WebDriverWait(browser, 10).until( lambda the_driver:the_driver.find_element_by_name('password').is_displayed())
    
    #elem=browser.find_element_by_name('nickname')  # Find the search box
    '''
    try:
        elem=browser.find_element_by_name('nickname')  # Find the search box
    except:
        print("cannot find this page")
        '''
    print(browser.title)
    elem = browser.find_element_by_name('password')  # Find the search box
    elem.send_keys(input_psw)
    
    #for  i in input_psw :
      #  elem.send_keys(i)
            
    elem = browser.find_element_by_name('pass_re')  # Find the search box
    elem.send_keys(input_psw)
    #for  i in input_psw:
      #  elem.send_keys(i)
        
    elem = browser.find_element_by_name('ok')  # Find the search box
    elem.send_keys(Keys.RETURN)
    
    #加入结果检测##############
    return 0
    browser.quit()

    #except:
       # print "error "
        
    #browser.quit()
    #browser.close()
    '''
    browser = webdriver.Ie()
    
    browser.get('http://192.168.104.71:8080/password.html')
    elem = browser.find_element_by_id('uid')  # Find the search box
    elem.send_keys(username+'@battlenet.im')
    elem = browser.find_element_by_id('pwd0')  # Find the search box
    elem.send_keys('Password@1')
    '''
    #
    ##对话框
    import ctypes
    import sys
    sysCharType = sys.getfilesystemencoding() #获取系统的编码方式 
    tip= 'tip'.encode(sysCharType)
    tip_main='已完成修改，请尝试用新密码登录'.encode(sysCharType)
    ctypes.windll.user32.MessageBoxA(0,tip_main,tip, 0) 




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
        self.label.setGeometry(QtCore.QRect(130, 10, 151, 16))
        self.label.setMidLineWidth(0)
        self.label.setObjectName("label")

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


class Dialog(QDialog, Ui_Dialog):
    def __init__(self, parent=None):
        QDialog.__init__(self, parent)
        self.setupUi(self)
    
    #这个装饰器不能删，否则会运行两遍
    @QtCore.pyqtSlot()  
    def on_pushButton_clicked(self):
        input_psw= self.lineEdit.text()
        if input_psw=="" : 
            self.label.setText(u"无输入") 
        else:
            dlg.close()    
            resetEIPpsw(str(input_psw))
            #exit()
             #此处对samid的str转换是必须的，因为从QT中获取的类型为QSTRING
   
if __name__ == "__main__":  
    app = QApplication(sys.argv)
       
    dlg = Dialog()   
    dlg.show()   
    sys.exit(app.exec_())  

