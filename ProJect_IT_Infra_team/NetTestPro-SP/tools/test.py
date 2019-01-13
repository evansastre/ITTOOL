

def testSpeed(urls):
    speedtest_cli.shutdown_event = threading.Event()
    signal.signal(signal.SIGINT, speedtest_cli.ctrl_c)
 
    print "Start to test download speed: "
    dlspeed = speedtest_cli.downloadSpeed(urls)
    dlspeed = (dlspeed / 1000 / 1000)
    print('Download: %0.2f M%s/s' % (dlspeed, 'B'))
 
    return dlspeed
 

urls = ["http://www.dynamsoft.com/assets/images/logo-index-dwt.png", 
        "ww.codepool.biz/wp-content/uploads/2015/06/django_dwt.png", 
        "http://whttp://www.dynamsoft.com/assets/images/logo-index-dnt.png", 
        "http://www.dynamsoft.com/assets/images/logo-index-ips.png", 
        "http://www.codepool.biz/wp-content/uploads/2015/07/drag_element.png"]
