set myOU=OU=WOW_AA_MEMBER,OU=WOW_AA,OU=WOW_user_hz,OU=WOW_all_user,DC=CorpDomain,DC=internal
::����OU

set mygroup1=wow_cs_aa


::Ҫ��ӵ������ڴ˶���

:: a���� b���� cȫ�� d�� e�� f�绰 gְ�� h����OU·��  �Ա��ʵ�ʷ���λ��Ϊ׼
::����û�����ȫ��


for /f  "tokens=1,2,3,4,5,6,7,8  delims=,"  %%a  in (.\users.csv) do (
dsadd user "cn=%%c,%myOU%"  -samid %%a -upn %%a@CorpDomain.internal -ln %%d -fn %%e -display %%c -pwd %%b -mustchpwd yes -title %%g -email %%a@mail.CorpDomain  -mobile %%f  -disabled no >> result.txt 


dsquery group -name %mygroup1% | dsmod group -addmbr   "cn=%%c,%myOU%" >> result.txt


)


pause>nul