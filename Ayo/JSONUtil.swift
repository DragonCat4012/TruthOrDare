//
//  JSONUtil.swift
//  Ayo
//
//  Created by Kiara on 11.04.23.
//

import Foundation
import CoreData

struct JSON {
    static func loadJSON() ->[Item]{
        var values: [Item] = [ ]
        let decoder = JSONDecoder()

        
        do {
            print("file missing qwq")
            if let file = Bundle.main.path(forResource: "demo", ofType: "json"){
                print("ayo")
                let json = try! String(contentsOfFile: file, encoding: String.Encoding.utf8).data(using: .utf8)!
                print("ayo 222")
                print(json)
                
                let products = try! decoder.decode([Item].self, from: json)
                values = products
            }
        }
        return values
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

@objc(Item)
class Item: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case text, truth, shots,groupActivity,category
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.truth = try container.decode(Bool.self, forKey: .truth)
        self.shots = try container.decode(Bool.self, forKey: .shots)
        self.groupActivity = try container.decode(Bool.self, forKey: .groupActivity)
        self.category = try container.decode(Int64.self, forKey: .category)
        
        print(">>>>>")
        print(self)
    }
}
