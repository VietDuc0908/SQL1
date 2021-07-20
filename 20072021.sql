use master
go

CREATE DATABASE MVD
GO

USE MVD
GO

CREATE TABLE Department(
	DepartmentId int primary key not null,
	DepartmentName nvarchar(50),
	Location nvarchar(50),
	Status bit
)

CREATE TABLE EmployeeType(
	EmpTypeId int primary key not null,
	EmpTypeName nvarchar(50),
	Status bit
)

CREATE TABLE Employee(
	EmpId nvarchar(50) not null,
	EmpName nvarchar(50),
	HireDate date,
	Salary float,
	Email nvarchar(50),
	Phone nvarchar(50),
	Sex bit,
	Status bit,
	DepartmentId int not null,
	EmpTypeId int not null
)


ALTER TABLE Employee
ADD CONSTRAINT FK_EmpType_Emp
FOREIGN KEY (EmpTypeId)
REFERENCES  EmployeeType(EmpTypeId);

ALTER TABLE Employee
ADD CONSTRAINT FK_Department_Emp
FOREIGN KEY (DepartmentId)
REFERENCES  Department(DepartmentId);


----Thêm dữ liệu-----
INSERT INTO EmployeeType (EmpTypeId,EmpTypeName,Status)
VALUES (1,N'Nhân viên cơ hữu', 'True')
INSERT INTO EmployeeType (EmpTypeId,EmpTypeName,Status)
VALUES (2,N'Nhân viên cộng tác', 'True')
INSERT INTO EmployeeType (EmpTypeId,EmpTypeName,Status)
VALUES (3,N'Nhân viên fulltime', 'False')


INSERT INTO Department(DepartmentId,DepartmentName,Location,Status)
VALUES (1, N'Phòng CMLT','304' ,'True')
INSERT INTO Department(DepartmentId,DepartmentName,Location,Status)
VALUES (2, N'Phòng CMM','306' ,'True')
INSERT INTO Department(DepartmentId,DepartmentName,Location,Status)
VALUES (3, N'Phòng Đào Tạo','301', 'True')

INSERT INTO Employee(EmpId,EmpName,HireDate,Salary,Email,Phone,Sex,Status,DepartmentId,EmpTypeId)
VALUES (N'E001', N'Nguyễn Công Phượng', '2017-05-14', 10000000,'phuongnc@gmail.com', '0948385837', 'True', 'True', 1,1)
INSERT INTO Employee(EmpId,EmpName,HireDate,Salary,Email,Phone,Sex,Status,DepartmentId,EmpTypeId)
VALUES (N'E002', N'Nguyễn Trung Hiếu', '2014-06-08', 8000000, 'hieunt@gmail.com', '0904488485', 'True', 'True', 2, 2)
INSERT INTO Employee(EmpId,EmpName,HireDate,Salary,Email,Phone,Sex,Status,DepartmentId,EmpTypeId)
VALUES (N'E003', N'Nguyễn Thị Thuỷ', '2013-09-06', 9000000,'thuynt@gmail.com', '0904305253', 'False', 'True', 3,3)
INSERT INTO Employee(EmpId,EmpName,HireDate,Salary,Email,Phone,Sex,Status,DepartmentId,EmpTypeId)
VALUES (N'E004', N'Nguyễn Thị Thắm', '2016-08-05', 6500000,'thamnt@gmail.com', '0949904567', 'False', 'True', 2,1)
INSERT INTO Employee(EmpId,EmpName,HireDate,Salary,Email,Phone,Sex,Status,DepartmentId,EmpTypeId)
VALUES (N'E005', N'Lê Thanh Thuỷ', '2012-02-01', 7500000,'thuylt@gmail.com', '0948856932', 'False', 'False', 1,3)


----5----
SELECT EmpID as 'MaNV', EmpName as 'TenNV', Sex as 'GioiTinh', Salary as 'Luong', DepartmentName as 'TenPhong'
FROM Employee inner join Department on
Employee.DepartmentId = Department.DepartmentId
ORDER BY Salary ASC

