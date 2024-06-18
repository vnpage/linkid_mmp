//
//  DeepLinkError.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 28/09/2023.
//

import Foundation

public class DeepLinkBuilderError {
    public var code: String
    public var message: String
    
    public init(code: String, message: String) {
        self.code = code
        self.message = message
    }
}
