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

    var headers: [String: String] = [:]
    var parameters: [String: Any] = [:]
    

    
    
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
    
    public func parameter(_ value: ApiParameterProtocol) -> Self {
        self.parameters[value.key] = value.value
        return self
    }

    public func header(key: String, value: String) -> Self {
        self.headers[key] = value
        return self
    }
    
    public func bearer(token: String) -> Self {
        self.headers["Authorization"] = token
        return self
    }
    
    public func lfwID(_ lfwID: String) -> Self {
        self.headers["lfwID"] = lfwID
        return self
    }
    
    public func date(_ date: String) -> Self {
        self.parameters["date"] = date
        return self
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
    
    private func makeRequest() -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        guard let url = self.url?.appendingPathComponent(endpoint.path) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = headers
        
        if !parameters.isEmpty {
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
}




