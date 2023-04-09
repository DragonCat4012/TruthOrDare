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
    
    var body: some View {
        VStack{
            Text("settings ig")
            Text("manage sets")
            Text("mange favorites/blocked etc‚")
            Text("3 von 4 aktiv oder so")
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.green)
                    .frame(height: 40)
                Text("add card")
            }.onTapGesture {
                addItem()
            }
        }.padding()
    }
    
    
    private func addItem() {
            let newItem = Item(context: viewContext)
            newItem.text = "aha interesting"
            newItem.truth = true

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
