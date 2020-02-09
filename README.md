
# Grammar::Parse

*Unstable API*

Library for build parsers for formal grammars.

## Use

    docker build -t parser .
    docker run -it --rm -u $(id -u) \
        -w /usr/src/bdd \
        -v $(pwd):/usr/src/bdd \
        parser example.feature
