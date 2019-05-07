FROM xales/byond:512-latest

ARG BUILD_ARGS
ENV RUNAS=root

COPY . /m13

WORKDIR /m13

RUN apt-get update && apt-get install -y gosu
RUN scripts/dm.sh $BUILD_ARGS metro13.dme

EXPOSE 8000
VOLUME /m13/data
VOLUME /m13/config

ENTRYPOINT ["./docker-entrypoint.sh"]
