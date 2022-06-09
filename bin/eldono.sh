#!/bin/bash

# helpas krei eldonon kun ĝusta etikedo

# Tio estas la eldono de voko-grundo kontraŭ kiu ni kompilas ĉion
# ĝi devas ekzisti jam kiel git-tag (kaj sekve kiel kodarĥivo kaj procezujo) en Github
# en celo "preparo" ni metas tiun eldonon ankaŭ por dosiernomoj kc. de voko-araneo
# Ni ankaŭ supozas, ke nova eldono okazas en git-branĉo kun la sama nomo
# Ĉe publikigo marku la kodstaton per etikedo (git-tag) v${eldono}.
# Dum la realigo vi povas ŝovi la etikedon ĉiam per celo "etikedo".
eldono=2f

# ni komprenas preparo | etikedo | kreo
# kaj supozas ???, se nenio donita argumente
target="${1}"

case $target in

preparo)
    # kontrolu ĉu la branĉo kongruas kun la agordita versio
    branch=$(git symbolic-ref --short HEAD)
    if [ "${branch}" != "${eldono}" ]; then
        echo "Ne kongruas la branĉo (${branch}) kun la eldono (${eldono})"
        echo "Agordu la variablon 'eldono' en tiu ĉi skripto por prepari novan eldonon."
        exit 1
    fi

    #echo "Aktualigante skriptojn al nova eldono ${eldono}..."
    #sed -ri 's/ARG ([A-Z_]+)=[1-9][a-z]$/ARG \1='${eldono}'/' Dockerfile
    ;;
etikedo)
    echo "Provizante la aktualan staton per etikedo (git tag) v${eldono}"
    echo "kaj puŝante tiun staton al la centra deponejo"
    git tag -f v${eldono} && git push && git push --tags -f
    ;;
kreo)
    echo "Kreante lokan procezujon (por docker) voko-grilo"
    docker build --build-arg VG_TAG=v${eldono} --build-arg ZIP_SUFFIX=${eldono} -t voko-grilo .
    ;;
esac
