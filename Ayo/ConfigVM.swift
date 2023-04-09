//
//  ConfigVM.swift
//  Ayo
//
//  Created by Kiara on 09.04.23.
//

import Foundation


class Config: ObservableObject {
    @Published var activeCard: Item?

    
    func updateViews(){
        self.objectWillChange.send()
    }
}
