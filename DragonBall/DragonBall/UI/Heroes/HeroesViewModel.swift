//
//  HeroesViewModel.swift
//  DragonBall
//
//  Created by Gabriel Castro on 18/10/23.
//

import Foundation

import Foundation

class HeroesViewModel: HeroesViewControllerDelegate {
    // MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let secureData: SecureDataProviderProtocol
    private var heroes: Heroes = []
    private var heroesFromNetwork: Heroes = []
    
    private let heroCoreData: HeroCoreData = .init()

    // MARK: - Properties -
    var viewState: ((HeroesViewState) -> Void)?
    

    // MARK: - Initializers -
    init(
        apiProvider: ApiProviderProtocol,
         secureData: SecureDataProviderProtocol
    ) {
        self.apiProvider = apiProvider
        self.secureData = secureData
    }

    // MARK: - Public functions -
    func onViewAppear() {
        viewState?(.loading(true))

        DispatchQueue.global().async {
            defer { self.viewState?(.loading(false)) }
            guard let token = self.secureData.getToken() else {
                return
            }

            // Core Data
            let dataHeroes = self.heroCoreData.getHeroes()
            if !dataHeroes.isEmpty {
                self.setClassData(of: dataHeroes)
                print("Obtained Heroes from CoreData")
                
            // API
            } else {
                self.apiProvider.getHeroes(by: nil, token: token) { heroes in
                    self.setClassData(of: heroes, save: true)
                }
                self.viewState?(.network)
                print("Obtained Heroes from Network")
            }
        }
    }

    func heroDetailViewModel(index: Int) -> HeroDetailViewControllerDelegate {
         HeroDetailViewModel(
            hero: heroes[index],
            apiProvider: apiProvider,
            secureDataProvider: secureData
        )
    }
    
    func mapViewModel() -> MapViewControllerDelegate {
        MapViewModel(
            apiProvider: apiProvider,
            secureDataProvider: secureData
        )
    }
    
    func loginViewModel() -> LoginViewControllerDelegate {
        LoginViewModel(
            apiProvider: apiProvider,
            secureDataProvider: secureData
        )
    }
    
    func logOut() {
        secureData.clear()
        viewState?(.logout)
    }
    
    func heroesCount() -> Int {
        heroes.count
    }
    
    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount() {
            return heroes[index]
        } else {
            return nil
        }
    }
    
    private func setClassData(of heroes: Heroes, save: Bool = false) {
        self.heroesFromNetwork = heroes
        self.heroes = self.heroesFromNetwork
        
        if (save) {
            self.heroCoreData.manageHeroes(of: heroes)
        }
        
        self.viewState?(.updateData)
    }

}
