//
//  VHView.swift
//  TCACalc
//
//  Created by Daniel Lyons on 9/19/23.
//

import SwiftUI
import DependenciesAdditions


/// A wrapper of two views, one vertical and one horizontal.
///
/// Designed to make it easier to respond to size classes
/// Warning: ``VHView`` may have negative performance implications since both the vertical and horizontal
/// views are rendering at all times. This was done so that the child views wouldn't lose their state when switching
/// between each View. However, if you have render intensive Views, consider not using ``VHView``.
struct VHView<VView: View, HView: View>: View {
  @Environment(\.horizontalSizeClass) private var hSizeClass
  @Environment(\.verticalSizeClass) private var vSizeClass
  @Dependency(\.logger) private var logger
  @ViewBuilder var vView: () -> VView
  @ViewBuilder var hView: () -> HView
  let defaultVisibleView: VisibleView
  
  
  /// Create a view that automatically switches between a horizontal and vertical presentation
  ///
  /// The View will switch based on the horizontal size class and the vertical size class.
  /// For more info, see Apple's documentation on Device size classes [here](https://developer.apple.com/design/human-interface-guidelines/layout#Device-size-classes).
  /// - Parameters:
  ///   - defaultVisibleView: the View that will be shown if either size class cannot be found in the
  ///   SwiftUI Environment.
  ///   - vView: the vertical View
  ///   - hView: the horizontal View
  init(
    default defaultVisibleView: VisibleView = .horizontal,
    vView: @escaping () -> VView,
    hView: @escaping () -> HView
  ) {
    self.vView = vView
    self.hView = hView
    self.defaultVisibleView = defaultVisibleView
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
      return self.defaultVisibleView
    }
  }
  
  var body: some View {
    switch visibleView {
      case .vertical:
        self.vView()
      case .horizontal:
        self.hView()
    }
  }
  
  /// Another implementation of `body`
  ///
  /// Use this implementation if you notice there are identity issues when switching between v and h views. 
  var identitySafeBody: some View {
    ZStack {
      self.vView()
        .zIndex(visibleView == .vertical ? 1 : -1)
        .opacity(visibleView == .vertical ? 1 : 0.001)
        .accessibilityHidden(visibleView != .vertical)
        .disabled(visibleView != .vertical)
      // This opacity is a workaround. SwiftUI appears to completely remove 0 opacity
      // Views from the hierarchy, thus destroying all state for that View.
      
      self.hView()
        .zIndex(visibleView == .horizontal ? 1 : -1)
        .opacity(visibleView == .horizontal ? 1 : 0.001)
        .accessibilityHidden(visibleView != .horizontal)
        .disabled(visibleView != .horizontal)
      
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
