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
    @State var selectedCategory = 2
    
    var body: some View {
        VStack {
            Text("cardHeadline").fontWeight(.bold)
            TextField("cardDesc", text: $description)
            Toggle("cardTruth", isOn: $cardTruth)
            Toggle("cardShots", isOn: $cardShots)
            Toggle("cardGroup", isOn: $cardGroupactivity)
            
            Picker("category", selection: $selectedCategory) {
                ForEach(Category.allCases, id: \.rawValue) { cat in
                    if cat != .all {
                        Text(categoryString(cat))
                    }
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(description == "" ? Color.gray : Color.orange)
                    .frame(height: 40)
                Text("addCard")
            }.onTapGesture {
                print(selectedCategory)
                if description == "" {return}
                addItem()
                description = ""
                cardTruth = false
                cardShots = false
                cardGroupactivity = false
                selectedCategory = 2
            }
        }
    }
    
    private func addItem() {
        let newItem = Item(context: viewContext)
        newItem.text = description
        newItem.truth = cardTruth
        newItem.shots = cardShots
        newItem.groupActivity = cardGroupactivity
        newItem.category = Int64(selectedCategory)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
