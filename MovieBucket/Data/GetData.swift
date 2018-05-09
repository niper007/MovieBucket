//
//  GetData.swift
//  MovieBucket
//
//  Created by Niklas Persson on 2018-05-09.
//  Copyright © 2018 Niklas Persson. All rights reserved.
//

import Foundation

let POPULAR_MOVIES = "https://api.themoviedb.org/3/discover/movie?api_key=07818be4aa5cd458ed604c904737e592&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"

let RATING_MOVIES = "https://api.themoviedb.org/3/discover/movie?api_key=07818be4aa5cd458ed604c904737e592&language=en-US&include_adult=false&include_video=false&page=1&vote_average.gte=8.0"

let OLD_MOVIES = "https://api.themoviedb.org/3/discover/movie?api_key=07818be4aa5cd458ed604c904737e592&language=en-US&include_adult=false&include_video=false&page=1&primary_release_date.lte=1999-12-31"
