
# TCACalc

Welcome to TCACalc, an example of a calculator app implemented in [TCA](https://github.com/pointfreeco/swift-composable-architecture) (The Composable Architecture), with a calculation engine implemented as a [Finite State Machine](https://en.wikipedia.org/wiki/Finite-state_machine). 

![](https://github.com/DandyLyons/TCACalc/blob/main/TCACalc/README/RocketSim_Recording_iPhone_14_Pro_2023-09-12_15.38.38.gif?raw=true)

## Outdated Example
It should be noted that this example of TCA is outdated. Point free has since released newer versions and updates that improve upon this architecture. In particular, TCA now has support for native Swift observation, meaning the use of views like `ViewStore` is no longer necessary, and there are much easier ways to use TCA. For more information, have a look at the many valuable migration guides for TCA including: 

1. [Migrating to 1.4](https://swiftpackageindex.com/pointfreeco/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4): the `@Reducer` macro
2. [Migrating to 1.7](https://swiftpackageindex.com/pointfreeco/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.7): `@ObservableState` macro
3. [Migrating to 1.8](https://swiftpackageindex.com/pointfreeco/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.8): Simplify `@Reducer` macro. 

## Features

- Animated Text View
- Light/dark mode toggle
  - Introducing [Night Mode](https://github.com/DandyLyons/PlusNightMode): A black and red UI Appearance for better sleep. 

## Tech Stack 

- Architecture: TCA
  - I chose TCA because it is extremely easy to prototype, iterate, and test. Each TCA feature is composable because it only observes it's own state, and cannot accidentally mutate someone else's state. 
  - The calculation engine is also implemented in TCA, but with an atypical approach, a Finite State Machine. An FSM is a system that can only possibly be in one of a limited number of possible states, and can only transition from one state to another. 
- SwiftUI
- Modern Swift Concurrency
  - This app uses only modern concurrency tools such as async await. 

## Inspiration and Acknowledgements

- **Robert M. Vunabandi**
  - Part way through implementing the calculation engine, I discovered that the logic of calculators is far more complex than I initially suspected. I began to suspect that it might be modeled as an FSM. This led me to find Vunabandi's fantastic article [Designing A Calculator with FSM Logic](https://rvunabandi.medium.com/making-a-calculator-in-javascript-64193ea6a492) which is essentially reverse-engineering the calculator logic of Apple's Calculator app as an FSM. This article was absolutely vital to the implementation of TCACalc's calculation engine. 
- This [helpful discussion](https://forums.swift.org/t/tca-and-state-chart/50583) on how to implement an FSM in TCA. 
- David Khourshid - [Infinitely Better UIs with Finite Automata](https://www.youtube.com/watch?v=VU1NKX6Qkxc)


## Roadmap


- [x] Add [Night Mode](https://github.com/DandyLyons/PlusNightMode) 
- [ ] Add support for Widgets


## Feedback

Feedback is greatly appreciated. To share suggestions for improvement, please open an issue. 
