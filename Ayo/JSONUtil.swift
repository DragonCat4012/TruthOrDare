//
//  JSONUtil.swift
//  Ayo
//
//  Created by Kiara on 11.04.23.
//

import Foundation
import CoreData


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
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(truth, forKey: .truth)
        try container.encode(shots, forKey: .shots)
        try container.encode(groupActivity, forKey: .groupActivity)
        try container.encode(category, forKey: .category)
    }
}


func writeJSON(_ data: String) -> URL{
    let DocumentDirURL = try! FileManager.default
        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("example").appendingPathExtension("json")
    
    do {
        try data.write(to: DocumentDirURL, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        print("Failed writing to URL: \(DocumentDirURL), Error: " + error.localizedDescription)
    }
    return DocumentDirURL
}
