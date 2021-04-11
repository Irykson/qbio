# qbio

This project is a simple utility to query the biography of any artist. It's meant to showcase basic functionalities and some design principles applied with Swift.
To showcase these, some implementations are a bit overkill for this kind of application and arguably violate the KISS principle.

Three principles are showcased in particular. A detailed description of these can be found [here](Documentation/DesignPrinciples.md).

## Project structure

The project consists out of two products (to use the Swift Package Manager terminology):
 - **qbio-lib**\
    type=library: Implementation of querying the data.
 - **qbio**\
    type=executable: Simple CLI application that uses qbio-lib for querying the data.

### qbio-lib
The library provides a protocol `ArtistDataSource` that can be used to implement custom logic and data sources but with an abstract API.
`AudioDBArtistDataSource` is an example implementation that uses [The AudioDB](https://theaudiodb.com/) via an HTTP-API as the data source.

### qbio
The executable uses qbio-lib to query the biography of one or more artists passed by the user.
It's using [ArgumentParser](https://github.com/apple/swift-argument-parser) by Apple to parse and execute the arguments and options passed by the user.
