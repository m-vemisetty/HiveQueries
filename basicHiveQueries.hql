
--Create hive database with your name.
create database m_db;

use m_db;

--Create a table to store users.
CREATE EXTERNAL TABLE users_string                           
(userId STRING,
screenName STRING,
createdAt STRING,
numberFollowers STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/assignment_4/users';

--Create a table to store tweets.
CREATE EXTERNAL TABLE tweets_string                           
(tweetId STRING,
userId STRING,
createdAt STRING,
source STRING,
text STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/assignment_4/tweets';


--Populate above two tables using provided input data.
Select * from users_string u join tweets_string t on CAST(t.USERID AS BIGINT) = CAST(u.USERID AS BIGINT);


--Select top 10 users based on number of followers
select screenName,CAST(numberFollowers AS INT) from users_string order by numberFollowers desc limit 10;


--Find how many users have tweeted
select count(CAST(userId AS INT)) from tweets_string;


--Find the time range of the tweets i.e. find out first and last tweet.
select min(from_unixtime(CAST(TRIM(createdAt) AS BIGINT), 'dd-MMM-yy hh.mm.ss a')),max(from_unixtime(CAST(TRIM(createdAt) AS BIGINT), 'dd-MMM-yy hh.mm.ss a')) from users_string limit 10;


--Create a table called output which contains users ids, number of tweets by the user and number of follower for the user.
CREATE TABLE IF NOT EXISTS output
STORED AS PARQUET
AS 
select CAST(t.userId AS BIGINT), count(CAST(t.userId AS BIGINT)), CAST(u.numberFollowers AS INT) from tweets_string t join users_string u on CAST(t.userId AS BIGINT) = CAST(u.userId AS BIGINT)
group by CAST(t.userId AS BIGINT), CAST(u.numberFollowers AS INT);
