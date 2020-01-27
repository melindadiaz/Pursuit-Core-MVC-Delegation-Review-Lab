//
//  File Manager.swift
//  MVC+Delegation-Review-Lab
//
//  Created by Melinda Diaz on 1/27/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import Foundation

public enum Directory {
    case documentsDirectory
    case cachesDirectory
}

extension FileManager {
    // returns a URL to the documents directory for the app
    //documents/schedules.plist
    //we need to make a file name "(put name here).plist" and it will append to the URL
    //this is just getting the URL inout and it doesn't exist yet so we will create the file later in persistence helper class. So this gets the path of the file name.
    public static func getDocumentsDirectory() -> URL  {
        //we append a new component to the URL the new component is the filename.  //File manager has a singleton called default. the .urls gives you an array of URLS
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]//DomainMask assigns to a specific user. It gives us an array but we don't want that so we index it cause we only want the first one[0] index 0. There is only 1 document directory there are no other document directory
    }
    
    public static func getCachesDirectory() -> URL  {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    // function takes a filename as a parameter, appends to the document directory's URL and returns that path
    // this path will be used to write (save) date or read (retrieve) data
    public static func getPath(with filename: String, for directory: Directory) -> URL {
        switch directory {
        case .cachesDirectory:
            return getCachesDirectory().appendingPathComponent(filename)
        case .documentsDirectory:
            return getDocumentsDirectory().appendingPathComponent(filename)
        }
    }
}
