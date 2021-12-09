#### staĝo 1: por kompili ni bezonas maven kun ĝia stokejo de funkciaroj ktp...

FROM openjdk:jre-slim as builder
LABEL maintainer <diestel@steloj.de>

# Grilo

RUN apt-get update && apt-get install -y --no-install-recommends \
    maven curl unzip \
        && rm -rf /var/lib/apt/lists/*
# tio ne necesa, se ni uzas maven...: 
# RUN apt install libjetty9-java libjing-java \

ADD . .

RUN curl -LO https://github.com/revuloj/voko-grundo/archive/master.zip \
  && unzip master.zip voko-grundo-master/dtd/* && rm master.zip \
  && cp voko-grundo-master/dtd/vokoxml.rnc src/main/resources/ \
  && mvn package && cp target/RngKtrl* ./ && ls

#### staĝo 2: Nun kreu novan procesumon kun nur la kompilaĵo, sen fontoj, maven ktp.

FROM openjdk:jre-slim
LABEL maintainer <diestel@steloj.de>

RUN useradd -ms /bin/bash -u 1099 grilo

WORKDIR /home/grilo

COPY --from=builder /RngKtrl-1.0-SNAPSHOT.jar /grilo /home/grilo/
COPY --from=builder /voko-grundo-master/dtd/ /home/grilo/voko/dtd/

#ADD --chown=grilo:users ./grilo /home/grilo/

USER grilo:users

CMD ["bash","./grilo"]

