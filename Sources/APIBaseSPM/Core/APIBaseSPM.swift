// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

// MARK: - Protocols
public protocol ApiEndpointProtocol {
    var path: String { get }
    var method: String { get }
}
public protocol ApiParameterProtocol {
    var key: String { get }
    var value: String { get }
}



// MARK: - ApiBase Class

public class ApiBase {
    private var url: URL!
    private var endpoint: ApiEndpointProtocol = DefaultEndpoint.default

    private var headers: [String: String] = [:]
    private var parameters: [String: Any] = [:]
    private var jsonPayload: Data?

    public enum DefaultEndpoint: ApiEndpointProtocol {
        case `default`
        
        public var path: String { return "/" }
        public var method: String { return "GET" }
    }
    
    public init() {}
    
    public func baseURL(_ baseURL: String) -> Self {
        self.url = URL(string: baseURL)
        return self
    }
    
    public func endpoint(_ endpoint: ApiEndpointProtocol) -> Self {
        self.endpoint = endpoint
        return self
    }
    
    public func endpoint(path: String, method: String) -> Self {
        self.endpoint = RawEndpoint.with(path, method)
        return self
    }
    
    public func parameter(_ value: ApiParameterProtocol) -> Self {
        self.parameters[value.key] = value.value
        return self
    }
    
    public func parameter(key: String, value: String) -> Self {
        self.parameters[key] = value
        return self
    }

    public func header(key: String, value: String) -> Self {
        self.headers[key] = value
        return self
    }
    
    public func bearer(token: String) -> Self {
        self.headers["Authorization"] = "Bearer " + token
        return self
    }
    // MARK: - Request with JSON object
    // This method allows you to set the JSON payload that should be sent with the request.
    public func jsonBody<T: Encodable>(_ value: T) -> Self {
        do {
            let data = try JSONEncoder().encode(value)
            self.jsonPayload = data
            return self
        } catch {
            fatalError("Failed to encode JSON: \(error)")
        }
    }
    
    public func jsonBody(_ jsonString: String) -> Self {
        if let data = jsonString.data(using: .utf8) {
            self.jsonPayload = data
            return self
        } else {
            fatalError("Failed to convert JSON string to Data")
        }
    }

  
    
    // MARK: - Request Types
    public func asJSON() -> AnyPublisher<String, Error> {
        return makeRequest()
            .map { String(data: $0.data, encoding: .utf8) ?? "" }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func asImage() -> AnyPublisher<Data, Error> {
        return makeRequest().map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func asData() -> AnyPublisher<Data, Error> {
        return makeRequest().map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func makeRequest() -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        guard let url = self.url?.appendingPathComponent(endpoint.path) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = headers
        
        if let jsonPayload = jsonPayload {
            request.httpBody = jsonPayload
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } else if !parameters.isEmpty {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                return Fail(error: URLError(.badServerResponse))
                    .eraseToAnyPublisher()
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .eraseToAnyPublisher()
    }

    
//    private func makeRequest() -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
//        guard let url = self.url?.appendingPathComponent(endpoint.path) else {
//            return Fail(error: URLError(.badURL))
//                .eraseToAnyPublisher()
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = endpoint.method
//        request.allHTTPHeaderFields = headers
//        
//        if !parameters.isEmpty {
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//            } catch {
//                return Fail(error: URLError(.badServerResponse))
//                    .eraseToAnyPublisher()
//            }
//        }
//        
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .eraseToAnyPublisher()
//    }
}




