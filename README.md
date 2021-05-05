# DogeWalk

**UNDER CONSTRUCTION**
DogeWalk is my gratuation Project for the [Udacity iOS Developer Nanodegree](https://www.udacity.com/course/ios-developer-nanodegree--nd003).
Even after passing the program, i continue to tweek and improve this App as a passion project with the plan of eventually releasing it on the App Store in the future.

### About this Project
DogeWalk is **still under construction** and not finished yet.
I constantly try to leave my main thread in a build-able state, but crashes can still occur.
Please keep this in mind when you take a look at the code. 

### What does DogeWalk do?
With DogeWalk you can add create a profile for your dog and track your walks together. 
You can add the Profile Image of your dog by taking a cute picture or selecting an existing image from your library. The Profile also covers your dogs age, breed, sex as well as its favourite toy and treat. 
Inside the `dog tabView`, all your registered Dogs will be listed. By selecting a dog you can inspect all the walks you have done with that dog or even go a step further and edit its information.
Inside the `paw tabview`, all your walk will be listed. Select a walk to get further information. Like, which dog was present during that walk, and which route you took. 
It doesnt matter if you have one dog or 5, when you start a walk you can select all your furry companions that are participating in this particular walk.
Once the walk has started, you can see the distance you covered as well as the time you spent on this walk. 
The walk will be saved and can be viewed in your DogeWalk App! 

### How to install DogeWalk?
1. Clone/Download repo
2. Open `DogeWalk.xcoderj` in Xcode
3. Build & run!

### Requirements
- `Swift 5+`
- `Xcode 12+`.
Please make sure to not use older versions of Xcode to ensure a smooth build 

### Used API
For this project i used this [DogAPI](https://dog.ceo/dog-api/documentation/) to fetch a list of dog breeds

### What are the upcoming implementations for DogeWalk
#### General tasks
- [ ] migration from API usage for dog breed to storing breedlist locally
- [ ] migration from CoraData to Realm
- [ ] **REFACTOR** 

#### CurrentWalkVC
- [x] creation of annotations for dog activity when button is pressed
- [x] creation of expandable Button menu

#### CalendarView
- [ ] Implementation of a Dog calendar for doctor appointments and overall dog mood

#### StatisticView
- [ ] Display statistics for your dog