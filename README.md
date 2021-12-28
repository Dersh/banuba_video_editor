# banuba_video_editor

## Integration steps

### Android
* add banuba token in app/src/main/res/values/string.xml
```
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="banuba_token">TOKEN</string>
</resources>
```
* add in app/build.gradle inside android {}
```
    packagingOptions {
        pickFirst '**/libyuv.so'
    }
        kotlinOptions {
        jvmTarget = '1.8'
    }
```
* add banuba dependencies in app/build.gradle dependencies section
* add di files 
* add a class that extends the FlutterApplication and contains the startKoin function in onCreate method
* add this class name to app/src/main/AndroidManifest.xml in application.name
* add config files inside the android/app/src/main/assets folder
* add styles in app/src/main/res/values/styles.xml and add VideoCreationActivity inside application tag in app/src/main/AndroidManifest.xml

### Ios
* add pod dependencies to Podfile
* add usage desctiptions in Info.plist