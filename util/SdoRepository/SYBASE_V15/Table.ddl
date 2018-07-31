create table SDOREP.BYTESTORE
  (NAME VARCHAR(250) not null,
   BYTES IMAGE null,
   TIMESTAMP1 NUMERIC(19, 0) not null)
GO


alter table SDOREP.BYTESTORE
  add constraint PK_BYTESTORE primary key (NAME)
GO
