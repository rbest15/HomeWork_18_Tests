import Foundation
import RealmSwift

class Human: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var dateOfBirth : Date = Date(timeIntervalSince1970: 0)
    @objc dynamic var height : Double = 0
    @objc dynamic var sexRawValue = Sex.unknown.rawValue
    var sex : Sex {
        get {
            return  Sex(rawValue: sexRawValue)!
        } set {
            sexRawValue = newValue.rawValue
        }
    }
    
    func set(name: String = "", date: Date = Date(timeIntervalSince1970: 0), height: Double = 0, sex: Sex = .unknown)-> Human {
        self.name = name
        self.dateOfBirth = date
        self.height = height
        self.sex = sex
        return self
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Human {
            return self.name == object.name && self.dateOfBirth == object.dateOfBirth && self.height == object.height && self.sexRawValue == object.sexRawValue
        } else {
            return false
        }
    }
}

enum Sex : String{
    case male, female, unknown
}

class HumanRealm{

    static var shared = HumanRealm()
    let realm = try! Realm()
    lazy var stack : Results<Human> = { self.realm.objects(Human.self)}()
    func add(human: Human) {
        try! realm.write({
            realm.add(human)
        })
    }
    
    func get() -> Results<Human> {
        return realm.objects(Human.self)
    }
    
    func delete(human: Human) {
        try! realm.write({
            realm.delete(human)
        })
    }
    
    func oldest() -> Human? {
        return get().max { h1, h2 in
            return h1.dateOfBirth > h2.dateOfBirth
        }
    }
    
    func youngest() -> Human? {
        return get().max { h1, h2 in
            return h1.dateOfBirth < h2.dateOfBirth
        }
    }
    
    func deleteWith(parametr: (Human)->(Bool)) {
        let objects = realm.objects(Human.self)
        let objectsToRemove = objects.filter(parametr)
        try! realm.write({
            realm.delete(objectsToRemove)
        })
    }
}

class HumanGenerator {
    
    static let shared = HumanGenerator()
    
    private func randomName() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<6).map{ _ in letters.randomElement()! }).lowercased().capitalizingFirstLetter()
    }
    
    private func randomSex() -> Sex {
        let a = Int.random(in: 0...1)
        switch a {
        case 1:
            return .female
        case 0:
            return .male
        default:
            return .unknown
        }
    }
    
    private func randomHeight() -> Double {
        return Double(Int.random(in: 100...200))
    }
    
    private func randomDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(Int.random(in: 0...1622314886)))
    }
    
    func generate() -> Human {
        return Human().set(name: randomName(), date: randomDate(), height: randomHeight(), sex: randomSex())
    }
    
    func addRandomHumans(count: Int) {
        for _ in 0...(count - 1) {
            HumanRealm.shared.add(human: HumanGenerator.shared.generate())
        }
    }
    
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
