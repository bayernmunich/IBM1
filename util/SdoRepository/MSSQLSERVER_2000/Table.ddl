CREATE TABLE SDOREP.BYTESTORE
  (NAME VARCHAR(250) NOT NULL,
   BYTES IMAGE NULL,
   TIMESTAMP1 BIGINT NOT NULL);

ALTER TABLE SDOREP.BYTESTORE
  ADD CONSTRAINT PK_BYTESTORE PRIMARY KEY (NAME);
