#  Fetch Mobile Take Home Project - Recipes App


### Summary: Include screen shots or a video of your app highlighting its features

This app features: 
- Fetch list of recipes from remote server and render them in a list
- For each recipe:
  - Images are only being loaded when user scrolls to the recipe (lazy load)
  - Images are cached to disk when it's first loaded.  Subsequent access to image are retrieved from cache, saving making repeated network operation for the same resource
- Pull to refresh
https://github.com/user-attachments/assets/5ad8c4be-bb97-4107-bf14-82c0d1f7e5be

- Empty State for when no recipes have been fetched from server
https://github.com/user-attachments/assets/4d8b574d-1a4d-43dc-b708-3cb1046e46b1

- Error state for when the app encounters error

https://github.com/user-attachments/assets/95106bd7-480b-4d93-b1c1-5b4ca12489a9

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I made an effort to focus on making the project modular with respect to the various subsystems.  I also attempted to make the subsystems generic and written in a way that has as little platform-specific dependencies as possible to promote reusability.  Though there's a bit of overhead in the initial set up, a modular subsystem is much easier to test and iterate features on.  Xcode also saves building time when there are no changes in the modules.  Swift Package Manager makes it fairly straight forward and trivial to set up local packages.  

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

I spent approximately 25 hours on this project.  Roughly about 10~15 hours are spent on feature implementation / debugging / refactoring.  About 2 hours are spent on profiling / performance optimization.  The rest of the time were spent on design / planning / modeling, as well as research and learning about disk based cache.  In the past I've always used third party caching solution, so this is the first time I've had to implement a disk-based cache on my won.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

In terms of architecture, I made the decision to strictly follow MVVM as the general architecture for the project, along with services / repository pattern to manage data and resources.  While this has led to clean interface that promotes testable code, it has led to relatively rigid API.  I find myself having to evolve the interface multiple times so that the client could of these interfaces could get what it needs.  It was very difficult to design the perfect interface from the get go.  In production setting we often don't have the luxury to change interface after the fact.  I think that having a bit more flexiblity, at the expense of testability could serve this project well. 

For the cache subsystem, I made the decision to allow image be fetched and cached in the file system concurrently.  This leads to better UI performance (more images can be downloaded at the same time), but at the expense of excessive write to the file system when images are first loaded.  I believe that a serial queue that enqueuees and process image caching oepration one by one would be better on the disk.  A hybrid in-memory / disk cache could allow the best of both world, allowing for images being fetched concurrently and held in memory cache, while actually saving to disk operation would take place in a serial queue.  Such hybrid system though will be significantly more complex than a pure disk-based cache.  

### Weakest Part of the Project: What do you think is the weakest part of your project?

I think the project could do better on both image processing and disk cache implementation.  Being able to compress image for example, would provide savings on cache.  The cache system should also have space constraint, as well as eviction policy.  Due to constraint on time, I haven't had the chance to research and look into them. However I believe that in a production app the cache system should be one of the most well-tested and full-featured subsystem, especially on space and eviction policy.  Otherwise we risk saving excessive amount of data on disk, which could lead to user deleting the app altogether.  


### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

A Swift Package does not appear to easily share resources between targets.  For the RecipeRepository package, I wanted to a couple of sample payload response for both mock and tests.  It turns out that I need to create yet another target that is then registered as a dependency for the other targets that want to use the resources.  This is the first time I ran into this issue and I find this interesting.  

Using Swift Package Manager makes it easy to modularize the code.  However I have yet to find a way to not include resources in the release build.  Unlike the main project bundle, there is no "Preview Content" in packages.  This could lead to bloated assets being included in release, and we don't want that.  In production setting, I would most likely not use swift package for this subsytem if it requires resources that cannot be stripped away for release build.  
