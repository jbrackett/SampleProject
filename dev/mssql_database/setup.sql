DROP DATABASE IF EXISTS Outtask;
CREATE DATABASE Outtask;
USE Outtask;

BEGIN TRAN

GO

CREATE TABLE OUTTASK_COMPANY_TRAVEL_CONFIG (
    COMPANY_ID int NOT NULL,
    TRAVEL_CONFIG_ID int NOT NULL,
    UUID uniqueidentifier NOT NULL,
    OVERRIDE_BOOKING_IATA_HOTEL varchar(8) NOT NULL,
    HOTEL_PREVIOUS_DAY_REMINDER_END_TIME varchar(5) NOT NULL,
    DEFAULT_HOTEL_SEARCH_RADIUS int NULL,
    PREFERRED_PROP_SEARCH_RADIUS int NOT NULL,
    HOTEL_MAX_RESULTS int NOT NULL,
    HOTEL_DISPLAYS_PER_DIEM_RATE bit NOT NULL,
    HOTEL_SORT_DEFAULT varchar(10) NOT NULL,
    LAST_MOD_BY int NULL
);

GO

CREATE TABLE OUTTASK_COMPANY (
	COMPANY_ID int NOT NULL,
	UUID uniqueidentifier NULL
);

GO

CREATE TABLE OUTTASK_RULE_CLASS (
    RULE_CLASS_ID int NOT NULL,
    COMPANY_ID int NOT NULL,
    TRAVEL_CONFIG_ID int NULL,
    PROPERTY_CONFIG_ID int NOT NULL
);

GO

CREATE TABLE OUTTASK_TRAVEL_CONFIG_CATEGORY (
    TRAVEL_CONFIG_ID int NOT NULL,
    CONFIG_DOMAIN_CODE varchar(20) NOT NULL,
    CONFIG_CATEGORY_CODE varchar(200) NOT NULL,
    IS_DISABLED bit NOT NULL,
    LAST_MOD_BY int NULL
);

GO

CREATE TABLE OUTTASK_TRAVEL_CONFIG_ITEM_VALUE (
	TRAVEL_CONFIG_ID int NOT NULL,
	CONFIG_ITEM_ID int NOT NULL,
	LAST_MOD_BY_ID int NULL,
	CONFIG_ITEM_VALUE nvarchar(4000) NULL,
	CONFIG_ITEM_VALUE_ID int NOT NULL
);

GO

CREATE TABLE CODE_TRAVEL_CONFIG_ITEM (
	CONFIG_ITEM_ID int NOT NULL,
	NAME_EN_US varchar (200) NOT NULL,
	NAME_MSGID varchar (200) NOT NULL,
	CONFIG_DOMAIN_CODE varchar (20) NOT NULL,
	CONFIG_CATEGORY_CODE varchar (200) NOT NULL,
	CONFIG_ITEM_CODE varchar (200) NOT NULL,
	DEFAULT_ITEM_VALUE nvarchar (4000) NULL,
	QUICKHELP_MSGID varchar (25) NULL,
	VALIDATION_TYPE varchar (25) NULL,
	VALIDATION_PARAM varchar (255) NULL,
	INPUT_RENDERER varchar (25) NULL,
	ENABLED bit NOT NULL,
	SORT_INDEX int NOT NULL,
	MUST_BE_ENCRYPTED bit NOT NULL
);

GO

INSERT INTO OUTTASK_COMPANY_TRAVEL_CONFIG
(COMPANY_ID, TRAVEL_CONFIG_ID, UUID, OVERRIDE_BOOKING_IATA_HOTEL, HOTEL_PREVIOUS_DAY_REMINDER_END_TIME,
DEFAULT_HOTEL_SEARCH_RADIUS, PREFERRED_PROP_SEARCH_RADIUS, HOTEL_MAX_RESULTS, HOTEL_DISPLAYS_PER_DIEM_RATE, HOTEL_SORT_DEFAULT, LAST_MOD_BY)
VALUES (1, 11111111, 'e1ce155f-7440-4e4a-a774-af7ed0bfbe92', '09080706', '6:00', 5, 30, 13, 1, 'CUSTOM', -2);

GO

INSERT INTO OUTTASK_COMPANY_TRAVEL_CONFIG
(COMPANY_ID, TRAVEL_CONFIG_ID, UUID, OVERRIDE_BOOKING_IATA_HOTEL, HOTEL_PREVIOUS_DAY_REMINDER_END_TIME,
DEFAULT_HOTEL_SEARCH_RADIUS, PREFERRED_PROP_SEARCH_RADIUS, HOTEL_MAX_RESULTS, HOTEL_DISPLAYS_PER_DIEM_RATE, HOTEL_SORT_DEFAULT, LAST_MOD_BY)
VALUES (2, 22222222, 'a950d08a-093c-4975-9b86-5a6b3ea2c20e', '10070606', '12:00', 10, 45, 15, 2, 'DISTANCE', -2);

GO

