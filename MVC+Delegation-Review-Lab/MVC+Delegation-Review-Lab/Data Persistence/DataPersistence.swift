//
//  DataPersistence.swift
//  MVC+Delegation-Review-Lab
//
//  Created by Melinda Diaz on 1/27/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import Foundation
public enum DataPersistenceError: Error {
    case propertyListEncodingError(Error)
    case propertyListDecodingError(Error)
    case writingError(Error)
    case deletingError
    case noContentsAtPath(String)
}
//step1: custom delegation - defining the protocol
//protocol can have getters and setters and variables no constants
protocol DataPersistenceDelegate: AnyObject {
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T)//The first thing you always see the type of object
}
typealias Writable = Codable & Equatable // must be capitlaized
//this is the same when swift says typealias for codable = Encodable & Decodable
//DataPersistance is now type constrained to only work with Codable types
class DataPersistence<T: Codable & Equatable> {
    
    private let filename: String
    
    private var items: [T]//You can only do this by making this class conform to codable
    
    //step2: custom delegation - defining a reference property that will be registered at the object listening for notifications
    weak var delegate: DataPersistenceDelegate?
    
    public init(filename: String) {
        self.filename = filename
        self.items = []
    }
    
    private func saveItemsToDocumentsDirectory() throws {
        do {
            let url = FileManager.getPath(with: filename, for: .documentsDirectory)
            let data = try PropertyListEncoder().encode(items)//we need to make our type T to conform to codable on dataPersistance
            try data.write(to: url, options: .atomic)
        } catch {
            throw DataPersistenceError.writingError(error)
        }
    }
    //CRUD - create , read update delete
    // Create
    public func createItem(_ item: T) throws {
        _ = try? loadItems()
        items.append(item)
        //Cannot invoke 'append' with an argument list of type '(Event)'
        do {
            try saveItemsToDocumentsDirectory()
        } catch {
            throw DataPersistenceError.writingError(error)
        }
    }
    
    // Read
    public func loadItems() throws -> [T] {
        let path = FileManager.getPath(with: filename, for: .documentsDirectory).path
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    items = try PropertyListDecoder().decode([T].self, from: data)
                } catch {
                    throw DataPersistenceError.propertyListDecodingError(error)
                }
            }
        }
        return items
    }
    
    // for re-ordering, and keeping date in sync
    public func synchronize(_ items: [T]) {
        self.items = items
        try? saveItemsToDocumentsDirectory()
    }
    
    // Update
    @discardableResult //silences the warning if the return value is not used
    //this one needs an old item finds where the index is
    public func update(_ oldItem: T, with newItem: T) -> Bool {
        //its an optional index cause it may not exist so it returns an optional
        //it needs to conform to Equatable because it goes through each element and looks for the certain item being searched and if it is currently in the Array. If it doesn't conform to equatable then you cannot search for something and compare the two item or element.
        //dis ardable result means i want to use the return value or not return the return value
        if let index = items.firstIndex(of: oldItem) {
            //Argument type 'T' does not conform to expected type 'Equatable' so you go back to the top and conform to type codable
            let result = update(newItem, at: index)
            return result
        }
        return false
    }
    @discardableResult//silences the warning if the return value is not used by the caller
    //this one takes in just the item so it already HAS the index unlike the previous. so its takes in a different value than the other update
    public func update(_ item: T,at index: Int) -> Bool {
        items[index] = item//save item to document directory
        do {
            try saveItemsToDocumentsDirectory()
            return true
        } catch {
            return false
        }
    }
    // Delete
    
    public func deleteItem(at index: Int) throws {
        let deletedItem = items.remove(at: index)
        do {
            try saveItemsToDocumentsDirectory()
            //step3: custom delegation - use delegate reference to notify observer of deletion
            //we use weak to break the strong reference cycle between the delegate object and dataPersistence //step1: custom delegation - defining the protocol
            delegate?.didDeleteItem(self, item: deletedItem)
        } catch {
            throw DataPersistenceError.deletingError
        }
    }
    
    public func hasItemBeenSaved(_ item: T) -> Bool {
        guard let items = try? loadItems() else {
            return false
        }
        self.items = items
        if let _ = self.items.firstIndex(of: item) {
            return true
        }
        return false
    }
    
    public func removeAll() {
        guard let loadedItems = try? loadItems() else {
            return
        }
        items = loadedItems
        items.removeAll()
        try? saveItemsToDocumentsDirectory()
    }
}
