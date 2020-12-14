
import Foundation
import UIKit
enum UserDefaultKeys: String {
    case keyboardDistances
    case token
    case name, email, avatarID
}
class StoringData {
    
    
    
    //    static var simCardNumbers: [ACLItem] {
    //        get {
    //            if let simCartList = UserDefaults.standard.retrieve(object: [ACLItem].self, fromKey: UserDefaultKeys.simCardNumbers.rawValue) {
    //                return simCartList
    //            } else {
    //                return [ACLItem(id: "", msisdn: "09000000000", simType: "POSTPAID")]
    //            }
    //        }
    //        set (newValue) {
    //            UserDefaults.standard.save(customObject: newValue, inKey: UserDefaultKeys.simCardNumbers.rawValue)
    //        }
    //    }
    
    static var token: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.token.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.token.rawValue)
        }
    }
    
    static var name: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.name.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.name.rawValue)
        }
    }
    
    static var email: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.email.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.email.rawValue)
        }
    }
    
    static var avatarID: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.avatarID.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.avatarID.rawValue)
        }
    }
    
    
    static var keyboardDistances: [String: Any]? {
        get {
            return UserDefaults.standard.dictionary(forKey: UserDefaultKeys.keyboardDistances.rawValue)
        }
        set (newValue) {
            if let dictionary = UserDefaults.standard.dictionary(forKey: UserDefaultKeys.keyboardDistances.rawValue) {
                var changedDictionary = dictionary
                changedDictionary["\(newValue!.keys.first!)"] = newValue!.values.first!
                UserDefaults.standard.setValue(changedDictionary, forKey: UserDefaultKeys.keyboardDistances.rawValue)
            } else {
                UserDefaults.standard.setValue(newValue!, forKey: UserDefaultKeys.keyboardDistances.rawValue)
            }
            
        }
    }
}
extension UserDefaults {
    
    func save<T:Encodable>(customObject object: T, inKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }
    
    func retrieve<T:Decodable>(object type: T.Type, fromKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            } else {
                print("Couldnt decode object")
                return nil
            }
        } else {
            print("Couldnt find key")
            return nil
        }
    }
    
}
