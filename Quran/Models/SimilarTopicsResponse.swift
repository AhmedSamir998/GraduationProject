//
//  SimilarTopicsResponse.swift
//  Quran
//
//  Created by Eyad Shokry on 5/30/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct SimilarTopicsResponse: Decodable {
    let Ranking: String
    let SubTopics: [String]
    let Topic: String
    let ayat: [Aya]
}

struct Aya: Decodable {
    let AyaText: String
    let ChapterNUM: String
    let PartNUM: String
    let SoraName: String
    let VerseNUM: String
}
