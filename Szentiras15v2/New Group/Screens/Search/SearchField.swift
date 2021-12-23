//
//  SearchField.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 21..
//

import SwiftUI


// MARK: - SearchField

struct SearchField: View {
    @Binding var text: String
    @State var isEditing: Bool = false
    var onCommit: () -> Void
    var onClear: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        HStack {
            TextField("Keresés ...", text: $text, onCommit: onCommit)
                .padding(12)
                .padding(.horizontal, 25)
                .background(Color(uiColor: .systemGray5))
                .cornerRadius(8)
                .font(.Theme.light(size: 17))
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
                        .foregroundColor(Color.dark)
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
                    onCancel()
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Mégsem")
                        .font(.Theme.regular(size: 17))
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
        
    }
}


// MARK: - Previews
struct Previews_SearchField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchField(text: .constant(""), isEditing: true, onCommit: {}, onClear: {}, onCancel: {})
            SearchField(text: .constant("Hello"), isEditing: false, onCommit: {}, onClear: {}, onCancel: {})
            SearchField(text: .constant(""), isEditing: true, onCommit: {}, onClear: {}, onCancel: {})
                .environment(\.colorScheme, .dark)
            SearchField(text: .constant(""), isEditing: false, onCommit: {}, onClear: {}, onCancel: {})
                .environment(\.colorScheme, .dark)
            
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("SearchField")
    }
}
