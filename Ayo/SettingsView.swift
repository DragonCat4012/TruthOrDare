//
//  SettingsView.swift
//  Ayo
//
//  Created by Kiara on 07.04.23.
//

import SwiftUI
import Foundation
import CoreData

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.truth, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var activeItems = 0
    
    @ObservedObject var vm: Config
    
    var body: some View {
        NavigationStack {
            List{
                Section {
                    VStack{
                        Text("Change active category")
                            .fontWeight(.bold)
                        Picker("Category: ", selection: $vm.activeCategory) {
                            ForEach(Category.allCases, id: \.rawValue) { cat in
                                Text(categoryString(cat))
                            }
                        }
                        Text("\(activeItems) of \(items.count) cards active")
                            .font(.footnote)
                    }
                    
                    NavigationLink {
                        EditCardsView()
                    } label: {
                        Text("mange cards")
                    }
                }
                
                Section {
                    CreateCard()
                }
            }.onAppear{
                getActiveCards()
            }
        }
    }
    
    func getActiveCards() {
        let fetchRequest: NSFetchRequest<Item>
        fetchRequest = Item.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "category == %@", NSNumber(value: vm.activeCategory))
        do {
            let objects = try viewContext.fetch(fetchRequest)
            activeItems = objects.count
        } catch {}
        
    }
    
    
    private func deleteItems(offsets: IndexSet) {
        offsets.map { items[$0] }.forEach(viewContext.delete)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
