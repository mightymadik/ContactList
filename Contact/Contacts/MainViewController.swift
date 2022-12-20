//
//  ViewController.swift
//  Contacts
//
//  Created by Bizhanov Madiyar on 11.10.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    static let shared = MainViewController()
    
    
    private var users: [UserInfo] = [UserInfo]()
    
    public let contactTable: UITableView = {
        let table = UITableView()
        table.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        return table
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "No Contacts"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(contactTable)
        view.addSubview(infoLabel)
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        contactTable.delegate = self
        contactTable.dataSource = self
        
        configureNavbar()
    
        self.view.setNeedsLayout()
    }
    
    
    public func fetchLocalStorageForUsers() {
        DataPersistenceManager.shared.fetchingUsersFromDataBase { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                DispatchQueue.main.async {
                    self?.contactTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contactTable.frame = view.bounds

        infoLabel.frame = CGRect(x: 148, y: 90, width: 200, height: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLocalStorageForUsers()
    }
    
    private func configureNavbar() {
        navigationItem.title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didAddTapped))
    }
    
    @objc private func didAddTapped() {
        let vc = AddViewController()
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count == 0 {
            infoLabel.isHidden = false
        }else {
            infoLabel.isHidden = true
        }
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
        
        cell.configure(with: User(name: user.name ?? "Unknow name", phone: user.phone ?? "unknonw phone number", image: user.image ?? "male"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView:UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        switch editingStyle {
        case .delete:
            print(users[indexPath.row])
            DataPersistenceManager.shared.deleteUserWith(model: users[indexPath.row]){ [weak self] result in
                switch result{
                case .success():
                    print("user is deleted")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.users.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UserPreviewViewController()
        
        vc.configure(with: users[indexPath.row])
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}



