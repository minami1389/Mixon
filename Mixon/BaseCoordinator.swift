//
//  BaseCoordinator.swift
//  Mixon
//
//  Created by Baba Minami on 2016/11/12.
//  Copyright © 2016年 Baba Minami. All rights reserved.
//

import RealmSwift

class BaseCoordinator: NSObject {
    static let sharedCoordinator = BaseCoordinator()
    
    func fetch() -> [Base] {
        
        var bases = [Base]()
        let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: "default", withExtension: "realm"), readOnly: true)
        let realm = try! Realm(configuration: config)
        
        let results = realm.objects(Base.self).sorted(byProperty: "id", ascending: true)
        for result in results {
            bases.append(result)
        }
        
        return bases
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
            let base = Base()
            let components = line.components(separatedBy: ",")
            
            if let id = Int(components[0]) { base.id = id }
            base.nameJp = components[1]
            base.nameEn = components[2]
            base.image = components[3]
            
            let realm = try! Realm()
            try! realm.write({ () -> Void in
                realm.add(base)
            })
        }
    }
}
