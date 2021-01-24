//
//  TodoListViewController.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/24.
//

import UIKit
import Combine

final class TodoListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    @Published private var todos: [Todo] = [
        Todo(description: "first"),
        Todo(description: "second"),
        Todo(description: "third")
    ]

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setLayout()

        $todos.sink(receiveValue: { [weak self] _ in
            self?.tableView.reloadData()
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
        return self.todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return .init() }
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.description
        cell.imageView?.image = todo.isDone ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        return cell
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todos[indexPath.row].isDone.toggle()
    }
}
