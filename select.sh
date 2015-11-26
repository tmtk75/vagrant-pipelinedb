psql -h localhost -p 5432 -d pipeline \
  -c "SELECT * FROM wiki_stats ORDER BY total_views DESC";
