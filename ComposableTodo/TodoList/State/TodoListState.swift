//
//  TodoListState.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/26.
//

import Foundation

struct TodoListState: Equatable {
    var todoList: [Todo] = []
    var isAddTodoPresented = false
}
