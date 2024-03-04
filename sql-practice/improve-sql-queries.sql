----------
-- Step 0 - Create a Query 
----------
-- Query: Select all cats that have a toy with an id of 5
-- Your code here
-- SELECT
--   c.name,
--   c.color,
--   c.breed
-- FROM
--   cats c
--   JOIN cat_toys ct ON c.id = ct.cat_id
--   JOIN toys t ON ct.toy_id = t.id
-- WHERE
--   t.id = 5;
-- Paste your results below (as a comment):
----------
-- Step 1 - Analyze the Query
----------
-- Query:
-- Your code here
-- EXPLAIN QUERY PLAN
-- SELECT
--   c.name,
--   c.color,
--   c.breed
-- FROM
--   cats c
--   JOIN cat_toys ct ON c.id = ct.cat_id
--   JOIN toys t ON ct.toy_id = t.id
-- WHERE
--   t.id = 5;
-- Paste your results below (as a comment):
-- QUERY PLAN
-- |--SEARCH t USING INTEGER PRIMARY KEY (rowid=?)
-- |--SCAN ct
-- --SEARCH c USING INTEGER PRIMARY KEY (rowid=?)
-- What do your results mean?
-- Was this a SEARCH or SCAN?
-- it searches the toys and cats table using a SEARCH while SCAN the cat_toys table
-- What does that mean?
-- It means that the primary keys on the toys and cats tables act as indexes already.
----------
-- Step 2 - Time the Query to get a baseline
----------
-- Query (to be used in the sqlite CLI):
-- Your code here
-- .timer on
-- SELECT
--   c.name,
--   c.color,
--   c.breed
-- FROM
--   cats c
--   JOIN cat_toys ct ON c.id = ct.cat_id
--   JOIN toys t ON ct.toy_id = t.id
-- WHERE
--   t.id = 5;
-- Paste your results below (as a comment):
-- Rachele|Maroon|Foldex Cat
-- Rodger|Lavender|Oregon Rex
-- Jamal|Orange|Sam Sawet
-- Run Time: real 0.001 user 0.001309 sys 0.000000
----------
-- Step 3 - Add an index and analyze how the query is executing
----------
-- Create index:
-- CREATE INDEX IF NOT EXISTS idx_cat_toys_toy_id ON cat_toys (toy_id);

-- Your code here
-- EXPLAIN QUERY PLAN
-- SELECT
--   c.name,
--   c.color,
--   c.breed
-- FROM
--   cats c
--   JOIN cat_toys ct ON c.id = ct.cat_id
--   JOIN toys t ON ct.toy_id = t.id
-- WHERE
--   t.id = 5;

-- Analyze Query:
-- Your code here
-- Paste your results below (as a comment):
-- Run Time: real 0.106 user 0.011908 sys 0.000235
-- QUERY PLAN
-- |--SEARCH t USING INTEGER PRIMARY KEY (rowid=?)
-- |--SEARCH ct USING INDEX idx_cat_toys_toy_id (toy_id=?)
-- -- SEARCH c USING INTEGER PRIMARY KEY (rowid=?)
-- -- Run Time: real 0.000 user 0.000069 sys 0.000074

-- Analyze Results:
-- Is the new index being applied in this query?
-- Yes
----------
-- Step 4 - Re-time the query using the new index
----------
-- Query (to be used in the sqlite CLI):
.timer on
-- Your code here
SELECT
  c.name,
  c.color,
  c.breed
FROM
  cats c
  JOIN cat_toys ct ON c.id = ct.cat_id
  JOIN toys t ON ct.toy_id = t.id
WHERE
  t.id = 5;
-- Paste your results below (as a comment):
-- Analyze Results:
-- Are you still getting the correct query results?
-- Yes
-- Did the execution time improve (decrease)?
-- Yes it decreased
-- Do you see any other opportunities for making this query more efficient?
-- Not yet
---------------------------------
-- Notes From Further Exploration
---------------------------------
