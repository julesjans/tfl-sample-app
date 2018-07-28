
# TFL iOS Coding Challenge  #

A sample app that accesses the TFL REST API at https://api.tfl.gov.uk, and displays statuses for major London roads.

![tfl-app](http://bucket-uk.julesjans.com.s3.amazonaws.com/Misc/Images/tfl-app.gif)

##  Configuration & build ##

The app has been built in Xcode 9.3 & Swift 4.1.

The  app needs to be configured with API credentials. These need to be put in the *Secret.swift* file. This method is adequate for a demo but a more robust solution could/should be used in a production app. 
The renamed file will be ignored by git.

1. Clone the repo and copy *Secret.swift.example*  to *Secret.swift*, open *tfl-app.xcodeproj* and ensure that *Secret.swift* is then added to the project, 
and "Target Membership" is checked for tfl-app.

```
git clone https://github.com/julesjans/tfl-app.git
cd tfl-app
cp Secret.swift.example Secret.swift
```
2. Enter relevant credentials in *Secret.swift*:

```Swift
enum APICredentials {
    static let app = "Your ApplicationID here"
    static let key = "Your API Key here"
}
```
3. The project should now build in Xcode, no further dependencies needed.

##  Overview ##

### *tfl-app/* ###

* APIClient - Protocols and class for handling API requests.
* Road - Model definition, complies with protocol for API access
* ViewController
* Storyboard

### *tfl-app/Supporting Files* ###

Contains configuration and necessary files for the app to run, also contains seed data for tests, assets and UIColor extension for colours.


##  Testing ##

There are two test targets, both of which can be run through the standard test menu functions in Xcode.

1. *tfl-appTests/* - standard unit tests for the model and the API. Tests both a mock API and the live API.

2. *tfl-appUITests/* - BDD style user story tests, these are tested using the mock API using **XCUIApplication** launch arguments and dependency injection in the view controller.


##  Notes ##

### Assumptions ###

I have assumed that:

* The app always has network connectivity. In production I would add handling for connection issues.

* All roads will have strings for displayName, statusSeverity, statusSeverityDescription & bounds. If either displayName, statusSeverity, statusSeverityDescription
are missing the Road object will not be created.

* When a road id is requested, successful reponses from the API are always in the form of a single item array.

* All urls are valid when lowercase and percent-encoded.

### Severity Levels ###

I have taken severity levels from: https://api.tfl.gov.uk/Road/Meta/Severities, which I have then mapped to a colour scale.

### Coordinates ###

The coordinates returned by the API are in the format [Lng, Lat] and therefore the bounds are in the format [West, South, East, North]. 
I have transposed them to [Lat, Lng] to create bounds of  [NorthWest, SouthEast].

The "envelope" attribute contains [Lng, Lat] coordinates plotting a closed path of the bounds with all four corners of the rectangle. 
Provided this remains a rectangle this is redundant and can be inferred from the bounds attribute.


## Valid roads & alternative version ##

Using the endpoint: https://api.tfl.gov.uk/road, I have made a feature branch — https://github.com/julesjans/tfl-app/tree/feature/picker —
that replaces the text input field with a picker, requesting all the information in one call when the view loads. Using this method ensures that the user
cannot enter an invalid road. Tests have been updated on this branch to reflect the changes.

![tfl-app-picker](http://bucket-uk.julesjans.com.s3.amazonaws.com/Misc/Images/tfl-app-picker.gif)
