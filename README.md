# ImageCrowlerApp
ImageCrowlerApp - CollectionView infinite scrolling

Description:
- An applcation which loads images from paginated api in collection view with layout of 3 columns
- Supports infine scrolling with paginated loading of data per page asynchronously.
- Supports In memory caching and filemanager cachcing if the image data is not available in in-memory cache.
- For In-memory caching using the NSCache which support LRU eviction for storing the data in it by default. In consideration with the defined maximum capacity.
- Images are being loaded lazily for the visible cells only, if the cell becomes invisible the operation task for that cell will be cancelled if the operation is not completed.
- Each item is of square size and image is centered to the item in the collection view cell
- No Third party library is used.
- iOS deployment target - iOS 15.0 and above

Requirements:
- Compiled on Xcode: 15.0.1
- Tested on: iOS 17.0

Instruction : Please check the signing certificate if the code does not build and try clean build folder.
