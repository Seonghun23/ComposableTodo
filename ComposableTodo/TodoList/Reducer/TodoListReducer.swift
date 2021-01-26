//
//  TodoListReducer.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/26.
//

import ComposableArchitecture

let todoListReducer = Reducer<TodoListState, TodoListAction, TodoListEnvironment> { state, action, environment in
  switch action {
  case .toggle(let index):
    var list = state.todoList
    list[index].isDone.toggle()
    return environment.save(list)
        .map(TodoListAction.reload)

  case .initialize:
      return environment.load()
        .catchToEffect()
        .map { result -> [Todo] in
            switch result {
            case .success(let todo):
                return todo
            case .failure(let error):
                return []
            }
        }
          .map(TodoListAction.reload)

  case .reload(let list):
    state.todoList = list
    return .none

  case .toggleAddTodoPresent:
    state.isAddTodoPresented = !state.isAddTodoPresented
    return .none
  }
}