--câu này em thử là u thì được mà g thì không ạ :< -------------
SELECT * FROM Employee
WHERE Employee.EmpName LIKE N'%ng'

SELECT CONCAT(EmpId,'-',EmpName) , CONCAT( Employee.DepartmentId,'-',DepartmentName)
FROM Employee inner join Department on
Employee.DepartmentId = Department.DepartmentId

-----6-----
UPDATE Employee
SET Status = NULL
WHERE Status = 'False'

SELECT * FROM Employee

---7----
DELETE FROM Employee WHERE Status IS NULL ;

-----8----

CREATE INDEX EmpNameIndex
On Employee(EmpName)

------9-------
CREATE VIEW vwEmployee
AS
	SELECT EmpName as 'Ten Nhan Vien', DepartmentName as 'Ten Phong Ban', Location as 'Noi Lam Viec', EmpTypeName as 'Loai Nhan Vien'
	FROM Employee inner join Department on
	Employee.DepartmentId = Department.DepartmentId
				  inner join EmployeeType on
	Employee.EmpTypeId = EmployeeType.EmpTypeId



select* from vwEmployee

-----10---------------


CREATE PROC proc_1(@x float , @y float)
AS
BEGIN
 SELECT * FROM Employee
 WHERE Salary>@x AND Salary< @y
END

EXEC proc_1 9500000,15000000

-----------------

ALTER PROC proc_2(@manv nvarchar(50), @hiredate date)
AS
BEGIN
	IF(@hiredate >GETDATE())
		PRINT('HireDate lon hon ngay hien tai')
	ELSE
	  BEGIN
		PRINT('Cap nhat thanh cong')
		UPDATE Employee 
		SET HireDate = @hiredate
		WHERE EmpId = @manv
	  END
END

EXEC proc_2 'E001', '20210720'

select * from Employee

---------------

CREATE PROC proc_3
AS
BEGIN
 SELECT * FROM Employee
 WHERE Salary>7000000
END

EXEC proc_3 

-----11--------------


CREATE TRIGGER trigger_1
ON Employee
FOR INSERT
AS
BEGIN
	DECLARE @hiredate date
	DECLARE @datenow date
	SELECT @datenow = GETDATE()
	SELECT @hiredate = HireDate FROM INSERTED
	IF(@hiredate>@datenow)
	 BEGIN
		RAISERROR('Hiredate lon hon ngay hien tai', 16,1)
		ROLlBACK TRANSACTION
	 END
END

INSERT INTO Employee(EmpId,EmpName,HireDate,Salary,Email,Phone,Sex,Status,DepartmentId,EmpTypeId)
VALUES (N'E006', N'Lê Thanh Thuỷ', '2022-02-01', 7500000,'thuylt@gmail.com', '0948856932', 'False', 'False', 1,3)


----------

CREATE TRIGGER trigger_2
ON Department
FOR UPDATE
AS
BEGIN
	DECLARE @truoc nvarchar(50)
	SELECT @truoc = DepartmentName FROM deleted
	IF(@truoc = N'Phòng CMLT')
		BEGIN
		RAISERROR('Khong cho cap nhap thong tin phong CMLT', 16,1)
		ROLlBACK TRANSACTION
		END
END

UPDATE Department
SET Location = '999'
WHERE DepartmentName = N'Phòng CMM'

SELECT * FROM Department

-----------
CREATE TRIGGER trigger_3
ON EmployeeType
FOR UPDATE
AS
BEGIN
	DECLARE @truoc nvarchar(50)
	SELECT @truoc = Status FROM deleted
	IF(@truoc = 1)
		BEGIN
		RAISERROR('Khong cho cap nhap', 16,1)
		ROLlBACK TRANSACTION
		END
END
GO

UPDATE EmployeeType
SET EmpTypeName = 'VMO'
WHERE Status = 1

SELECT * FROM Department

-------------------
DROP DATABASE MVD







