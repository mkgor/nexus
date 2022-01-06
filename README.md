![test coverage](https://img.shields.io/badge/coverage-95.5%25-green)
![test results](https://img.shields.io/badge/tests-16%20passed%2C%200%20failed-green)

# Nexus 🚀

**Nexus** is a state management library that makes it easy to create and consume your application's reactive data to the user interface. With **nexus_codegen**, wiring becoming fully automatic and feels very natural. As an application developer, you focus solely on what reactive data should be consumed in the UI (and elsewhere) without worrying about keeping it in sync.

## Roadmap table

| Goal | Completed |
|---|---|
| Reactive variables  | ✅ |
| Reactions | ✅  | 
| Synchronous actions | ✅  |
| Asynchronous actions |  ✅ |
| Reactions |  ✅ |
| Lifecycle hooks |  ✅ |
| Reactive collections (list, set, map) |  ✅ |
| Custom reactive objects |  ✅ |
| Access to context from state |  ✅ |
| Processable controller and widget (contains reactive content state) |  ✅ |
| Global state's stream (tracks all lifecycle of states) | ✅ |
| Mutators | ✅ |
| Guards | ✅ |
| Unit-tests | ✅ |
| Documentation | ✅ |
| Final refactoring | WIP |

## Quickstart

States in Nexus can be really simple and elegant
![Tiny state](https://i.imgur.com/U2u9sPT.png)

But it is not fully reactive state, we call update() manually when updating counter, but what if we add some **annotations**?
![Annotations](https://i.imgur.com/KFILTpJ.png)
## Global event bus

Nexus are tracking all controllers and can notify you, when something happens via global event bus

It supports next events:

* EventType.stateInitialized
* EventType.stateUpdated
* EventType.stateDisposed
* EventType.reactionRegistered
* EventType.reactionInitiated
* EventType.reactionRemoved
* EventType.performedAction
* EventType.performedAsyncAction

All events' payloads contain **stateId** - unique identifier of NexusController (you can pass it manually by invoking super constructor of controller)
