enum Arguments {
    case help
    case artistValue
    case unknown

    init(arg: String) {
        switch arg {
        case "--help", "-h":
            self = .help
        default:
            self = .unknown
        }
    }
}

struct ArgumentParser {
    var parsedArguments: [Arguments] {
        CommandLine.arguments[1...].map { arg in
            return Arguments.init(arg: arg)
        }
    }
}
