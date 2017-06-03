//
//  CocktailCoordinator.swift
//  Mixon
//
//  Created by Baba Minami on 2016/11/12.
//  Copyright © 2016年 Baba Minami. All rights reserved.
//

import RealmSwift

class CocktailCoordinator: NSObject {
    static let sharedCoordinator = CocktailCoordinator()
    var haveCocktails = [Bool]()
    
    func fetch(baseID: Int) -> [Cocktail] {
        
        var cocktails = [Cocktail]()
        let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: "default", withExtension: "realm"), readOnly: true)
        let realm = try! Realm(configuration: config)
        
        switch baseID {
        case -1:
            let results = realm.objects(Cocktail.self)
            for result in results {
                cocktails.append(result)
            }
        default:
            let results = realm.objects(Cocktail.self).filter("baseID == \(baseID)")
            for result in results {
                cocktails.append(result)
            }
        }
        
        return cocktails
    }
    
    func coordinate(fileName:String) {
        guard let csvPath = Bundle.main.path(forResource: fileName, ofType: "csv") else { fatalError("miss open csv file") }
        var csvString = ""
        do {
            csvString = try NSString(contentsOfFile: csvPath, encoding: String.Encoding.utf8.rawValue) as String
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        print("RealmPath:\(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString)")
        
        csvString.enumerateLines { (line, stop) -> () in
            let cocktail = Cocktail()
            let components = line.components(separatedBy: ",")
            
            if let id = Int(components[0]) { cocktail.id = id }
            if let baseID = Int(components[1]) { cocktail.baseID = baseID }
            cocktail.nameJp = components[2]
            cocktail.nameEn = components[3]
            cocktail.image = components[4]
            
            if components[5] != "" {
                let material = components[5].components(separatedBy: ":")
                cocktail.material1 = material[0]
                if let quantity = Int(material[1]) { cocktail.quantity1 = quantity }
            }
            if components[6] != "" {
                let material = components[6].components(separatedBy: ":")
                cocktail.material2 = material[0]
                if let quantity = Int(material[1]) { cocktail.quantity2 = quantity }
            }
            
            if components.count >= 8 {
                if components[7] != "" {
                    let material = components[7].components(separatedBy: ":")
                    cocktail.material3 = material[0]
                    if let quantity = Int(material[1]) { cocktail.quantity3 = quantity }
                }
            }
            
            if components.count >= 9 {
                if components[8] != "" {
                    let material = components[8].components(separatedBy: ":")
                    cocktail.material4 = material[0]
                    if let quantity = Int(material[1]) { cocktail.quantity4 = quantity }
                }
            }
            
            if components.count >= 10 {
                if components[9] != "" {
                    let material = components[9].components(separatedBy: ":")
                    cocktail.material5 = material[0]
                    if let quantity = Int(material[1]) { cocktail.quantity5 = quantity }
                }
            }
            
            let realm = try! Realm()
            try! realm.write({ () -> Void in
                realm.add(cocktail)
            })
        }
    }

}
