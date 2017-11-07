//
//  Game.swift
//  GameReviewer
//
//  Created by Ethan Mathew on 11/4/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit

class Game: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var summary: String
    var favorite: Bool
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("games")
    static let ArchiveURL2 = DocumentsDirectory.appendingPathComponent("favorites")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let summary = "summary"
        static let favorite = "favorite"
    }
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int, summary: String, favorite: Bool) {
    
        guard !name.isEmpty else {
            return nil
        }
        
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        guard !summary.isEmpty else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        self.summary = summary
        self.favorite = favorite
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(summary, forKey: PropertyKey.summary)
        aCoder.encode(favorite, forKey: PropertyKey.favorite)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            return nil
        }
        
        guard let summary = aDecoder.decodeObject(forKey: PropertyKey.summary) as? String else {
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        let favorite = aDecoder.decodeBool(forKey: PropertyKey.favorite)
        
        self.init(name: name, photo: photo, rating: rating, summary: summary, favorite: favorite)
        
    }
}
