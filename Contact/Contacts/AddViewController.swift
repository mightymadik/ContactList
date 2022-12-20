//
//  AddViewController.swift
//  Contacts
//
//  Created by Bizhanov Madiyar on 11.10.2022.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    
    var genderText: String = "Male"
    
    let genders = ["Male", "Female"]
    
    let pickerView: UIPickerView = UIPickerView()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter name"
        field.autocapitalizationType = UITextAutocapitalizationType.none
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = 8
        
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: field.frame.size.height))
        field.leftView = leftView
        field.leftViewMode = .always
        
        return field;
    }()
    
    private let phoneField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter phone number"
        field.autocapitalizationType = UITextAutocapitalizationType.none
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = 8
        
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: field.frame.size.height))
        field.leftView = leftView
        field.leftViewMode = .always
        
        return field;
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.title = "New Contact"
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        view.addSubview(nameField)
        view.addSubview(phoneField)
        view.addSubview(pickerView)
        
        nameField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        phoneField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        
        configureNavbar()
        
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        nameField.frame = CGRect(x: 20, y: 120, width: view.frame.size.width-40, height: 50)

        phoneField.frame = CGRect(x:20, y: 180, width: view.frame.size.width-40, height: 50)
        
        pickerView.frame = CGRect(x:100, y: 170, width: 200, height: 200)
    }
    
    private func configureNavbar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didCancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didDoneTapped))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func didCancelTapped(){
        dismiss(animated: true)
    }
    
    @objc func didDoneTapped(){
        let image = genderText.lowercased()
        
        DataPersistenceManager.shared.addUserWith(model: User(name: nameField.text ?? "", phone: phoneField.text ?? "", image: image )){ result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                self.dismiss(animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            }

        }
    }
    
    @objc func textChanged(_ textField: UITextField) {
        if textField.text != "" && phoneField.text != "" {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderText = genders[row]
    }
}
