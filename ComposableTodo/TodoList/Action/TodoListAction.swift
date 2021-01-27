//
//  TodoListAction.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/26.
//

import Foundation

enum TodoListAction {
    case addTodo(String)
    case toggle(index: Int)
    case toggleAddTodoPresent
    case reload(list: [Todo])
    case initialize
}