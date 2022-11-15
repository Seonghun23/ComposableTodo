//
//  TodoListTests.swift
//  ComposableTodoTests
//
//  Created by Sunny.K on 2021/01/28.
//

import Foundation
import XCTest
import ComposableArchitecture

@testable import ComposableTodo

@MainActor
final class TodoListTests: XCTestCase {
    var todoManager: MockTodoManager!

    override func setUpWithError() throws {
        todoManager = MockTodoManager()
    }

    override func tearDownWithError() throws {
        todoManager = nil
    }

    func test_whenStoreReceiveInitialize_thenLoadShouldCalled() async {
        let store = TestStore(
            initialState: .init(),
            reducer: TodoListReducer(todoManager: todoManager)
        )
        
        todoManager.todos = [Todo(description: "initialize")]
        await store.send(.initialize)
        await store.receive(.reload(list: [Todo(description: "initialize")])) { state in
            state.todoList = [Todo(description: "initialize")]
        }
    
        todoManager.todos = [Todo(description: "reload")]
        await store.receive(.reload(list: [Todo(description: "reload")])) { state in
            state.todoList = [Todo(description: "reload")]
        }
        
        await store.send(.deinitialize)
    }

    func test_whenStoreReceiveToggle_thenSaveShouldCalled() async {
        let store = TestStore(
            initialState: .init(
                todoList: [Todo(description: "test")]
            ),
            reducer: TodoListReducer(todoManager: todoManager)
        )
        await store.send(.toggle(index: 0))
        XCTAssertEqual(todoManager.isSaveCalled, true)
    }

    func test_whenStoreReceiveToggleAddTodoPresent_thenIsAddTodoPresentedShouldBeToggled() async {
        let store = TestStore(
            initialState: .init(),
            reducer: TodoListReducer(todoManager: todoManager)
        )

        await store.send(.toggleAddTodoPresent) { state in
            state.isAddTodoPresented = true
        }
        await store.send(.toggleAddTodoPresent) { state in
            state.isAddTodoPresented = false
        }
    }

    func test_whenStoreReceiveReload_thenTodoListShouldBeUpdated() async {
        let store = TestStore(
            initialState: .init(),
            reducer: TodoListReducer(todoManager: todoManager)
        )

        await store.send(.reload(list: [Todo(description: "test")])) { state in
            state.todoList = [Todo(description: "test")]
        }
    }
}
