
::net user admin  password 
::默认admin账号由供应商建立，此步骤用于修改其密码,由前面的脚本写入

net user administrator /active:no
::禁用administrator ，由于administrator是内置账号无法从管理员组删除，故禁用



net user newUser  Password@1 /add
net user newUser  Password@1
:: 添加用户 newUser 密码 123 

net localgroup administrators newUser /add
::暂时添加 newUser到本地管理员组，限制策略的实施需要在user下应用管理员权限


ping -n 5 127.1>nul


::net user newAdmin /del
::net user newUser /del

::net user newAdmin 123  /add
:: 添加用户 newAdmin 密码 123 

::net localgroup administrators newAdmin /add
::添加 newAdmin到本地管理员组

