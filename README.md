
# TFL iOS App Example  #

##  Configuration ##

The sample app needs to be configured with API credentials. These need to be put in the 'Secret.swift' file. This method is adequate for a demo, and keeps the credentials
out of 'Info.plist', but a more robust solution could/should be used in a production app.

1. Copy `tfl-app/Secret.swift.example`  to `tfl-app/Secret.swift`, ensuring the file is added to the project, and "Target Membership" is checked for tfl-app.

2. Enter relevant credentials:

```Swift
enum APICredentials {
    static let app = "Your ApplicationID here"
    static let key = "Your API Key here"
}
```
