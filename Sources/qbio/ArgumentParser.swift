enum Argument {
    case help
    case artistValue(String)
    case unknown

    init(arg: String) {
        switch arg {
        case "--help", "-h":
            self = .help
        default:
            if arg.starts(with: "--") {
                self = .unknown
            } else {
                self = .artistValue(arg)
            }
        }
    }

    /// The value of an enum case.
    /// Values are guaranteed for
    /// `.artistValue`
    var value: String? {
        switch self {
        case .artistValue(let value):
            return value
        default:
            return nil
        }
    }
}

struct ArgumentParser {
    var parsedArguments: [Argument] {
        CommandLine.arguments[1...].map { arg in
            return Argument.init(arg: arg)
        }
    }
}
