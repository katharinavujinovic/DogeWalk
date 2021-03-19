//
//  DogBreedAPI.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 19.03.21.
//

import Foundation
import UIKit

class DogBreedAPI {
    
    static let dogURL = URL(string: "https://dog.ceo/api/breeds/list/all")!
    
    class func fetchBreedList(url: URL, completionhandler: @escaping(DogBreedResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionhandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let breedList = try! decoder.decode(DogBreedResponse.self, from: data)
            completionhandler(breedList, nil)
        }
        task.resume()
    }
}
