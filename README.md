# Nexus :rocket:

**Nexus** is a state management library that makes it easy to create and consume your application's reactive data to the user interface. With **nexus_codegen**, wiring becoming fully automatic and feels very natural. As an application developer, you focus solely on what reactive data should be consumed in the UI (and elsewhere) without worrying about keeping it in sync.

## Roadmap table

| Goal | Completed |
|---|---|
| Reactive variables  | :white_check_mark: |
| Reactions | :white_check_mark:  | 
| Synchronous actions | :white_check_mark:  |
| Asynchronous actions |  :white_check_mark: |
| Reactions |  :white_check_mark: |
| Lifecycle hooks |  :white_check_mark: |
| Reactive collections (list, set, map) |  :white_check_mark: |
| Custom reactive objects |  :white_check_mark: |
| Access to context from state |  :white_check_mark: |
| Processable controller and widget (contains reactive content state) |  :white_check_mark: |
| Global state's stream (tracks all lifecycle of states) | :white_check_mark: |
| Unit-tests | |
| Saving and restoring state from cache |  |

## Quickstart

States in Nexus can be really simple and elegant
![Tiny state](https://i.imgur.com/U2u9sPT.png)

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
