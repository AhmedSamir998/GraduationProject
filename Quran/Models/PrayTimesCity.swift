//
//  PrayTimesCity.swift
//  Quran
//
//  Created by Eyad Shokry on 4/4/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

struct PrayTimesDataCity: Decodable {
    let code: Int
    let status: String
    let results: CityResultsData
}

struct CityResultsData: Decodable {
    let datetime: [CityDateTimeData]
    let location: CityLocationData
    let settings: CitySettingsData
}

struct CityDateTimeData: Decodable {
    let times: CityTimeData
    let date: CityDateData
}

struct CityTimeData: Decodable {
    let Imsak: String
    let Sunrise: String
    let Fajr: String
    let Dhuhr: String
    let Asr: String
    let Sunset: String
    let Maghrib: String
    let Isha: String
    let Midnight: String
}

struct CityDateData: Decodable {
    let timestamp: Double
    let gregorian: String
    let hijri: String
}

struct CityLocationData: Decodable {
    let latitude: Double
    let longitude: Double
    let elevation: Double
    //let city: String
    let country: String
    let country_code: String
    let timezone: String
    let local_offset: Double
}

struct CitySettingsData: Decodable {
    let timeformat: String
    let school: String
    let juristic: String
    let highlat: String
    let fajr_angle: Double
    let isha_angle: Double
}
