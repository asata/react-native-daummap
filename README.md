# react-native-daummap

 <!-- [![npm](https://img.shields.io/npm/v/npm.svg)](react-native-daummap) [![Github All Releases](https://img.shields.io/github/downloads/atom/atom/total.svg)](react-native-daummap) [![npm](https://img.shields.io/npm/l/express.svg)](react-native-daummap) -->

# Content
- [Installation](#installation)
- [Usage](#usage)

***

| iOS | Android |
|-----|---------|
|<img src="https://user-images.githubusercontent.com/899614/40526246-3b4a1c08-6020-11e8-8759-a6fb0ab99a78.png" alt="iOS ScreenShot" width="300px" />|<img src="https://user-images.githubusercontent.com/899614/40526080-05f7d0a0-601f-11e8-9acf-f2810ef01ad6.png" alt="Android ScreenShot" width="300px" />|

***

# Installation
## 1. Download
`npm i -S react-native-daummap`

## 2. Plugin Installation
### Mostly automatic installation
`react-native link react-native-daummap`

### Manual installation
#### iOS
1. In XCode, in the project navigator, right click Libraries ➜ Add Files to [your project's name]
2. Go to node_modules ➜ react-native-daummap and add DaumMap.xcodeproj
3. In XCode, in the project navigator, select your project. Add libDaumMap.a to your project's Build Phases ➜ Link Binary With Libraries
4. Select your project → Build Settings → Search Paths → Header Search Paths to add:
    `$(SRCROOT)/../node_modules/react-native-daummap/ios/DaumMap`

#### Android
1. In your android/settings.gradle file, make the following additions:
```
include ':react-native-daummap'   
project(':react-native-daummap').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-daummap/android/app')
```
2. In your android/app/build.gradle file, add the :react-native-splash-screen project as a compile-time dependency:
```
...
dependencies {
    ...
    compile project(':react-native-daummap')
}
```
3. Update the MainApplication.java file to use react-native-splash-screen via the following changes:
```
...
import com.teamsf.daummap.DaumMapPackage;
...

public class MainApplication extends Application implements ReactApplication {
    private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {

        ...

        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                new MainReactPackage(),
                new DaumMapPackage()
            );
        }

        ...
    }
}
```
## 3. 다음 지도 SDK 추가
##### iOS
1. [다음 지도 SDK 다운로드](http://apis.map.daum.net/ios/guide/)
2. XCode Project navigator에서 프로젝트 이름을 오른쪽 버튼으로 클릭 후 "Add Files to [your project's name]" 선택
3. 다운로드 받은 SDK 폴더로 이동해 libv폴더 안에 있는 DaumMap.embeddedframework 폴더를 선택, 아래 "Copy items if needed"와 "Add to targets"를 선택 후 Add

    ![xcodeaddframework](https://user-images.githubusercontent.com/899614/40526075-fed2087c-601e-11e8-9bbd-a6df4fe207de.jpeg)
    
4. XCode에서 프로젝트 이름을 선택 후 General - Linked Frameworks and Libraries에 3번에서 추가한 DaumMap.framework를 추가

    <img src="https://user-images.githubusercontent.com/899614/40571726-12ff54e8-60d9-11e8-974d-34767ddb460e.gif" alt="DaumMap.framework Add" width="550px" />
<!--
해당 기능 동작 추가 확인 필요
- Build Setting 추가
    - Other Linker Flags
        ```
        -force_load $(PROJECT_DIR)/../node_modules/react-native-daummap/ios/DaumMap.embeddedframework/DaumMap.framework/DaumMap
        ```
    - Header Search Paths
        ```
        $(PROJECT_DIR)/../node_modules/react-native-daummap/ios
        ```
    - Framework Search Paths
        ```
        $(PROJECT_DIR)/../node_modules/react-native-daummap/ios/DaumMap.embeddedframework/
        ```
-->

#### Android
- 별도 작업 없음

## 4. 네이티브 앱 키 발급 및 Bundle ID, 키 해시 등록
1. [Kakao Developer](https://developers.kakao.com/apps)에서 애플리케이션을 등록
2. 등록한 애플리케이션을 선택 후 설정 - 일반으로 이동
3. 플랫폼(iOS, Android) 추가

#### iOS
4. 번들 ID에 개발 앱 번들 ID 등록 후 저장
5. 상단에 있는 "네이티브 앱 키"를 복사
6. Info.plist에 KAKAO_APP_KEY 추가
```
    <dict>
        ...
        <key>KAKAO_APP_KEY</key>
        <string>발급 받은 APP KEY</string>
        ...
    </dict>
```

#### Android
4. 패키지명에 개발 앱 패키지명 추가
5. 키 해시는 터미널에서 아래 명령 수행한 결과 값 입력
```
keytool -exportcert -alias androiddebugkey -keystore [keystore_path] -storepass android -keypass android | openssl sha1 -binary | openssl base64
```
- Debug일 경우 Keystore 경로는 ~/.android/debug.keystore에 저장되며 비밀번호는 android
6. 상단에 있는 "네이티브 앱 키"를 복사
7. AndroidManifest.xml에 Permission 과 APP KEY 추가
```
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <application>
        ...
        <meta-data android:name="com.kakao.sdk.AppKey" android:value="발급 받은 APP KEY"/>
        ...
    </application>
```
***

# Usage
```
import MapView form 'react-native-daummap';

<MapView
    initialRegion={{
        latitude: 36.143099,
        longitude: 128.392905,
        zoomLevel: 5,
    }}
    mapType={"Standard"}
    style={{ width: 300, height: 300, }}
/>
```
## Properties
| Property      | Type   | Default  | Description |
|---------------|--------|----------|-------------|
| initialRegion | Object | {}       | 지도 초기 화면 좌표 및 확대/축소 레벨 |
| mapType       | String | Standard | 지도 종류 (기본 지도 - Standard, 위성 지도 - Satellite, 하이브리드 지도 - Hybrid)
| markers       | Object | {}       | 지도 위에 추가되는 마커 정보 |
| region        | Object | {}       | 지도 중심점 좌표, 지도 이동시 사용 |
| onRegionChange| Function|         | 지도 이동시 변경되는 좌표값 반환 |
| onMarkerSelect| Function|         | 마커 핀을 선택한 경우 |
| onMarkerPress | Function|         | 마커 위 말풍선을 선택한 경우 |

### initialRegion
| Property      | Type   | Default  | Description   |
|---------------|--------|----------|---------------|
| latitude      | Number | 36.143099| 위도 좌표값      |
| longitude     | Number | 128.392905| 경도 좌표값     |
| zoomLevel     | Number | 2        | 확대/축소 레벨 (-2~12, 값이 클수록 더 넓은 영역이 보임)|

### markers
| Property      | Type   | Default  | Description   |
|---------------|--------|----------|---------------|
| latitude      | Number | 36.143099| 위도 좌표값      |
| longitude     | Number | 128.392905| 경도 좌표값     |
| title         | String |          | 마커 이름, 마커 선택시 표시 |
| pinColor      | String | blue     | 마커 핀 색상     |
| selectPinColor| String | red      | 선택된 마커 핀 색상 |

### region
| Property      | Type   | Default  | Description   |
|---------------|--------|----------|---------------|
| latitude      | Number |          | 위도 좌표값      |
| longitude     | Number |          | 경도 좌표값      |

***
