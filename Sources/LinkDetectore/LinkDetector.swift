import Foundation
import UIKit
import SwiftUI
 
public struct DetectedItem: Identifiable {
    public let id = UUID()
    public let text: String
    public let url: URL?
}


public  struct LiveDetectingTextView: UIViewRepresentable {
    @Binding var text: String

    public func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.isEditable = true
        tv.isScrollEnabled = true
        tv.isSelectable = true
        tv.delegate = context.coordinator
        tv.font = UIFont.systemFont(ofSize: 17)
        tv.text = text
        
        return tv
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, UITextViewDelegate {
        var parent: LiveDetectingTextView

        init(_ parent: LiveDetectingTextView) {
            self.parent = parent
        }

        public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            
            let cursor = textView.selectedRange

            let attributed = NSMutableAttributedString(string: parent.text)
            let full = NSRange(location: 0, length: attributed.length)

            // REGEX PATTERNS
            let patterns = [
                "(?i)[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}",         // email
                "(https?://)?([A-Za-z0-9.-]+\\.[A-Za-z]{2,})[/A-Za-z0-9._%+-]*", // website
                "\\b[0-9]{7,15}\\b"                                   // phone number
            ]

            for pattern in patterns {
                let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                let matches = regex.matches(in: parent.text, options: [], range: full)
                
                for match in matches {
                    let matchText = (parent.text as NSString).substring(with: match.range)
                    let url = detectURL(for: matchText)
                    
                    if let url = url {
                        attributed.addAttribute(.link, value: url, range: match.range)
                        attributed.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: match.range)
                        attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: match.range)
                    }
                }
            }
            
            textView.attributedText = attributed
            textView.selectedRange = cursor
        }
        
        /// Convert email/phone/url into real tappable URLs
        func detectURL(for string: String) -> URL? {
            if string.contains("@") { return URL(string: "mailto:\(string)") }
            if Int(string) != nil { return URL(string: "tel:\(string)") }
            if string.hasPrefix("http") { return URL(string: string) }
            return URL(string: "https://\(string)")
        }
    }
}
