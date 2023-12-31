//
//  APIBaseView.swift
//  
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/08/2023.
//

import SwiftUI
import Combine



@MainActor class APIAccess: ObservableObject {
    
    private let apiBase = ApiBase()
    private var cancelable = Set<AnyCancellable>()
    
    @Published var jsonResult: String = "..."
    
  /*
    let jsonString =
"""
{
    "model": "gpt-3.5-turbo",
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful assistant."
      },
      {
        "role": "user",
        "content": "Hello!"
      }
    ]
}
"""
    */
    
    
    let jsonString =
"""
{
    "model": "gpt-3.5-turbo",
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful assistant."
      },
      {
        "role": "user",
        "content": "Hello!"
      }
    ]
}
"""
    
    
    func callApi(){
        
        // Usage Example
        ApiBase()
            .baseURL("https://api.openai.com/v1")
            .bearer(token: "zxywertNFokJdGxxxxx")
            .endpoint(path: "/chat/completions", method: "POST")
            .jsonBody(jsonString)
        
        //.bearer(token: "")
        //.endpoint(ExampleEndpoint.getCountries)
        //.endpoint(ApiEndpoint.rawEndpoint("/api/countries/locales", "GET"))
        //.parameter(ApiParameter.rawParameter("key", "value"))
        //.parameter(ExampleParameter.userID("12345"))
        //.header(key: "X-App-Key", value: "8f7e9a7b5b")
        //.bearer(token: "xyz")
        //.parameter(key: "param1", value: "value1")
        
            .asJSON()
            .sink { completion in
                switch completion {
                case .finished:
                    print("Request completed")
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            } receiveValue: { [weak self] json in
                print("JSON response: \(json)")
                DispatchQueue.main.async {
                    self?.jsonResult = json
                }
                
            }
            .store(in: &cancelable)
    }
}

public struct APIBaseView: View {
    
   // MARK: - init
    public init(){}
    
    @ObservedObject var apiAccess = APIAccess()
    
    public var body: some View {
        VStack{
            Button{
                apiAccess.jsonResult = "Requesting..."
                apiAccess.callApi()
            } label: {
                Text("Call API")
                    .padding()
                    .font(.title)
                    .background(Color.orange)
                    .foregroundColor(.white)
                
                
            }
            Text("JSON Result").font(.title)
            Text(apiAccess.jsonResult)
        }
    }
    
    
}

#Preview {
    APIBaseView()
}

