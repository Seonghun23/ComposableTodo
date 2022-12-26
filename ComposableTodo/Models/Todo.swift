//
//  Todo.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/24.
//

import Foundation

struct Todo: Equatable, Codable {
    let description: String
    var done: Bool = false
}
