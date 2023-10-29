//
//  MapViewModel.swift
//  DragonBall
//
//  Created by Gabriel Castro on 29/10/23.
//

import Foundation

// MARK: - Class -
class MapViewModel: MapViewControllerDelegate {
    
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    private let heroCoreData: HeroCoreData = .init()
    private let locationCoreData: LocationCoreData = .init()
    
    init(
        apiProvider: ApiProviderProtocol,
        secureDataProvider: SecureDataProviderProtocol
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    // MARK: - Extended -
    var viewState: ((MapViewState) -> Void)?
    
    func handleViewDidLoad() {
        defer { viewState?(.loading(false)) }
        
        viewState?(.loading(true))
        
        DispatchQueue.global().async {
            guard let token = self.secureDataProvider.getToken() else {
                return
            }
            
            self.heroCoreData.getHeroes().forEach { hero in
                // BDD
                let dataLocations = self.locationCoreData.getLocations(by: hero.id ?? "")
                if  !dataLocations.isEmpty {
                    self.viewState?(.update(hero: hero, locations: dataLocations ))
                    print("DETAIL MAP - FROM BDD")
                    
                // API
                } else {
                    self.apiProvider.getLocations(
                        by: hero.id,
                        token: token
                    ) { [weak self] heroLocation in
                        
                        self?.locationCoreData.manageLocations(of: heroLocation)
                        
                        self?.viewState?(.update(hero: hero, locations: heroLocation))
                    }
                    print("DETAIL MAP - FROM API")
                }
            }
            
        }
    }
    
    func navigateToHeroDetail(of id: String) {
        if id.isEmpty {
            return
        }
        
        guard let hero = self.heroCoreData.getHero(by: id) else {
            return
        }
        
        self.viewState?(.navigateToHeroDetail(hero: hero))
    }
    
    func heroDetailViewModel(hero: Hero) -> HeroDetailViewControllerDelegate {
        HeroDetailViewModel(
            hero: hero,
            apiProvider: apiProvider,
            secureDataProvider: secureDataProvider
        )
    }
}
