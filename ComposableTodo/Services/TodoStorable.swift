//
//  TodoStorable.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/28.
//

import Foundation
import Combine

protocol TodoStorable {
    var todoPublisher: Published<[Todo]>.Publisher { get }

    func add(todo: String)
    func save(todos: [Todo])
}
