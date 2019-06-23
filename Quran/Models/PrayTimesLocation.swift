//
//  PrayerTimes.swift
//  Quran
//
//  Created by Eyad Shokry on 3/29/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

struct PrayTimesDataLocation: Decodable {
    let code: Int
    let status: String
    let results: ResultsData
}

struct ResultsData: Decodable {
    let datetime: [DateTimeData]
    let location: LocationData
    let settings: SettingsData
}

struct DateTimeData: Decodable {
    let times: TimeData
    let date: DateData
}

struct TimeData: Decodable {
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

struct DateData: Decodable {
    let timestamp: Double
    let gregorian: String
    let hijri: String
}

struct LocationData: Decodable {
    let latitude: Double
    let longitude: Double
    let elevation: Double
    //let city: String
    let country: String
    let country_code: String
    let timezone: String
    let local_offset: Double
}

struct SettingsData: Decodable {
    let timeformat: String
    let school: String
    let juristic: String
    let highlat: String
    let fajr_angle: Double
    let isha_angle: Double
}

