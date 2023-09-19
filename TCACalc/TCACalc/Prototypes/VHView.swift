//
//  VHView.swift
//  TCACalc
//
//  Created by Daniel Lyons on 9/19/23.
//

import SwiftUI
import DependenciesAdditions


/// A wrapper of two views, one vertical and one horizontal
/// Designed to make it easier to respond to size classes
/// Warning: The VView and HView should not own their own state.
/// Instead a parent View should own their state. This way state won't be lost when switching views.
struct VHView<VView: View, HView: View>: View {
  @Environment(\.horizontalSizeClass) private var hSizeClass
  @Environment(\.verticalSizeClass) private var vSizeClass
  @Dependency(\.logger) private var logger
  @ViewBuilder var vView: () -> VView
  @ViewBuilder var hView: () -> HView
  
  init(vView: @escaping () -> VView, hView: @escaping () -> HView) {
    self.vView = vView
    self.hView = hView
  }
  
  enum VisibleView { case vertical, horizontal }
  var visibleView: VisibleView {
    if let hSizeClass,
       let vSizeClass {
      switch (hSizeClass, vSizeClass) {
        case (.compact, .regular):
          // typically used on iPhone portrait
          return .vertical
        case (.compact, .compact):
          // typically used on iphone landscape (except Max)
          return .horizontal
        case (.regular, .compact):
          // typically used on iPhone (Max) landscape
          return .horizontal
        case (.regular, .regular):
          // typically used on iPad, portrait AND landscape
          return .horizontal
        default:
          let _ = logger.error("Unexpected Size class \nHorizontalSizeClass: \(self.hSizeClass.debugDescription), \nVerticalSizeClass: \(self.vSizeClass.debugDescription)")
          return .vertical
      }
    } else {
      let _ = logger.error("Missing size class in Environment. \nHorizontalSizeClass: \(self.hSizeClass.debugDescription), \nVerticalSizeClass: \(self.vSizeClass.debugDescription)")
      return .horizontal
    }
  }
  
  var body: some View {
    
    
    ZStack {
      self.vView()
        .zIndex(visibleView == .vertical ? 1 : -1)
      
      self.hView()
        .zIndex(visibleView == .horizontal ? 1 : -1)
    }
  }
  
}

#Preview {
  VHView {
    Text("Vertical View")
      .foregroundStyle(.green)
  } hView: {
    Text("Horizontal View")
      .foregroundStyle(.blue)
  }

}
