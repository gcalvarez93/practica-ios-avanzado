//
//  LocationMapper.swift
//  DragonBall
//
//  Created by Gabriel Castro on 29/10/23.
//

import Foundation

class LocationMapper {
    static func mapperDao(of locationsDao: [LocationDAO]) -> HeroLocations {
        locationsDao.map { locationDao in
            HeroLocation(
                id: locationDao.id,
                latitude: locationDao.latitude,
                longitude: locationDao.longitude,
                date: locationDao.date,
                hero: Hero(
                    id: locationDao.hero,
                    name: nil,
                    description: nil,
                    photo: nil,
                    isFavorite: nil)
            )
        }
    }
}
