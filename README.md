# react-native-daummap

---
* react-native 다음 지도

[![NPM](https://nodei.co/npm/react-native-daummap.png)](https://nodei.co/npm/react-native-daummap/)

# Content
- [Installation](#installation)
- [Usage](#usage)
    - [Daum Map](#daum-map)
    - [Local Map API](#local-restapi)

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
2. XCode Project navigator에서 Frameworks 폴더를 마우스 오른쪽 버튼으로 클릭 후 "Add Files to [your project's name]" 선택
3. 다운로드 받은 SDK 폴더로 이동해 libs폴더 안에 있는 DaumMap.embeddedframework 폴더에서 DaumMap.framework 파일 선택, 아래 "Copy items if needed"와 "Add to targets"를 선택 후 Add

    ![xcodeaddframework](https://user-images.githubusercontent.com/899614/40526075-fed2087c-601e-11e8-9bbd-a6df4fe207de.jpeg)

4. XCode에서 프로젝트 이름을 선택 후 General - Linked Frameworks and Libraries에 3번에서 추가한 DaumMap.framework를 추가

    <img src="https://user-images.githubusercontent.com/899614/40571726-12ff54e8-60d9-11e8-974d-34767ddb460e.gif" alt="DaumMap.framework Add" width="550px" />

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

7. 트래킹 모드, 나침반 모드 기능 사용시 Info.plist에 아래 내용 추가
    ```
    <dict>
        ...
        <key>NSLocationWhenInUseUsageDescription</key>
        <string>권한 이용 설명 기재</string>
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

    <application>
        ...
        <meta-data android:name="com.kakao.sdk.AppKey" android:value="발급 받은 APP KEY"/>
        ...
    </application>
    ```

***

# Usage
# Daum Map
```
import MapView from 'react-native-daummap';

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
| Property                  | Type      | Default   | Description |
|---------------------------|-----------|-----------|-------------|
| initialRegion             | Object    | {}        | 지도 초기 화면 좌표 및 확대/축소 레벨 |
| style                     |           | {}        | 지도 View Style |
| mapType                   | String    | Standard  | 지도 종류 (기본 지도 - Standard, 위성 지도 - Satellite, 하이브리드 지도 - Hybrid)
| markers                   | Object    | {}        | 지도 위에 추가되는 마커 정보 |
| region                    | Object    | {}        | 지도 중심점 좌표, 지도 이동시 사용 |
| isTracking                | Bool      | false     | 현위치 트래킹 모드 (지도화면 중심을 단말의 현재 위치로 이동) |
| isCompass                 | Bool      | false     | 나침반 모드 (단말의 방향에 따라 지도화면이 회전), 트래킹 모드를 활성화 시켜야 사용 가능 |
| isCurrentMarker           | Bool      | false     | 현 위치를 표시하는 마커 표시 여부, 트래킹 모드 활성화시 true |
| permissionDeniedView      | Component | null      | (Android) 위치 권한이 없을 경우 표시될 View  |
| permissionsAndroidTitle   | String    |           | (Android) 위치 권한 요청시 Alert창 제목 |
| permissionsAndroidMessage | String    |           | (Android) 위치 권한 요청시 Alert창 본문 |
| onRegionChange            | Function  |           | 지도 이동시 변경되는 좌표값 반환 |
| onMarkerSelect            | Function  |           | 마커 핀을 선택한 경우 |
| onMarkerPress             | Function  |           | 마커 위 말풍선을 선택한 경우 |
| onMarkerMoved             | Function  |           | 마커를 이동시킨 경우 |
| onUpdateCurrentLocation   | Function  |           | 트래킹 모드 사용중 좌표가 변경된 경우 |
| onUpdateCurrentHeading    | Function  |           | 나침반 모드 사용시 방향 각도 값이 변경된 경우 |

### initialRegion
| Property          | Type   | Default      | Description   |
|-------------------|--------|--------------|---------------|   
| latitude          | Number | 36.143099    | 위도 좌표값      |
| longitude         | Number | 128.392905   | 경도 좌표값      |
| zoomLevel         | Number | 2            | 확대/축소 레벨 (-2~12, 값이 클수록 더 넓은 영역이 보임) |

### markers
| Property          | Type   | Default      | Description   |
|-------------------|--------|--------------|---------------|
| latitude          | Number | 36.143099    | 위도 좌표값      |
| longitude         | Number | 128.392905   | 경도 좌표값      |
| title             | String |              | 마커 이름, 마커 선택시 표시 |
| pinColor          | String | blue         | 마커 핀 색상 (blue, yellow, red, image) |
| markerImage       | String |              | 마커 사용자 이미지 |
| pinColorSelect    | String | red          | 선택된 마커 핀 색상 (blue, yellow, red, image) |
| markerImageSelect | String |              | 선택된 마커 사용자 이미지 |
| draggable         | Bool   | false        | 마커 이동 여부 |
* 사용자 이미지는 추가 위치
    - Android : android/app/src/main/res/drawable
    - iOS : Xcode Project에 추가

### region
| Property          | Type   | Default      | Description   |
|-------------------|--------|--------------|---------------|
| latitude          | Number |              | 위도 좌표값      |
| longitude         | Number |              | 경도 좌표값      |

***

# Local RestAPI
```
import DaumMap from 'react-native-daummap';

componentDidMount () {
	DaumMap.setRestApiKey("********************************");
}


functionName () {
    DaumMap.serachAddress("양호동")
	.then((responseJson) => {
        // API 결과값 반환
		console.log(responseJson);
	}).catch((error) => {
        // API 호출 중 오류 발생시
		console.log(error);
	});
}
```

## 기능
| 기능명 | Function Name | URL |
|------|---------------|-----|
| Rest API Key 설정     | setRestApiKey | |
| 주소 검색              | serachAddress | https://developers.kakao.com/docs/restapi/local#주소-검색 |
| 좌표 → 행정구역정보 변환  | getCoordToRegionArea | https://developers.kakao.com/docs/restapi/local#좌표-행정구역정보-변환 |
| 좌표 → 주소 변환        | getCoordToAddress | https://developers.kakao.com/docs/restapi/local#좌표-주소-변환 |
| 좌표계 변환            | transCoord | https://developers.kakao.com/docs/restapi/local#좌표계-변환 |
| 키워드로 장소 검색       | searchKeyword | https://developers.kakao.com/docs/restapi/local#키워드로-장소-검색 |
| 카테고리로 장소 검색     | searchCategory | https://developers.kakao.com/docs/restapi/local#카테고리로-장소-검색 |
 * API Key는 "네이티브 앱 키"가 아닌 "REST API 키"입니다.
     - 네이티브 앱 키 사용시 에러가 발생합니다.
 * 각 API 호출 반환값은 Daum API 문서를 참고 해 주세요.

## 각 함수 설명
 * Rest API Key 설정 (setRestApiKey)
    - RestAPI Key 설정
    - Parameter : API Key(필수)
    - Example : setRestApiKey(API_Key)


* 주소 검색 (serachAddress)
    - 주소를 지도 위에 정확하게 표시하기 위해 해당 주소의 좌표 정보를 제공
    - Parameter : 검색어(필수), 결과 페이지 번호(선택, 기본값 : 1), 한 페이지에 보여질 문서의 개수(선택, 기본값 : 10)
    - Example : serachAddress("양호동", 1, 10) or serachAddress("양호동")


* 좌표 → 행정구역정보 변환 (getCoordToRegionArea)
    - 해당 좌표에 부합되는 행정동, 법정동을 얻는 API
    - Parameter : 위도(필수), 경도(필수), 입력되는 값에 대한 좌표 체계(선택, 기본값 : WGS84), 결과에 출력될 좌표 체계(선택, 기본값 : WGS84), 결과 언어(선택, 기본값 : ko)
    - Example : getCoordToRegionArea(36.143099, 128.392905, "WGS84", "WGS84", "ko") or getCoordToRegionArea(36.143099, 128.392905)


* 좌표 → 주소 변환 (getCoordToRegionArea)
    - 해당 좌표의 구주소와 도로명 주소 정보를 표출하는 API
    - Parameter : 위도(필수), 경도(필수), 입력되는 값에 대한 좌표 체계(선택, 기본값 : WGS84)
    - Example : getCoordToAddress(36.143099, 128.392905, "WGS84") or getCoordToAddress(36.143099, 128.392905)


* 좌표계 변환 (transCoord)
    - x, y 값과 입력/출력 좌표계를 지정하여 변환된 좌표값
    - Parameter : 위도(필수), 경도(필수), 입력되는 값에 대한 좌표 체계(선택, 기본값 : WGS84), 결과에 출력될 좌표 체계(선택, 기본값 : WGS84)
    - Example : transCoord(36.143099, 128.392905, "WGS84", "WGS84") or transCoord(36.143099, 128.392905)


* 키워드로 장소 검색 (searchKeyword)
    - 질의어에 매칭된 장소 검색 결과를 지정된 정렬 기준에 따라 제공
    - Parameter : 검색어(필수), 카테고리 그룹 코드(선택, 기본값 : ""), 위도(선택), 경도(선택), 중심 좌표부터의 반경거리(선택, 기본값 : 500, 단위 : m, 0~20000), 결과 페이지 번호(선택, 기본값 : 1, 1~45), 한 페이지에 보여질 문서의 개수(선택, 기본값 : 15, 1~15), 결과 정렬 순서(선택, 기본값 : accuracy)
    - 카테고리 그룹 코드는 Daum API 문서 참고
    - Example : searchKeyword("편의점", "CS2", 36.143099, 128.392905, 100, 1, 10, "accuracy") or searchKeyword("편의점")


* 카테고리로 장소 검색 (searchCategory)
    - 미리 정의된 그룹코드에 해당하는 장소 검색 결과를 지정된 정렬 기준에 따라 제공
    - Parameter : 카테고리 그룹 코드(필수), 위도(필수), 경도(필수), 중심 좌표부터의 반경거리(필수, 기본값 : 500, 단위 : m, 0~20000), 결과 페이지 번호(선택, 기본값 : 1, 1~45), 한 페이지에 보여질 문서의 개수(선택, 기본값 : 15, 1~15), 결과 정렬 순서(선택, 기본값 : accuracy)
    - 카테고리 그룹 코드는 Daum API 문서 참고
    - Example : searchCategory("CS2", 36.143099, 128.392905, 100, 1, 10, "accuracy") or searchCategory("CS2", 36.143099, 128.392905, 100)

***

## License
MIT © Cory Asata 2018
