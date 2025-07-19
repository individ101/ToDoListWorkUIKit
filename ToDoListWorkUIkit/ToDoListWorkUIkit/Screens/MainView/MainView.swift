//
//  ViewController.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 18.07.2025.
//

import UIKit

class MainView: UIViewController {
    private let viewModel = TodoViewModel()
    private let searchBar = CustomSearchBar()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .singleLine
        table.separatorColor = .systemGray
        table.rowHeight = UITableView.automaticDimension
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        return table
    }()
    
    lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "addButton"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(addButton)
        setupConstraints()
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load { [weak self] in self?.tableView.reloadData() }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func addButtonTapped() {
        let addVC = AddNewTask()
        addVC.onCreate = { [weak self] title, text in
            self?.viewModel.create(title: title, text: text) {
                self?.tableView.reloadData()
            }
        }
        navigationController?.pushViewController(addVC, animated: true)
    }
}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoCell.identifier,
            for: indexPath
        ) as? TodoCell else { return UITableViewCell() }
        
        let task = viewModel.tasks[indexPath.row]
        cell.configure(with: task)
        
        cell.checkmarTapped = { [weak self] in
            guard let self else { return }
            self.viewModel.toggle(at: indexPath.row) { [weak self] in
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let vc = AddNewTask()
        vc.task = viewModel.tasks[indexPath.row]
        vc.onUpdate = { [weak self] task, title, text in
            self?.viewModel.update(task: task, title: title, text: text) {
                self?.tableView.reloadData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.delete(at: indexPath.row) { [weak self] in
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension MainView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            viewModel.load { [weak self] in self?.tableView.reloadData() }
        } else {
            viewModel.search(text: searchText) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.load { [weak self] in self?.tableView.reloadData() }
        searchBar.resignFirstResponder()
    }
}
