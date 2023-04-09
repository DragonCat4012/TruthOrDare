//
//  CardView.swift
//  Ayo
//
//  Created by Kiara on 07.04.23.
//

import SwiftUI

var cardOrange = Color(red: 242/255, green: 170/255, blue: 92/255)
var cardYellow = Color(red: 242/255, green: 214/255, blue: 92/255)

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var activeItem: Item?
    
    var body: some View {
        ZStack {
            if (activeItem == nil) {
                RoundedRectangle(cornerRadius: 8).fill(colorScheme == .dark ? Color.black : Color.white)
                    .shadow(color: colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7), radius: 3)
                Text("oh no")
            } else{
                let cat = getCategory(activeItem!.category)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(activeItem!.truth ? cardYellow : cardOrange)
                    .shadow(radius: 5)
                
                VStack {
                    HStack {
                        if activeItem!.groupActivity {
                            Image(systemName: "person.2.fill")
                        }
                        
                        Spacer()
                        
                        HStack{
                            Image(systemName: categoryIcon(activeItem!.category))
                            Text(categoryString(cat))
                            Image(systemName: categoryIcon(activeItem!.category))
                        }
                        Spacer()
                        if activeItem!.shots {
                            Image(systemName: "wineglass")
                        }
                        
                    }
                    Spacer()
                    
                    Text(activeItem?.text ?? "No text")
                        .font(.headline)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "nosign")
                        Spacer()
                        Text("Nr: \(activeItem!.objectID.uriRepresentation().lastPathComponent.trimmingCharacters(in: ["p"]))").font(.footnote)
                        Spacer()
                        Image(systemName: "star")
                    }
                }.padding()}
        }.frame(height: 500).padding()
        
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(activeItem: Binding.constant(nil))
    }
}