INSERT INTO OUTTASK_COMPANY
(COMPANY_ID, UUID)
VALUES (1, '2a09b1ba-125f-4e4c-a8ef-f48a018583cc');

GO

INSERT INTO OUTTASK_RULE_CLASS
(RULE_CLASS_ID, COMPANY_ID, TRAVEL_CONFIG_ID, PROPERTY_CONFIG_ID)
VALUES (10016511, 1, 11111111, 340);

GO

INSERT INTO OUTTASK_RULE_CLASS
(RULE_CLASS_ID, COMPANY_ID, TRAVEL_CONFIG_ID, PROPERTY_CONFIG_ID)
VALUES (10016512, 1, 11111111, 340);

GO

DECLARE @airConnConfigDomainCode AS varchar(20) = 'AIRCONN';
DECLARE @travelfusion AS varchar(20) = 'TravelFusion';
DECLARE @interjet AS varchar(20) = 'Interjet';
DECLARE @southwest AS varchar(20) = 'Southwest';
DECLARE @cleartrip AS varchar(20) = 'Cleartrip';

INSERT INTO OUTTASK_TRAVEL_CONFIG_CATEGORY
(TRAVEL_CONFIG_ID, CONFIG_DOMAIN_CODE, CONFIG_CATEGORY_CODE, IS_DISABLED, LAST_MOD_BY)
VALUES (11111111, @airConnConfigDomainCode, @travelfusion, 0, -2);

INSERT INTO OUTTASK_TRAVEL_CONFIG_CATEGORY
(TRAVEL_CONFIG_ID, CONFIG_DOMAIN_CODE, CONFIG_CATEGORY_CODE, IS_DISABLED, LAST_MOD_BY)
VALUES (22222222, @airConnConfigDomainCode, @travelfusion, 0, -2);

INSERT INTO OUTTASK_TRAVEL_CONFIG_CATEGORY
(TRAVEL_CONFIG_ID, CONFIG_DOMAIN_CODE, CONFIG_CATEGORY_CODE, IS_DISABLED, LAST_MOD_BY)
VALUES (11111111, @airConnConfigDomainCode, @interjet, 0, -2);

INSERT INTO OUTTASK_TRAVEL_CONFIG_CATEGORY
(TRAVEL_CONFIG_ID, CONFIG_DOMAIN_CODE, CONFIG_CATEGORY_CODE, IS_DISABLED, LAST_MOD_BY)
VALUES (22222222, @airConnConfigDomainCode, @interjet, 0, -2);

INSERT INTO OUTTASK_TRAVEL_CONFIG_CATEGORY
(TRAVEL_CONFIG_ID, CONFIG_DOMAIN_CODE, CONFIG_CATEGORY_CODE, IS_DISABLED, LAST_MOD_BY)
VALUES (11111111, @airConnConfigDomainCode, @southwest, 0, -2);

INSERT INTO OUTTASK_TRAVEL_CONFIG_CATEGORY
(TRAVEL_CONFIG_ID, CONFIG_DOMAIN_CODE, CONFIG_CATEGORY_CODE, IS_DISABLED, LAST_MOD_BY)
VALUES (22222222, @airConnConfigDomainCode, @southwest, 0, -2);

INSERT INTO OUTTASK_TRAVEL_CONFIG_CATEGORY
(TRAVEL_CONFIG_ID, CONFIG_DOMAIN_CODE, CONFIG_CATEGORY_CODE, IS_DISABLED, LAST_MOD_BY)
VALUES (11111111, @airConnConfigDomainCode, @cleartrip, 0, -2);

INSERT INTO OUTTASK_TRAVEL_CONFIG_CATEGORY
(TRAVEL_CONFIG_ID, CONFIG_DOMAIN_CODE, CONFIG_CATEGORY_CODE, IS_DISABLED, LAST_MOD_BY)
VALUES (22222222, @airConnConfigDomainCode, @cleartrip, 0, -2);

