//
//  SearchView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 23..
//

import SwiftUI

struct SearchView: View {
    @State var search: String = ""
    var body: some View {
        VStack {
            SearchBar(text: $search, onCommit: onCommit, onClear: onClear)
                .padding()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Spacer()
        }
        
    }
    
    func onClear() {
        print("onClear")
    }
    
    func onCommit() {
        print("Search:", search)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
