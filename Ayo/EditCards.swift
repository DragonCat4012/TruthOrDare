//
//  EditCards.swift
//  Ayo
//
//  Created by Kiara on 09.04.23.
//

import SwiftUI

struct EditCardsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.truth, ascending: true)],
        animation: .default)
    var items: FetchedResults<Item>
    
    var body: some View {
        if items.isEmpty {
            Text("no items qwq")
        } else {
            List{
                Section{
                    HStack{
                        Text("ID")
                        Text("card description")
                            .lineLimit(1)
                    }
                }
                
                ForEach(Category.allCases, id: \.rawValue) { cat in
                    Section(categoryString(cat)) {
                        ForEach(items) { card in
                            if card.category == cat.rawValue {
                                HStack{
                                    Text("\(card.objectID.uriRepresentation().lastPathComponent.trimmingCharacters(in: ["p"]))")
                                    Text(card.text ?? "-")
                                        .lineLimit(1)
                                }.swipeActions {
                                    Button {
                                        card.blocked = !card.blocked
                                        saveContext()
                                    } label: {
                                        Image(systemName: "nosign")
                                    }

                                    Button {
                                        viewContext.delete(card)
                                        saveContext()
                                    } label: {
                                        Image(systemName: "trash")
                                    }  .tint(.red)
                                  
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func saveContext(){
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
