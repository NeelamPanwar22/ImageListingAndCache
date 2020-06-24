//
//  PhotosModel.swift
//  AssignedTask1MG
//
//  Created by neelam panwar on 24/06/20.
//  Copyright © 2020 neelam panwar. All rights reserved.
//

import Foundation

struct PhotoMainModel : Codable {
    
    let photos : PhotoModel?
    let stat : String?
    
    enum CodingKeys : String , CodingKey {
           case photos = "photos"
           case stat = "stat"
          
       }
       
       init(from decoder: Decoder) throws {
           let values = try decoder.container(keyedBy: CodingKeys.self)
           stat = try values.decodeIfPresent(String.self, forKey: .stat)
           photos = try values.decodeIfPresent(PhotoModel.self, forKey: .photos)
       }
}

struct PhotoModel : Codable {
    
    let currentPage : Int?
    let totalPagesCount : Int?
    var photosList : [PhotoDetailModel]?
    let itemPerPageCount : Int?
    
    enum CodingKeys : String , CodingKey {
        case currentPage = "page"
        case totalPagesCount = "pages"
        case photosList = "photo"
        case itemPerPageCount = "perpage"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currentPage = try values.decodeIfPresent(Int.self, forKey: .currentPage)
        totalPagesCount = try values.decodeIfPresent(Int.self, forKey: .totalPagesCount)
        photosList = try values.decodeIfPresent([PhotoDetailModel].self, forKey: .photosList)
        itemPerPageCount = try values.decodeIfPresent(Int.self, forKey: .itemPerPageCount)
    }
    
}

struct PhotoDetailModel : Codable {
    
    let id : String?
    let secret : String?
    let server : String?
    let imageUrl : String?
    let farm : Int?
    
    enum CodingKeys : String , CodingKey {
        case id = "id"
        case secret = "secret"
        case server = "server"
        case farm = "farm"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        secret = try values.decodeIfPresent(String.self, forKey: .secret)
        server = try values.decodeIfPresent(String.self, forKey: .server)
        farm = try values.decodeIfPresent(Int.self, forKey: .farm)
        imageUrl = "http://farm\(farm ?? 0).staticflickr.com/\(server ?? "" )/\(id ?? "" )_\(secret ?? "").jpg"
        
    }
}
