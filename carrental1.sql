create database CarRental
go
create schema Car
go

CREATE TABLE Car.RENTAL_LOCATION
(
  Location_ID INT PRIMARY KEY,  
  Phone CHAR(10) NOT NULL,
  Email VARCHAR(25),
  Street_Name VARCHAR(40) NOT NULL,
  State CHAR(2) NOT NULL,
  Zip_Code CHAR(6) NOT NULL
);

CREATE TABLE Car.CAR_TYPE
(
  Car_Type VARCHAR(15) PRIMARY KEY,
  Price_Per_Day money NOT NULL  
);

CREATE TABLE Car.INSURANCE
(
  Insurance_Type VARCHAR(15) PRIMARY KEY,
  Bodily_Coverage money NOT NULL,
  Medical_Coverage money NOT NULL,
  Collision_Coverage money NOT NULL
);

CREATE TABLE Car.CAR_INSURANCE
(
  Car_Type VARCHAR(15),
  Insurance_Type VARCHAR(15),
  Insurance_Price money NOT NULL,
  PRIMARY KEY(Car_Type,Insurance_Type),
  CONSTRAINT CARTYPEFK
  FOREIGN KEY (Car_Type) REFERENCES Car.CAR_TYPE(Car_Type)
              ON DELETE CASCADE,
  CONSTRAINT INSURANCETYPEFK
  FOREIGN KEY (Insurance_Type) REFERENCES Car.INSURANCE(Insurance_Type)
              ON DELETE CASCADE            
);

CREATE TABLE Car.CAR_USER
(
  License_No VARCHAR(15) PRIMARY KEY,
  Fname VARCHAR(15) NOT NULL,
  Lname VARCHAR(15) NOT NULL,
  Email VARCHAR(25) NOT NULL UNIQUE,
  Address VARCHAR(100) NOT NULL,
  Phone CHAR(10) NOT NULL,
  DOB DATE NOT NULL,
  User_Type VARCHAR(10) NOT NULL
);

CREATE TABLE Car.USER_CREDENTIALS
(
  Login_ID VARCHAR(15) PRIMARY KEY,
  Password VARCHAR(15) NOT NULL,
  Year_Of_Membership Char(4) NOT NULL ,
  License_No VARCHAR(15) NOT NULL,
  CONSTRAINT USRLIC
  FOREIGN KEY (License_No) REFERENCES Car.CAR_USER(License_No)
              ON DELETE CASCADE
);

CREATE TABLE Car.CARD_DETAILS
(
  Login_ID VARCHAR(15) NOT NULL,
  Name_On_Card VARCHAR(50) NOT NULL,
  Card_No CHAR(16) NOT NULL,
  Expiry_Date DATE NOT NULL,
  CVV CHAR(3) NOT NULL,
  Billing_Address VARCHAR(50) NOT NULL,
  PRIMARY KEY(Login_ID,Card_No),
  CONSTRAINT USRCARDFK
  FOREIGN KEY (Login_ID) REFERENCES Car.USER_CREDENTIALS(Login_ID)
              ON DELETE CASCADE
);

CREATE TABLE Car.CAR
(
  VIN CHAR(17) PRIMARY KEY,
  Location_ID INT NOT NULL,
  Reg_No VARCHAR(15) UNIQUE,
  Status VARCHAR(15) NOT NULL,
  Seating_Capacity INT NOT NULL,
  Disability_Friendly CHAR(1),
  Car_Type VARCHAR(15) NOT NULL, 
  Model VARCHAR(20),
  Year CHAR(4),
  Color VARCHAR(10),
  CONSTRAINT CARVINTYPEFK
  FOREIGN KEY (Car_Type) REFERENCES Car.CAR_TYPE(Car_Type)
              ON DELETE CASCADE,
  CONSTRAINT CARVINRENTALFK
  FOREIGN KEY (Rental_Location_ID) REFERENCES Car.RENTAL_LOCATION(Location_ID)
              ON DELETE CASCADE         
);

