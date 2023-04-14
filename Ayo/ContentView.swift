//
//  ContentView.swift
//  Ayo
//
//  Created by Kiara on 07.04.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var vm = Config()
    
    
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.truth, ascending: true)],
        predicate: NSPredicate(format: "truth == %@", NSNumber(value: true)),
        animation: .default)
    var truthCards: FetchedResults<Item>
    
    
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.truth, ascending: true)],
        predicate: NSPredicate(format: "truth == %@", NSNumber(value: false)),
        animation: .default)
    var dareCards: FetchedResults<Item>
    
    @State var offset = CGSize(width: 0, height: 0)
    @State var cardOpacity = 1.0
    
    @State var settingspresented: Bool = false
    @State var cardRotation = 0.0
    
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                CardView( vm: vm)
                    .rotation3DEffect(Angle(degrees: cardRotation), axis: (x: 0, y: 1, z: 0))
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
                                        showNewCard(true)
                                    }
                                    else {
                                        self.offset.width = 0
                                    }
                                }
                            })
                    )
                
                Spacer()
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.yellow)
                            .frame(height: 40)
                        Text("Truth")
                    }.onTapGesture {
                        withAnimation {
                            cardRotation = 180
                            cardOpacity = 0
                        }
                        showNewCard()
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colorScheme == .dark ? Color.black : Color.white)
                            .frame(width: 40, height: 40)
                            .shadow(color: colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7), radius: 3)
                        Image(systemName: "gearshape")
                    }.onTapGesture {
                        settingspresented = true
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.orange)
                            .frame(height: 40)
                        Text("Dare")
                    }.onTapGesture {
                        withAnimation {
                            cardRotation = 180
                            cardOpacity = 0
                        }
                        showNewCard(true)
                    }
                }
                
                
                Text("\(truthCards.count) Karten")
                
                
            }.padding()
                .sheet(isPresented: $settingspresented) {
                    SettingsView(vm: vm)
                }
        }
    }
    
    func showNewCard(_ dare: Bool = false){
        self.cardOpacity = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            cardRotation = 0
            self.offset.width = 0
            self.offset.height = 0
            vm.activeCard =  dare ? dareCards.randomElement() : truthCards.randomElement()
            
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