INSERT INTO OUTTASK_TRAVEL_CONFIG_ITEM_VALUE
(TRAVEL_CONFIG_ID, CONFIG_ITEM_ID, LAST_MOD_BY_ID, CONFIG_ITEM_VALUE, CONFIG_ITEM_VALUE_ID)
VALUES (11111111, 3, -2, 'this.is.interjet.corporateCode', 1),
       (11111111, 4, -2, 'this.is.interjet.discountCode', 2),
       (11111111, 22, -2, 'this.is.interjet.agentUserName', 3),
       (11111111, 23, -2, 'this.is.interjet.agentPassword', 4),
       (11111111, 126, -2, 'this.is.interjet.locationCode', 5),
       (11111111, 127, -2, 'this.is.interjet.roleCode', 6),
       (11111111, 128, -2, 'this.is.interjet.agPrepaidPass', 7),
       (11111111, 36, -2, 'this.is.southwestAirlines.accountNumber', 8),
       (11111111, 42, -2, 'this.is.southwestAirlines.companyShortName', 9),
       (11111111, 46, -2, 'this.is.southwestAirlines.overrideEmailAddress', 10),
       (11111111, 51, -2, 'this.is.southwestAirlines.disableTicketCredits', 11),
       (11111111, 83, -2, 'this.is.southwestAirlines.allowPreticketingFlightChanges', 12),
       (11111111, 84, -2, 'this.is.southwestAirlines.allowPostticketingFlightChanges', 13),
       (11111111, 172, -2, 'this.is.southwestAirlines.allowEarlyBirdCheckin', 14),
       (11111111, 131, -2, 'this.is.cleartrip.depositAccountId', 15),
       (11111111, 153, -2, 'this.is.cleartrip.apiKey', 16),
       (22222222, 3, -2, 'this.is.interjet.corporateCode', 17),
       (22222222, 4, -2, 'this.is.interjet.discountCode', 18),
       (22222222, 22, -2, 'this.is.interjet.agentUserName', 19),
       (22222222, 23, -2, 'this.is.interjet.agentPassword', 20),
       (22222222, 126, -2, 'this.is.interjet.locationCode', 21),
       (22222222, 127, -2, 'this.is.interjet.roleCode', 22),
       (22222222, 128, -2, 'this.is.interjet.agPrepaidPass', 23),
       (22222222, 36, -2, 'this.is.southwestAirlines.accountNumber', 24),
       (22222222, 42, -2, 'this.is.southwestAirlines.companyShortName', 25),
       (22222222, 46, -2, 'this.is.southwestAirlines.overrideEmailAddress', 26),
       (22222222, 51, -2, 'this.is.southwestAirlines.disableTicketCredits', 27),
       (22222222, 83, -2, 'this.is.southwestAirlines.allowPreticketingFlightChanges', 28),
       (22222222, 84, -2, 'this.is.southwestAirlines.allowPostticketingFlightChanges', 29),
       (22222222, 172, -2, 'this.is.southwestAirlines.allowEarlyBirdCheckin', 30),
       (22222222, 131, -2, 'this.is.cleartrip.depositAccountId', 31),
       (22222222, 153, -2, 'this.is.cleartrip.apiKey', 32);

INSERT INTO CODE_TRAVEL_CONFIG_ITEM
(CONFIG_ITEM_ID,NAME_EN_US,NAME_MSGID,CONFIG_DOMAIN_CODE,CONFIG_CATEGORY_CODE,
 CONFIG_ITEM_CODE,DEFAULT_ITEM_VALUE,QUICKHELP_MSGID,VALIDATION_TYPE,VALIDATION_PARAM,
 INPUT_RENDERER,ENABLED,SORT_INDEX,MUST_BE_ENCRYPTED)
VALUES (3,'Corporate Code', 'CorpCode', @airConnConfigDomainCode, @interjet, 'CorpCode', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (4,'Discount Code', 'DiscountCode', @airConnConfigDomainCode, @interjet, 'DiscountCode', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (22,'AgentUserName', 'AgentUserName', @airConnConfigDomainCode, @interjet, 'InterjetAgentUserName', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (23,'AgentPassword', 'AgentPassword', @airConnConfigDomainCode, @interjet, 'InterjetAgentPassword', NULL, NULL, NULL, NULL, NULL, 1, 0, 1),
       (126,'LocationCode', 'LocationCode', @airConnConfigDomainCode, @interjet, 'LocationCode', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (127,'RoleCode', 'RoleCode', @airConnConfigDomainCode, @interjet, 'RoleCode', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (128,'AGPrepaidPass', 'AGPrepaidPass', @airConnConfigDomainCode, @interjet, 'AGPrepaidPass', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (36,'Corporate Rate Code', 'AccountNumber', @airConnConfigDomainCode, @southwest, 'DiscountCode', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (42,'Company Short Name', 'CompanyShortName', @airConnConfigDomainCode, @southwest, 'CompanyShortName', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (46,'Company Short Name', 'OverrideEmail', @airConnConfigDomainCode, @southwest, 'OverrideEmail', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (51,'Disable Ticket Credits', 'DisableTicketCredits', @airConnConfigDomainCode, @southwest, 'DisableTicketCredits', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (83,'Allow pre-ticketing flight changes', 'AllowPreTicketChange', @airConnConfigDomainCode, @southwest, 'AllowPreTicketChange', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (84,'Allow post-ticketing flight changes', 'AllowPostTicketChange', @airConnConfigDomainCode, @southwest, 'AllowPostTicketChange', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (172,'Allow Early Bird Checkin', 'AllowEarlyBirdCheckin', @airConnConfigDomainCode, @southwest, 'AllowEarlyBirdCheckin', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (131,'Deposit Account ID', 'DepositAccountID', @airConnConfigDomainCode, @cleartrip, 'DepositAccountID', NULL, NULL, NULL, NULL, NULL, 1, 0, 0),
       (153,'API Key', 'APIKey', @airConnConfigDomainCode, @cleartrip, 'APIKey', NULL, NULL, NULL, NULL, NULL, 1, 0, 1);

COMMIT TRAN