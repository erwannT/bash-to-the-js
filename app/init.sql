-- CREATE USER bash2js IDENTIFIED BY pa55W0RD;
-- CREATE DATABASE bash2js;
-- GRANT ALL PRIVILEGES ON bash2js.* TO bash2js;
CREATE TABLE IF NOT EXISTS speakers (
    id int(11) NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    avatar varchar(200) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO speakers (`id`, `name`, `avatar`) VALUES
(1,	'Erwann Thebault',	'https://media.licdn.com/dms/image/C4E03AQExxvVFbL0gJQ/profile-displayphoto-shrink_400_400/0/1517622962602?e=2147483647&v=beta&t=ln3lKYXM_fytS29k-JxJj5DlMhhiKjD-mMLOuHqrOSQ'),
(2,	'Mahdi AICI',	'https://i.discogs.com/jtlykYk336toKQUjrLIQNtGJaF0vVRn8ORrWRvDIUW0/rs:fit/g:sm/q:90/h:300/w:300/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9BLTEwMTA4/MjMtMTMzNTcyODAx/Ni5wbmc.jpeg');