
::net user admin  password 
::Ĭ��admin�˺��ɹ�Ӧ�̽������˲��������޸�������,��ǰ��Ľű�д��

net user administrator /active:no
::����administrator ������administrator�������˺��޷��ӹ���Ա��ɾ�����ʽ���



net user newUser  Password@1 /add
net user newUser  Password@1
:: ����û� newUser ���� 123 

net localgroup administrators newUser /add
::��ʱ��� newUser�����ع���Ա�飬���Ʋ��Ե�ʵʩ��Ҫ��user��Ӧ�ù���ԱȨ��


ping -n 5 127.1>nul


::net user newAdmin /del
::net user newUser /del

::net user newAdmin 123  /add
:: ����û� newAdmin ���� 123 

::net localgroup administrators newAdmin /add
::��� newAdmin�����ع���Ա��

