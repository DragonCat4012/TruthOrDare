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
            RoundedRectangle(cornerRadius: 8).fill(activeItem != nil ?  Color.orange : Color.gray)
               
            VStack {
                HStack {
                    Image(systemName: "person.2.fill")
                    Spacer()
                    Text("category")
                    Spacer()
                    Image(systemName: "wineglass")
                }
                Spacer()
                Text(activeItem?.text ?? "No text")
                Spacer()
                HStack {
                    Image(systemName: "nosign")
                    Spacer()
                    Image(systemName: "star")
                }
            }.padding()
        }.frame(height: 500).padding()
       
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(activeItem: Binding.constant(nil))
    }
}
