//
//  TopicResponse.swift
//  Quran
//
//  Created by Eyad Shokry on 5/11/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct TopicResponse: Decodable {
    let Ayat: [Ayat]
    let SubTopics: [String]
    
  
}

struct Ayat: Decodable {
    let AyaText: String
    let ChapterNUM: String
    let PartNUM: String
    let SoraName: String
    let VerseNUM: String
}
