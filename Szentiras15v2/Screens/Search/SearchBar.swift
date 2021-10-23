//
//  SearchBar.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 23..
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    var onCommit: () -> Void
    var onClear: () -> Void
    var body: some View {
        HStack {
            TextField("Keresés ...", text: $text, onCommit: onCommit)
                .padding(14)
                .padding(.horizontal, 25)
                .background(Color.Theme.background)
                .font(.Theme.book(size: 19))
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                                onClear()
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                        .foregroundColor(.Theme.text)
                )
                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                    }
                }
            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                    }
                    self.text = ""
                    onClear()
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .font(.Theme.medium(size: 19))
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), onCommit: {}, onClear: {})
            .padding()
            .previewLayout(.sizeThatFits)
    }
}