//
//  ContentView.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 12/29/23.
//

import SwiftUI
import CoreData
import CloudKit


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    private let database = CKContainer(identifier: "icloud.R-R").privateCloudDatabase
    
    
    

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("R&R")
                        .font(Font.custom("Amoitar", fixedSize: 34))
                        .foregroundStyle(.pink)
                                                
                }
        
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            
            Text("Select an item")
        }
    }
    
    private struct Album {
        let name = ""
        let artist = ""
        let genre = ""
        let listens = 0
    }
    
    private func saveItem (record :Album){
        let album = CKRecord(recordType: "Album")
        album.setValue(record.name, forKey: "name")
        album.setValue(record.artist, forKey: "artist")
        album.setValue(record.genre, forKey: "genre")
        album.setValue(record.listens+1, forKey: "listens")
        album.setValue(Date(), forKey: "lastListened")
        database.save(album) { record, error in
            if record != nil, error == nil {
                print("saved")
            }
        }
    }
        


    private func addItem() {
        withAnimation {
            let alert = UIAlertController(title: "Add an Album", message: nil, preferredStyle: .alert)
            alert.addTextField { field in
                field.placeholder = "Album Name"}
            
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
