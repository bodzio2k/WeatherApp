# WeatherApp
This is **how not to make** applications for iOS. It is a classic example of so called MVC - *massive view controller* - the approach often used by beginner developers. Nevertheless application is accepted for App Store so You can see it running on Your device.
It consists of three screens:
 - main screen - displays weather conditions in selected area
 - favorites - where You can arrange by drag and drop favorite locations
 - search - where You can find new locations by search as You type

Application is built on storyboards and segues. It utilises few popular pods:
 - Alamofire for making network requests
 - Swinject/SwinjectStoryboard to implement DI pattern
 - Some SnapKit just to see how this package works
 - Willow for logging

**Main features**
 - Weather data are fetched from [Dark Sky API](https://darksky.net/dev)
- Location names are fetched from [GeoDB Cities API](http://geodb-cities-api.wirefreethought.com/)
- iOS 13 Dark/Light theme
- Reachability for dealing with connections errors
- Prefetching data in collection/table views
- Reverse-geocoding to obtain user-friendly description of a geographic coordinate
- Location Manager to dynamically display current location weather conditions

The application is available at App Store as [Calm Skies](https://apps.apple.com/pl/app/calm-skies/id1493782876). Just grab it and find out how it works. 
