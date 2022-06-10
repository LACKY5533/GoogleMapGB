//
//  LoginViewController.swift
//  GoogleMapGB
//
//  Created by LACKY on 25.05.2022.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let database = AllRealmDB()
    private var users: Results<User>?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users = database.loadUsers()
        configureLoginButton()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard loginTextField.text != "" && passwordTextField.text != "" else { alertEmptyFields(); return }
        guard let users = users else {
            return
        }
        if users.contains(where: { $0.login == loginTextField.text && $0.password == passwordTextField.text?.sha1() }) {
            loginIsRight()
        } else {
            alert()
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
        guard let vc = R.Storyboard.Register.instantiateInitialViewController() else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func loginIsRight() {
        guard let vc = R.Storyboard.MainMenu.instantiateInitialViewController() else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func alert() {
        let alertVC = UIAlertController(title: "Ошибка", message: "Неправильные данные!", preferredStyle: .alert)
        let alertItem = UIAlertAction(title: "Ок", style: .cancel)
        alertVC.addAction(alertItem)
        present(alertVC, animated: true)
    }
    
    private func alertEmptyFields() {
        let alertVC = UIAlertController(title: "Ошибка", message: "Пустые поля!", preferredStyle: .alert)
        let alertItem = UIAlertAction(title: "Ок", style: .cancel)
        alertVC.addAction(alertItem)
        present(alertVC, animated: true)
    }
    
    private func configureLoginButton() {
        Observable
            .combineLatest(loginTextField.rx.text, passwordTextField.rx.text)
            .map { login, password in
                print("reading textfields")
                return !(login ?? "").isEmpty && !(password ?? "").isEmpty
            }
            .subscribe { [weak loginButton] inputFilled in
                loginButton?.isEnabled = inputFilled
            }.disposed(by: disposeBag)
    }
}
