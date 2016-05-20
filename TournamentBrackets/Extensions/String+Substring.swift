//
//  String+Substring.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 20/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

extension String {
    public static func substring(ofString s : String, withCount : Int)  -> String {
        return ( s.characters.count > withCount ? s.substringToIndex(s.startIndex.advancedBy(withCount)) : s )
    }
    public static func sevenChars(ofString s : String)  -> String {
        return String.substring(ofString: s, withCount: 7)
    }
}
