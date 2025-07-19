//
//  AddNewTask.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 18.07.2025.
//

import UIKit

class AddNewTask: UIViewController {
    
    private let manager = CoreDataManager.shared
    var task: TodoTask?
    
    lazy var titleField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Добавьте задачу"
        tf.heightAnchor.constraint(equalToConstant: 60).isActive = true
        tf.font = UIFont.systemFont(ofSize: 17)
        tf.backgroundColor = .systemGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        tv.backgroundColor = .systemGray
        tv.font = UIFont.systemFont(ofSize: 12)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var btn: UIButton = {
        let btn = UIButton(primaryAction: action)
        btn.setTitle("Сохранить", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var action = UIAction { _ in
        if self.task == nil {
            self.manager.createNewTask(title: self.titleField.text ?? "", text: self.textView.text ?? "" )
        } else {
            self.task?.updateTask(title: self.titleField.text ?? "", text: self.textView.text ?? "")
        }
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Добавление новой задачи"
        
        view.addSubview(titleField)
        view.addSubview(textView)
        view.addSubview(btn)
        
        setupConstraints()
        
        if task != nil {
            title = "Обновить"
            titleField.text = task?.title
            textView.text = task?.text
        } else {
            title = "Добавление новой задачи"
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            textView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            btn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

}
