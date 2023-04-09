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
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.truth, ascending: true)],
        predicate: NSPredicate(format: "truth == %@", NSNumber(value: true)),
        animation: .default)
    var truthCards: FetchedResults<Item>
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.truth, ascending: true)],
        predicate: NSPredicate(format: "truth == %@", NSNumber(value: false)),
        animation: .default)
    var dareCards: FetchedResults<Item>
    
    @State var offset = CGSize(width: 0, height: 0)
    @State var cardOpacity = 1.0
    
    @State var settingspresented: Bool = false
    
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                CardView( vm: vm)
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
                            cardOpacity = 0
                            offset.height = -200
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
                            cardOpacity = 0
                            offset.height = -200
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.offset.width = 0
            self.offset.height = 0
            
            withAnimation{
                vm.activeCard =  dare ? dareCards.randomElement() : truthCards.randomElement()
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
