
# TFL iOS App Example  #

##  Configuration ##

The sample app needs to be configured with API credentials. These need to be put in the "Secret.swift" file. This method is adequate for a demo, and keeps the credentials
out of "Info.plist", but a more robust solution could/should be used in a production app.

1. Copy `Secret.swift.example`  to `Secret.swift`, ensuring the file is added to the project, and "Target Membership" is checked for tfl-app.

2. Enter relevant credentials:

```Swift
enum APICredentials {
    static let app = "Your ApplicationID here"
    static let key = "Your API Key here"
}
```

##  Testing ##

There are two test targets, both of which can be run through the standard test menu functions in Xcode.

1. Unit Tests - standard unit tests for the model and the API. Tests both a mock API and the live API using depency injection.

2. UI Tests - BDD style user story tests.



##  API Anomalies ##

### Coordinates ###

The coordinates returned by the API are in the format [Lng, Lat] and therefore the bounds are in the format [West, South, East, North]. I have transposed them to [Lat, Lng] to create bounds of  [NorthWest, SouthEast].

The "envelope" attribute contains [Lng, Lat] coordinates plotting a closed path of the bounds with all four corners of the rectangle. Provided this remains a rectangle this is redundant and can be inferred from the bounds attribute.
