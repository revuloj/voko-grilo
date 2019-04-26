#### staĝo 1: por kompili ni bezonas maven kun ĝia stokejo de funkciaroj ktp...

FROM openjdk:jre-slim as builder
MAINTAINER <diestel@steloj.de>

# Grilo

RUN apt-get update && apt-get install -y --no-install-recommends \
    maven curl unzip \
        && rm -rf /var/lib/apt/lists/*

# ne necesa, se ni uzas maven...: apt install libjetty9-java libjing-java \

RUN curl -LO https://github.com/revuloj/voko-iloj/archive/master.zip \
  && unzip master.zip voko-iloj-master/dtd/* && rm master.zip 


RUN useradd -ms /bin/bash -u 1099 grilo
USER grilo:users

# necesas forigi ./RngKtrl/target

ADD . /home/grilo/
WORKDIR /home/grilo

RUN mvn package && cp target/RngKtrl* ./ && ls

#COPY --chown=revo:users /ant /home/revo/voko/ant
#COPY --chown=revo:users /xsl /home/revo/voko/xsl
#COPY --chown=revo:users /cfg /home/revo/voko/cfg

#### staĝo 2: Nun kreu novan procesumon kun nur la kompilaĵo, sen fontoj, maven ktp.

FROM openjdk:jre-slim
MAINTAINER <diestel@steloj.de>

RUN useradd -ms /bin/bash -u 1099 grilo

WORKDIR /home/grilo

COPY --from=builder /home/grilo/RngKtrl-1.0-SNAPSHOT.jar /home/grilo/grilo /home/grilo/
COPY --from=builder voko-iloj-master/dtd/ /home/grilo/grilo /home/grilo/voko/dtd/

#ADD --chown=grilo:users ./grilo /home/grilo/

USER grilo:users

CMD ["bash","./grilo"]

