//
//  AddTodoState.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/27.
//

import Foundation

struct AddTodoState: Equatable {
    var addTodo: String?
    var isAddTodoDismissed = false
}
