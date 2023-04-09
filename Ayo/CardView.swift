//
//  CardView.swift
//  Ayo
//
//  Created by Kiara on 07.04.23.
//

import SwiftUI

struct CardView: View {
    @Binding var activeItem: Item?
    
    var body: some View {
        ZStack {
            if (activeItem == nil) {
                RoundedRectangle(cornerRadius: 8).fill(activeItem != nil ?  Color.orange : Color.gray)
                Text("oh no")
            } else{
                let cat = getCategory(activeItem!.category)
                
                RoundedRectangle(cornerRadius: 8).fill(Color.orange)
                
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
