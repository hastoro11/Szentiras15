//
//  Szentiras15v2App.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import SwiftUI

@main
struct Szentiras15v2App: App {
    @StateObject var readerVM: ReaderViewModel = ReaderViewModel()
    @StateObject var searchVM: SearchViewModel = SearchViewModel()
    @StateObject var historyVM: HistoryViewModel = HistoryViewModel()
    var body: some Scene {
        WindowGroup {
            SzentirasTabView(idezet: Idezet.example(filename: "Rom16"))
                .environmentObject(readerVM)
                .environmentObject(searchVM)
                .environmentObject(historyVM)
                .environmentObject(PartialSheetManager())
        }
    }
    
    init() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
}
