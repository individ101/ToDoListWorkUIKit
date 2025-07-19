//
//  AddNewTask.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 18.07.2025.
//

import UIKit

final class AddNewTask: UIViewController {

    // MARK: - I/O
    var task: TodoTask?
    var onCreate: ((_ title: String, _ text: String) -> Void)?
    var onUpdate: ((_ task: TodoTask, _ title: String, _ text: String) -> Void)?

    // MARK: - UI Elements
    private let dateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .lightGray
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let titleField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Добавьте задачу"
        tf.font = .systemFont(ofSize: 34, weight: .bold)
        tf.textColor = .white
        tf.tintColor = .systemGreen
        tf.borderStyle = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let notesView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16, weight: .regular)
        tv.layer.borderColor = UIColor.darkGray.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 8
        tv.textColor = .white
        tv.tintColor = .systemGreen
        tv.backgroundColor = .black
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let saveButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Сохранить", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 18)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .systemGreen
        b.layer.cornerRadius = 12
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setup()
    }

    // MARK: - Setup
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

    // MARK: - Actions
    @objc private func saveTapped() {
        let t   = (titleField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let txt = (notesView.text   ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !t.isEmpty else {
            titleField.becomeFirstResponder(); return
        }

        if let task = task {
            onUpdate?(task, t, txt)
        } else {
            onCreate?(t, txt)
        }
        navigationController?.popViewController(animated: true)
    }
}
