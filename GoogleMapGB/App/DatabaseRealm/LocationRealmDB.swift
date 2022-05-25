//
//  LocationRealmDB.swift
//  GoogleMapGB
//
//  Created by LACKY on 22.05.2022.
//

import Realm
import RealmSwift
import CoreLocation

final class LocationRealmDB {
    
    init() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1)
    }
    
    public func save(_ items: [Location]) {
        let realm = try! Realm()
        do {
            try! realm.write {
                realm.add(items)
            }
        }
    }
    
    public func saveToRealm(_ coordinates: [CLLocation]) {
        let locationObject = LocationObject()
        let realm = try! Realm()
        coordinates.forEach { coordinate in
            let location = Location()
            location.latitude = coordinate.coordinate.latitude
            location.longitude = coordinate.coordinate.longitude
            locationObject.coordinates.append(location)
        }
        do {
            try! realm.write {
                realm.add(locationObject)
            }
        }
    }
    
    public func load() -> Results<Location> {
        let realm = try! Realm()
        let locations: Results<Location> = realm.objects(Location.self)
        return locations
    }
    
    public func delete(_ items: [Location]) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(items)
        }
    }
    
    public func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func getPersistedRoutes() -> [LocationObject] {
        let realm = try! Realm()
        return Array(realm.objects(LocationObject.self))
    }
}
