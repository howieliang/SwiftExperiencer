# SwiftExperiencer
This project aims to port an adapted version of [Experiencer](https://experiencer.eu) to the iOS platform. The goal of this extension is to support DRM (Day Reconstruction Method) [1] by utilising ESM. It has been shown in multiple studies that relying on one of the two methods can lead to bias [2, 3]. The hypothesis is that by combining these two methods, users can remember more of key moments in their day better. The project features a watchOS app where users can enter their current mood (on a scale from 1-4) which is then stored in addition to their current location and recent heart rate entries (at most 2h before the entry, at least right up until the previous entry) in the user's private iCloud. The corresponding iPhone app visualises the entered data/data gathered through Apple's internal Health Kit.

## Visuals
Smartwatch App             |  Smartwatch Widget
:-------------------------:|:-------------------------:
<img width="183" alt="smartwatch_app_experiencer" src="https://github.com/user-attachments/assets/023be266-49b3-4fd1-b81f-3971dc4573cd">  |  <img width="139" alt="smartwatch_widget_experiencer" src="https://github.com/user-attachments/assets/6d61598a-ef41-405e-979e-4401cd2d5e3a">
### Smartphone App
https://github.com/user-attachments/assets/f77177c2-03f6-452b-9009-dd49239fa94c

## Prerequisites
* [Xcode](https://developer.apple.com/xcode/) (version >=15.0)
* Python3 installation (to export data)
* (Free) Apple Developer account
* [Register app ID in Apple Developer account dashboard](https://developer.apple.com/help/account/manage-identifiers/register-an-app-id/)
  
### For testing on device
* An active [Apple Developer account](https://developer.apple.com) to utilise CloudKit (for storage). To add your Developer Account to the project, see the screenshot below:
  <img width="1280" height="560" alt="How to add developer account" src="https://github.com/user-attachments/assets/7bca89b5-46d2-4042-9bdb-3e5acd86bb97">
* [Register device for provisioning profile](https://developer.apple.com/help/account/register-devices/register-a-single-device)
## How to run
* Change the bundle identifier to match the one from your Apple Developer account (see screenshot above). This has to be changed for target `SwiftExperiencer`, `SwiftExperiencer Watch App` and `WatchWidget Extension` (see screenshot above).

* Change the `WatchKit Companion App Bundle Identifier` to match your bundle identifier: <img width="750" alt="Screenshot of WatchKit Companion App Bundle Identifier" src="https://github.com/user-attachments/assets/0f26507a-ce49-4445-916c-5f345e22c7fc">
* Select your target: \
  <img width="402" alt="image" src="https://github.com/user-attachments/assets/8c2ebd1d-d002-4235-a49f-cc7102e428db"> \
  ... followed by CMD + R (Build)
* Enable/disable dummy db for iOS app in file `SwiftExperiencerApp`, line 17-18

## How to export data
* Run `python server_upload.py` (in the directory of the project), ensure port 8001 is not in use. If you connect from a physical device, update `IP_ADDRESS` in the python file. If you want to update the default port, update the variable `PORT` in the same python file.
* Interact with the button "Export" on the device (ensure device and server are connected to the same network) and enter the corresponding URL, e.g. `http://localhost:8001 : \
  <img width="271" alt="image" src="https://github.com/user-attachments/assets/7c88b4df-2c99-4123-8c13-72d8093182fe">
* File `device_id_data` should have been created in the folder `device_data`

## Current issues & possible next steps
* As private CloudKit repositories are _private_ it is impossible to access user data. For research purposes the data has to be manually exported instead. In the future, a switch to another Database, e.g. to [Gamebus DB](https://blog.gamebus.eu), should be considered.
* Map entries are currently not clickable &rarr; can potentially be added
* Currently there is no interaction with a server and no notificaiton system is in place. A strategy for sending smart notifications (can be scheduled in the first iteration) should be considered.
## References
[1] Kahneman, D., Krueger, A. B., Schkade, D. A., Schwarz, N., & Stone, A. A. (2004). A survey method for characterizing daily life experience: the day reconstruction method. Science (New York, N.Y.), 306(5702), 1776–1780. https://doi.org/10.1126/science.1103572 \
[2] Han, W., Feng, X., Zhang, M., Peng, K., & Zhang, D. (2019). Mood States and Everyday Creativity: Employing an Experience Sampling Method and a Day Reconstruction Method. In Frontiers in Psychology (Vol. 10). Frontiers Media SA. https://doi.org/10.3389/fpsyg.2019.01698 \
[3] Diener, E., & Tay, L. (2013). Review of the Day Reconstruction Method (DRM). In Social Indicators Research (Vol. 116, Issue 1, pp. 255–267). Springer Science and Business Media LLC. https://doi.org/10.1007/s11205-013-0279-x
