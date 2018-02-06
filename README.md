# Countdowner
![Countdowner logo](https://raw.githubusercontent.com/rafaelcpalmeida/Countdowner/master/img/countdownerLogo.jpg)

Countdowner is a simple tool that I built to help to keep a track on time. It shows a countdown watch and its purpose is to help someone who's presenting something to an audience to extend their available time slot. It is available for both **macOS** and **iOS**.

## Contents
- <a href="#how-it-works">How it works</a>
- <a href="#usage-instructions">Usage instructions</a>
- <a href="#compile-instructions">Compile instructions</a>
- <a href="#known-bugs">Known bugs</a>
- <a href="#thanks-to">Thanks to</a>
- <a href="#license">License</a>

# How it works
From out of the box Countdowner is configured to 30 minutes. If you wish to change this time just press the white cog visible on the rectangle and insert a new time, in seconds.

In the images below you can see the workflow for Countdowner:
### Step 1
![Countdowner logo](https://raw.githubusercontent.com/rafaelcpalmeida/Countdowner/master/img/step1.jpg)

### Step 2
![Countdowner logo](https://raw.githubusercontent.com/rafaelcpalmeida/Countdowner/master/img/step2.jpg)

### Step 3
![Countdowner logo](https://raw.githubusercontent.com/rafaelcpalmeida/Countdowner/master/img/step3.jpg)

In the images above you saw the flow of the **macOS** app. In the **iOS** version the app will fill the whole screen with the correspondent color.

# Usage instructions
Below you can find the instructions for **macoS** and **iOS** versions.

## macOS
- Left click anywhere on the window (except the cog) and the timer will start or stop, if the timer was stopped or running, accordingly.
- Right click anywhere on the window (except the cog) and the timer will be reseted and ready to be executed.
- Click on the cog to set the timer, in seconds

## iOS
- Single tap on the screen and the timer will start or stop, if the timer was stopped or running, accordingly.
- Click on the cog to set the timer, in seconds

# Compile instructions
In order to compile the app to either **macOS** or **iOS** you'll need an Apple Developer account. You can get yours at the [Apple Developer Portal]. Below you'll find instructions for both platforms.

## macOS
- Download the project ZIP or clone this repo in your machine.
- Open the project on **Xcode**
- Enter the project config page by:
    - Clicking the project name just below Xcode window controls
    - Go to **General** tab and just below **Targets** you'll see two entries: `Countdowner` and `Countdowner iOS`. Make sure to select the first one
    - Under **Identity** you'll find a field named `Bundle Identifier`. Change it accordingly (i.e.: **com.yourName.Countdowner**)
    - Under signing select your Team
- Build and run the app

## iOS
**iOS** compile instructions will be available soon.

# Known bugs
None at the moment.

# Thanks to
- [P.J. Onori] and [Maxim Popov] for the beautiful icons

# License

MIT

**Made with :heart: in Portugal**

**Software livre c\*ralho! :v:**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [P.J. Onori]: <https://www.iconfinder.com/icons/118694/cog_icon>
   [Maxim Popov]: <https://www.freepik.com/free-vector/business-man-hand-holding-stopwatch_1311462.htm>
   [Apple Developer Portal]: <https://developer.apple.com>
