//
//  SwiftUIView.swift
//  Salaì
//
//  Created by Claudio Marciello on 25/02/24.
//

import SwiftUI
import UIKit
import Vision



struct AlertMessage: Identifiable {
  let id = UUID()
  var title: Text
  var message: Text
  var actionButton: Alert.Button?
  var cancelButton: Alert.Button = .default(Text("OK"))
}

struct PickerInfo: Identifiable {
  let id = UUID()
  let picker: PickerView
}

struct StyleTransferView: View {
  @State private var image: UIImage?
  @State private var styleImage: UIImage?
  @State private var stylizedImage: UIImage?
  @State private var processing = false
  @State private var showAlertMessage: AlertMessage?
  @State private var showImagePicker: PickerInfo?

  var body: some View {
    VStack {
      Text("PETRA")
        .font(.title)
      Spacer()
      Button(action: {
        if self.stylizedImage != nil {
          self.showAlertMessage = .init(
            title: Text("Choose new image?"),
            message: Text("This will clear the existing image!"),
            actionButton: .destructive(
              Text("Continue")) {
                self.stylizedImage = nil
                self.image = nil
                self.showImagePicker = PickerInfo(picker: PickerView(selectedImage: self.$image))
            },
            cancelButton: .cancel(Text("Cancel")))
        } else {
          self.showImagePicker = PickerInfo(picker: PickerView(selectedImage: self.$image))
        }
      }, label: {
        if let anImage = self.stylizedImage ?? self.image {
          Image(uiImage: anImage)
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: ContentMode.fit)
            .border(.blue, width: 3)
        } else {
          Text("Choose a Pet Image")
            .font(.callout)
            .foregroundColor(.blue)
            .padding()
            .cornerRadius(10)
            .border(.blue, width: 3)
        }
      })
      Spacer()
      Text("Choose Style to Apply")
      Button(action: {
        self.showImagePicker = PickerInfo(picker: PickerView(selectedImage: self.$styleImage))
      }, label: {
        Image(uiImage: styleImage ?? UIImage(named: Constants.Path.presetStyle1) ?? UIImage())
          .resizable()
          .frame(width: 100, height: 100, alignment: .center)
          .scaledToFit()
          .aspectRatio(contentMode: ContentMode.fit)
          .cornerRadius(10)
          .border(.blue, width: 3)
      })
      Button(action: {
        guard let petImage = image, let styleImage = styleImage ?? UIImage(named: Constants.Path.presetStyle1) else {
          self.showAlertMessage = .init(
            title: Text("Error"),
            message: Text("You need to choose a Pet photo before applying the style!"),
            actionButton: nil,
            cancelButton: .default(Text("OK")))
          return
        }
        if !self.processing {
          self.processing = true
          MLStyleTransferHelper.shared.applyStyle(styleImage, on: petImage) { stylizedImage in
            processing = false
            self.stylizedImage = stylizedImage
          }
        }
      }, label: {
        Text(self.processing ? "Processing..." : "Apply Style!")
          .padding(EdgeInsets.init(top: 4, leading: 8, bottom: 4, trailing: 8))
          .font(.callout)
          .background(.blue)
          .foregroundColor(.white)
          .cornerRadius(8)
      })
      .padding()
    }
    .sheet(item: self.$showImagePicker) { pickerInfo in
      return pickerInfo.picker
    }
    .alert(item: self.$showAlertMessage) { alertMessage in
      if let actionButton = alertMessage.actionButton {
        return Alert(
          title: alertMessage.title,
          message: alertMessage.message,
          primaryButton: actionButton,
          secondaryButton: alertMessage.cancelButton)
      } else {
        return Alert(
          title: alertMessage.title,
          message: alertMessage.message,
          dismissButton: alertMessage.cancelButton)
      }
    }.onAppear{
        
    }
  }
        
}