CREATE TABLE Car.OFFER_DETAILS
(
  Promo_Code VARCHAR(15) PRIMARY KEY,
  Description VARCHAR(50),
  Promo_Type VARCHAR(20) NOT NULL,
  Is_One_Time CHAR(1),
  Percentage DECIMAL(5,2),
  Discounted_Amount Money,
  Status VARCHAR(10) NOT NULL
);
CREATE TABLE Car.RESERVATION
(
  Reservation_ID INT PRIMARY KEY,
  Start_Date DATE NOT NULL,
  End_Date DATE NOT NULL,
  Meter_Start INT NOT NULL,
  Meter_End INT,
  Rental_Amount money NOT NULL,
  Insurance_Amount money NOT NULL,
  Actual_End_Date DATE NULL,
  Status VARCHAR(10) NOT NULL,
  License_No VARCHAR(15) NOT NULL,
  VIN CHAR(17) NOT NULL,
  Promo_Code VARCHAR(15),
  Additional_Amount money,
  Tot_Amount money NOT NULL,
  Insurance_Type VARCHAR(15),
  Penalty_Amount money,
  Drop_Location_ID INT,  
  CONSTRAINT RSERVLOCATIONFK
  FOREIGN KEY (Drop_Location_ID) REFERENCES Car.RENTAL_LOCATION(Location_ID)
              ON DELETE CASCADE,
  CONSTRAINT RESLICENSEFK
  FOREIGN KEY (License_No) REFERENCES Car.CAR_USER(License_No)
              ON DELETE CASCADE,
  --CONSTRAINT VINRESERVATIONFK
  --FOREIGN KEY (VIN) REFERENCES Car.CAR(VIN) -Bu eklenecek
  --            ON DELETE CASCADE,
  CONSTRAINT PROMORESERVATIONFK
  FOREIGN KEY (Promo_Code) REFERENCES Car.OFFER_DETAILS(Promo_Code)
              ON DELETE CASCADE,
  CONSTRAINT INSURESERVATIONFK
  FOREIGN KEY (Insurance_Type) REFERENCES Car.INSURANCE(Insurance_Type)
              ON DELETE CASCADE
);
CREATE TABLE Car.PAYMENT
(
  Payment_ID INT PRIMARY KEY,
  Amount_Paid Money NOT NULL,
  Card_No CHAR(16),
  Expiry_Date DATE,
  Name_On_Card VARCHAR(50),
  CVV CHAR(3),
  Billing_Address VARCHAR(50),
  Reservation_ID INT NOT NULL,
  Login_ID VARCHAR(15),
  Saved_Card_No CHAR(16),
  Paid_By_Cash CHAR(1),
  CONSTRAINT PAYMENTRESERVATIONFK
  FOREIGN KEY (Reservation_ID) REFERENCES Car.RESERVATION(Reservation_ID)
              ON DELETE CASCADE,
  --CONSTRAINT PAYMENTLOGINFK
  --FOREIGN KEY (Login_ID,Saved_Card_No) REFERENCES Car.CARD_DETAILS(Login_ID,Card_No)
  --            ON DELETE CASCADE
);
CREATE TABLE Car.ADDITIONAL_DRIVER
(
  Reservation_ID INT,
  NAME VARCHAR(50) NOT NULL,  
  DOB DATE NOT NULL,
  PRIMARY KEY(Reservation_ID,NAME),
  CONSTRAINT ADDTIONALFK
  FOREIGN KEY (Reservation_ID) REFERENCES Car.RESERVATION(Reservation_ID)
              ON DELETE CASCADE
);

CREATE TABLE Car.ACCESSORIES
(
  Accessory_ID INT PRIMARY KEY,
  Type VARCHAR(15) NOT NULL,
  Amount money NOT NULL
);
CREATE TABLE Car.ACCESSORY_RESERVED
(
  Accessory_ID INT,
  Reservation_ID INT,
  PRIMARY KEY(Accessory_ID,Reservation_ID),
  CONSTRAINT ACCESSORYRESERVFK
  FOREIGN KEY (Reservation_ID) REFERENCES Car.RESERVATION(Reservation_ID)
              ON DELETE CASCADE,
  CONSTRAINT ACCESSFK
  FOREIGN KEY (Accessory_ID) REFERENCES Car.ACCESSORIES(Accessory_ID)
              ON DELETE CASCADE
);
GO




-- Insert
INSERT 
INTO Car.RENTAL_LOCATION (Location_ID,Phone,Email,Street_Name,State,Zip_Code) 
VALUES 
(101,'5312513266','cem@gmail.com','980 Addison Road, Seatle','WA',75122)

