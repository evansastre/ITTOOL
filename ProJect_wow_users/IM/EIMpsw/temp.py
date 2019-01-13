#import easygui 
#easygui.msgbox(u'内容',u'标题',image="1.jpg")

#import ctypes 
#ctypes.windll.user32.MessageBoxW(0, u"内容", u"标题",0)


#from selenium.remote import connect                                                                                                                          
'''
b = connect('htmlunit')                                                                                                                                      
b.get('http://google.com')                                                                                                                                   

q = b.find_element_by_name('q')                                                                                                                              
q.send_keys('selenium')                                                                                                                                      
q.submit()                                                                                                                                                   

for l in b.find_elements_by_xpath('//h3/a'):                                                                                                                 
    print('%s\n\t%s\n' % (l.get_text(), l.get_attribute('href')))

from selenium import webdriver
driver = webdriver.Remote(desired_capabilities=webdriver.DesiredCapabilities.HTMLUNIT)
driver.get('http://www.163.com')

print (driver.title)
'''

from selenium import webdriver
driver = webdriver.Remote("http://localhost:4444/wd/hub", webdriver.DesiredCapabilities.HTMLUNIT.copy())
#driver = webdriver.Remote("http://127.0.0.1:4444/wd/hub", webdriver.DesiredCapabilities.FIREFOX.copy())
driver.get("http://www.douban.com/")
print(driver.title)
driver.quit()

#from selenium import webdriver
#from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
#browser=webdriver.remote.webdriver.WebDriver\
  #                                             (command_executor='http://10.231.94.11:4444/wd/hub',desired_capabilities=DesiredCapabilities.FIREFOX)



'''


from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities   #（1）
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.keys import Keys
import time


browser = webdriver.Remote(desired_capabilities=DesiredCapabilities.HTMLUNIT)     #（2）
#browser = webdriver.DesiredCapabilities.HTMLUNIT() # Get local session of firefox
browser.get("http://www.douban.com") # Load page
assert "douban" in browser.title
elem = browser.find_element_by_name("p") # Find the query box
elem.send_keys("seleniumhq" + Keys.RETURN)
time.sleep(0.2) # Let the page load, will be added to the API
try:
    browser.find_element_by_xpath("//a[@data-bk='5174.1']")
    print("ok")
except NoSuchElementException:
    assert 0, "can't find seleniumhq"
browser.close() 
'''


