//
//  HeroDAO.swift
//  DragonBall
//
//  Created by Gabriel Castro on 18/10/23.
//

import Foundation
import CoreData

@objc(HeroDAO)
class HeroDAO: NSManagedObject {
    static let entityName = "HeroDAO"

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var heroDescription: String?
    @NSManaged var photo: String?
    @NSManaged var favorite: Bool
}

