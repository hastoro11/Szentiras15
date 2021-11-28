//
//  BibleChapterView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 27..
//

import SwiftUI

struct BibleChapterView: View {
    var idezet: Idezet
    var body: some View {
        NavigationView {
            Content(idezet: idezet)
        }
    }
}

extension BibleChapterView {
    struct Content: View {
        var idezet: Idezet
        var body: some View {
            BibleChapterView.VersList(versek: idezet.valasz.versek)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(idezet.keres.hivatkozas)
        }
    }
}

extension BibleChapterView {
    struct VersList: View {
        var versek: [Vers]
        var body: some View {
            ScrollViewReader { proxy in
                List {
                    ForEach(versek.indices, id:\.self) { index in
                        VersRow(vers: versek[index], index: index, fontSize: 17)
                            
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

extension BibleChapterView.VersList {
    struct VersRow: View {
        var vers: Vers
        var index: Int
        var fontSize: CGFloat
        
        var body: some View {
            Text(attributedText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        var attributedText: AttributedString {
            var attributedIndex = AttributedString("\(vers.versSzam) ")
            attributedIndex.foregroundColor = .accentColor
            attributedIndex.font = .Theme.bold(size: fontSize)
            var attributedString = AttributedString(vers.szoveg)
            attributedString.font = .Theme.light(size: fontSize)
            attributedString.foregroundColor = Color("Title")
            let result = attributedIndex + attributedString
            return result
        }
    }
    
    
}

struct BibleChapterView_Previews: PreviewProvider {
    static var idezet: Idezet = TestData.idezetRom16
    static var previews: some View {
        BibleChapterView(idezet: idezet)
        Group {
            BibleChapterView.VersList.VersRow(vers: idezet.valasz.versek[0], index: 0, fontSize: 17)
        }
        .previewLayout(.sizeThatFits)
        .previewDisplayName("VersRow")
    }
}
