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
    
    @State private var offset = CGSize(width: 0, height: 0)
    @State var cardOpacity = 1.0
    
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                CardView(activeItem: $activeItem)
                    .offset(offset)
                    .opacity(cardOpacity)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            self.offset.width = gesture.translation.width
                        })
                            .onEnded({ gesture in
                                withAnimation{
                                    if gesture.translation.width < -200 {
                                        self.offset.width = -400
                                        cardOpacity = 0
                                        showNewCard()
                                    } else if  gesture.translation.width > 200{
                                        self.offset.width = 400
                                        cardOpacity = 0
                                        showNewCard()
                                    }
                                    else {
                                        self.offset.width = 0
                                    }
                                }
                            })
                    )
                
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
    
    func showNewCard(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.offset.width = 0
            withAnimation{
                self.cardOpacity = 1
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
