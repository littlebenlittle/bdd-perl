
# BDD Testing

Parses a `.feature` file and runs associated step definitions.

## Use

    docker run -it --rm -u $(id -u) \
        -w /usr/src/bdd \
        -v $(pwd):/usr/src/bdd \
        benlittle6/bdd-perl <your feature file>

