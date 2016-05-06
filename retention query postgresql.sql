--see how 1 to 30 day retention changes over time

SELECT
  date_trunc('day', t1.timestamp) AS day,
  count(distinct t2.uniqueId) AS #retained,
  count(distinct t1.uniqueId) AS total,
  round(100 * count(distinct t2.uniqueId) /
    count(distinct t1.uniqueId)) AS retention%
 FROM yourTable AS t1
  LEFT JOIN yourTable AS t2 ON
    t1.uniqueId = t2.uniqueId
    AND t2.timestamp BETWEEN
    t1.timestamp + interval '1 day' AND t1.timestamp + interval '30 days' 
    	-- does user come back 1 day to 30 days after the first visit?
    WHERE date(t1.timestamp) < current_date - interval '30 days'
    	-- you can't count timestamps too close to today's date, 
    	-- because there is incomplete retention data
	AND t1.column2 LIKE '%xample%' -- add other constraints here
GROUP BY 1
ORDER BY 1;