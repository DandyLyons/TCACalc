//
//  File.swift
//  
//
//  Created by Daniel Lyons on 7/15/23.
//

import Foundation

extension AttributedString {
  func superscripted() -> AttributedString {
    var result = self
    result.baselineOffset = 10.0
    result.font = .caption
    return result
  }
  
  func subscripted() -> AttributedString {
    var result = self
    result.baselineOffset = -10.0
    result.font = .caption
    return result
  }

}

extension String {
  func attributed() -> AttributedString {
    return AttributedString(self)
  }
}
