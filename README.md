# LinkDetectore

LinkDetectore is a Swift Package that provides live detection of email addresses, phone numbers, and website links inside an editable text field. As the user types, detected patterns become clickable links in real time. This is achieved using a `UITextView` wrapped in a SwiftUI-compatible component.

---

## Installation

### Add via Swift Package Manager (recommended)

1. Open your Xcode project.
2. Select **File → Add Packages...**
3. Enter the package URL:

```

https://github.com/Excelsior-Technologies-Community/LinkDetectore

````

4. Select the latest version (for example `1.0.0`).
5. Click **Add Package**.
6. Import the library where you want to use it:

```swift
import LinkDetectore
````

---

## Usage Example (SwiftUI)

The following example shows how to embed the `LiveDetectingTextView` inside your SwiftUI view.
As the user types, emails, phone numbers, and URLs become clickable automatically.

```swift
import SwiftUI
import LinkDetectore

struct ContentView: View {
    @State private var message = ""

    var body: some View {
        VStack {
            Text("Type here, links become clickable LIVE:")
                .font(.headline)

            LiveDetectingTextView(text: $message)
                .frame(height: 200)
                .border(Color.gray.opacity(0.4))

            Spacer()
        }
        .padding()
    }
}
```

---

## What LiveDetectingTextView Does

* Detects and hyperlinks:

  * Email addresses (example: `test@example.com`)
  * Website URLs (example: `apple.com`, `https://google.com`)
  * Phone numbers (example: `9876543210`)
* Updates links instantly as the user types
* Preserves cursor position
* Works entirely inside a single editable field (unlike TextField/TextEditor)

---

## Requirements

* iOS 14+
* Swift 5.7 or later
* Xcode 14 or later
 
