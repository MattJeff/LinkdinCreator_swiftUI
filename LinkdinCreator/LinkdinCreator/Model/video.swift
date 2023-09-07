//
//  video.swift
//  LinkdinCreator
//
//  Created by Mathis Higuinen on 07/09/2023.
//

import Foundation
struct VideoData: Identifiable, Codable {
    var id = UUID()
    var url: String
    var transcription: String
    var summary: String
    var linkedinPost: String
}
