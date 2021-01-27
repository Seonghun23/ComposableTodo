//
//  TodoListReducer.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/26.
//

import ComposableArchitecture


let updateTodoListReducer = Reducer<TodoListState, TodoListAction, TodoListEnvironment> { state, action, environment in
    switch action {
    case .addTodo(let description):
        let todo = Todo(description: description)
        state.todoList.append(todo)
        return environment.save(state.todoList)
            .map(TodoListAction.reload)

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

let printTodoListLogReducer = Reducer<TodoListState, TodoListAction, TodoListEnvironment> { state, action, environment in
    switch action {
    case .addTodo(let description):
        print("addTodo: \(description)")
        return .none
    case .toggle(let index):
        print("toggle at: \(index)")
        return .none

    case .initialize:
        print("initialize")
        return .none

    case .reload(let list):
        print("reload")
        return .none

    case .toggleAddTodoPresent:
        print("toggleAddTodoPresent")
        return .none
    }
  }

let todoListReducer: Reducer<TodoListState, TodoListAction, TodoListEnvironment> = .combine([
    updateTodoListReducer,
    printTodoListLogReducer
])