//
//  NewCard.swift
//  Ayo
//
//  Created by Kiara on 09.04.23.
//

import SwiftUI


struct CreateCard: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var description = ""
    @State var cardTruth = false
    @State var cardShots = false
    @State var cardGroupactivity = false
    @State var category: Category = .familyfriendly
    
    var body: some View {
        VStack {
            Text("Create new Card").fontWeight(.bold)
            TextField("Card description", text: $description)
            Toggle("Is Truth", isOn: $cardTruth)
            Toggle("Is shots", isOn: $cardShots)
            Toggle("Is groupActivity", isOn: $cardGroupactivity)
            //category
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(description == "" ? Color.gray : Color.orange)
                    .frame(height: 40)
                Text("add card")
            }.onTapGesture {
                if description == "" {return}
                addItem()
                description = ""
                cardTruth = false
                cardShots = false
                cardGroupactivity = false
                category = .familyfriendly
            }
            
        }.padding()
    }
    
    
    private func addItem() {
        let newItem = Item(context: viewContext)
        newItem.text = description
        newItem.truth = cardTruth
        newItem.shots = cardShots
        newItem.groupActivity = cardGroupactivity
        newItem.category = Int64(category.rawValue)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
