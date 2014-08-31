USE voting_poll;

DROP TABLE IF EXISTS yes_no_voting;
DROP TABLE IF EXISTS constituency_party;
DROP TABLE IF EXISTS voting_stats;
DROP TABLE IF EXISTS constituency;
DROP TABLE IF EXISTS party;
DROP TABLE IF EXISTS county;

CREATE TABLE county (
  id   SMALLINT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  name VARCHAR(60)                   
) ENGINE=InnoDB;

CREATE TABLE constituency (
  id   SMALLINT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  name VARCHAR(60),                   
  county SMALLINT(4) NOT NULL,
  FOREIGN KEY (county) REFERENCES county(id),
  UNIQUE (name,county),
  INDEX (county)                   
) ENGINE=InnoDB;

CREATE TABLE party (
  id   SMALLINT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  name VARCHAR(40)                   
) ENGINE=InnoDB;

CREATE TABLE constituency_party (
  id   		SMALLINT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  constituency 	SMALLINT(4) NOT NULL,
  party 	SMALLINT(4) NOT NULL,
  FOREIGN KEY (constituency) REFERENCES constituency(id),
  FOREIGN KEY (party) REFERENCES party(id),
  UNIQUE (constituency,party),
  INDEX (constituency),                   
  INDEX (party)                   
) ENGINE=InnoDB;

CREATE TABLE yes_no_voting (
  id   		INT(8) NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  votes 	ENUM('Yes', 'No', 'Undecided' ) NOT NULL
) ENGINE=MyISAM;

CREATE TABLE voting_stats (
  id   		INT(8) NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  constituency 	SMALLINT(4) NOT NULL,
  party 	SMALLINT(4) NOT NULL,
  FOREIGN KEY (constituency) REFERENCES constituency(id),
  FOREIGN KEY (party) REFERENCES party(id),
  INDEX (constituency),                   
  INDEX (party)                   
) ENGINE=InnoDB;


INSERT INTO county VALUES (NULL, 'Hertfordshire');
INSERT INTO county VALUES (NULL, 'Bedforshire');
INSERT INTO county VALUES (NULL, 'Essex');
INSERT INTO county VALUES (NULL, 'Cownwall');

INSERT INTO constituency VALUES (NULL, 'Constituency 1', 1);
INSERT INTO constituency VALUES (NULL, 'Constituency 2', 1);
INSERT INTO constituency VALUES (NULL, 'Constituency 3', 1);
INSERT INTO constituency VALUES (NULL, 'Constituency 1', 2);
INSERT INTO constituency VALUES (NULL, 'Constituency 2', 2);
INSERT INTO constituency VALUES (NULL, 'Constituency 3', 2);
INSERT INTO constituency VALUES (NULL, 'Constituency 4', 2);
INSERT INTO constituency VALUES (NULL, 'Constituency 1', 3);
INSERT INTO constituency VALUES (NULL, 'Constituency 2', 3);
INSERT INTO constituency VALUES (NULL, 'Constituency 3', 3);
INSERT INTO constituency VALUES (NULL, 'Constituency 1', 4);
INSERT INTO constituency VALUES (NULL, 'Constituency 2', 4);

INSERT INTO party VALUES (NULL, 'Conservative');
INSERT INTO party VALUES (NULL, 'Labour');
INSERT INTO party VALUES (NULL, 'Liberal');
INSERT INTO party VALUES (NULL, 'Green');

INSERT INTO constituency_party VALUES (NULL, 1, 1);
INSERT INTO constituency_party VALUES (NULL, 1, 2);
INSERT INTO constituency_party VALUES (NULL, 1, 3);
INSERT INTO constituency_party VALUES (NULL, 1, 4);

INSERT INTO constituency_party VALUES (NULL, 2, 1);
INSERT INTO constituency_party VALUES (NULL, 2, 2);
INSERT INTO constituency_party VALUES (NULL, 2, 3);
INSERT INTO constituency_party VALUES (NULL, 2, 4);

INSERT INTO constituency_party VALUES (NULL, 3, 1);
INSERT INTO constituency_party VALUES (NULL, 3, 2);
INSERT INTO constituency_party VALUES (NULL, 3, 3);
INSERT INTO constituency_party VALUES (NULL, 3, 4);

INSERT INTO constituency_party VALUES (NULL, 4, 1);
INSERT INTO constituency_party VALUES (NULL, 4, 2);
INSERT INTO constituency_party VALUES (NULL, 4, 3);
INSERT INTO constituency_party VALUES (NULL, 4, 4);

INSERT INTO constituency_party VALUES (NULL, 5, 1);
INSERT INTO constituency_party VALUES (NULL, 5, 2);
INSERT INTO constituency_party VALUES (NULL, 5, 3);
INSERT INTO constituency_party VALUES (NULL, 5, 4);

INSERT INTO constituency_party VALUES (NULL, 6, 1);
INSERT INTO constituency_party VALUES (NULL, 6, 2);
INSERT INTO constituency_party VALUES (NULL, 6, 3);
INSERT INTO constituency_party VALUES (NULL, 6, 4);

INSERT INTO constituency_party VALUES (NULL, 7, 1);
INSERT INTO constituency_party VALUES (NULL, 7, 2);
INSERT INTO constituency_party VALUES (NULL, 7, 3);
INSERT INTO constituency_party VALUES (NULL, 7, 4);

INSERT INTO constituency_party VALUES (NULL, 8, 1);
INSERT INTO constituency_party VALUES (NULL, 8, 2);
INSERT INTO constituency_party VALUES (NULL, 8, 3);
INSERT INTO constituency_party VALUES (NULL, 8, 4);

INSERT INTO constituency_party VALUES (NULL, 9, 1);
INSERT INTO constituency_party VALUES (NULL, 9, 2);
INSERT INTO constituency_party VALUES (NULL, 9, 3);
INSERT INTO constituency_party VALUES (NULL, 9, 4);

INSERT INTO constituency_party VALUES (NULL, 10, 1);
INSERT INTO constituency_party VALUES (NULL, 10, 2);
INSERT INTO constituency_party VALUES (NULL, 10, 3);
INSERT INTO constituency_party VALUES (NULL, 10, 4);

INSERT INTO constituency_party VALUES (NULL, 11, 1);
INSERT INTO constituency_party VALUES (NULL, 11, 2);
INSERT INTO constituency_party VALUES (NULL, 11, 3);
INSERT INTO constituency_party VALUES (NULL, 11, 4);

INSERT INTO constituency_party VALUES (NULL, 12, 1);
INSERT INTO constituency_party VALUES (NULL, 12, 2);
INSERT INTO constituency_party VALUES (NULL, 12, 3);
INSERT INTO constituency_party VALUES (NULL, 12, 4);

