//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Bizhanov Madiyar on 11.10.2022.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    static let identifier = "ContactTableViewCell"
    
    private let userImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = image.frame.height / 2
        return image;
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 21.0)
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(13)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(phoneLabel)
        applyConstraints()
    }
    
    private func applyConstraints () {
        let userImageConstraints = [
            userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            userImage.widthAnchor.constraint(equalToConstant: 80)
        ]
        
        let titleLabelConstraints = [
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 30),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ]
        
        let phoneLabelContraint = [
            phoneLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 30),
            phoneLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(userImageConstraints)
        NSLayoutConstraint.activate(phoneLabelContraint)
    }
    
    public func configure(with model: User) {
        titleLabel.text = model.name
        userImage.image = UIImage(named: model.image)
        phoneLabel.text = model.phone
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
