//
//  SecureDataProvider.swift
//  DragonBall
//
//  Created by Gabriel Castro on 18/10/23.
//

import Foundation
import KeychainSwift

protocol SecureDataProviderProtocol {
    func save(token: String)
    func getToken() -> String?
    func clear()
}

 class SecureDataProvider: SecureDataProviderProtocol {
    private let keychain = KeychainSwift()

    private enum Key {
        static let token = "KEY_KEYCHAIN_TOKEN"
    }

    func save(token: String) {
        keychain.set(token, forKey: Key.token)
    }

    func getToken() -> String? {
        keychain.get(Key.token)
    }
     
     func clear() {
         keychain.delete(Key.token)
     }
}

