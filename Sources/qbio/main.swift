import qbio_lib

let artistDataSource = AudioDBArtistDataSource()

executeArguments()

func executeArguments() {
    for arg in ArgumentParser().parsedArguments {
        switch arg {
        case .help:
            printUsage()
        default:
            continue
        }
    }
}

func printUsage() {
    print("USAGE")
    print(
        "\tqbio <artist to query>  -- Values with white space needs to be surrounded by quoutes (\")"
    )
    print("OPTIONS")
    print("\t--help -h\tPrints this manual")
}
