set myOU=OU=WOW_AA_MEMBER,OU=WOW_AA,OU=WOW_user_hz,OU=WOW_all_user,DC=CorpDomain,DC=internal
::定义OU

set mygroup1=wow_cs_aa


::要添加到的组在此定义

:: a工号 b密码 c全名 d姓 e名 f电话 g职务 h所属OU路径  以表的实际分列位置为准
::添加用户到安全组


for /f  "tokens=1,2,3,4,5,6,7,8  delims=,"  %%a  in (.\users.csv) do (
dsadd user "cn=%%c,%myOU%"  -samid %%a -upn %%a@CorpDomain.internal -ln %%d -fn %%e -display %%c -pwd %%b -mustchpwd yes -title %%g -email %%a@mail.CorpDomain  -mobile %%f  -disabled no >> result.txt 


dsquery group -name %mygroup1% | dsmod group -addmbr   "cn=%%c,%myOU%" >> result.txt


)


pause>nul