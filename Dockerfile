FROM python:3.7-alpine3.9

RUN apk add --no-cache curl perl bash docker jq

RUN pip install awscli
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/bin/kubectl

ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]
