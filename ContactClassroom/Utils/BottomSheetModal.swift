//
//  BottomSheetModal.swift
//  BottomSheetSwiftUI
//
//  Created by Fernando de la Fuente on 10/14/19.
//  Copyright © 2019 Fernando de la Fuente. All rights reserved.
//
//  Found from: https://github.com/fernandodelafuente/BottomSheetModal

import SwiftUI

struct BottomSheetModal<Content: View>: View {

  private let modalHeight: CGFloat = 250
  private let modalWidth: CGFloat = UIScreen.main.bounds.width
  private let modalCornerRadius: CGFloat = 10
  private let backgroundOpacity = 0.65
  private let dragIndicatorVerticalPadding: CGFloat = 20

  @State private var offset = CGSize.zero
  @Binding var display: Bool
  @Binding var backgroundColor: Color
  @Binding var rectangleColor: Color
    

  var content: () -> Content

  var body: some View {
    ZStack(alignment: .bottom) {
      if display {
        background
        modal
      }
    }
    .edgesIgnoringSafeArea(.all)
  }

  private var background: some View {
    Color.black
      .fillParent()
      .opacity(backgroundOpacity)
      .animation(.spring())
  }

  private var modal: some View {
    VStack {
      indicator
      self.content()
    }
    .frame(width: modalWidth, height: modalHeight, alignment: .top)
    .background(backgroundColor)
    .cornerRadius(modalCornerRadius)
    .offset(y: offset.height)
    .gesture(
      DragGesture()
        .onChanged { value in self.onChangedDragValueGesture(value) }
        .onEnded { value in self.onEndedDragValueGesture(value) }
    )
    .transition(.move(edge: .bottom))
  }

  private var indicator: some View {
    DragIndicator(rectangleColor: $rectangleColor)
      .padding(.vertical, dragIndicatorVerticalPadding)
  }

  private func onChangedDragValueGesture(_ value: DragGesture.Value) {
    guard value.translation.height > 0 else { return }
    self.offset = value.translation
  }

  private func onEndedDragValueGesture(_ value: DragGesture.Value) {
    guard value.translation.height >= self.modalHeight / 2 else {
      self.offset = CGSize.zero
      return
    }

    withAnimation {
      self.display.toggle()
      self.offset = CGSize.zero
    }
  }
}

struct DragIndicator: View {
  private let width: CGFloat = 60
  private let height: CGFloat = 6
  private let cornerRadius: CGFloat = 4
    
    @Binding var rectangleColor: Color

  var body: some View {
    Rectangle()
      .fill(rectangleColor)
      .frame(width: width, height: height)
      .cornerRadius(cornerRadius)
  }
}

//struct BottomSheetModal_Previews: PreviewProvider {
//    
//    
//    static var previews: some View {
//        BottomSheetModal(display: .constant(true), backgroundColor: .constant(Color.white), rectangleColor: .constant(Color.black)) {
//        Text("Bottom Sheet Modal")
//          .font(Font.system(.headline))
//          .foregroundColor(Color.white)
//      }
//    }
//}