insert
INTO Car.RENTAL_LOCATION
(Location_ID,Phone,Email,Street_Name,State,Zip_Code) 
VALUES 
(102,'9726032222','mali@gmail.com',' 111, Berlington Road, Portland','WA',75243)
insert
INTO Car.RENTAL_LOCATION
(Location_ID,Phone,Email,Street_Name,State,Zip_Code) 
VALUES 
(103,'9721903121','sena@gmail.com',' 9855 Shadow Way, Seatle','WA',75211)
insert INTO Car.RENTAL_LOCATION
(Location_ID,Phone,Email,Street_Name,State,Zip_Code) 
VALUES 
(104,'721903121','hazal@gmail.com','434 Harrodswood Road, Seatle','WA',76512)
insert INTO Car.RENTAL_LOCATION
(Location_ID,Phone,Email,Street_Name,State,Zip_Code) 
VALUES 
(105,'5026981045','gözde@gmail.com','7788 internal Drive, Seatle','WA',77888)

-- Insert Car.CarType
INSERT INTO 
Car.CAR_TYPE 
(Car_Type,Price_Per_Day) 
VALUES 
('Economy',50)
INSERT INTO Car.CAR_TYPE
(Car_Type,Price_Per_Day) 
VALUES 
('Standard',75)
INSERT INTO Car.CAR_TYPE
(Car_Type,Price_Per_Day) 
VALUES 
('SUV',100)
INSERT INTO Car.CAR_TYPE
(Car_Type,Price_Per_Day) 
VALUES 
('MiniVan',150)
INSERT INTO Car.CAR_TYPE
(Car_Type,Price_Per_Day) 
VALUES 
('Premium',200)

--insert Car.INSURANCE

INSERT
INTO Car.INSURANCE
(Insurance_Type,Bodily_Coverage,Medical_Coverage,Collision_Coverage) 
VALUES 
('Liability',25000.00,50000.00,0.00)
INSERT INTO Car.INSURANCE
(Insurance_Type,Bodily_Coverage,Medical_Coverage,Collision_Coverage) 
VALUES 
('Comprehensive',50000,50000,50000)

--INSERT Car.CAR_INSURANCE
INSERT INTO Car.CAR_INSURANCE
(Car_Type,Insurance_Type,Insurance_Price)
VALUES
('Economy','Liability',9.99)
INSERT INTO Car.CAR_INSURANCE
(Car_Type,Insurance_Type,Insurance_Price)
VALUES
('Standard','Liability',10.99)
INSERT INTO Car.CAR_INSURANCE
(Car_Type,Insurance_Type,Insurance_Price)
VALUES
('SUV','Liability',12.99)
INSERT INTO Car.CAR_INSURANCE
(Car_Type,Insurance_Type,Insurance_Price)
VALUES
('MiniVan','Liability',14.99)
INSERT INTO Car.CAR_INSURANCE
(Car_Type,Insurance_Type,Insurance_Price)
VALUES
('Premium','Liability',19.99)
INSERT INTO Car.CAR_INSURANCE
(Car_Type,Insurance_Type,Insurance_Price)
VALUES
('Economy','Comprehensive',19.99)
INSERT INTO Car.CAR_INSURANCE
(Car_Type,Insurance_Type,Insurance_Price)
VALUES
('Standard','Comprehensive',19.99)
INSERT INTO Car.CAR_INSURANCE
(Car_Type,Insurance_Type,Insurance_Price)
VALUES
('SUV','Comprehensive',24.99)
INSERT INTO Car.CAR_INSURANCE
(Car_Type,Insurance_Type,Insurance_Price)
VALUES
('MiniVan','Comprehensive',29.99)
INSERT INTO Car.CAR_INSURANCE
(Car_Type,Insurance_Type,Insurance_Price)
VALUES
('Premium','Comprehensive',49.99)

--INSERT Car.CAR_USER

INSERT 
INTO Car.CAR_USER
(License_No,FName,Lname,Email,Address,Phone,DOB,USER_TYPE)
VALUES
('E12905109','Mehmet','Onde','mali@gmail.com','1701 N.Campbell Rd, Dallas, TX-75243','5426895259',('1995/05/20'),'Guest')

INSERT INTO Car.CAR_USER
(License_No,FNAME,LNAME,Email,Address,Phone,DOB,USER_TYPE)
VALUES
('G30921561','Sena','Bulut','senabulut@hotmail.com','101 Meritline drive','5426895257',('1996/08/3'),'Customer')
INSERT INTO Car.CAR_USER
(License_No,FNAME,LNAME,Email,Address,Phone,DOB,USER_TYPE)
VALUES
('R12098127','Hazal','Fýrat','hazalfirat@hotmail.com','43 Greenville Road','5426895256',('1997/03/23'),'Guest')
INSERT INTO Car.CAR_USER
(License_No,FNAME,LNAME,Email,Address,Phone,DOB,USER_TYPE)
VALUES
('M12098127','Cem','Cebi','cemberkecebi@gmail.com','43 Greenville Road','5426895255',('1997/07/20'),'Customer')
INSERT INTO Car.CAR_USER
(License_No,FNAME,LNAME,Email,Address,Phone,DOB,USER_TYPE)
VALUES
('M12098187','Gözde','Sismanoglu','gozde@gmail.com','43 Greenville Road','5426895261',('1997/09/2'),'Customer')


