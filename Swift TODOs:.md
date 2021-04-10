Swift TODOs:

## Design by Contract

- use documentation (e.g. precondition, postcondition)
- maybe implement a Contract System like C# does:

```swift
enum ConditionError : Error {
     case notMet
}

func requires(condition: Bool) throws {
    if (!condition) {
        throw ConditionError.notMet;
    }
}
```

## Uniform access principle
- realization (not strictly) in swift via properties