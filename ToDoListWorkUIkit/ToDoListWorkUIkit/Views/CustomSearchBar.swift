//
//  CustomSearchBar.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 18.07.2025.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        placeholder = "Find task"
        translatesAutoresizingMaskIntoConstraints = false
        searchBarStyle = .minimal
        barTintColor = .clear
        
        let tf = searchTextField
        tf.backgroundColor = UIColor(named: "searchBarBackground")
        tf.textColor = .white
        tf.tintColor = .systemBlue
        
        tf.attributedPlaceholder = NSAttributedString(
            string: "Find Todo",
            attributes: [.foregroundColor: UIColor(named: "searchBarPlaceHolder") ?? .blue])
        
        
        let glassImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        setImage(glassImage, for: .search, state: .normal)
        
        tf.leftView?.tintColor = UIColor(named: "searchBarPlaceHolder") ?? .gray
        
        if let clearButton = tf.value(forKey: "_clearButton") as? UIButton {
            let clearImage = clearButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(clearImage, for: .normal)
            clearButton.tintColor = UIColor(named: "searchBarPlaceHolder") ?? .gray
        }
    }
    
}