--INSERT USER_CREDENTIALS
INSERT
INTO Car.USER_CREDENTIALS
(Login_ID,Password,Year_Of_Membership,License_No)
VALUES
('gozde','1234','2015','M12098187')
INSERT INTO Car.USER_CREDENTIALS
(Login_ID,Password,Year_Of_Membership,License_No)
VALUES
('sena','1234','2017','G30921561')
INSERT INTO Car.USER_CREDENTIALS
(Login_ID,Password,Year_Of_Membership,License_No)
VALUES
('cem','1234','2016','M12098127')
INSERT INTO Car.USER_CREDENTIALS
(Login_ID,Password,Year_Of_Membership,License_No)
VALUES
('hazal','1234','2016','R12098127')
INSERT INTO Car.USER_CREDENTIALS
(Login_ID,Password,Year_Of_Membership,License_No)
VALUES
('mali','1234','2016','E12905109')


--Insert Car.CARD_DETAILS
INSERT
INTO Car.CARD_DETAILS
(Login_ID,Name_On_Card,Card_No,Expiry_Date,CVV,Billing_Address)
VALUES
('mali','Mehmet Ali Onde','4735111122223333',('2018/01/15'),'287','1530 S.Campbell Rd, Dallas, TX 75251')
INSERT INTO Car.CARD_DETAILS
(Login_ID,Name_On_Card,Card_No,Expiry_Date,CVV,Billing_Address)
VALUES
('sena','Sena Bulut','4233908110921001',('2018/01/15'),'419','101 Meritline drive')
INSERT INTO Car.CARD_DETAILS
(Login_ID,Name_On_Card,Card_No,Expiry_Date,CVV,Billing_Address)
VALUES
('gozde','Gozde Sismanuglu','823990811009209',('2020/01/15'),'419','43 Greenville Road')
INSERT INTO Car.CARD_DETAILS
(Login_ID,Name_On_Card,Card_No,Expiry_Date,CVV,Billing_Address)
VALUES
('hazal','Hazal Fýrat','1200000210921909',('2019/05/15'),'419','43 Greenville Road')
INSERT INTO Car.CARD_DETAILS
(Login_ID,Name_On_Card,Card_No,Expiry_Date,CVV,Billing_Address)
VALUES
('cem','Cem Berke Çebi','4533777190721001',('2018/01/15'),'419','43 Greenville Road')


--INSERT Car.CAR
INSERT
INTO Car.CAR
(VIN,Location_ID,Reg_No,Status,Seating_Capacity,Disability_Friendly,Car_Type,Model,Year,Color)
VALUES
('F152206785240289',101,'TXF101','Available',5,'N','Economy','Mazda3','2007','Gold')
INSERT INTO Car.CAR
(VIN,Location_ID,Reg_No,Status,Seating_Capacity,Disability_Friendly,Car_Type,Model,Year,Color)
VALUES
('T201534710589051',101,'KYQ101','Available',5,'Y','Standard','Toyota Camry','2012','Grey')
INSERT INTO Car.CAR
(VIN,Location_ID,Reg_No,Status,Seating_Capacity,Disability_Friendly,Car_Type,Model,Year,Color)
VALUES
('E902103289341098',102,'XYZ671','Available',5,NULL,'Premium','BMW','2015','Black')
INSERT INTO Car.CAR
(VIN,Location_ID,Reg_No,Status,Seating_Capacity,Disability_Friendly,Car_Type,Model,Year,Color)
VALUES
('R908891209418173',103,'DOP391','Unavailable',7,NULL,'SUV','Mercedes','2014','White')
INSERT INTO Car.CAR
(VIN,Location_ID,Reg_No,Status,Seating_Capacity,Disability_Friendly,Car_Type,Model,Year,Color)
VALUES
('N892993994858292',104,'RAC829','Available',15,NULL,'MiniVan','Volvo','2013','Black')

