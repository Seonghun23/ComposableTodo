//
//  TodoListTests.swift
//  ComposableTodoTests
//
//  Created by Sunny.K on 2021/01/28.
//

import XCTest
import ComposableArchitecture

@testable import ComposableTodo
final class TodoListTests: XCTestCase {
    var environment: MockTodoListEnvironment!

    override func setUpWithError() throws {
        environment = MockTodoListEnvironment()
    }

    override func tearDownWithError() throws {
        environment = nil
    }

    func test_whenStoreReceiveInitialize_thenLoadShouldCalled() {
        let store = TestStore(
            initialState: TodoListState(),
            reducer: updateTodoListReducer,
            environment: environment
        )
        environment.expectedLoad = Effect(value: [Todo(description: "reload")])

        store.assert(
            .send(.initialize),
            .receive(.reload(list: [Todo(description: "reload")])) { state in
                state.todoList = [Todo(description: "reload")]
            },
            .do { XCTAssertEqual(self.environment.isLoadCalled, true) }
        )
    }

    func test_whenStoreReceiveToggle_thenSaveShouldCalled() {
        let store = TestStore(
            initialState: TodoListState(
                todoList: [Todo(description: "test")]
            ),
            reducer: updateTodoListReducer,
            environment: environment
        )

        store.assert(
            .send(.toggle(index: 0)),
            .do() { XCTAssertEqual(self.environment.isSaveCalled, true) }
        )
    }

    func test_whenStoreReceiveToggleAddTodoPresent_thenIsAddTodoPresentedShouldBeToggled() {
        let store = TestStore(
            initialState: TodoListState(),
            reducer: updateTodoListReducer,
            environment: environment
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
            environment: environment
        )

        store.assert(
            .send(.reload(list: [Todo(description: "test")])) { state in
                state.todoList = [Todo(description: "test")]
            }
        )
    }
}
