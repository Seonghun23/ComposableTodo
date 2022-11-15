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

struct TodoListReducer: ReducerProtocol {
    enum Action: Equatable {
        case toggle(index: Int)
        case toggleAddTodoPresent
        case reload(list: [Todo])
        case initialize
        case deinitialize
    }
    
    struct State: Equatable {
        var todoList: [Todo] = []
        var isAddTodoPresented = false
    }

    init(todoManager: TodoStorable) {
        self.todoManager = todoManager
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .toggle(let index):
            var todos = state.todoList
            todos[index].isDone.toggle()
            todoManager.save(todos: todos)
            return .none

        case .initialize:
            return Effect(todoManager.todoPublisher)
                .cancellable(id: Cancellable.initializeID)
                .map(Action.reload)

        case .deinitialize:
            return .cancel(id: Cancellable.initializeID)

        case .reload(let list):
            state.todoList = list
            return .none

        case .toggleAddTodoPresent:
            state.isAddTodoPresented = !state.isAddTodoPresented
            return .none
        }
    }
    
    private let todoManager: TodoStorable
}