--INSERT Car.OFFER_DETAILS
INSERT 
INTO Car.OFFER_DETAILS
(PROMO_CODE,Description,PROMO_TYPE,Is_One_Time,PERCENTAGE,Discounted_Amount,Status)
VALUES
('CHRISTMAS10','Christmas 10% offer','Percentage','N',10.00,NULL,'Available')
INSERT 
INTO Car.OFFER_DETAILS
(PROMO_CODE,Description,PROMO_TYPE,Is_One_Time,PERCENTAGE,Discounted_Amount,Status)
VALUES
('July25','July $25.00 discount','Discounted Amount','Y',NULL,25.00,'Expired')
INSERT 
INTO Car.OFFER_DETAILS
(PROMO_CODE,Description,PROMO_TYPE,Is_One_Time,PERCENTAGE,Discounted_Amount,Status)
VALUES
('LaborDay5','Labor Day $5.00 offer','Discounted Amount','Y',NULL,5.00,'Expired')
INSERT 
INTO Car.OFFER_DETAILS
(PROMO_CODE,Description,PROMO_TYPE,Is_One_Time,PERCENTAGE,Discounted_Amount,Status)
VALUES
('NewYear10','New Year 10% offer','Percentage','N',10.00,NULL,'Available')
INSERT 
INTO Car.OFFER_DETAILS
(PROMO_CODE,Description,PROMO_TYPE,Is_One_Time,PERCENTAGE,Discounted_Amount,Status)
VALUES
('blackfriday','blackfriday 15% offer','Percentage','N',15.00,NULL,'Expired')


--Insert Car.RESERVATION
INSERT 
INTO Car.RESERVATION
(Reservation_ID,Start_Date,End_Date,Meter_Start,Meter_End,Rental_Amount,Insurance_Amount,Status,Actual_End_Date,License_No,VIN,Promo_Code,Additional_Amount,Tot_Amount,Penalty_Amount,Insurance_Type,Drop_Location_ID)
VALUES
(1,('2017/11/06'),('2017/11/12'),81256,81300,119.70,9.95,'Completed',('2017/11/12'),'E12905109','F152206785240289',NULL,NULL,129.65,0.00,'Liability',101)
INSERT INTO  Car.RESERVATION
(Reservation_ID,Start_Date,End_Date,Meter_Start,Meter_End,Rental_Amount,Insurance_Amount,Status,Actual_End_Date,License_No,VIN,Promo_Code,Additional_Amount,Tot_Amount,Penalty_Amount,Insurance_Type,Drop_Location_ID)
VALUES
(2,('2017/10/20'),('2017/10/24'),76524,76590,119.80,9.95,'Completed',('2017/10/24'),'G30921561','T201534710589051',NULL,NULL,129.75,0.00,'Liability',101)
INSERT INTO  Car.RESERVATION
(Reservation_ID,Start_Date,End_Date,Meter_Start,Meter_End,Rental_Amount,Insurance_Amount,Status,Actual_End_Date,License_No,VIN,Promo_Code,Additional_Amount,Tot_Amount,Penalty_Amount,Insurance_Type,Drop_Location_ID)
VALUES
(3,('2017/12/06'),('2017/12/12'),82001,NULL,659.40,29.95,'Reserved',NULL,'M12098127','N892993994858292','NewYear10',NULL,689.35,0.00,'Comprehensive',104)
INSERT INTO  Car.RESERVATION
(Reservation_ID,Start_Date,End_Date,Meter_Start,Meter_End,Rental_Amount,Insurance_Amount,Status,Actual_End_Date,License_No,VIN,Promo_Code,Additional_Amount,Tot_Amount,Penalty_Amount,Insurance_Type,Drop_Location_ID)
VALUES
(4,('2017/09/01'),('2017/09/02'),51000,51100,89.95,24.95,'Completed',('2017/09/02'),'M12098187','R908891209418173',NULL,NULL,114.90,0.00,'Comprehensive',103)
INSERT INTO  Car.RESERVATION
(Reservation_ID,Start_Date,End_Date,Meter_Start,Meter_End,Rental_Amount,Insurance_Amount,Status,Actual_End_Date,License_No,VIN,Promo_Code,Additional_Amount,Tot_Amount,Penalty_Amount,Insurance_Type,Drop_Location_ID)
VALUES
(5,('2017/08/13'),('2017/08/15'),51000,51100,299.00,99.9,'Completed',('2017/08/15'),'R12098127','E902103289341098',NULL,NULL,398.90,0.00,'Comprehensive',105)


--Insert Car.PAYMENT

