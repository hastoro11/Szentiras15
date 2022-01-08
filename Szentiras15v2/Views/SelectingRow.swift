//
//  SelectingRow.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 01..
//

import SwiftUI

struct SelectingRow: View {
    var abbrev: String
    var text: String
    var selected: Bool
    var isAligned: Bool = false
    var body: some View {
        HStack {
            Text(abbrev.uppercased())
                .iconButtonStyle(active: selected)
            if isAligned {
                Spacer()
            }
            Text(text)
                .font(.Theme.light(size: 17))
                .foregroundColor(selected ? Color("Title") : Color.light)
            if !isAligned {
                Spacer()
            }
        }
    }
}

struct SelectingRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SelectingRow(abbrev: "RUF", text: "Magyar Bibliatársulat fordítása", selected: true)

            SelectingRow(abbrev: "RUF", text: "Magyar Bibliatársulat fordítása", selected: false)

        }
        .padding()
        .previewLayout(.sizeThatFits)
        
        VStack {
            SelectingRow(abbrev: "Ósz", text: "Ószövetség", selected: true, isAligned: true)

            SelectingRow(abbrev: "Úsz", text: "Újszövetség", selected: false, isAligned: true)

        }
        .padding()
        .previewLayout(.sizeThatFits)
            
    }
}
