//
//  Cocktail.swift
//  Mixon
//
//  Created by Baba Minami on 2016/11/12.
//  Copyright © 2016年 Baba Minami. All rights reserved.
//

import RealmSwift

class Cocktail: Object {
    dynamic var id = 0
    dynamic var baseID = 0
    dynamic var name = ""
    dynamic var detail = ""
    dynamic var image = ""
    dynamic var material1 = ""
    dynamic var quantity1 = 0
    dynamic var material2 = ""
    dynamic var quantity2 = 0
    dynamic var material3 = ""
    dynamic var quantity3 = 0
    dynamic var material4 = ""
    dynamic var quantity4 = 0
    dynamic var favorite = false
}
