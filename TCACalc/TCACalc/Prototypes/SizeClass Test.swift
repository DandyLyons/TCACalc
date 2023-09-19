//
//  SizeClass Test.swift
//  TCACalc
//
//  Created by Daniel Lyons on 9/19/23.
//

import SwiftUI
import DependenciesAdditions

struct SizeClass_Test: View {
  @Environment(\.horizontalSizeClass) var hSizeClass
  @Environment(\.verticalSizeClass) var vSizeClass
  @Dependency(\.logger) var logger
  
  @ViewBuilder
  var hView: some View {
    Text("Horizontal View")
  }
  
  @ViewBuilder
  var vView: some View {
    Text("Vertical View")
  }
  
    var body: some View {
      if let hSizeClass, 
         let vSizeClass {
        switch (hSizeClass, vSizeClass) {
          case (.compact, .regular):
            self.vView
          case (.compact, .compact):
            self.hView
          default:
            Text("Unexpected size classes")
        }
        
      }
      
    }
}

#Preview {
    SizeClass_Test()
}
