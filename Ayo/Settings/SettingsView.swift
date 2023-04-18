//
//  SettingsView.swift
//  Ayo
//
//  Created by Kiara on 07.04.23.
//

import SwiftUI
import Foundation
import CoreData

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.truth, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var showDocumentSheet = false
    @State var showLoading = false
    
    @State var fileURL: URL?
    
    @ObservedObject var vm: Config
    
    var body: some View {
        NavigationStack {
            List{
                Section {
                    VStack{
                        Text("Change active category")
                            .fontWeight(.bold)
                        Picker("Category: ", selection: $vm.activeCategory) {
                            ForEach(Category.allCases, id: \.rawValue) { cat in
                                Text(categoryString(cat))
                            }
                        }
                        Text("\(vm.activeSet.count) of \(items.count) cards active")
                            .font(.footnote)
                    }
                    
                    NavigationLink {
                        EditCardsView()
                            .navigationTitle("Manage Cards")
                    } label: {
                        Text("Manage Cards")
                    }
                }
                
                Section {
                    CreateCard()
                }
                
                Section {
                    Button {
                        loadDemoData()
                    } label: {
                        Text("Load default Data")
                    }
                    /* Button {
                     exportData()
                     } label: {
                     Text("Export all Data")
                     }*/
                    Button(role: .destructive) {
                        addDefaultData()
                    } label: {
                        Text("Delete all Cards")
                    }
                }
            }
            .onChange(of: vm.activeCategory) { _ in
                vm.setSet(viewContext)
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showDocumentSheet) {
                Text("ay")
                ShareLink(item: fileURL!, preview:SharePreview("JSON"))
                //  DocumentPicker(fileURL: $vm.importeJsonURL).onDisappear{ vm.reloadAndSave()}
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        offsets.map { items[$0] }.forEach(viewContext.delete)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func loadDemoData(){
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = viewContext
        
        do {
            if let file = Bundle.main.path(forResource: "demo", ofType: "json"){
                let json = try! String(contentsOfFile: file, encoding: String.Encoding.utf8).data(using: .utf8)!
                _ = try! decoder.decode([Item].self, from: json)
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func exportData(){
        showLoading = true
        let data = exportJSON()
        let url = writeJSON(data)
        fileURL = url
        showLoading = false
        showShareSheet(url: url)
    }
    
    
    func exportJSON()-> String{
        var string = " ["
        
        for sub in  items {
            string += "{\"text\": \"\(sub.text ?? "-")\", \"truth\": \(sub.truth), \"category\": \(sub.category), \"groupActivity\":  \"\(sub.groupActivity )\", \"shots\": \"\(sub.shots)\"},"
        }
        string += "]}"
        return string
    }
    
    func addDefaultData() {
        items.forEach { i in
            viewContext.delete(i)
        }
        
        let newItem = Item(context: viewContext)
        newItem.text = "Example Truth"
        newItem.truth = true
        newItem.shots = false
        newItem.groupActivity = false
        newItem.category = 1
        
        let newItem2 = Item(context: viewContext)
        newItem2.text = "Example Dare"
        newItem2.truth = false
        newItem2.shots = false
        newItem2.groupActivity = false
        newItem2.category = 1
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
