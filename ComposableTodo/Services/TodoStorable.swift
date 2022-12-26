//
//  TodoStorable.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/28.
//

import Foundation
import Combine

protocol TodoStorable {
    func todos() async -> [Todo]
    func add(todo: String) async
    func save(todos: [Todo]) async
}
