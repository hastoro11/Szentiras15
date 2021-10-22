//
//  SzentirasTabView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import SwiftUI

enum TabSelection {
    case read
}

struct SzentirasTabView: View {
    @State var selection: TabSelection = .read
    var idezet: Idezet
    var versek: [Vers] {
        idezet.valasz?.versek ?? []
    }
    var body: some View {
        TabView(selection: $selection) {
            ReaderView()
                .tabItem {
                    Label("Biblia", systemImage: "book.fill")
                }
                .tag(TabSelection.read)
        }
    }
}

struct SzentirasTabView_Previews: PreviewProvider {
    static var previews: some View {
        SzentirasTabView(idezet: Idezet.example(filename: "Rom16"))
    }
}
