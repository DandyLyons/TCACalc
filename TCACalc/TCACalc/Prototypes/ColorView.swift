//
//  ColorView.swift
//  TCACalc
//
//  Created by Daniel Lyons on 8/19/23.
//

import Foundation
import SwiftUI

struct _ColorView: View {
  @State private var selectedColor: Color = .green
  @State private var tintColor: Color = .blue
  
  var body: some View {
    NavigationStack {
      Form {
        Section("Selected Color") {
          Text("Inherited Foreground Style Color")
          ColorPicker("Pick Color", selection: self.$selectedColor, supportsOpacity: true)
        }
        .foregroundStyle(selectedColor)
        
        Section("Tint Color") {
          Text("Inherited Tint Style Color")
          ColorPicker("Pick Color", selection: self.$tintColor, supportsOpacity: true)
        }
        .foregroundStyle(.tint)
      }
    }
    .tint(tintColor)
  }
}

#Preview {
  _ColorView()
}