INSERT 
INTO Car.PAYMENT
(Payment_ID,Amount_Paid,Card_NO,Expiry_Date,Name_On_Card,CVV,Billing_Address,Reservation_ID,Login_ID,Saved_Card_No,Paid_By_Cash)
VALUES
(1001,129.65,'4735111122223333',('2018/01/15'),'Mehmet Ali Onde','100','1530 S.Campbell Rd, Dallas, TX 75251',1,NULL,NULL,NULL)
INSERT INTO Car.PAYMENT
(Payment_ID,Amount_Paid,Card_NO,Expiry_Date,Name_On_Card,CVV,Billing_Address,Reservation_ID,Login_ID,Saved_Card_No,Paid_By_Cash)
VALUES
(1002,300.00,NULL,NULL,NULL,NULL,NULL,5,NULL,NULL,'Y')
INSERT INTO Car.PAYMENT
(Payment_ID,Amount_Paid,Card_NO,Expiry_Date,Name_On_Card,CVV,Billing_Address,Reservation_ID,Login_ID,Saved_Card_No,Paid_By_Cash)
VALUES
(1003,98.90,NULL,NULL,NULL,NULL,NULL,5,NULL,NULL,'Y')
INSERT INTO Car.PAYMENT
(Payment_ID,Amount_Paid,Card_NO,Expiry_Date,Name_On_Card,CVV,Billing_Address,Reservation_ID,Login_ID,Saved_Card_No,Paid_By_Cash)
VALUES
(1004,689.35,NULL,NULL,NULL,NULL,NULL,3,'cem','4735111122223333',NULL)
INSERT INTO Car.PAYMENT
(Payment_ID,Amount_Paid,Card_NO,Expiry_Date,Name_On_Card,CVV,Billing_Address,Reservation_ID,Login_ID,Saved_Card_No,Paid_By_Cash)
VALUES
(1005,114.91,NULL,NULL,NULL,NULL,NULL,4,NULL,NULL,'Y')

--Insert Car.ADDITIONAL_DRIVER
INSERT 
INTO Car.ADDITIONAL_DRIVER
(Reservation_ID,Name,DOB)
VALUES
(1,'William',('1970/07/15'))
INSERT INTO Car.ADDITIONAL_DRIVER
(Reservation_ID,Name,DOB)
VALUES
(2,'Green',('1987/06/15'))
INSERT INTO Car.ADDITIONAL_DRIVER
(Reservation_ID,Name,DOB)
VALUES
(2,'Robert',('1990/12/17'))
INSERT INTO Car.ADDITIONAL_DRIVER
(Reservation_ID,Name,DOB)
VALUES
(4,'Brad',('1966/12/12'))
INSERT INTO Car.ADDITIONAL_DRIVER
(Reservation_ID,Name,DOB)
VALUES
(5,'Steve',('1976/05/28'))


--INSERT Car.ACCESSORIES

INSERT 
INTO Car.ACCESSORIES
(Accessory_ID,Type,Amount)
VALUES
(1,'GPS Navigation',49.95)
INSERT INTO Car.ACCESSORIES
(Accessory_ID,Type,Amount)
VALUES
(2,'GPS Navigation',49.95)
INSERT INTO Car.ACCESSORIES
(Accessory_ID,Type,Amount)
VALUES
(3,'GPS Navigation',49.95)
INSERT INTO Car.ACCESSORIES
(Accessory_ID,Type,Amount)
VALUES
(4,'Baby Seater',29.95)
INSERT INTO Car.ACCESSORIES
(Accessory_ID,Type,Amount)
VALUES
(5,'Baby Seater',29.95)


--INSERT Car.ACCESSORY_RESERVED
INSERT 
INTO Car.ACCESSORY_RESERVED
(Accessory_ID,Reservation_ID)
VALUES
(1,1)
INSERT INTO Car.ACCESSORY_RESERVED
(Accessory_ID,Reservation_ID)
VALUES
(1,4)
INSERT INTO Car.ACCESSORY_RESERVED
(Accessory_ID,Reservation_ID)
VALUES
(5,5)
INSERT INTO Car.ACCESSORY_RESERVED
(Accessory_ID,Reservation_ID)
VALUES
(5,2)
INSERT INTO Car.ACCESSORY_RESERVED
(Accessory_ID,Reservation_ID)
VALUES
(2,4)



--Procedure
Create Procedure InsertCarUser
(
@Fname nvarchar(15),
@Lname varchar(15),
@Email varchar(25),
@Address varchar(100),
@Phone char(10),
@DOB date,
@User_Type varchar(10)


)
as
Begin
Insert Into Car.CAR_USER(Fname,Lname,Email,Address,Phone,DOB,User_Type)
Values(@Fname,@Lname,@Email,@Address,@Phone,@DOB,@User_Type)
End

