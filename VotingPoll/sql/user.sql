CREATE DATABASE IF NOT EXISTS voting_poll;
CREATE USER 'voting_poll'@'localhost' IDENTIFIED BY 'StRaW101';
GRANT SELECT, INSERT, UPDATE ON voting_poll.* TO 'voting_poll'@'localhost';
