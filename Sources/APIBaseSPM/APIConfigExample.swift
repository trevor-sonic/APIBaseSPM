//
//  ApiConfig.swift
//  API Base SPM
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 09/08/2023.
//  Copyright © 2023 Proagrica-AH. All rights reserved.
//

import Foundation

// MARK: - Config Api endpoints
public enum ExampleEndpoint: ApiEndpointProtocol {
    
    case rawEndpoint(_ endpoint: String, _ method: String)
    case getUser
    case getCountries
    
    public var path: String {
        switch self {
        case .rawEndpoint(let endpoint, _): return endpoint
        case .getUser: return "/api/user"
        case .getCountries: return "/api/countries/locales"
        }
    }
    
    public var method: String {
        switch self {
        case .rawEndpoint(_, let method): return method
        case .getCountries: return "GET"
        case .getUser: return "POST"
        }
    }
}

// MARK: - Config Api parameters
public enum ExampleParameter: ApiParameterProtocol {
    case rawParameter(_ key: String, _ value: String)
    case userID(String)
    
    public var key: String {
        switch self {
        case .rawParameter(let key, _): return key
        case .userID(_): return "UserID"
        }
    }
    
    public var value: String {
        switch self {
        case .rawParameter(_, let value): return value
        case .userID(let value): return value
        }
    }
}



// MARK: - Another Api environment
public enum AnotherExampleParameter: ApiParameterProtocol {
    case abc
    
    public var key: String {
        switch self {
        case .abc: return "abc"
        }
    }
    
    public var value: String {
        switch self {
        case .abc: return "abc"
        }
    }
}
