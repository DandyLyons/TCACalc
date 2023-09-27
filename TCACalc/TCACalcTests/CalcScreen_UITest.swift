//
//  CalcScreenUITest.swift
//  TCACalcTests
//
//  Created by Daniel Lyons on 9/27/23.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import TCACalc
import Dependencies

@MainActor
final class CalcScreen_UITest: XCTestCase {
  func testSnapshotOfAppStartup() async {
    var view = ContentView()
    
    assertSnapshot(
      of: view,
      as: .image(
        drawHierarchyInKeyWindow: true,
        perceptualPrecision: 0.98,
        layout: .device(config: .iPhone13Pro),
        traits: .init(userInterfaceStyle: .light)
      ),
      named: "App Startup",
      record: false
    )
    
  }
}
