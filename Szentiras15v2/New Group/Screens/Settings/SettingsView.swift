//
//  SettingsView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 04..
//

import SwiftUI

struct SettingsView: View {
    @State var historyCapacity: Int
    @State var isCurrentSaved: Bool
    
    init() {
        let capacity = UserDefaults.standard.historyCapacity
        _historyCapacity = State(initialValue: capacity)
        _isCurrentSaved = State(initialValue: UserDefaults.standard.isCurrentSaved)
    }
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Előzmények száma")
                    Picker("", selection: $historyCapacity) {
                        Text("5").tag(5)
                        Text("10").tag(10)
                        Text("15").tag(15)
                    }
                    
                }
                HStack {
                    Text("Utolsó olvasott helytől folytat")
                        
                    Spacer()
                    CustomToggle(state: $isCurrentSaved) { value in
                        UserDefaults.standard.setCurrentSaved(value: value)
                    }
                }
            }
            .onChange(of: historyCapacity, perform: { newValue in
                UserDefaults.standard.setHistoryCapacity(to: newValue)
            })
            .font(.Theme.light(size: 15))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Beállítások")
                        .font(.Theme.bold(size: 17))
                }
            }
        }
    }
}

// MARK: - Previews
struct SettingsView_Previews: PreviewProvider {
    @State var histroyCapacity: Int = 5
    static var previews: some View {
        SettingsView()

        HStack {
            CustomToggle(state: .constant(true)) {_ in }
            CustomToggle(state: .constant(false)) {_ in }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
