//
//  TodoCell.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 19.07.2025.
//

import UIKit

class TodoCell: UITableViewCell {
    
    static let identifier = "TodoCell"
    
    private var todo: TodoTask?
    var checkmarTapped: (() -> ())?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackLabels: UIStackView = {
        let stackLabels = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            dateLabel
        ])
        stackLabels.axis = .vertical
        stackLabels.spacing = 4
        stackLabels.translatesAutoresizingMaskIntoConstraints = false
        return stackLabels
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        setupConstraints()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(checkmarkTappedAction))
        checkmarkImageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(stackLabels)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkmarkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            checkmarkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
            
            stackLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackLabels.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 12),
            stackLabels.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
        ])
    }
    
    @objc private func checkmarkTappedAction() {
        checkmarTapped?()
    }
    
    private func animateCheckmark(isDone: Bool) {
        UIView.transition(
            with: checkmarkImageView,
            duration: 0.3,
            options: .transitionFlipFromRight
        ) {
            if isDone {
                self.checkmarkImageView.image = UIImage(systemName: "checkmark.circle")
            } else {
                self.checkmarkImageView.image = UIImage(systemName: "circle")
            }
        }
    }
    
    func configure(with todo: TodoTask) {
        self.todo = todo
        dateLabel.text = todo.formattedDate
        
        if todo.isCompleted {
            titleLabel.attributedText = NSAttributedString(
                string: todo.title ?? "",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            descriptionLabel.text = todo.text
            descriptionLabel.textColor = .systemGray
            titleLabel.textColor = .systemGray
            
            checkmarkImageView.image = UIImage(systemName: "checkmark.circle")
            checkmarkImageView.tintColor = .systemYellow
        } else {
            titleLabel.attributedText = nil
            titleLabel.text = todo.title
            titleLabel.textColor = .white
            
            descriptionLabel.text = todo.text
            descriptionLabel.textColor = .white
            
            checkmarkImageView.image = UIImage(systemName: "circle")
            checkmarkImageView.tintColor = .systemGray
        }
    }    
}
