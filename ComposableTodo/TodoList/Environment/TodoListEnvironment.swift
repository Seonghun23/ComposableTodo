//
//  TodoListEnvironment.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/26.
//

import Foundation
import Combine
import ComposableArchitecture

struct TodoListEnvironment {
    let todoManager: TodoStorable
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

enum CodableError: Error {
    case unknown
    case noData
}
