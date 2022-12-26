//
//  Dependency+TodoManager.swift
//  ComposableTodo
//
//  Created by Seonghun Kim on 2022/12/26.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
  var todoManager: TodoStorable {
    get { self[TodoManager.self] }
    set { self[TodoManager.self] = newValue }
  }
    
    enum TodoManager: DependencyKey {
        static let liveValue: TodoStorable = ComposableTodo.TodoManager.shared
        static let previewValue: TodoStorable = ComposableTodo.TodoManager.shared
        static let testValue: TodoStorable = ComposableTodo.TodoManager.shared
    }
}
