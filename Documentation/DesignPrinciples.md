# Design Principles

This project is meant to showcase some design principles in how to use them to increase the maintainability. In particular these three will be discussed:

-   Design By Contract
-   Uniform Access Principle
-   Stable Abstraction Principle

Here I will explain briefly what each of these mean. After this, I'll give an answer for how these principles are applied in this project.

## Design By Contract

Design by contract (or DbC) defines a contract for a method / function. It consists of

-   precondition - Which conditions must be met, before a function can be called
-   postcondition - Which conditions must be met, after a function was executed
-   invariant - Defines a state or a property, that will never change

### Why to use it

-   makes the system predictable and thus easier to use
-   Changes to the inner workings don't change the contract. Consumers of the function will continue to work in a predictable way

### How to use it in Swift / in this project

Some languages (by no means all) implement DbC. The best example (it's the inventor of this principle) would be Eiffel. Another language / framework is C# with .NET.
Swift on the other hand implements a "weak" DbC with it's type system and some other constructs.

**For this project I've seen two options to implement DbC:**

1. Implement runtime checks similar to [C# Code Contract](https://docs.microsoft.com/de-de/dotnet/framework/debug-trace-profile/code-contracts)\
   **Benefits**

    - It can simulate DbC

    **Drawbacks**

    - it's not a true DbC since it relies on runtime checks
    - it would mean a custom solution to a publicly known problem (e.g. reinvent the wheel)
    - no efficient way to guarantee the invariant

2. Just rely on the Swift language\
   **Benefits**

    - You can rely on public knowledge and don't reinvent the wheel
    - Many postconditions can already be ensured via the type system (especially Optional / non-Optionals)
    - Swift has a built in `guard`-expression for a semantically clear way to define preconditions

    **Drawbacks**

    - Other than the type system and invariant via access control and encapsulation, all preconditions are runtime checks.
    - postconditions are not considered by Swift (other than e.g. you have to / not have to return a value)

**Option 2** is used here because of another principle [KISS](https://en.wikipedia.org/wiki/KISS_principle). In my opinion Option 2 is _good enough_ while not adding much complexity and builds upon other best practices like encapsulation and defensive programming. Option 1 would overcomplicate things for a minimal benefit.

## Uniform Access Principle

In simple terms, this principle defines that there should not be a syntactical difference between working with an attribute, computed property or a function of an object.

### Why use it

-   if later you see, that you need to change the implementation of an attribute, you don't need to change existing code, where the attribute was used
-   less cognitive overhead while reading the code (controversial, but objectively cleaner code since it's less code)
-   less to type (programmers are "lazy" :) )

### How to use it in Swift / in this project

Swift doesn't support this principle for functions with more than one parameter. Thus this principle cannot be followed 100% from a technical point of view.
But there is another point, why I don't want to follow it blindly. An good example is the central function in this project. This could be implemented via a property:

```Swift
// Setter initializes querying the data
artistDataSource.bioOfArtist = "Slipknot" // 1

// Getter reads the queried data from an internal state
print(artistDataSource.bioOfArtist) // 2
```

This approach would have multiple drawbacks:

1. Here are a few things not obvious to the user.
    - Without looking into the implementation / documentation it's not very clear, what happens behind the scene
    - The user can think, that this simply sets a value. But in reality this operation is relatively expensive
2. The setter could be implemented asynchronous. In this case the value read here would most definitely be invalid since it's not set yet.

To summarize: The Uniform Access Principle is followed, where it's reasonable, e.g. simple / efficient computations. 

## Stable Abstraction Principle
This principle promotes the Opened-Closed-Principle (the **O** in SOLID)