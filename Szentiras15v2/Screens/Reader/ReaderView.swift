//
//  ReaderView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import SwiftUI

struct ReaderView: View {
    @StateObject var vm: ReaderViewModel = ReaderViewModel()
    @State var showBooklist: Bool = false
    @State var showTranslationList: Bool = false
    
    var versek: [Vers] {
        if case .success(let idezet) = vm.phase {
            return idezet.valasz?.versek ?? []
        }
        return []
    }
    
    var body: some View {
        NavigationView {
            versList
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    booksToolbar
                    translationsToolbar
                }
        }
        .task {
            await vm.fetch()
        }
        .sheet(isPresented: $showBooklist) {
            BooksListView(showBookslist: $showBooklist, current: vm.current, load: vm.load)
        }
        .sheet(isPresented: $showTranslationList) {
            TranslationSelectView(current: vm.current, showTranslations: $showTranslationList, load: vm.load)
        }
    }
    
    var versList: some View {
        return List {
            ForEach(versek.indices, id:\.self) { index in
                Text(attributedText(index:index))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }.listStyle(.plain)
    }
    
    var booksToolbar: some ToolbarContent {
        var title: String {
            if case .success(let idezet) = vm.phase, let versek = idezet.valasz?.versek, !versek.isEmpty {
                let szep = versek[0].hely.szep
                return String(szep.split(separator: ",")[0])
            }
            return ""
        }
        return ToolbarItem(placement: .principal) {
            Button(action: {
                showBooklist.toggle()
            }) {
                Text(title)
                    .font(.Theme.black(size: 17))
                    .foregroundColor(.black)
            }
        }
    }
    
    var translationsToolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button(action: {
                showTranslationList.toggle()
            }) {
                Text(vm.current.translation.abbrev)
                    .font(.Theme.heavy(size: 17))
            }
        }
    }
    
    func attributedText(index: Int) -> AttributedString {
        let vers = versek[index]
        var attributedIndex = AttributedString("\(vers.versSzam) ")
        attributedIndex.foregroundColor = .accentColor
        attributedIndex.font = .Theme.black(size: 17)
        var attributedString = AttributedString(vers.szoveg)
        attributedString.font = .Theme.light(size: 17)
        attributedString.foregroundColor = .Theme.button
        let result = attributedIndex + attributedString
        return result
    }
}


struct ReaderView_Previews: PreviewProvider {
    static var vm = ReaderViewModel.preview
    static var previews: some View {
        ReaderView(vm: vm)
    }
}