--Delete UserCredentials Procedure


create procedure DeleteUserCredentials
(
@LoginID varchar(15)
)
AS
BEGIN
delete from [Car].[USER_CREDENTIALS]
where Login_ID=@LoginID
END

--exec DeleteUserCredentials 'Cem'

--UpdateCardDetails
Create Procedure UpdateCardDetails
(
@Login_ID varchar(15),
@CardNo char(16),
@Expiry_Date date,
@CVV char(3)
)
as
begin
update [Car].[CARD_DETAILS]
SET Card_No=@CardNo,Expiry_Date=@Expiry_Date,CVV=@CVV
WHERE Login_ID=@Login_ID
end

-Procedure AddCar

create procedure AddCar
(
@VINN char(17),
@Rental_Location_ID int,
@Status varchar(15),
@Seating_Capacity int,
@Car_Type varchar(15)
)
as
begin
Insert Into[Car].[CAR](VIN,Rental_Location_ID,Status,Seating_Capacity,Car_Type)
Values(@VINN,@Rental_Location_ID,@Status,@Seating_Capacity,@Car_Type)
end


--Updadet CarInsurance price
create procedure updInsurancePrice
(
@Insurance_Price money
)
as
begin
update [Car].[CAR_INSURANCE]
set Insurance_Price=@Insurance_Price
end

-- WHO USE THE PROMO CODE

create procedure whoUsePromoCode
as
select [License_No],[Promo_Code]
from[Car].[RESERVATION]
where Promo_Code is not null


--Insert Promo Code

create procedure InsertPromoCode
(
@Promo_Code varchar(15),
@Promo_Type varchar(50),
@Status varchar(10),
@Percentage decimal(5,2),
@Discounted_Amount money,
@Description varchar(50)

)
as
begin
insert into [Car].[OFFER_DETAILS](Promo_Code,Promo_Type,[Status],[Percentage],Discounted_Amount,[Description])
values(@Promo_Code,@Promo_Type,@Status,@Percentage,@Discounted_Amount,@Description)
end

--Delete Promo Code

create procedure DeletePromoCode
(
@Promo_Code varchar(15)
)
as
begin
delete from [Car].[OFFER_DETAILS]
where Promo_Code=@Promo_Code
end

--Delete Car
create Procedure deleteCar
(
@VIN char
)
as
begin
delete from [Car].[CAR]
where VIN=@VIN
end

--Update Rental Location
create procedure UpdateRentalLocation
(
@Phone char,
@Email varchar(25),
@Street_Name varchar(40),
@State char(2),
@Zip_Code char(6)
)
as
begin
update [Car].[RENTAL_LOCATION]
set Phone=@Phone,Email=@Email,Street_Name=@Street_Name,State=@State,Zip_Code=@Zip_Code
end


--UpdatePriceCarType
create procedure UpdatePriceCarType
(
@Price_Per_Day money
)
as
begin
update [Car].[CAR_TYPE]
set Price_Per_Day=@Price_Per_Day
end



--delete reservation

create procedure deleteReservation
(
@Reservation_ID int
)
as
begin 
delete from [Car].[RESERVATION]
where Reservation_ID=@Reservation_ID
end

--Show the user credentials
create procedure usercredentials
as
select [License_No],[Year_Of_Membership]
from[Car].[USER_CREDENTIALS]

--Update Reservation
create procedure updateReservation
(
@Promo_Code varchar(15),
@Insurance_Type varchar(15),
@Rental_Amount money,
@Insurance_Amount money,
@Additional_Amount money
)
as
begin
update [Car].[RESERVATION]
set Promo_Code=@Promo_Code,Insurance_Type=@Insurance_Type,Rental_Amount=@Rental_Amount,Insurance_Amount=@Insurance_Amount,Additional_Amount=@Additional_Amount
end

--Update User Credentials
create procedure UpdateUserCredentials
(
@Password varchar(15)
)
as
begin
update[Car].[USER_CREDENTIALS]
set Password=@Password
end


--View
--1

Create View getTotalAmount
As
select [Car].[CAR_USER].[License_No],[Fname],[Lname],[Rental_Amount],[Insurance_Amount],[Tot_Amount]
from [Car].[RESERVATION] inner join [Car].[CAR_USER]
on [Car].[CAR_USER].[License_No]=[Car].[RESERVATION].[License_No]


--select *from getTotalAmount

