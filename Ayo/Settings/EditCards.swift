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
                    if cat != .all {
                        Section(categoryString(cat)) {
                            let cards = getItems(cat)
                            if !cards.isEmpty {
                                ForEach(cards) { card in
                                    HStack{
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(card.truth ? cardYellow : cardOrange)
                                                .frame(width: 35, height: 35)
                                            Text("\(card.objectID.uriRepresentation().lastPathComponent.trimmingCharacters(in: ["p"]))")
                                        }
                                        
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
    }
    
    func getItems(_ cat: Category) -> [Item] {
        items.filter {$0.category == cat.rawValue}
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
