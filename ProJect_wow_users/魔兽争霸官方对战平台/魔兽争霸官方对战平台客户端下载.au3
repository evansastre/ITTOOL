#include <InetConstants.au3>
#include <Date.au3>
 #include <IE.au3>
 
; ���ص��ļ����浽��ʱ�ļ���.
;~ Local $sFilePath = @TempDir & "\dzclient.exe"
;~ ; �ں�̨��ѡ����ѡ�������ļ�, ��ǿ�ƴ�Զ��վ�����¼���.'
;~ TrayTip("","���������У����Ե�",30)
;~ Local $hDownload = InetGet("http://dz.gdl.corpname.com/dzclient*",$sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADWAIT)


;~ ; �ر� InetGet ���صľ��.
;~ InetClose($hDownload)
;~ TrayTip("","������ɣ�������ʼ��װ",30)
;~ ;���а�װatlas
;~ Run($sFilePath)
	
	;<a href="http://dz.gdl.corpname.com/dzclient-1.0.4.exe" class="u-btn-base u-btn-lg active" target="_blank"><span class="u-btn-inner">ƽ̨����</span></a>
	
	
	
Local $oIE = _IE_Example("basic")
Local $sText = _IEBodyReadText()