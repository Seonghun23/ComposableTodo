//
//  AddTodoEnvirenment.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/27.
//

import Foundation

protocol AddTodoEnvirenmentType {
    func add(todo: String)
}

struct AddTodoEnvirenment: AddTodoEnvirenmentType {
    let todoManager: TodoStorable

    func add(todo: String) {
        todoManager.add(todo: todo)
    }
}
