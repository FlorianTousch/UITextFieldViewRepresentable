//
//  ContentView.swift
//  UIViewRepresentableExplaination
//
//  Created by Florian on 01/02/2022.
//

import SwiftUI

// UIViewRepresentable: Convert UIView from UIKit to SwiftUI

struct ContentView: View {
    
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            Text(text)
            HStack {
                Text("SwiftUI")
                TextField("Type here..", text: $text)
                    .padding()
                    .frame(height: 55)
                    .background(.gray.opacity(0.3))
            }
            HStack {
                Text("UIKit")
                UITextFieldViewRepresentable(text: $text)
                    .updatePlaceholder("test")
                    .updatePlaceholderColor(UIColor.orange)
                    .padding()
                    .frame(height: 55)
                    .background(.gray.opacity(0.3))
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UITextFieldViewRepresentable: UIViewRepresentable {
    
    @Binding var text: String
    var placeholder: String
    var placeholderColor: UIColor
    
    init(text: Binding<String>, placeholder: String = "Placeholder", placeholderColor: UIColor = .blue) {
        self._text = text
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = getTextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    // From SwiftUI to UIKit
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    private func getTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        let placeholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: placeholderColor
            ])
        textField.attributedPlaceholder = placeholder
        return textField
    }
    
    func updatePlaceholder(_ text: String) -> UITextFieldViewRepresentable {
        var viewRepresentable = self
        viewRepresentable.placeholder = text
        return viewRepresentable
    }
    
    func updatePlaceholderColor(_ color: UIColor) -> UITextFieldViewRepresentable {
        var viewRepresentable = self
        viewRepresentable.placeholderColor = color
        return viewRepresentable
    }
    
    // From UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String

        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}
