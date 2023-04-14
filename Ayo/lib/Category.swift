//
//  Util.swift
//  Ayo
//
//  Created by Kiara on 07.04.23.
//

import Foundation


enum Category: Int, CaseIterable {
    case sporty = 1, familyfriendly = 2, nsfw = 3, cringe = 4
}




func getCategory(_ num: Int64) -> Category {
    if num < 1 ||  num > 4 {
        return .familyfriendly
    }
    return Category.init(rawValue: Int(num))!
}


func getCategoryNumber(_ cat: Category) -> Int64 {
    return Int64(cat.rawValue)
}


func categoryString(_ cat: Category) -> String {
    switch cat{
    case .sporty:
        return "Sporty"
    case .familyfriendly:
        return "Family friendly"
    case .nsfw:
        return "NSFW"
    case .cringe:
        return"Cringe"
    }
}

func categoryIcon(_ num: Int64) -> String{
    let cat = getCategory(num)
    switch cat {
    case .sporty:
        return "figure.disc.sports"
    case .familyfriendly:
        return "figure.2.and.child.holdinghands"
    case .nsfw:
        return "18.circle"
    case .cringe:
        return  "party.popper"
    }
}
