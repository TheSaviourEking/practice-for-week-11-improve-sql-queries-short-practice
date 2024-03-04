----------
-- Step 0 - Create a Query 
----------
-- Query: Find a count of `toys` records that have a price greater than
-- 55 and belong to a cat that has the color "Olive".
-- Your code here
-- SELECT
--   COUNT(toys.id)
-- FROM
--   toys
--   JOIN cat_toys ON (cat_toys.toy_id = toys.id)
--   JOIN cats ON (cat_toys.cat_id = cats.id)
-- WHERE
--   toys.price > 55
--   AND cats.color = 'Olive';
-- Paste your results below (as a comment):
-- 215
-- Run Time: real 0.009 user 0.008875 sys 0.000000
----------
-- Step 1 - Analyze the Query
----------
-- Query:
-- Your code here
-- EXPLAIN QUERY PLAN
-- SELECT
--   COUNT(toys.id)
-- FROM
--   toys
--   JOIN cat_toys ON (cat_toys.toy_id = toys.id)
--   JOIN cats ON (cat_toys.cat_id = cats.id)
-- WHERE
--   toys.price > 55
--   AND cats.color = 'Olive';
-- Paste your results below (as a comment):
-- QUERY PLAN
-- |--SCAN cat_toys
-- |--SEARCH toys USING INTEGER PRIMARY KEY (rowid=?)
-- `--SEARCH cats USING INTEGER PRIMARY KEY (rowid=?)
--  --Run Time: real 0.000 user 0.000136 sys 0.000000
-- What do your results mean?
-- it means that the cat_toys table is not indexed by anything
-- Was this a SEARCH or SCAN?
-- There are SEARCHes in the toys and cats tables using the primary keys, and a SCAN in the cat_toys table
-- What does that mean?
-- it means that there's a way to improve the speed of searches by indexing the cat_toys table
----------
-- Step 2 - Time the Query to get a baseline
----------
-- Query (to be used in the sqlite CLI):
-- Your code here
-- .timer on
-- Paste your results below (as a comment):
-- QUERY PLAN
-- |--SCAN cat_toys
-- |--SEARCH toys USING INTEGER PRIMARY KEY (rowid=?)
-- `--SEARCH cats USING INTEGER PRIMARY KEY (rowid=?)
-- Run Time: real 0.000 user 0.000124 sys 0.000000
----------
-- Step 3 - Add an index and analyze how the query is executing
----------
-- Create index:
-- Your code here

CREATE INDEX IF NOT EXISTS idx_cat_toys_cat_id ON cat_toys (cat_id);

CREATE INDEX IF NOT EXISTS idx_cats_color ON cats (color);

CREATE INDEX IF NOT EXISTS idx_toys_price ON toys (price);

-- Analyze Query:
-- Your code here
EXPLAIN QUERY PLAN
SELECT
  COUNT(toys.id)
FROM
  toys
  JOIN cat_toys ON (cat_toys.toy_id = toys.id)
  JOIN cats ON (cat_toys.cat_id = cats.id)
WHERE
  toys.price > 55
  AND cats.color = 'Olive';

-- Paste your results below (as a comment):
-- QUERY PLAN
-- |--SEARCH cats USING COVERING INDEX idx_cats_color (color=?)
-- |--SEARCH cat_toys USING INDEX idx_cat_toys_cat_id (cat_id=?)
-- `--SEARCH toys USING INTEGER PRIMARY KEY (rowid=?)

-- Analyze Results:
-- Is the new index being applied in this query?
-- Yeah

----------
-- Step 4 - Re-time the query using the new index
----------
-- Query (to be used in the sqlite CLI):
.timer on
-- Your code here
SELECT
  COUNT(toys.id)
FROM
  toys
  JOIN cat_toys ON (cat_toys.toy_id = toys.id)
  JOIN cats ON (cat_toys.cat_id = cats.id)
WHERE
  toys.price > 55
  AND cats.color = 'Olive';
-- Paste your results below (as a comment):
-- QUERY PLAN
-- |--SEARCH cats USING COVERING INDEX idx_cats_color (color=?)
-- |--SEARCH cat_toys USING INDEX idx_cat_toys_cat_id (cat_id=?)
-- `--SEARCH toys USING INTEGER PRIMARY KEY (rowid=?)
-- 215
-- Run Time: real 0.001 user 0.001017 sys 0.000000

-- Analyze Results:
-- Are you still getting the correct query results?
-- Yeah
-- Did the execution time improve (decrease)?
--Yeah, just a bit

-- Do you see any other opportunities for making this query more efficient?
-- No, Not yet!
---------------------------------
-- Notes From Further Exploration
---------------------------------
