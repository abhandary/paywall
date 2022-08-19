# Disney Streaming Take-Home

Welcome to the Disney Streaming take-home interview!

Check out the [prompt](PROMPT.md) to get started.

## README Questions:

## XCode version used

* 13.4.1

## To run

* run directly from XCode

## Assumptions in the code.
* That the UI layout can be stacked vertically, the currently layout enginge works for simple vertically stacked layouts, but will not scale to more complex layouts that need a combination of horizontal and vertical stacks.

## Focus Areas and problems I was looking to solve

**Modularization & Inter Module Communication**
* Consistent use of completion handlers and dispatch queues to enable inter module communications that require awaiting of results. 
* Use of Combine as glue between View Model and View layer.
* Adhering to SOLID principles with each module having a single reponsibility. Use of protocols for repo and network module to enable dependency injection, LSP, interface segregation and dependency-inversion, this also supports use of mocks for unit testing.
* Layering of the app using MVVM architecture style with a separate service layer.
* Use of a Repository, this enables abstraction of source of truth. Repo then can then fetch from Network or a local data store as needed. This also can create a parallel with Android where the repository can mirror the work done by an Android service enabling an Android version of this app to use a similar and consistent architecture.

**UI**
* Use of adaptaive layout for the UI as much as possible to enable driving the using using the JSON response which contains custom declarative attributes and components that get mapped to UIKit components, stacks and constraints.

## Some things you I would have liked to do if I had more time. 
* Use of Actors, Tasks and async, await for inter-module communication. Note that I used this approach in a demo app I had written earlier - https://github.com/abhandary/employeedirectory, however used dispatch queues and completion handlers in this project. 
* Exploring using SwiftUI to do the layout. I have have used SwiftUI for this demo app I had written earlier to render a list view - https://github.com/abhandary/bookstore, however SwiftUI is relatively new for me, so would have needed more time to figure out how to do the JSON driven adaptive lahyout. 
* Use of Combine as glue between Service layer and View Model for consistent inter-module communication. This would also enable any updates in the repo, initiated from elsewhere in the app, to get published to the view model and update the view without use of mechanims such as delegate callbacks.
* Use of a better adapative layout engine that would use a combination of verical and horizontal stack views to enable laying out and rendering more complex UIs. The JSON would have contained nested declarations for these stacks and would have specifed the stack type, alignment etc and that would be converted into UIKIt of SwiftUI based layouts.   
* Use of in-memory caching and persistent asset store for images, note that I used this approach in the demo app here - https://github.com/abhandary/employeedirectory, but didn't use this approach here.
* Implement a disk store that the repo can hit to service paywall requests, as long as they are not considered expired, while the network fetch is in progress. Use network provided paywalls at a later point, i.e. maintain a locally stored pool of paywalls. Here is a simple example written in an earlier demo app - https://github.com/abhandary/reqres/blob/main/ReqRes/ReqRes/Service/DataStore.swift which just stores data in flat files, this can be done with frameworks like sqlite or CoreData if needed and required.

## Edge cases have you considered in your code? What edge cases have you yet to handle?
**Synchornization**
* Tried my best to handle hand off from the main thread to background threads through queues and then getting back onto the main thread when appropriate, the use of serial dispatch queues also provide Actor like behavior, may need to review more closely and test out more thoroughly to see if it's done right.
 


