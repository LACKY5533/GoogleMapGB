//
//  RegisterViewController.swift
//  GoogleMapGB
//
//  Created by LACKY on 25.05.2022.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let database = AllRealmDB()
    private let realm = try! Realm()
    private var users: Results<User>?
    private var usertoDB = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users = database.loadUsers()
    }
    
    @IBAction func registerButton(_ sender: Any) {
        guard loginTextField.text != "" && passwordTextField.text != "" else { alert()
            return }
        
        guard let users = users else { return }
        
        if users.contains(where: { $0.login == loginTextField.text }) == true {
            guard let index = users.firstIndex(where: { $0.login == loginTextField.text }) else { return }
            try! realm.write ({
                users[index].password = passwordTextField.text!
            })
        } else {
            usertoDB.append(User(login: loginTextField.text!, password: passwordTextField.text!))
            database.saveUsers(usertoDB)
        }
        
        guard let vc = R.Storyboard.MainMenu.instantiateInitialViewController() else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func alert() {
        let alertVC = UIAlertController(title: "Ошибка", message: "Пустые поля, либо пароль неверный!", preferredStyle: .alert)
        let alertItem = UIAlertAction(title: "Ок", style: .cancel)
        alertVC.addAction(alertItem)
        present(alertVC, animated: true)
    }
}
