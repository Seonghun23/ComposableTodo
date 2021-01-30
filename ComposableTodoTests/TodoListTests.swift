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
final class TodoListTests: XCTestCase {
    var todoManager: MockTodoManager!
    var scheduler = DispatchQueue.testScheduler

    override func setUpWithError() throws {
        todoManager = MockTodoManager()
    }

    override func tearDownWithError() throws {
        todoManager = nil
    }

    func test_whenStoreReceiveInitialize_thenLoadShouldCalled() {
        let store = TestStore(
            initialState: TodoListState(),
            reducer: updateTodoListReducer,
            environment: TodoListEnvironment(
                todoManager: todoManager,
                globalQueue: scheduler.eraseToAnyScheduler()
            )
        )



        store.assert(
            .send(.initialize),
            .do { self.scheduler.advance() },
            .receive(.reload(list: [])) { state in
                state.todoList = []
            },
            .do { self.todoManager.todos = [Todo(description: "reload")] },
            .receive(.reload(list: [Todo(description: "reload")])) { state in
                state.todoList = [Todo(description: "reload")]
            },
            .send(.deinitialize)
        )
    }

    func test_whenStoreReceiveToggle_thenSaveShouldCalled() {
        let store = TestStore(
            initialState: TodoListState(
                todoList: [Todo(description: "test")]
            ),
            reducer: updateTodoListReducer,
            environment: TodoListEnvironment(
                todoManager: todoManager,
                globalQueue: scheduler.eraseToAnyScheduler()
            )
        )

        store.assert(
            .send(.toggle(index: 0)),
            .do() { XCTAssertEqual(self.todoManager.isSaveCalled, true) }
        )
    }

    func test_whenStoreReceiveToggleAddTodoPresent_thenIsAddTodoPresentedShouldBeToggled() {
        let store = TestStore(
            initialState: TodoListState(),
            reducer: updateTodoListReducer,
            environment: TodoListEnvironment(
                todoManager: todoManager,
                globalQueue: scheduler.eraseToAnyScheduler()
            )
        )

        store.assert(
            .send(.toggleAddTodoPresent) { state in
                state.isAddTodoPresented = true
            },
            .send(.toggleAddTodoPresent) { state in
                state.isAddTodoPresented = false
            }
        )
    }

    func test_whenStoreReceiveReload_thenTodoListShouldBeUpdated() {
        let store = TestStore(
            initialState: TodoListState(),
            reducer: updateTodoListReducer,
            environment: TodoListEnvironment(
                todoManager: todoManager,
                globalQueue: scheduler.eraseToAnyScheduler()
            )
        )

        store.assert(
            .send(.reload(list: [Todo(description: "test")])) { state in
                state.todoList = [Todo(description: "test")]
            }
        )
    }
}
