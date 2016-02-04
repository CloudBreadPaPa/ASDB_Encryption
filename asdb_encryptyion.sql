


--Azure SQL Database Encryptyion 수행 방안
--ASDB에서 수행 - 반드시 ASDB가 V12임을 확인
select @@version

--결과가 이렇게 12.0.x 이어야 함
--Microsoft SQL Azure (RTM) - 12.0.2000.8 
--	Jan 30 2016 11:11:59 
--	Copyright (c) Microsoft Corporation

--ㅡmaster 키 생성
--drop MASTER KEY
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'masterkey!@#123';
GO

--인증서 생성
--drop CERTIFICATE MyCertificateName
CREATE CERTIFICATE MyCertificateName
WITH SUBJECT = 'A label for this certificate'

--OPEN MASTER KEY DECRYPTION BY PASSWORD = 'masterkey!@#123';

--인증서 키 생성
--drop SYMMETRIC KEY MySymmetricKeyName
CREATE SYMMETRIC KEY MySymmetricKeyName WITH
IDENTITY_VALUE = 'a fairly secure name',
ALGORITHM = AES_256,
KEY_SOURCE = 'a very secure strong password or phrase'
ENCRYPTION BY CERTIFICATE MyCertificateName;

--SYMMETRIC KEY 오픈
OPEN SYMMETRIC KEY MySymmetricKeyName
DECRYPTION BY CERTIFICATE MyCertificateName

--drop table tLotte
create table tLotte(
idx int,
name varchar(100),
pwd varbinary(max)
)
go

--컬럼에 암호화된 값 삽입
insert into tLotte(idx, name, pwd) values(1, 'daewookim', EncryptByKey(Key_GUID('MySymmetricKeyName'),'daewookim_pwd'))

--데이터 조회 - 암호화 된 것을 확인
select * from tLotte

--복호화 수행 결과가 binary로 나오기 때문에 convert해서 varchar로 변환
select idx, name, convert(varchar(max), DecryptByKey(pwd)) from tLotte
