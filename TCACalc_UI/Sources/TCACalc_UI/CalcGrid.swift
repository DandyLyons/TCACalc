//
//  File.swift
//  
//
//  Created by Daniel Lyons on 7/13/23.
//

import Foundation
import SwiftUI

struct CalcGrid: View {
  let grayStyle = CircleButtonStyle(foregroundIdleColor: .black, backgroundIdleColor: .gray)
  let darkgrayStyle = CircleButtonStyle(foregroundIdleColor: .white, backgroundIdleColor: .secondary)
  
  let onOrangeBackground = CircleBackground(foreground: .orange, background: .white)
  let offOrangeBackground = CircleBackground(foreground: .white, background: .orange)
  
  @State private var isDivideOn = false
  @State private var isMultiplyOn = false
  @State private var isMinusOn = false
  @State private var isPlusOn = false
  @State private var isEqualOn = false
  
  var body: some View {
    Grid(alignment: .center, horizontalSpacing: 10.0, verticalSpacing: 10.0) {
      GridRow {
        Button("AC") {}
          .buttonStyle(self.grayStyle)
        Button {} label: { Image(systemName: "plus.forwardslash.minus")}
          .buttonStyle(self.grayStyle)
        Button("%") {}
          .buttonStyle(self.grayStyle)
        Button { self.isDivideOn.toggle() } label: {
          Image(systemName: "divide")
            .modifier(self.isDivideOn ? self.onOrangeBackground : self.offOrangeBackground)
        }
      }
      GridRow {
        Button("7") {}
          .buttonStyle(self.darkgrayStyle)
        Button("8") {}
          .buttonStyle(self.darkgrayStyle)
        Button("9") {}
          .buttonStyle(self.darkgrayStyle)
        Button { self.isMultiplyOn.toggle() } label: {
          Image(systemName: "multiply")
            .modifier(self.isMultiplyOn ? self.onOrangeBackground : self.offOrangeBackground)
        }
      }
      GridRow {
        Button("4") {}
          .buttonStyle(self.darkgrayStyle)
        Button("5") {}
          .buttonStyle(self.darkgrayStyle)
        Button("6") {}
          .buttonStyle(self.darkgrayStyle)
        
        Button { self.isMinusOn.toggle() } label: {
          Image(systemName: "minus")
            .modifier(self.isMinusOn ? self.onOrangeBackground : self.offOrangeBackground)
        }
        

        
      }
      GridRow {
        Button("1") {}
          .buttonStyle(self.darkgrayStyle)
        Button("2") {}
          .buttonStyle(self.darkgrayStyle)
        Button("3") {}
          .buttonStyle(self.darkgrayStyle)
        Button { self.isPlusOn.toggle() } label: {
          Image(systemName: "plus")
            .modifier(self.isPlusOn ? self.onOrangeBackground : self.offOrangeBackground)
        }
      }
      GridRow {
//        Button("AC") {}
//          .buttonStyle(self.grayStyle)
        Button {} label: { Text("0").foregroundStyle(.white)}
          .gridCellColumns(2)
          .frame(maxWidth: .infinity)
          .frame(maxHeight: .infinity)
          .background { Capsule().foregroundColor(.secondary) }
        

        Button(".") {}
          .buttonStyle(self.darkgrayStyle)
        Button { self.isEqualOn.toggle() } label: {
          Image(systemName: "equal")
            .modifier(self.isEqualOn ? self.onOrangeBackground : self.offOrangeBackground)
        }
      }
      .frame(maxHeight: 90)
    }
    .font(.title)
    .fontWeight(.bold)

    
  }
}

struct CircleBackground: ViewModifier {
  let foreground: Color
  let background: Color
  
  func body(content: Content) -> some View {
    ZStack {
      Circle()
        .foregroundColor(self.background)
      
      content
        .foregroundColor(self.foreground)
    }
  }
}

#Preview {
  ZStack {
    Color.black
      .ignoresSafeArea()
    VStack(alignment: .trailing) {
      Spacer()
      
      Text("0")
        .font(.largeTitle)
        .foregroundColor(.white)
        .padding(.horizontal)
      
      CalcGrid()
    }
    .padding(.horizontal)
  }
}
