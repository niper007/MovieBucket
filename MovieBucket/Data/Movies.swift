//
//  Movies.swift
//  MovieBucket
//
//  Created by Niklas Persson on 2018-05-09.
//  Copyright © 2018 Niklas Persson. All rights reserved.
//

import Foundation

struct Movies:Decodable{
    
    let page: Int
    let total_results : Int
    let total_pages: Int
    let results:[Content]
    
    struct Content : Codable {
        let poster_path:String
        let adult: Bool
        let overview: String
        let release_date: String
        let genre_ids: [Int]
        let id: Int
        let original_title:String
        let original_language: String
        let title: String
        let backdrop_path: String
        let popularity: Double
        let vote_count: Int
        let video: Bool
        let vote_average: Float
    }
    
}
