Notes for Take Home test
=============================
Cocoapods
---------
The project uses the standard CocoaPods project layout, i.e. it has a podfile and it is recommended to use the .xcworkspace instead of the .xcproject to open and work with the project. There are no dependencies added, yet.

Minimize 3rd party libraries
---------
As guided to "minimise the usage of 3rd party libraries", I have deliberatedly added no external libraries, at all. Appropriate choices have been taken to accommodate this.

Unit Tests and UI Tests
---------
I have added Unit tests to test the main Flickr data model object in use. I've also added a thorough Xcode UI Test that walks through all of the main application logic with regards to adding search phrases, filtering and deleting search phrases and scrolling / paging through the Flickr result set. Please note: The UI tests depend on keyboard focus, please toggle Software keyboard On (Cmd + K) if running in the iOS simulator.

Code clarity
---------
I have tried to be neat, clear and concise in the code project. Wherever the logic was not directly clear, I have tried to add comments to explain it.

Production ready
---------
Even with the choices / accommodations below, I believe the code is production ready. I had the time to quickly add an App Icon using the amazing generator from https://appicontemplate.com/ by Michael Flarup.

Choices / Accommodations
------------------------
 * **No dedicated image cache**: I could have used one of the many 3rd party memory / disk caches to better handle thumbnails being available persistently, but deliberately chose to not use one, to minimize dependencies. Instead of coding one from scratch, to save time, I went with the native iOS `NSURLCache` and it worked out pretty decently.

 * **No dedicated NSURLSession delegate**: I used a `NSURLCache` for a separate `NSURLSession` to download image thumbnails. The API calls to flickr use the app-wide shared session available from `NSURLSession`. This was deliberately done, to reduce code complexity and because only native `NSURLCache` caching is in use. If I was using a custom coded cache I would have maintained a separate `NSURLSession` delegate that would handle on-disk cache and directly vend `UIImage` objects using custom callback blocks. Without custom caching there was no point in maintaining a separate delegate and thus I opted to directly use the callback block methods on `NSURLSession`.

 * **Search phrases are stored in a keyed archive**: I would ideally have used realm.io for a storage database, especially for storing a list of saved search history, as required. But in the interest of keeping the dependencies to a minimum, I opted to use the native `KeyedArchiver` / `KeyedUnarchiver` functionality to maintain search history. I also went beyond the minimum specification given, and added the following specifications since it made sense to do so:
    * Search history items can be deleted by swiping left and pressing the delete button that appears
    * Search history gets filtered when typing in the search bar. Filtered items can be tapped to search and swiped to be deleted
    * Search history items are sorted most recent to oldest
    * Tapping or re-searching for a search phrase moves it to the top of the history list; search phrases are de-duplicated.

