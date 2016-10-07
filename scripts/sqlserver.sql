USE Players

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[whatplayswhatformat]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [dbo].[whatplayswhatformat]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[format]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [dbo].[format]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[player]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [dbo].[player]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[manufacturer]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [dbo].[manufacturer]

CREATE TABLE Manufacturer (
  ManufacturerID int NOT NULL identity,
  ManufacturerName varchar(50) NOT NULL default '',
  ManufacturerCountry varchar(50) default NULL,
  ManufacturerEmail varchar(100) default NULL,
  ManufacturerWebsite varchar(100) default NULL,
  CONSTRAINT PK__Manufacturer PRIMARY KEY (ManufacturerID)
)

INSERT INTO Manufacturer (ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite)
VALUES('Apple', 'USA', 'lackey@apple.com', 'http://www.apple.com')

INSERT INTO Manufacturer (ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite)
VALUES('Creative', 'Singapore', 'someguy@creative.com', 'http://www.creative.com')

INSERT INTO Manufacturer (ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite)
VALUES('iRiver', 'Korea', 'knockknock@iriver.com', 'http://www.iriver.com')

INSERT INTO Manufacturer (ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite)
VALUES('MSI', 'Taiwan', 'hello@miscomputer.co.uk', 'http://www.miscomputer.co.uk')

INSERT INTO Manufacturer (ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite)
VALUES('Rio', 'USA', 'Greetings@rio.com', 'http://www.rio.com')

INSERT INTO Manufacturer (ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite)
VALUES('SanDisk', 'USA', 'heyhey@sandisk.com', 'http://www.sandisk.com')

INSERT INTO Manufacturer (ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite)
VALUES('Sony', 'Japan', 'hi_San@sony.co.jp', 'http://www.sony.com')

INSERT INTO Manufacturer (ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite)
VALUES('Cowon', 'Korea', 'moomoo@cowon.com', 'http://www.cowon.com')

INSERT INTO Manufacturer (ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite)
VALUES('Frontier Labs', 'Hong Kong', 'frontdesk@frontierlabs.com', 'http://www.frontierlabs.com')

INSERT INTO Manufacturer (ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite)
VALUES('Samsung', 'Japan', 'mashimashi@samsung.co.jp', 'http://www.samsung.com')


CREATE TABLE Format (
  FormatID int  NOT NULL identity,
  FormatName varchar(50) NOT NULL default '',
  CONSTRAINT PK__Format PRIMARY KEY (FormatID)
)

INSERT INTO Format (FormatName) VALUES ('wav')
INSERT INTO Format (FormatName) VALUES ('mp3')
INSERT INTO Format (FormatName) VALUES ('aac')
INSERT INTO Format (FormatName) VALUES ('wma')
INSERT INTO Format (FormatName) VALUES ('asf')
INSERT INTO Format (FormatName) VALUES ('ogg')
INSERT INTO Format (FormatName) VALUES ('atrac')
INSERT INTO Format (FormatName) VALUES ('aiff')


CREATE TABLE Player (
  PlayerID int  NOT NULL identity,
  PlayerName varchar(50) NOT NULL default '',
  PlayerManufacturerID int  NOT NULL default '0',
  PlayerCost decimal(10,2) NOT NULL default '0',
  PlayerStorage varchar(50) NOT NULL default '',
  CONSTRAINT PK__Player PRIMARY KEY (PlayerID),
  CONSTRAINT FK_Player_Manufacturer FOREIGN KEY (PlayerManufacturerID) REFERENCES Manufacturer(ManufacturerID)
)

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('iPod Shuffle', 1, 99, 'Solid State')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('MuVo V200', 2, 96, 'Solid State')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('iFP-700 Series', 3, 149, 'Solid State')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('iFP-900 Series', 3, 149, 'Solid State')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('MegaPlayer 521', 4, 199, 'Solid State')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('Forge', 5, 93, 'Solid State')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('Digital Audio Player', 6, 119, 'Solid State')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('Network Walkman NW-E99', 7, 135, 'Solid State')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('iPod', 1, 209, 'Hard Disk')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('iPod Mini', 1, 169, 'Hard Disk')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('iPod Photo', 1, 309, 'Hard Disk')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('iAudio M3', 8, 249, 'Hard Disk')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('Zen Micro', 2, 138, 'Hard Disk')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('Zen Touch', 2, 169, 'Hard Disk')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('L1', 9, 149, 'Hard Disk')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('H10', 3, 189, 'Hard Disk')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('H300 Series', 3, 319, 'Hard Disk')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('Carbon', 5, 169, 'Hard Disk')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('Napster YH-920', 10, 179, 'Hard Disk')

INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)
VALUES ('Network Walkman NW-HD3', 7, 215, 'Hard Disk')


CREATE TABLE WhatPlaysWhatFormat (
  WPWFPlayerID int NOT NULL default '0',
  WPWFFormatID int NOT NULL default '0',
  CONSTRAINT PK__WhatPlaysWhatFormat PRIMARY KEY (WPWFFormatID,WPWFPlayerID),
  CONSTRAINT FK_WhatPlaysWhatFormat_Player FOREIGN KEY (WPWFPlayerID) REFERENCES Player (PlayerID),
  CONSTRAINT FK_WhatPlaysWhatFormat_Format FOREIGN KEY (WPWFFormatID) REFERENCES Format (FormatID)
)

INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (1,1)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (1,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (1,3)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (2,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (2,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (3,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (3,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (3,5)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (3,6)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (4,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (4,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (4,5)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (4,6)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (5,1)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (5,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (5,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (6,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (6,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (7,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (7,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (8,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (8,7)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (9,1)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (9,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (9,3)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (9,8)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (10,1)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (10,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (10,3)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (10,8)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (11,1)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (11,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (11,3)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (11,8)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (12,1)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (12,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (12,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (12,5)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (12,6)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (13,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (13,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (14,1)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (14,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (14,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (15,1)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (15,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (15,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (16,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (16,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (17,1)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (17,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (17,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (17,5)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (17,6)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (18,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (18,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (19,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (19,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (20,2)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (20,4)
INSERT INTO WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (20,6)

exec sp_addlogin 'band', 'letmein'
exec sp_grantdbaccess 'band', 'band'
GRANT SELECT, INSERT, UPDATE, DELETE TO band