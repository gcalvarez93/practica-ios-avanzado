//
//  SecureDatProviderTests.swift
//  DragonBallTests
//
//  Created by Gabriel Castro on 29/10/23.
//

import Foundation
import XCTest
@testable import DragonBall

final class SecureDataProvideTests: XCTestCase {
    private var sut: SecureDataProviderProtocol!

    override func setUp() {
        sut = SecureDataProvider()
    }

    func test_givenSecureDataProvider_whenLoadToken_thenGetStoredToken() throws {
        let token = "MyTestToken"
        sut.save(token: token)
        let tokenLoaded = sut.getToken()
        XCTAssertEqual(token, tokenLoaded)
    }
    
    func test_givenSecureDataProvider_whenTokenIsCleared_thenNoTokenIsStored() throws {
        sut.clear()
        let tokenLoaded = sut.getToken()
        XCTAssertEqual(nil, tokenLoaded)
        XCTAssertNil(tokenLoaded)
    }
    
}
