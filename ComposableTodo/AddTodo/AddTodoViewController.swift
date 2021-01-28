//
//  AddTodoViewController.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/26.
//

import UIKit
import Combine
import ComposableArchitecture

final class AddTodoViewController: UIViewController {

    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private var cancellables = Set<AnyCancellable>()

    private let viewStore: ViewStore<AddTodoState, AddTodoAction>

    init(store: Store<AddTodoState, AddTodoAction>) {
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setLayout()

        let baritem = UIBarButtonItem(systemItem: .done)
        baritem.primaryAction = UIAction(handler: { [weak self] _ in
            guard let text = self?.textView.text else {
                self?.viewStore.send(.dismiss)
                return
            }
            self?.viewStore.send(.addTodo(text))
        })
        self.navigationItem.rightBarButtonItem  = baritem

        self.viewStore.publisher
            .map(\.isAddTodoDismissed)
            .filter { $0 }
            .sink(receiveValue: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .store(in: &cancellables)
    }

    private func setLayout() {
        self.view.addSubview(textView)

        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.textView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.textView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
