#### staĝo 1: certigu, ke vi antaŭe kompilis voko-grundo aŭ ŝargis de Github kiel pakaĵo
ARG VERSION=latest
FROM ghcr.io/revuloj/voko-grundo/voko-grundo:${VERSION} as grundo

#### staĝo 2: por kompili ni bezonas maven kun ĝia stokejo de funkciaroj ktp...
FROM debian:stable-slim as builder
LABEL maintainer <diestel@steloj.de>

# la variablon oni povas ŝanĝi ankaŭ per komandlinio, ekz-e --build-arg VG_TAG=v1e
#ARG VG_TAG=master
# por etikedoj kun nomo vXXX estas la problemo, ke GH en la ZIP-nomo kaj dosierujo forprenas la "v"
# do se VG_TAG estas "v1e", ZIP_SUFFIX estu "1e"
# la variablon oni povas ŝanĝi ankaŭ per komandlinio --build-arg VG_TAG=...
#ARG ZIP_SUFFIX=master


RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates-java openjdk-17-jre  \
    && rm -rf /var/lib/apt/lists/* 

WORKDIR /tmp
ADD . .
COPY --from=grundo build/dtd/ dtd/

# Grilo
RUN apt-get update && apt-get install -y --no-install-recommends \
    maven curl unzip \
        && rm -rf /var/lib/apt/lists/* \
# tio ne necesa, se ni uzas maven...: 
# RUN apt install libjetty9-java libjing-java \
# RUN curl -LO https://github.com/revuloj/voko-grundo/archive/${VG_TAG}.zip \
#  && unzip ${VG_TAG}.zip voko-grundo-${ZIP_SUFFIX}/dtd/* && rm ${VG_TAG}.zip \
#  && cp voko-grundo-${ZIP_SUFFIX}/dtd/vokoxml.rnc src/main/resources/ \
  && cp dtd/vokoxml.rnc src/main/resources/ \
  && mvn package && cp target/RngKtrl* ./ && ls

#### staĝo 2: Nun kreu novan procesumon kun nur la kompilaĵo, sen fontoj, maven ktp.

FROM debian:stable-slim 
LABEL maintainer <diestel@steloj.de>

#ARG ZIP_SUFFIX

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates-java openjdk-17-jre  \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -ms /bin/bash -u 1099 grilo

WORKDIR /home/grilo

COPY --from=builder /tmp/RngKtrl-1.0-SNAPSHOT.jar /tmp/grilo /home/grilo/
COPY --from=grundo build/dtd/ /home/grilo/voko/dtd/

# COPY --from=builder /voko-grundo-${ZIP_SUFFIX}/dtd/ /home/grilo/voko/dtd/

#ADD --chown=grilo:users ./grilo /home/grilo/

USER grilo:users

CMD ["bash","./grilo"]

