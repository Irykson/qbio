# Design Principles

This project is meant to showcase some design principles in how to use them to increase the maintainability. In particular these three will be discussed:

-   Design By Contract
-   Uniform Access Principle
-   Stable Abstraction Principle

Here I will explain briefly what each of these mean. After this, I'll give an answer for how these principles are applied in this project.

## Design By Contract

Design by contract (or DbC) defines a contract for a method or function. It consists of

-   precondition - Which conditions must be met, before a function can be called
-   postcondition - Which conditions must be met, after a function was executed
-   invariant - Defines a state or a property, that will never change

### Why to use it

-   makes the system predictable and thus easier to use
-   Changes to the inner workings don't change the contract. Consumers of the function will continue to work in a predictable way

### How to use it in Swift / in this project

Some languages (by no means all) implement DbC. The best example (it's the inventor of this principle) would be Eiffel. Another language / framework is C# with .NET.
Swift on the other hand implements a "weak" DbC with it's type system and some other constructs.
For this project I've seen two options to implement DbC:

1. Implement runtime checks similar to [C#](https://docs.microsoft.com/de-de/dotnet/framework/debug-trace-profile/code-contracts)\
   **Drawbacks**
    - it's not a true DbC since it relies on runtime checks
    - it would mean a custom solution to a publicly known problem (e.g. reinvent the wheel)
    - no efficient way to guarantee the invariant
2. Just rely on the Swift language\
   **Benefits**
    - You can rely on public knowledge and don't reinvent the wheel
    - Many postconditions can already be ensured via the type system (especially Optional / non-Optionals)
    - Swift has a built in `guard`-expression for a semantically clear way to define postconditions
      **Drawbacks**
    - other than the type system, all postconditions are runtime checks
