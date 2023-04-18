//
//  CardView.swift
//  Ayo
//
//  Created by Kiara on 07.04.23.
//

import SwiftUI

var cardOrange = Color(red: 242/255, green: 170/255, blue: 92/255)
var cardYellow = Color(red: 242/255, green: 214/255, blue: 92/255)


var cardOrangeDarker = Color(red: 181/255, green: 108/255, blue: 37/255)
var cardYellowDarker = Color(red: 207/255, green: 175/255, blue: 14/255) 

struct CardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var vm: Config
    
    var body: some View {
        let card = vm.activeCard
        ZStack {
            if (card == nil) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorScheme == .dark ? Color.black : Color.white)
                    .shadow(color: colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7), radius: 3)
                Text("No active Card selected, swipe or press button to start :3")
                    .multilineTextAlignment(.center)
            } else{
                let card = vm.activeCard!
                let cat = getCategory(card.category)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorScheme == .dark ? Color.black : Color.white)
                    .shadow(radius: 5)
                
                VStack() {
                    HStack {
                        if card.groupActivity {
                            Image(systemName: "person.2.fill")
                        }
                        
                        Spacer()
                        
                        HStack{
                            Image(systemName: categoryIcon(card.category))
                          //  Text(categoryString(cat))
                          //  Image(systemName: categoryIcon(card.category))
                        }
                        Spacer()
                        if card.shots {
                            Image(systemName: "wineglass")
                        }
                        
                    }
                    Spacer()
                    
                    Text(card.text ?? "No text")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                    
                    Spacer()
                    
                   HStack {
                       /* Image(systemName: card.blocked ? "xmark.app.fill": "xmark.app")
                            .onTapGesture {
                                card.blocked = !card.blocked
                                saveContext()
                                vm.updateViews()
                            }*/
                        Spacer()
                        Text("Nr: \(card.objectID.uriRepresentation().lastPathComponent.trimmingCharacters(in: ["p"]))").font(.footnote)
                        Spacer()
                        /*Image(systemName: card.liked ? "star.fill" :"star")
                            .onTapGesture {
                                card.liked = !card.liked
                                saveContext()
                                vm.updateViews()
                            }*/
                    }
                }.padding()
                    .foregroundColor(textColor())
            }
        }.frame(height: 500).padding()
    }
    
    func textColor()->Color{
        guard let card = vm.activeCard else {
            return Color.red
        }
        if card.truth {
            return colorScheme == .dark ? cardYellow : cardYellowDarker
        } else {
            return  colorScheme == .dark ? cardOrange : cardOrangeDarker
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

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView( vm: Config())
    }
}
