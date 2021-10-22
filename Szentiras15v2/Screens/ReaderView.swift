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
    
    var title: String {
        if case .success(let idezet) = vm.phase {
            return idezet.keres.hivatkozas
        }
        return ""
    }
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
                .navigationTitle(title)
        }
        .task {
            await vm.fetch()
        }
    }
    
    var versList: some View {
        List {
            ForEach(versek.indices, id:\.self) { index in
                Text(attributedText(index:index))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }.listStyle(.plain)
    }
    
    func attributedText(index: Int) -> AttributedString {
        let vers = versek[index]
        var attributedIndex = AttributedString("\(vers.versSzam) ")
        attributedIndex.foregroundColor = .accentColor
        attributedIndex.font = .black(size: 17)
        var attributedString = AttributedString(vers.szoveg)
        attributedString.font = .light(size: 17)
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
