psql -h localhost -p 5432 -d pipeline -c "
  CREATE CONTINUOUS VIEW wiki_stats AS
  SELECT hour::timestamp,
         project::text,
         count(*) AS total_pages,
         sum(view_count::bigint) AS total_views,
         min(view_count) AS min_views,
         max(view_count) AS max_views,
         avg(view_count) AS avg_views,
         percentile_cont(0.99) WITHIN GROUP (ORDER BY view_count) AS p99_views,
         sum(size::bigint) AS total_bytes_served
    FROM wiki_stream
    GROUP BY hour, project;"

