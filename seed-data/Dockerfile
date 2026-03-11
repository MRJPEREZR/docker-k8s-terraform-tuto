FROM python:3.9-slim

WORKDIR /app
COPY make-data.py ./make-data.py
RUN python make-data.py

RUN apt-get update && \
    apt-get install apache2-utils -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY generate-votes.sh ./generate-votes.sh
RUN chmod +x generate-votes.sh

CMD ["./generate-votes.sh" ]