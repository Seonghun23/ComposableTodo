//
//  AddTodoReducer.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/27.
//

import Foundation
import ComposableArchitecture

let addTodoReducer = Reducer<AddTodoState, AddTodoAction, AddTodoEnvirenment> { state, action, environment in
  switch action {
  case .addTodo(let todo):
    environment.add(todo: todo)
    return Effect(value: .dismiss)
  
  case .dismiss:
    state.isAddTodoDismissed = true
    return .none
  }
}
