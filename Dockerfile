FROM alpine:3.4

RUN apk -U add ca-certificates python python-dev py-pip build-base && \
    pip install locustio pyzmq && \
    apk del python-dev && \
    rm -r /var/cache/apk/* && \
    mkdir /locust

WORKDIR /locust

ADD . /locust
RUN test -f requirements.txt && pip install -r requirements.txt; exit 0

EXPOSE 8089 5557 5558
ENTRYPOINT [ "/usr/bin/locust" ]
