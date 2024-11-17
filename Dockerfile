# Use the official Neo4j image

FROM neo4j:5.25.1 as neo4j-import
 
# Set environment variables

ENV NEO4J_AUTH=neo4j/testtest
 
# Create necessary directories for Neo4j

RUN mkdir -p /data /import
 
# Copy import files (node.csv and relation.csv) into the image

COPY node.csv /import/node.csv

COPY relation.csv /import/relation.csv


 
# Run the database import command

RUN neo4j-admin database import full neo4j \

    --nodes=/import/node.csv \

    --relationships=/import/relation.csv
 
# Second stage for running Neo4j with the preloaded data

FROM neo4j:5.25.1
 
# Set environment variables

ENV NEO4J_AUTH=neo4j/testtest
 
# Use the preloaded database from the import stage

COPY --from=neo4j-import /data /data

COPY server-logs.xml /var/lib/neo4j/conf/server-logs.xml

COPY user-logs.xml /var/lib/neo4j/conf/server-logs.xml

COPY neo4j.conf /var/lib/neo4j/conf/neo4j.conf

 
# Expose Neo4j ports

EXPOSE 7474 7687
 
# Run Neo4j

CMD ["neo4j"]

 
