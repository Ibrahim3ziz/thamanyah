//
//  HomeTarget.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import NetworkKit

struct HomeTarget: BaseRequest {
    
    var scheme: String = "https"
    
    var baseURL: String = "api-v2-b2sit6oh3a-uc.a.run.app"
    
    var path: String = "home_sections"
    
    var method: HTTPMethod = .get
    
    var headers: [String : String]? = ["Content-Type": "application/json"]
    
    var parameter: [String : String]?
    
    var body: [String : Any]?
    
    // MARK: - Init
    init(page: Int = 1) {
        self.parameter = ["page": "\(page)"]
    }
}
