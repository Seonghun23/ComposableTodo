//
//  TodoListReducer.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/26.
//

import ComposableArchitecture

enum Cancellable {
    static let initializeID = 10
}

let updateTodoListReducer = Reducer<TodoListState, TodoListAction, TodoEnvironment>
{ state, action, environment in

    switch action {
    case .toggle(let index):
        var todos = state.todoList
        todos[index].isDone.toggle()
        environment.todoManager.save(todos: todos)
        return .none

    case .initialize:
        return Effect(
            environment.todoManager.todoPublisher
                .subscribe(on: environment.globalQueue)
        )
        .cancellable(id: Cancellable.initializeID)
        .map(TodoListAction.reload)

    case .deinitialize:
        return  .cancel(id: Cancellable.initializeID)

    case .reload(let list):
        state.todoList = list
        return .none

    case .toggleAddTodoPresent:
        state.isAddTodoPresented = !state.isAddTodoPresented
        return .none
    }
}

let printTodoListLogReducer = Reducer<TodoListState, TodoListAction, TodoEnvironment>
{ state, action, environment in
    switch action {
    case .toggle(let index):
        print("toggle at: \(index)")
        return .none

    case .initialize:
        print("initialize")
        return .none
    case .deinitialize:
        print("deinitialize")
        return .none

    case .reload(let list):
        print("reload")
        return .none

    case .toggleAddTodoPresent:
        print("toggleAddTodoPresent")
        return .none
    }
}

let todoListReducer: Reducer<TodoListState, TodoListAction, TodoEnvironment>
    = .combine([
        updateTodoListReducer,
        printTodoListLogReducer
    ])
