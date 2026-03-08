//
//  SearchTarget.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 08/03/2026.
//

import NetworkKit

struct SearchTarget: BaseRequest {
    
    var scheme: String = "https"
    
    var baseURL: String = "mock.apidog.com"
    
    var path: String = "m1/735111-711675-default/search"
    
    var method: HTTPMethod = .get
    
    var headers: [String : String]? = ["Content-Type": "application/json"]
    
    var parameter: [String : String]?
    
    var body: [String : Any]?
    
    // MARK: - Init
    init(query: String) {
        self.parameter = ["query": query]
    }
}
