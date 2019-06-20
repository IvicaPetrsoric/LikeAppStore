# LikeAppStore

Copy of Apple AppStore with integrated some functionality utilizing iTunes API. 
The app is segmented in 4 main views: Music, Today, Apps, Search


# Musics

It shows integrating iTunes API call for specifics artist music offering pagination while scrolling down.

<img src="images/music1.png" widht= 150 height = 300  hspace="0" > <img src="images/music2.png" widht= 150 height = 300  hspace="0" > <img src="images/music3.png" widht= 150 height = 300  hspace="0" > 


# Today
Shows apps list separated into two types of cells: app per cell, multiple apps per cell. 
Supporting multi-dimensional collection views enabling opening and closing animations 
and dragging animation for triggering closing animation.

<img src="images/today1.png" widht= 150 height = 300  hspace="0" /> <img src="images/todayFull1.png" widht= 150 height = 300  hspace="0" /> <img src="images/todayFull2.png" widht= 150 height = 300  hspace="0" />

<img src="images/today2.png" widht= 150 height = 300  hspace="0" /> <img src="images/todayFull3.png" widht= 150 height = 300  hspace="0" /> 


# Apps 
Nested collection views, first cell show apps banners and some info about it, second types of cells shows specific apps per type.
By sellecting GET on specific apps, the description of that app i shown with it specific content like thumnails and comments.

<img src="images/apps1.png" widht= 150 height = 300  hspace="0" /> <img src="images/apps4.png" widht= 150 height = 300  hspace="0" /> <img src="images/apps2.png" widht= 150 height = 300  hspace="0" /> <img src="images/apps3.png" widht= 150 height = 300  hspace="0" />


# Search
Last view enables searhcing the App store for specific app with iTunes API fetch.

<img src="images/search1.png" widht= 150 height = 300  hspace="0" /> <img src="images/search2.png" widht= 150 height = 300  hspace="0" /> 


# Main Features:
- Programmatically UI (no Stoaryboards)
- Nested UICollectionViews
- Animation using Auto Layout constraints
- Animating Child View Controller objects
- Modeling using JSON Decodable protocol
- JSON Custom Coding Keys
- Asynchronous Data Fetching
- DispatchGroup Fetch Synchronization
- SDWebImage Caching
- Snapping Collection Flow Layout
- Generics Code Reduction and Reusability
- Pagination Data Fetching
- Dependency Injection
- UIVisualEffectView & UIBlurEffect
- Floating Controls
