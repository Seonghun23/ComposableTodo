//
//  TodoListAction.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/26.
//

import Foundation

enum TodoListAction {
    case toggle(index: Int)
    case addTodo
    case reload(list: [Todo])
    case initialize
}
