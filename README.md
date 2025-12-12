# LinkDetector

Lightweight Swift package to detect phone numbers, emails, and website links inside a string and return ordered, tappable items (text + URL). Ideal for use in SwiftUI/UIKit projects that need simple link extraction logic.

---

## Features

* Detects phone numbers, emails and website-like strings
* Returns ordered `DetectedItem` objects with `text` and `URL?`
* Works on iOS and macOS (minimum platform set in Package.swift)
* Simple, dependency-free API — ready to import via Swift Package Manager

---

## Requirements

* Swift 5.9+
* Xcode 15+
* Platforms defined in `Package.swift` (example in this repo uses iOS 14+, macOS 12+)

---

## Package structure

```
LinkDetector/
├── Package.swift
├── README.md
└── Sources/
    └── LinkDetector/
        └── LinkDetector.swift
```

`LinkDetector.swift` contains two public types:

* `public struct DetectedItem: Identifiable` — holds `text: String` and `url: URL?`
* `public class LinkDetector` — contains `public static func detectLinks(in:) -> [DetectedItem]`

---

## Installation

### Add via Swift Package Manager (recommended)

1. In Xcode open your app/project.
2. **File → Add Packages...**
3. Paste your repository URL (e.g. `https://github.com/<your-username>/LinkDetector`).
4. Choose the version/tag you want (for example `1.0.0`) and click **Add Package**.
5. Import and use in your code:

```swift
import LinkDetector

let items = LinkDetector.detectLinks(in: "Contact: noman@gmail.com or visit example.com or call 9876543210")
```

### Add manually (copy source)

If you prefer not to use SPM, copy `Sources/LinkDetector/LinkDetector.swift` into your project and make sure the types you need are `public`.

---

## Quick Usage Example (SwiftUI)

```swift
import SwiftUI
import LinkDetector

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

> Note: For a fully editable single-field experience with live clickable links you should use a `UITextView`-based wrapper as described in the project examples. `TextField` cannot display clickable attributed links.

---

## Publishing your package (GitHub + SPM)

1. Create a Git repository and push the package root (the folder containing `Package.swift`).

```bash
git init
git add .
git commit -m "Initial commit: LinkDetector"
git remote add origin https://github.com/<your-username>/LinkDetector.git
git branch -M main
git push -u origin main
```

2. Create a release tag (semantic version)

```bash
git tag 1.0.0
git push origin 1.0.0
```

3. In Xcode add the package via **File → Add Packages...** using the repo URL and select the tag.

---

## Testing

A test target exists in `Package.swift` as `LinkDetectorTests`. Add XCTest files under `Tests/LinkDetectorTests` and run tests via Xcode or `swift test`.

---

## Contributing

Contributions are welcome. Please follow these guidelines:

* Create feature branches from `main`.
* Add tests for new behavior.
* Keep API surface small and stable.

---

## License

Add your chosen license here (MIT is a common choice). Example `LICENSE` file content for MIT:

```
MIT License

Copyright (c) YYYY <Your Name>

Permission is hereby granted, free of charge, to any person obtaining a copy
... (standard MIT text) ...
```

---

## Support

If you run into trouble installing the package or want help integrating with SwiftUI or UITextView wrappers, open an issue on the repository or contact the maintainer.
