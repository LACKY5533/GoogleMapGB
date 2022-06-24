//
//  User.swift
//  GoogleMapGB
//
//  Created by LACKY on 25.05.2022.
//

import Realm
import RealmSwift

final class UserObject: Object {
    let users = List<User>()
}

final class User: Object, Codable {
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    
    convenience init(login: String, password: String, imageData: String) {
        self.init()
        self.login = login
        self.password = password
    }
}
