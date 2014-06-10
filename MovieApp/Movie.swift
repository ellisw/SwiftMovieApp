//
//  Movie.swift
//  MovieApp
//
//  Created by Ellis Weng on 6/8/14.
//  Copyright (c) 2014 Ellis Weng. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var title : NSString
    var posterUrl : NSURL
    var posterDetailedUrl : NSURL
    var movieDescription : NSString

    init(title : NSString, posterUrl : NSString, posterDetailedUrl: NSString, movieDescription : NSString) {
        self.title = title
        self.posterUrl = NSURL.URLWithString(posterUrl)
        self.posterDetailedUrl = NSURL.URLWithString(posterDetailedUrl)
        self.movieDescription = movieDescription
    }

    convenience init(_ jsonDictionary : NSDictionary) {
        let posterUrls : (AnyObject!) = jsonDictionary.objectForKey("posters")

        // Can't use subscript syntax due to bug with swift
        self.init(
            title : jsonDictionary.objectForKey("title") as NSString,
            posterUrl : posterUrls.objectForKey("thumbnail") as NSString,
            posterDetailedUrl : posterUrls.objectForKey("detailed") as NSString,
            movieDescription : jsonDictionary.objectForKey("synopsis") as NSString)
    }
}