--2
create view WhoUsePromoCode
as
select [Car].[OFFER_DETAILS].[Promo_Code],[Description],[Promo_Type],[Tot_Amount]
from[Car].[OFFER_DETAILS] inner join [Car].[RESERVATION]
on[Car].[RESERVATION].[Promo_Code]=[Car].[OFFER_DETAILS].[Promo_Code]

--3

create view RentalCarInformation
as
select [Car].[CAR].[Car_Type],[Seating_Capacity],[Model],[Year],[Color],[Price_Per_Day]
from [Car].[CAR_TYPE] inner join [Car].[CAR]
on [Car].[CAR].[Car_Type]=[Car].[CAR_TYPE].Car_Type

--4


create view InsuranceInformation
as
select [Car_Type],[Car].[INSURANCE].[Insurance_Type],[Bodily_Coverage],[Medical_Coverage],[Collision_Coverage],[Insurance_Price]
from [Car].[CAR_INSURANCE] inner join [Car].[INSURANCE]
on [Car].[INSURANCE].[Insurance_Type]=[Car].[CAR_INSURANCE].[Insurance_Type]

--5
create view AccessoryInformation
as
select [Car].[ACCESSORIES].[Accessory_ID],[Type],[Amount],[Reservation_ID]
from  [Car].[ACCESSORIES]inner join [Car].[ACCESSORY_RESERVED]
on [Car].[ACCESSORIES].[Accessory_ID]=[Car].[ACCESSORY_RESERVED].Accessory_ID




--Hata Düzeltme
     CREATE UNIQUE NONCLUSTERED INDEX unq_abbr ON Car.CARD_DETAILS(Card_No)
 
alter TABLE Car.PAYMENT
add CONSTRAINT PAYMENTLOGINFK
FOREIGN KEY (Saved_Card_No) REFERENCES Car.CARD_DETAILS(Card_No)
             -- ON DELETE CASCADE
 
CREATE UNIQUE NONCLUSTERED INDEX unq_abbr2 ON Car.CARD_DETAILS(Login_ID)
 
alter TABLE Car.PAYMENT
add CONSTRAINT PAYMENTLOGINFK2
FOREIGN KEY (Login_ID) REFERENCES Car.CARD_DETAILS(Login_ID)





--Trigger Table can not delete
--1
Create Trigger tblntdlt
on database 
for Drop_table
as
begin 
print('Table can not deleted')
rollback
end

--2
--Výn deðiþtirilemiyor

create trigger trg_UpdateVIN on[Car].[CAR]    
after update
as begin

if(exists(select * from inserted,deleted where inserted.[Reg_No]=deleted.[Reg_No] and inserted.[VIN]!=deleted.[VIN])) 
begin
raiserror('VIN can not be change.',1,1)
rollback transaction
end
end

select * from [Car].[CAR]  where [Reg_No] ='XYZ671'  --test of trigger
update [Car].[CAR] set [VIN]  = 'E902103289341097' where Reg_No ='XYZ671'


--3

Create trigger trg_NoPermissonforLicenseDeletion on  [Car].[CAR_USER]  --Admin Accountunu silmeyi engelleyen trigger
after delete
as
begin
   if(exists(select * from deleted where [License_No] is not null ))
    begin
     raiserror('You are not allowed to delete license No:',0,0)
     rollback transaction
    end
end


delete from [Car].[CAR_USER] where [License_No] is not null  --test of trigger

--Trigger 
 create trigger OldCar on [Car].[CAR]
  after delete
  as begin
  insert into[Car].[OutOfUseCars] select[VIN],[Rental_Location_ID],[Reg_No],[Status],[Seating_Capacity],[Disability_Friendly],[Car_Type],[Model],[Year],[Color] from deleted
  end

  delete from [Car].[CAR] where VIN='E902103289341098'



--Function

create function ValueAddedTax
(@Reservation_ID INT)
returns decimal
as
begin
declare @TotalPrice as decimal
select @TotalPrice =SUM([Tot_Amount])* 0.18
FROM [Car].[RESERVATION]
where [Reservation_ID]=@Reservation_ID
return @TotalPrice
end 
go
select [dbo].[ValueAddedTax](1)

--Login
create login Furkan with
password='6666', 
default_database=[CarRental],
CHECK_EXPIRATION=OFF,CHECK_POLICY=ON
go
--Login
create login Mehmet with
password='1234', 
default_database=[CarRental],
CHECK_EXPIRATION=OFF,CHECK_POLICY=ON
go

EXEC sp_addsrvrolemember 'Furkan', 'sysadmin'
EXEC sp_addsrvrolemember 'Mehmet', 'sysadmin'







