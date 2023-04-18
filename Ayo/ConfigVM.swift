//
//  ConfigVM.swift
//  Ayo
//
//  Created by Kiara on 09.04.23.
//

import Foundation
import CoreData


class Config: ObservableObject {
    @Published var activeCard: Item?
    @Published var activeSet: [Item] = []
    @Published var activeCategory = 2
    
    @Published var truthActive = true
    @Published var dareActive = true

    
    func updateViews(){
        self.objectWillChange.send()
    }
    
    func setSet(_ viewContext: NSManagedObjectContext){
        let fetchRequest: NSFetchRequest<Item>
        fetchRequest = Item.fetchRequest()
        
        fetchRequest.entity = Item.entity()
        fetchRequest.predicate = NSPredicate(format: "category == %@", NSNumber(value: activeCategory))
        do {
            let objects = try viewContext.fetch(fetchRequest)
            activeSet = objects
        } catch {}
        
        truthActive = !activeSet.filter {$0.truth == true}.isEmpty
        dareActive = !activeSet.filter {$0.truth == false}.isEmpty
    }
    
    func loadTruths(){
        activeCard = activeSet.filter {$0.truth == true}.randomElement()
    }
    
    func loadDares(){
        activeCard = activeSet.filter {$0.truth == false}.randomElement()
    }
}
