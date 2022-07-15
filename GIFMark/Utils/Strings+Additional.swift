//
//  Strings+Localize.swift
//  GIFMark
//
//  Created by Lal Castro on 15/07/22.
//

import Foundation
extension String {
    
    /// This will give you the localized version of the given string key
    var localized: String {
        NSLocalizedString(self, comment: " ")
    }
    
    func trimSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var isValidSearch: Bool {
        return self.trimSpace().count > 2 || Int(self) != nil
    }
}
