//
//  APIStructs.swift
//  Spots
//
//  Created by Kathryn Krumholz on 12/11/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import Foundation

 struct APIResults: Decodable {
    let results: [Results]
    let html_attributions: [String]
    let next_page_token: String?
 }
 
 struct Results: Decodable {
      let name: String?
      let formatted_address: String?
      let place_id: String?
      let geometry: Geometry?
         }

 struct Geometry: Decodable {
     let location: Location?
     let viewport: Viewport?
 }
 
 struct Location: Decodable {
     let lat: Double
     let lng: Double
 }
 
 struct Viewport: Decodable {
     let northeast: [String:Double]?
     let southwest: [String:Double]?
 }
