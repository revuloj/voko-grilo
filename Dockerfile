FROM openjdk:jre-slim as builder

# Grilo

RUN apt-get update && apt-get install -y --no-install-recommends \
    maven \
        && rm -rf /var/lib/apt/lists/*

# ne necesa, se ni uzas maven...: apt install libjetty9-java libjing-java \

RUN useradd -ms /bin/bash -u 1099 grilo
USER grilo:users

# necesas forigi ./RngKtrl/target

ADD . /home/grilo/
WORKDIR /home/grilo

RUN mvn package && cp target/RngKtrl* ./ && ls

#COPY --chown=revo:users /ant /home/revo/voko/ant
#COPY --chown=revo:users /xsl /home/revo/voko/xsl
#COPY --chown=revo:users /cfg /home/revo/voko/cfg

# Nun kreu novan Docker-keston kun nur la kompilaĵo, sen fontoj, maven ktp.

FROM openjdk:jre-slim

RUN useradd -ms /bin/bash -u 1099 grilo
USER grilo:users

WORKDIR /home/grilo

COPY --from=builder /home/grilo/RngKtrl-1.0-SNAPSHOT.jar /home/grilo/grilo /home/grilo/
#ADD --chown=grilo:users ./grilo /home/grilo/

CMD ["bash","./grilo"]

