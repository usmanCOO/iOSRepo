//
//  Meddpicc AppSessionManager.swift
//  Meddpicc App
//
//  Created by Asad Khan on 9/6/22.
//

import Foundation

class DealDocSessionManager  {
    static var shared: DealDocSessionManager {
        let ob = DealDocSessionManager()
        return ob
    }
    private init() {}
    
    func saveUser(value: userData?) {
        do {
            let placesData = try JSONEncoder().encode(value)
            UserDefaults.standard.set(placesData, forKey: "user")
        }
        catch {
            print("Date is not saved in Session")
        }
    }
    
    func getUser()  -> userData? {
        guard let Data = UserDefaults.standard.data(forKey: "user") else { return nil }
        do{
            return try JSONDecoder().decode(userData.self, from: Data)
        }
        catch {
            return nil
        }
    }
    
    func removeUserData(){
        UserDefaults.standard.removeObject(forKey: "user")
    }
    
}
