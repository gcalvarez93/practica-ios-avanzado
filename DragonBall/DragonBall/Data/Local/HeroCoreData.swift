//
//  HeroCoreData.swift
//  DragonBall
//
//  Created by Gabriel Castro on 29/10/23.
//

import Foundation
import CoreData

// MARK: - Class -
class HeroCoreData {
    
    func manageHeroes(of heroes: Heroes) {
        deleteAll()
        saveHeroes(of: heroes)
    }
    
    func getHeroes() -> Heroes {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<HeroDAO>(entityName: HeroDAO.entityName)
        
        guard let heroes = try? moc.fetch(fetch)
            else {
            return []
        }
        return HeroMapper.mapperDao(of: heroes)
    }
    
    func getHero(by id: String) -> Hero? {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<HeroDAO>(entityName: HeroDAO.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id)
        
        guard let heroes = try? moc.fetch(fetch)
            else {
            return nil
        }
        return HeroMapper.mapperDao(of: heroes).first
    }
    
    public func deleteAll() {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let requestAllHeroes = NSFetchRequest<HeroDAO>(entityName: HeroDAO.entityName)
        
        guard let heroes = try? moc.fetch(requestAllHeroes)
            else {
            return
        }
        heroes.forEach { heroe in
            moc.delete(heroe)
        }
        try? moc.save()
    }
    
    // MARK: - Privates -
    private func saveHeroes(of heroes: Heroes) {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        guard let heroEntity = NSEntityDescription.entity(forEntityName: HeroDAO.entityName, in: moc)
            else {
            return
        }
        
        heroes.forEach { hero in
            let heroDao = HeroDAO(entity: heroEntity, insertInto: moc)
            heroDao.heroDescription = hero.description
            heroDao.favorite = hero.isFavorite ?? false
            heroDao.name = hero.name
            heroDao.id = hero.id
            heroDao.photo = hero.photo
        }
        try? moc.save()
    }
}
