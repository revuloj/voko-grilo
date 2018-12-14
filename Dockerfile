FROM openjdk:jre-slim

# Grilo

RUN apt-get update && apt-get install -y --no-install-recommends \
    maven \
        && rm -rf /var/lib/apt/lists/*

# ne necesa, se ni uzas maven...: apt install libjetty9-java libjing-java \

RUN useradd -ms /bin/bash -u 1099 grilo
USER grilo:users

# necesas forigi ./RngKtrl/target

ADD . /home/grilo/
RUN cd /home/grilo/ && mvn package && mvn dependency:build-classpath

#COPY --chown=revo:users /ant /home/revo/voko/ant
#COPY --chown=revo:users /xsl /home/revo/voko/xsl
#COPY --chown=revo:users /cfg /home/revo/voko/cfg
