//
//  AddTodoReducer.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/27.
//

import Foundation
import ComposableArchitecture

struct AddTodoReducer: ReducerProtocol {
    enum Action: Equatable {
        case addTodo(String)
        case dismiss
    }
    
    struct State: Equatable {
        var addTodo: String?
        var isAddTodoDismissed = false
    }
    
    @Dependency(\.todoManager) var todoManager
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .addTodo(let todo):
                return .task {
                    await todoManager.add(todo: todo)
                    return .dismiss
                }
                
            case .dismiss:
              state.isAddTodoDismissed = true
              return .none
            }
        }
    }
}
