//
//  BaseConfig.swift
//  
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/08/2023.
//

import Foundation



// MARK: - This RawEndpoint is used as default base access to facilitate direct test to API
public enum RawEndpoint: ApiEndpointProtocol {
    /// path (String) ex: "/user"  and method (String) ex: "GET"
    case with(_ endpoint: String, _ method: String)

    
    public var path: String {
        switch self {
        case .with(let endpoint, _): return endpoint
        }
    }
    
    public var method: String {
        switch self {
        case .with(_, let method): return method
        }
    }
}

// MARK: - This RawEndpoint is used as default base access to facilitate direct test to API
 enum RawParameter: ApiParameterProtocol {
    
     case with(_ key: String, _ value: String)
    
    var key: String {
        switch self {
        case .with(let key, _): return key
        }
    }
    
    var value: String {
        switch self {
        case .with(_, let value): return value
        }
    }
}
