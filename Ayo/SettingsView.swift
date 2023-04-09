//
//  SettingsView.swift
//  Ayo
//
//  Created by Kiara on 07.04.23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.truth, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var selectedCategory = 2
    
    var body: some View {
        NavigationStack {
            List{
                VStack{
                    Text("Change active category")
                        .fontWeight(.bold)
                    Picker("Category: ", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.rawValue) { cat in
                            Text(categoryString(cat))
                            // TODO: actually set category
                        }
                    }
                    Text("3 of \(items.count) cards active")
                        .font(.footnote)
                }
                
                NavigationLink {
                    EditCardsView()
                } label: {
                    Text("mange cards")
                }
                
                CreateCard()
            }
        }
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
