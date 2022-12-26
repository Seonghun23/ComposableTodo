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
    }
    
    struct State: Equatable {
        var todoList: [Todo] = []
        var isAddTodoPresented = false
    }
    
    @Dependency(\.todoManager) var todoManager
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .toggle(let index):
                var todos = state.todoList
                todos[index].done.toggle()
                return .task { [todos] in
                    await todoManager.save(todos: todos)
                    return .reload(list: todos)
                }
                .cancellable(id: CancelID.self)
                
            case .initialize:
                return .task {
                    let todos = await todoManager.todos()
                    return .reload(list: todos)
                }
                .cancellable(id: CancelID.self)
                
            case .reload(let list):
                state.todoList = list
                return .none
                
            case .toggleAddTodoPresent:
                state.isAddTodoPresented.toggle()
                return .none
            }
        }
    }
    
    private enum CancelID {}
}
