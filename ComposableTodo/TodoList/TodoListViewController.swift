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

    var viewStore: ViewStore<TodoListState, TodoListAction>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setLayout()
        
        let baritem = UIBarButtonItem(systemItem: .add)
        baritem.primaryAction = UIAction(handler: { [weak self] _ in
            self?.viewStore?.send(.toggleAddTodoPresent)
        })
        self.navigationItem.rightBarButtonItem  = baritem

        viewStore?.send(.initialize)

        viewStore?.publisher
            .map(\.todoList)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)

        viewStore?.publisher
            .map(\.isAddTodoPresented)
            .removeDuplicates()
            .filter { $0 }
            .sink(receiveValue: { [weak self] _ in
                let viewController = AddTodoViewController()
                self?.present(viewController, animated: true, completion: {
                    self?.viewStore?.send(.toggleAddTodoPresent)
                })
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
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewStore?.state.todoList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return .init() }
        guard let todo = self.viewStore?.state.todoList[indexPath.row] else { return .init() }
        cell.textLabel?.text = todo.description
        cell.imageView?.image = todo.isDone ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        return cell
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewStore?.send(.toggle(index: indexPath.row))
    }
}
