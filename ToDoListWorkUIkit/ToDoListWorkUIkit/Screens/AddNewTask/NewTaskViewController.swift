//
//  AddNewTask.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 18.07.2025.
//

import UIKit

final class NewTaskViewController: UIViewController {
    
    var task: TodoTask?
    var onCreate: ((_ title: String, _ text: String) -> Void)?
    var onUpdate: ((_ task: TodoTask, _ title: String, _ text: String) -> Void)?
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleField: UITextField = {
        let titleField = UITextField()
        titleField.placeholder = "Добавьте задачу"
        titleField.font = .systemFont(ofSize: 34, weight: .bold)
        titleField.textColor = .white
        titleField.tintColor = .systemGreen
        titleField.borderStyle = .none
        titleField.translatesAutoresizingMaskIntoConstraints = false
        return titleField
    }()
    
    private let notesView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.textColor = .white
        textView.tintColor = .systemGreen
        textView.backgroundColor = .black
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setup()
    }
    
    private func setup() {
        view.addSubview(titleField)
        view.addSubview(dateLabel)
        view.addSubview(notesView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            titleField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            titleField.heightAnchor.constraint(equalToConstant: 41),
            
            dateLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            notesView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            notesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notesView.heightAnchor.constraint(greaterThanOrEqualToConstant: 66),
            
            saveButton.topAnchor.constraint(equalTo: notesView.bottomAnchor, constant: 45),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        dateLabel.text = task?.formattedDate ?? Date().shortSlash
        
        if let task {
            title = "Обновить"
            titleField.text = task.title
            notesView.text = task.text
        } else {
            title = "Новая задача"
        }
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    @objc private func saveTapped() {
        let title = titleField.text ?? ""
        let txt = notesView.text ?? ""
        
        if let task = task {
            onUpdate?(task, title, txt)
        } else {
            onCreate?(title, txt)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
