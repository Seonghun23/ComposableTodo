//
//  TodoListViewController.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/24.
//

import UIKit
import Combine
import ComposableArchitecture

final class TodoListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var cancellables = Set<AnyCancellable>()

    private let viewStore: ViewStore<TodoListState, TodoListAction>

    init(store: Store<TodoListState, TodoListAction>) {
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setLayout()
        
        let baritem = UIBarButtonItem(systemItem: .add)
        baritem.primaryAction = UIAction(handler: { [weak self] _ in
            self?.viewStore.send(.toggleAddTodoPresent)
        })
        self.navigationItem.rightBarButtonItem  = baritem

        viewStore.send(.initialize)

        viewStore.publisher
            .map(\.todoList)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)

        viewStore.publisher
            .map(\.isAddTodoPresented)
            .removeDuplicates()
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.presentAddTodo()
            })
            .store(in: &cancellables)
    }

    private func setLayout() {
        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func presentAddTodo() {

        let store = Store(
            initialState: AddTodoState(),
            reducer: addTodoReducer,
            environment: AddTodoEnvirenment(todoManager: TodoManager.shared)
        )
        let viewController = AddTodoViewController(store: store)
        self.navigationController?.pushViewController(viewController, animated: true)
        self.viewStore.send(.toggleAddTodoPresent)
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewStore.state.todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return .init() }
        let todo = self.viewStore.state.todoList[indexPath.row]
        cell.textLabel?.text = todo.description
        cell.imageView?.image = todo.isDone ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        return cell
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewStore.send(.toggle(index: indexPath.row))
    }
}
