curl -sL http://pipelinedb.com/data/wiki-pagecounts \
  | gunzip \
  | psql -h localhost -p 5432 -d pipeline \
      -c "COPY wiki_stream (hour, project, title, view_count, size) FROM STDIN"
