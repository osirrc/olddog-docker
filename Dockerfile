FROM openjdk:8-stretch

EXPOSE 50000

RUN apt -y update
RUN apt -qq -y install python3 apt-transport-https

RUN echo "deb https://dev.monetdb.org/downloads/deb/ stretch monetdb\ndeb-src https://dev.monetdb.org/downloads/deb/ stretch monetdb" > /etc/apt/sources.list.d/monetdb.list

RUN wget --output-document=- https://www.monetdb.org/downloads/MonetDB-GPG-KEY | apt-key add -
RUN apt -y update

RUN apt -qq -y install monetdb5-sql monetdb-client

# Copy scripts into place
COPY init init
COPY index index
COPY interact interact
COPY search search

# Set working directory
WORKDIR /work
