//
//  SzentirasTabView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import SwiftUI

enum TabSelection {
    case read
    case search
}

struct SzentirasTabView: View {
    @State var selection: TabSelection = .search
    var idezet: Idezet
    var versek: [Vers] {
        idezet.valasz.versek
    }
    var body: some View {
        TabView(selection: $selection) {
            ReaderView()
                .tabItem {
                    Label("Biblia", systemImage: "book.fill")
                }
                .tag(TabSelection.read)
            SearchView()
                .tabItem {
                    Label("Keresés", systemImage: "magnifyingglass")
                }
                .tag(TabSelection.search)
        }
    }
}

struct SzentirasTabView_Previews: PreviewProvider {
    static var previews: some View {
        SzentirasTabView(idezet: Idezet.example(filename: "Rom16"))
    }
}
