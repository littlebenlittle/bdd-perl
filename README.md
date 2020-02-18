
# BDD Testing

Parses a `.feature` file and runs associated step definitions.

## Use

### Running Feature Tests

The project you want to test needs to have structure similar to the following

```
.
└── features
    ├── example.feature
    └── step_definitions
        └── example.pl

```

To run the feature tests in `./features`, run the following from the root of the project

    docker run -it --rm -u $(id -u) \
        --workdir /work \
        --volume  $(pwd):/work \
        benlittle6/bdd-perl

### Running in "dev mode"

    docker run -it --rm -u $(id -u) \
        --workdir /work \
        --volume  $(pwd):/work \
        --volume  <path to bdd-perl>:/usr/src/bdd \
        benlittle6/bdd-perl

