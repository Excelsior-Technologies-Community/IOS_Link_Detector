import SwiftUI
import UIKit


public struct LiveDetectingTextView: UIViewRepresentable {
    
    @Binding public var text: String
    
    public init(text: Binding<String>) {
        self._text = text
    }

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
        
        public var parent: LiveDetectingTextView
        
        public init(_ parent: LiveDetectingTextView) {
            self.parent = parent
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            
            let cursor = textView.selectedRange
            let attributed = NSMutableAttributedString(string: parent.text)
            
            // Reset all attributes first
            attributed.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: attributed.length))
            
            // Detect and link emails
            detectAndLinkEmails(in: attributed)
            
            // Detect and link websites
            detectAndLinkWebsites(in: attributed)
            
            // Detect and link phone numbers
            detectAndLinkPhones(in: attributed)
            
            textView.attributedText = attributed
            textView.selectedRange = cursor
        }
        
        private func detectAndLinkEmails(in attributed: NSMutableAttributedString) {
            let pattern = "(?i)[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}"
            let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches = regex.matches(in: attributed.string, options: [], range: NSRange(location: 0, length: attributed.length))
            
            for match in matches {
                let matchText = (attributed.string as NSString).substring(with: match.range)
                if let url = URL(string: "mailto:\(matchText)") {
                    attributed.addAttribute(.link, value: url, range: match.range)
                    attributed.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: match.range)
                    attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: match.range)
                }
            }
        }
        
        private func detectAndLinkWebsites(in attributed: NSMutableAttributedString) {
            // Valid TLDs - expand as needed
            let validTLDs = [
                "com", "org", "net", "edu", "gov", "mil", "int",
                "co", "in", "uk", "us", "ca", "au", "de", "fr", "jp", "cn", "br", "ru",
                "io", "ai", "app", "dev", "tech", "info", "biz", "me", "tv", "xyz",
                "online", "store", "site", "space", "club", "pro", "life", "world"
            ]
            
            // Pattern: (optional http/https)(optional www.)domain.validTLD(optional /path)
            // Must be preceded by space or start, followed by space, punctuation or end
            let pattern = "(?:^|\\s|^)((?:https?://)?(?:www\\.)?[A-Za-z0-9][A-Za-z0-9-]*[A-Za-z0-9]\\.[A-Za-z]{2,}(?:\\.[A-Za-z]{2,})?(?:/[^\\s]*)?)(?=\\s|$|[,.;:!?)])"
            
            let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches = regex.matches(in: attributed.string, options: [], range: NSRange(location: 0, length: attributed.length))
            
            for match in matches {
                // Get the captured group (index 1) which excludes leading whitespace
                let matchRange = match.range(at: 1)
                let matchText = (attributed.string as NSString).substring(with: matchRange)
                
                // Validate that the TLD is in our whitelist
                if isValidWebsite(matchText, validTLDs: validTLDs) {
                    let urlString = matchText.hasPrefix("http") ? matchText : "https://\(matchText)"
                    if let url = URL(string: urlString) {
                        attributed.addAttribute(.link, value: url, range: matchRange)
                        attributed.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: matchRange)
                        attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: matchRange)
                    }
                }
            }
        }
        
        private func isValidWebsite(_ text: String, validTLDs: [String]) -> Bool {
            // Extract the TLD from the URL
            var domain = text
            
            // Remove protocol
            if domain.hasPrefix("http://") {
                domain = String(domain.dropFirst(7))
            } else if domain.hasPrefix("https://") {
                domain = String(domain.dropFirst(8))
            }
            
            // Remove path
            if let slashIndex = domain.firstIndex(of: "/") {
                domain = String(domain[..<slashIndex])
            }
            
            // Split by dots and get TLD parts
            let parts = domain.split(separator: ".")
            
            guard parts.count >= 2 else { return false }
            
            // Check for multi-part TLDs like .co.in, .co.uk
            if parts.count >= 3 {
                let lastTwo = "\(parts[parts.count - 2]).\(parts[parts.count - 1])".lowercased()
                if validTLDs.contains(String(parts[parts.count - 2]).lowercased() + "." + String(parts[parts.count - 1]).lowercased()) {
                    return true
                }
            }
            
            // Check single TLD
            let tld = String(parts.last!).lowercased()
            return validTLDs.contains(tld)
        }
        
        private func detectAndLinkPhones(in attributed: NSMutableAttributedString) {
            let pattern = "(?:^|\\s)([0-9]{10})(?=\\s|$)"
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: attributed.string, options: [], range: NSRange(location: 0, length: attributed.length))
            
            for match in matches {
                let matchRange = match.range(at: 1)
                let matchText = (attributed.string as NSString).substring(with: matchRange)
                if let url = URL(string: "tel:\(matchText)") {
                    attributed.addAttribute(.link, value: url, range: matchRange)
                    attributed.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: matchRange)
                    attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: matchRange)
                }
            }
        }
    }
}
