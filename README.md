## Installation

### Add via Swift Package Manager (recommended)

1. In Xcode open your app/project.
2. **File → Add Packages...**
3. Paste your repository URL (e.g. `https://github.com/<your-username>/LinkDetectore`).
4. Choose the version/tag you want (for example `1.0.0`) and click **Add Package**.
5. Import and use in your code:

```swift
import LinkDetectore

let items = LinkDetector.detectLinks(in: "Contact: noman@gmail.com or visit example.com or call 9876543210")
```

### Add manually (copy source)

If you prefer not to use SPM, copy `Sources/LinkDetectore/LinkDetector.swift` into your project and make sure the types you need are `public`.

---

## Quick Usage Example (SwiftUI)

```swift
import SwiftUI
import LinkDetectore

struct DemoView: View {
    @State private var text = "Contact noman@gmail.com or 9876543210 or visit apple.com"

    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $text)
                .frame(height: 140)
                .border(Color.gray)

            let items = LinkDetector.detectLinks(in: text)

            HStack {
                ForEach(items) { item in
                    if let url = item.url {
                        Text(item.text)
                            .foregroundColor(.blue)
                            .underline()
                            .onTapGesture { UIApplication.shared.open(url) }
                    } else {
                        Text(item.text)
                    }
                    Text(" ")
                }
            }
            Spacer()
        }
        .padding()
    }
}
```

 