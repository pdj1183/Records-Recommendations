//
//  MainViewModel.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
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

