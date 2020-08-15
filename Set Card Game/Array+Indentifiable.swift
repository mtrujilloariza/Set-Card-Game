//
//  Array+Indentifiable.swift
//  Memorize
//
//  Created by Marlon Trujillo Ariza on 8/6/20.
//  Copyright © 2020 Marlon Trujillo Ariza. All rights reserved.
//

import Foundation


extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        
        return nil
    }
}
