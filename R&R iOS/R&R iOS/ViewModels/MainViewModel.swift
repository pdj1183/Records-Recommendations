//
//  MainViewModel.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 12/30/23.
//

import Foundation

class MainViewModel: ObservableObject {

    
    
    @Published var currentUserID: String = ""
    private var test: Bool = false
    
    init() {
        // Set User ID
    }
    
    public var isSignedIn: Bool {
        return false
    }
}
