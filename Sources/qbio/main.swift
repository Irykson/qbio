import qbio_lib

let artistDataSource = AudioDBArtistDataSource()

executeArguments()

func executeArguments() {
    for arg in ArgumentParser().parsedArguments {
        switch arg {
        case .help:
            printUsage()
        case .artistValue:
            // Value is guaranteed for .artistValue and can safely accessed
            printBio(artist: arg.value!)
        default:
            continue
        }
    }
}

func printBio(artist: String) {
    print(artist)
    print("--------------------")
    print(artistDataSource.getBio(artist: artist))

    // print an empty line for better visual separation for multiple artists
    print()
}

func printUsage() {
    print("USAGE")
    print(
        "\tqbio <artist(s) to query>  -- Values with whitespace needs to be surrounded by quoutes (\"). Multiple artists can be queried by separating with whitespace"
    )
    print("OPTIONS")
    print("\t--help -h\tPrints this manual")
}
