//
//  UserPreviewViewController.swift
//  Contacts
//
//  Created by Bizhanov Madiyar on 11.10.2022.
//

import UIKit

class UserPreviewViewController: UIViewController {
    
    private var user: UserInfo? = nil
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let userImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image;
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
            
        return button
    }()
    
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(13)
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemBackground
        title = "Contact Info"
        
        
        view.addSubview(nameLabel)
        view.addSubview(userImage)
        view.addSubview(phoneLabel)
        view.addSubview(deleteButton)
        
        configureConstraints()
        
        deleteButton.addTarget(self, action: #selector(didDeleteTapped), for: .touchUpInside)
    }
    
    
    func configureConstraints() {
        
        
        let userImageConstraints = [
            userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            userImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userImage.widthAnchor.constraint(equalToConstant: 120),
            userImage.heightAnchor.constraint(equalToConstant: 130)
        ]
        
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40)
        ]
        
        let phoneLabelConstraints = [
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 40),
            phoneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40)
        ]
        
        let deleteButtonConstraint = [
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            deleteButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        
        NSLayoutConstraint.activate(userImageConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(phoneLabelConstraints)
        NSLayoutConstraint.activate(deleteButtonConstraint)
    }
    
    func configure(with model: UserInfo){
        nameLabel.text = model.name
        userImage.image = UIImage(named: model.image ?? "")
        phoneLabel.text = model.phone
        self.user = model
    }
    
    @objc func didDeleteTapped(){
    
        DataPersistenceManager.shared.deleteUserWith(model: self.user!) { result in
            switch result {
            case .success():
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
