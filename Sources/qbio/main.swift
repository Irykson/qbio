import qbio_lib

let artistDataSource = AudioDBArtistDataSource()

executeArguments()

func executeArguments() {
    do {
        for arg in ArgumentParser().parsedArguments {
            switch arg {
            case .help:
                printUsage()
            case .artistValue:
                // Value is guaranteed for .artistValue and can safely accessed
                try printBio(artist: arg.value!)
            default:
                continue
            }
        }
    } catch {
        print("An error occurred while executing the query. Please try again later.")
    }
}

func printBio(artist: String) throws {
    let bio = try artistDataSource.getBio(artist: artist)
    print(artist)
    print("--------------------")
    print(bio)

    // print an empty line for better visual separation for multiple artists
    print()
}

func printUsage() {
    print("USAGE")
    print(
        "\tqbio <artist(s) to query>  -- Values with whitespace needs to be surrounded by quotes (\"). Multiple artists can be queried by separating with whitespace"
    )
    print("OPTIONS")
    print("\t--help -h\tPrints this manual")
}
