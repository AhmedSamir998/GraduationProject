//
//  Client+Extension.swift
//  Quran
//
//  Created by Eyad Shokry on 5/29/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

extension Client {
    
    struct PrayerTimesConstants {
        static let APIScheme = "https"
        static let APIHost = "api.pray.zone"
        static let APIPath = "/v2/times/today.json"
    }
    
    struct TopicSearchingConstants {
        static let APIScheme = "http"
        static let APIHost = "127.0.0.1:5000"
        static let TopicAPIPath = "/api/v1/resources/topic"
        static let TopicsAPIPath = "/api/v1/resources/topic"
    }
    
 
}
