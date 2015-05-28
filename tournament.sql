-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.
CREATE TABLE players
(
id serial PRIMARY KEY,
name text
);

CREATE TABLE matches
(
id serial PRIMARY KEY,
winner integer REFERENCES players (id), 
loser integer REFERENCES players (id)
);

CREATE VIEW countPlayers AS
SELECT count(*)
FROM players;

CREATE VIEW winCounts AS
SELECT players.id, coalesce(count(matches.winner), 0) AS wins
FROM players
LEFT OUTER JOIN matches
ON players.id = matches.winner
GROUP BY players.id;

CREATE VIEW lossCounts AS
SELECT players.id, coalesce(count(matches.loser), 0) AS losses
FROM players
LEFT OUTER JOIN matches
ON players.id = matches.loser
GROUP BY players.id;

CREATE VIEW playerStandings AS
SELECT players.id, players.name, winCounts.wins, winCounts.wins + lossCounts.losses AS matches
FROM players
LEFT OUTER JOIN winCounts
ON players.id = winCounts.id
LEFT OUTER JOIN lossCounts
ON players.id = lossCounts.id
ORDER BY wins;