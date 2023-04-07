//
//  ContentView.swift
//  Ayo
//
//  Created by Kiara on 07.04.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.truth, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    
    @State var activeItem: Item?

    var body: some View {
        VStack {
            CardView(activeItem: $activeItem)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue)
                    .frame(height: 40)
                Text("Truth")
            }
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.green)
                    .frame(height: 40)
                Text("Dare")
            }.onTapGesture {
                activeItem = items.randomElement()
            }
            Text("\(items.count) Karten")
           
           
        }.padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
