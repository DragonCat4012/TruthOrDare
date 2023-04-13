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
        entity: Item.entity(),
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
                            .navigationTitle("Manage Cards")
                    } label: {
                        Text("Manage Cards")
                    }
                }
                
                Section {
                    CreateCard()
                }
                
                Section {
                    
                    Button {
                        loadDemoData()
                    } label: {
                        Text("Load default Data")
                    }

                    Text("Export Data")
                }
                
            }.onAppear{
                getActiveCards()
            }
            .onChange(of: vm.activeCategory) { _ in
                getActiveCards()
            }
            .navigationTitle("Settings")
        }
    }
    
    func getActiveCards() {
        let fetchRequest: NSFetchRequest<Item>
        fetchRequest = Item.fetchRequest()
        
        fetchRequest.entity = Item.entity()
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
    
    private func loadDemoData(){
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = viewContext
        
        do {
            if let file = Bundle.main.path(forResource: "demo", ofType: "json"){
                let json = try! String(contentsOfFile: file, encoding: String.Encoding.utf8).data(using: .utf8)!
                let products = try! decoder.decode([Item].self, from: json)
            }
        }
    
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
