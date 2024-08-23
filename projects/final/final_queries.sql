-- [CMPS1171-1] Introduction to Databases Final Project
-- Andres Hung & Jennessa Sierra
-- 2024/04/12

/* QUERIES */

-- Query 1: Retrieve the usernames of users who have uploaded photos and have a gender preference for the opposite gender
-- Requirement: Join
SELECT u.username
FROM users u
JOIN user_photos up ON u.utopia_id = up.uploader_id
JOIN user_gender_preferences ugp ON u.utopia_id = ugp.utopia_id
JOIN genders g ON ugp.gender_id = g.gender_id
WHERE g.gender <> (SELECT gender FROM genders WHERE gender_id = u.gender);

-- Query 2: Retrieve the total number of conversations for each user, including users with no conversations
-- Requirement: Left Join and count()
SELECT u.username, COUNT(uc.conversation_id) AS total_conversations
FROM users u
LEFT JOIN user_conversations uc ON u.utopia_id = uc.initiator
GROUP BY u.username;

-- Query 3: Retrieve the usernames of users who have blocked other users and have not uploaded any photos
-- Requirement: Join and subquery
SELECT u.username
FROM users u
JOIN user_block_lists ub ON u.utopia_id = ub.blocker
WHERE ub.blockee IN (SELECT utopia_id FROM users)
AND u.utopia_id NOT IN (SELECT uploader_id FROM user_photos);

-- Query 4: Retrieve the number of messages sent by each user, including users with no sent messages
-- Requirement: Left Join and count()
SELECT u.username, COUNT(um.message_id) AS total_messages
FROM users u
LEFT JOIN user_messages um ON u.utopia_id = um.sender
GROUP BY u.username;