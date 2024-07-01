//
//  FribeSDKConfiguration.swift
//  Fribe
//
//  Created by mac on 14/06/2024.
//

import Foundation

public class FribeSDKConfiguration {
    public static let shared = FribeSDKConfiguration()
    
    private var clientId: String?
    private var secretKey: String?
    private var publishableKey: String?
    
    private init() {}
    
    public func setup(clientId: String, secretKey: String, publishableKey: String) {
        self.clientId = clientId
        self.secretKey = secretKey
        self.publishableKey = publishableKey
        // Perform any other setup you need
    }
    
    public func getClientId() -> String? {
        return clientId
    }
    
    public func getSecretKey() -> String? {
        return secretKey
    }
    
    public func getPublishableKey() -> String? {
        return publishableKey
    }
}
