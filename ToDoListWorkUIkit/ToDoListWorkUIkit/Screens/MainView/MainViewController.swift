//
//  ViewController.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 18.07.2025.
//

import UIKit

class MainViewController: UIViewController {
    private let viewModel: MainViewModel
    private let searchBar = CustomSearchBar()
    
    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let taskCountContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let taskCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .systemGray
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        return tableView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(taskCountContainer)
        taskCountContainer.addSubview(taskCountLabel)
        taskCountContainer.addSubview(addButton)
        setupConstraints()
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFromAPI { [weak self] in
            self?.reloadTableView()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: taskCountContainer.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            taskCountContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            taskCountContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            taskCountContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
            taskCountContainer.heightAnchor.constraint(equalToConstant: 100),
            
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.trailingAnchor.constraint(equalTo: taskCountContainer.trailingAnchor, constant: -10),
            addButton.topAnchor.constraint(equalTo: taskCountContainer.topAnchor),
            
            taskCountLabel.centerXAnchor.constraint(equalTo: taskCountContainer.centerXAnchor),
            taskCountLabel.centerYAnchor.constraint(equalTo: taskCountContainer.centerYAnchor, constant: -20)
        ])
    }
    
    @objc private func addButtonTapped() {
        let addVC = NewTaskViewController()
        addVC.onCreate = { [weak self] title, text in
            self?.viewModel.create(title: title, text: text) {
                self?.reloadTableView()
            }
        }
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.updateTaskCountLabel()
        }
    }
    
    private func updateTaskCountLabel() {
        let count = self.viewModel.tasks.count
        self.taskCountLabel.text = count == 0 ? "Нет задач" : "\(count) задач"
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
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
        let vc = NewTaskViewController()
        vc.task = viewModel.tasks[indexPath.row]
        vc.onUpdate = { [weak self] task, title, text in
            self?.viewModel.update(task: task, title: title, text: text) {
                self?.reloadTableView()
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
            self?.updateTaskCountLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let task = viewModel.tasks[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { _ in
            let edit = UIAction(
                title: "Редактировать",
                image: UIImage(named: "editIcon")) { [weak self] _ in
                    let vc = NewTaskViewController()
                    vc.task = task
                    vc.onUpdate = { task, title, text in
                        self?.viewModel.update(task: task, title: title, text: text) {
                            self?.reloadTableView()
                        }
                    }
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            
            let share = UIAction(
                title: "Поделиться",
                image: UIImage(named: "shareIcon")
            ) { _ in
                let text = "\(task.title ?? "")\n\(task.text ?? "")"
                let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                self.present(vc, animated: true)
            }
            
            let delete = UIAction(
                title: "Удалить",
                image: UIImage(named: "trashIcon"),
                attributes: .destructive
            ) { [weak self] _ in
                self?.viewModel.delete(at: indexPath.row) {
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self?.updateTaskCountLabel()
                }
            }
            return UIMenu(children: [edit, share, delete])
        }
    }
    
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            viewModel.load { [weak self] in self?.tableView.reloadData() }
        } else {
            viewModel.search(text: searchText) { [weak self] in
                self?.reloadTableView()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.load { [weak self] in self?.reloadTableView() }
        searchBar.resignFirstResponder()
    }
}
