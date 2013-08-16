#OTNotification

##Feature

*  Create notifications like push notifications' cube animation in iOS6, covering status bar.  
*  Use NO private API. Only QuartzCore and runtime used.  
*  Supports all screen orientations.
*  Supports iPhone and iPad.
*  Supports iOS4/5/6/7. Tested in SDK6.1, runtime 5.0 - 7.0 dp5.
*  Use ARC.

##Screenshots

![screen shot iphone 1](https://raw.github.com/OpenFibers/OTNotification/master/ScreenShots/screenshot-iphone1.png)

![screen shot iphone 2](https://raw.github.com/OpenFibers/OTNotification/master/ScreenShots/screenshot-iphone2.png)

![screen shot iphone 3](https://raw.github.com/OpenFibers/OTNotification/master/ScreenShots/screenshot-iphone3.png)

![screen shot ipad 1](https://raw.github.com/OpenFibers/OTNotification/master/ScreenShots/screenshot-ipad1.png)

![screen shot ipad 2](https://raw.github.com/OpenFibers/OTNotification/master/ScreenShots/screenshot-ipad2.png)

![screen shot ipad 3](https://raw.github.com/OpenFibers/OTNotification/master/ScreenShots/screenshot-ipad3.png)


#How to use
1. Add QuartzCore.framework to your project.
2. Copy `OTNotification` to your project.
3. import "OTNotification.h"
4. call notification APIs. e.g.

```
    OTNotificationManager *notificationManager = [OTNotificationManager defaultManager];
    OTNotificationMessage *notificationMessage = [[OTNotificationMessage alloc] init];
    notificationMessage.title = [self notificationTitle];
    notificationMessage.message = @"A notification. Touch me to hide me.";
    [notificationManager postNotificationMessage:notificationMessage];
```

More API usage in `OTNotificationDemo/ViewController.m`

#Modules
*  Use [OTScreenshotHelper](https://github.com/OpenFibers/OTScreenshotHelper) to make screenshots of views and status bar.
*  Use [OTCubeRotateView](https://github.com/OpenFibers/OTCubeRotateView) to do cube rotate animation.

#Lisence
The MIT License (MIT)

Copyright (c) <2013> <OpenFibers>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
