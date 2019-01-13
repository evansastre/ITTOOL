#include <InetConstants.au3>
#include <Date.au3>
 #include <IE.au3>
 
; 下载的文件保存到临时文件夹.
;~ Local $sFilePath = @TempDir & "\dzclient.exe"
;~ ; 在后台按选定的选项下载文件, 并强制从远程站点重新加载.'
;~ TrayTip("","正在下载中，请稍等",30)
;~ Local $hDownload = InetGet("http://dz.gdl.corpname.com/dzclient*",$sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADWAIT)


;~ ; 关闭 InetGet 返回的句柄.
;~ InetClose($hDownload)
;~ TrayTip("","下载完成，即将开始安装",30)
;~ ;运行安装atlas
;~ Run($sFilePath)
	
	;<a href="http://dz.gdl.corpname.com/dzclient-1.0.4.exe" class="u-btn-base u-btn-lg active" target="_blank"><span class="u-btn-inner">平台下载</span></a>
	
	
	
Local $oIE = _IE_Example("basic")
Local $sText = _IEBodyReadText()