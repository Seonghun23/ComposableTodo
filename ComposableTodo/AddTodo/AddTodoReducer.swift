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
    
    init(todoManager: TodoStorable) {
        self.todoManager = todoManager
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .addTodo(let todo):
          todoManager.add(todo: todo)
          return Effect(value: .dismiss)
        
        case .dismiss:
          state.isAddTodoDismissed = true
          return .none
        }
    }
    
    private let todoManager: TodoStorable
}
