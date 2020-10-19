 = Lower(SUBSTRING(Convert(CHAR(36),_IDRRef,1),27, 8)+'-'+ 
              SUBSTRING(Convert(CHAR(36),_IDRRef,1),23, 4)+'-'+
              SUBSTRING(Convert(CHAR(36),_IDRRef,1),19, 4)+'-'+
              SUBSTRING(Convert(CHAR(36),_IDRRef,1), 3, 4)+'-'+
              SUBSTRING(Convert(CHAR(36),_IDRRef,1), 7,12))

