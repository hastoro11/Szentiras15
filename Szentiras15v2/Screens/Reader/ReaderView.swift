//
//  ReaderView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import SwiftUI

struct ReaderView: View {    
    @EnvironmentObject var vm: ReaderViewModel
    @State var showBooklist: Bool = false
    @State var showTranslationList: Bool = false
    @State var showArrows: Bool = true
    var versek: [Vers] {
        if case .success(let res) = vm.phase, let idezet = res as? Idezet {
            return idezet.valasz.versek
        }
        return []
    }
    
    var body: some View {
        NavigationView {
            versList
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(overlay.padding(.horizontal))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    booksToolbar
                    translationsToolbar
                    settingToolbar
                }
                .refreshable {
                    vm.load()
                }
                .onTapGesture {
                    withAnimation {
                        showArrows.toggle()
                    }
                }
                
        }
        .task {
            vm.load()
        }
        .sheet(isPresented: $showBooklist) {
            BooksListView(showBookslist: $showBooklist, current: vm.current, load: vm.load)
        }
        .sheet(isPresented: $showTranslationList) {
            TranslationSelectView(current: vm.current, showTranslations: $showTranslationList, load: vm.load)
        }
    }
    

}

extension ReaderView {
    var versList: some View {
        ScrollViewReader { proxy in
            List{
                ForEach(versek.indices, id:\.self) { index in
                    Text(attributedText(index:index))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineSpacing(3)
                        .id(tag(index: index))
                        .listRowBackground(tag(index: index) == vm.searchTag ? Color.Theme.background : Color.clear)
                }
                .listRowSeparator(.hidden)
                
            }
            .listStyle(.plain)
            .task(id: vm.seekSearched) {
                if vm.seekSearched {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        withAnimation {
                            proxy.scrollTo(vm.searchTag, anchor: .top)
                            vm.seekSearched = false
                            vm.searchTag = ""
                        }
                    }
                }
            }
        }
    }
    
    func tag(index: Int) -> String {
        "\(vm.current.translation.id)/\(vm.current.book.number)/\(vm.current.chapter)/\(versek[index].versSzam)"
    }
    
    var booksToolbar: some ToolbarContent {
        var title: String {
            if case .success(let res) = vm.phase, let idezet = res as? Idezet, !idezet.valasz.versek.isEmpty {
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
                    .font(.Theme.black(size: 19))
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
                    .font(.Theme.heavy(size: 19))
            }
        }
    }
    
    var settingToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing, content: {
            Button(action: {}) {
                Text("Aa")
                    .font(.Theme.heavy(size: 19))
            }
            
        })
    }
    
    @ViewBuilder
    var overlay: some View {
        switch vm.phase {
        case .isFetching:
            VStack {
                ProgressView("Keresés...\n\(vm.current.book.name) \(vm.current.chapter). fejezet")
                    .multilineTextAlignment(.center)
            }
        case .empty:
            VStack(alignment: .leading) {
                Text(attributedEmptyMessage(name:vm.current.book.name))
                
                Text("Bizonyos fordítások csak az Újszövetséget tartalmazzák")
                    .font(.Theme.book(size: 19))
                    .padding(.top)
            }
            .multilineTextAlignment(.center)
        case .error(let error):
            VStack(spacing: 10) {
                Image(systemName: "exclamationmark.icloud.fill")
                    .font(.Theme.light(size: 48))
                Text("\(error.description)")
                Button(action: {
                    vm.load(current: vm.current)
                }) {
                    Text("Újra megpróbálom")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .font(.Theme.book(size: 19))
                }
            }
            .font(.Theme.light(size: 19))
        case .success(_):
            if showArrows {
                HStack {
                    arrowButton(direction: "left")
                        .opacity(vm.current.chapter == 1 ? 0 : 1)
                    Spacer()
                    arrowButton(direction: "right")
                        .opacity(vm.current.chapter == vm.current.book.chapters ? 0 : 1)
                }
                .padding(.horizontal)
            }
        }
    }
    
    func attributedEmptyMessage(name: String) -> AttributedString {
        var attributedString = AttributedString("\(name) nem található meg ebben a fordításban.")
        attributedString.font = .Theme.book(size: 19)
        if let range = attributedString.range(of: name) {
            attributedString[range].font = .Theme.heavy(size: 19)
        }
        return attributedString
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
    
    func arrowButton(direction: String) -> some View {
        Button(action: {
            if direction == "left" {
                vm.current.chapter = max(1, vm.current.chapter-1)
                vm.load(current: vm.current)
            }
            if direction == "right" {
                vm.current.chapter = min(vm.current.book.chapters, vm.current.chapter+1)
                vm.load(current: vm.current)
            }
        }) {
            Image(systemName: "arrow.\(direction)")
                .font(.title)
                .foregroundColor(.white)
        }
        .padding()
        .background(
            Circle().fill(
                Color.Theme.text.opacity(0.3)
            )
                .shadow(color: .Theme.text, radius: 5, y: 5)
        )
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        return ReaderView()
            .environmentObject(ReaderViewModel.preview)
    }
}
