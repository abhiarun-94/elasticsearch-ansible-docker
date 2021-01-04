FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt-get install curl -y &&  \
    apt-get install gnupg -y && \
    apt install default-jre -y && apt install default-jdk -y && \
    curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list && \
    apt update -y && apt install elasticsearch -y


 WORKDIR /usr/share/elasticsearch

RUN set -ex && for path in data logs config config/scripts; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch "$path"; \
    done


COPY logging.yml /etc/elasticsearch/
COPY elasticsearch.yml /etc/elasticsearch/
COPY javaconf /etc/elasticsearch/
RUN chown -R elasticsearch:elasticsearch /usr/share/elasticsearch

USER elasticsearch

ENV PATH=$PATH:/usr/share/elasticsearch/bin

CMD ["elasticsearch"]

EXPOSE 9200

