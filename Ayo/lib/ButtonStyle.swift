//
//  ButtonStyle.swift
//  Ayo
//
//  Created by Kiara on 18.04.23.
//

import SwiftUI


struct UserButton: View {
    let text: String
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var vm: Config
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .dark ? Color.black : Color.white)
                .shadow(color: colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7), radius: 3)
                .frame(height: 40)
            Text(text)
        }
    }
}
