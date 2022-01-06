//
//  VersListView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 24..
//

import SwiftUI

// MARK: - VersList
struct VersList: View {
    var verses: [Vers]
    var scrollTo: Bool = false
    var index: Int = 0
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(verses.indices, id:\.self) { index in
                    VersRow(vers: verses[index], index: index, fontSize: 17)
                        .id(index)
                        .background(scrollTo && index == self.index ? Color(uiColor: .systemGray5) : Color.clear)
                    
                }
                
            }
            .listStyle(.plain)
            .onAppear {
                if scrollTo {
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(index, anchor: .top)
                    }
                }
            }
        }
    }
}


// MARK: - VersRow
extension VersList {
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
            var attributedString = AttributedString(vers.szoveg.htmlString)
            attributedString.font = .Theme.light(size: fontSize)
            attributedString.foregroundColor = Color("Title")
            let result = attributedIndex + attributedString
            return result
        }
    }
}

struct Previews_VersListView_Previews: PreviewProvider {
    static var idezet: Idezet = TestData.idezetRom16
    static var previews: some View {
        VersList(verses: idezet.valasz.versek)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("VersList")
        
       
        
        Group {
            VersList.VersRow(vers: idezet.valasz.versek[0], index: 0, fontSize: 17)
                .background(Color(uiColor: .systemGray5))
            
            VersList.VersRow(vers: idezet.valasz.versek[0], index: 0, fontSize: 17)
        }
        .previewLayout(.sizeThatFits)
        .previewDisplayName("VersRow")
    }
}
