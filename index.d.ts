import * as React from 'react';

export interface Region {
    latitude: number;
    longitude: number;
}

export interface InitialRegion extends Region {
    zoomLevel: number;
}

export interface PolyLines {
    tag: number;
    color: string;
    points: Region[];
}

export interface Circles extends Region {
    lineColor: string;
    fillColor: string;
    lineWidth: number;
    radius: number;
}

export interface Marker extends Region {
    title: string;
    pinColor: string;
    markerImage: any;
    pinColorSelect: string;
    markerImageSelect: string;
    draggable: boolean;
}

export type MapType = 'Standard' | 'Satellite' | 'Hybrid';

export interface MapViewProps {
    /**
     * 지도 초기 화면 좌표 및 확대/축소 레벨
     */
    initialRegion?: InitialRegion;

    /**
     * 지도 View Style
     */
    style?: any;

    /**
     * 지도 종류 (기본 지도 - Standard, 위성 지도 - Satellite, 하이브리드 지도 - Hybrid)
     */
    mapType?: MapType;

    /**
     * 지도 위에 추가되는 마커 정보
     */
    marker?: Marker[];

    /**
     * 지도 중심점 좌표, 지도 이동시 사용
     */

    region?: Region;

    /**
     * 	정해진 좌표로 선을 그림
     */

    polyLines?: PolyLines;

    /**
     * 지정한 좌표에 원을 그림
     */
    circles?: Circles;

    /**
     * 현위치 트래킹 모드 (지도화면 중심을 단말의 현재 위치로 이동)
     */
    isTracking?: boolean;

    /**
     * 나침반 모드 (단말의 방향에 따라 지도화면이 회전), 트래킹 모드를 활성화 시켜야 사용 가능
     */
    isTracking?: boolean;

    /**
     * 현 위치를 표시하는 마커 표시 여부, 트래킹 모드 활성화시 true
     */
    isCurrentMarker?: boolean;

    /**
     * (Android) 위치 권한이 없을 경우 표시될 View
     */
    permissionDeniedView?: React.ReactElement<any>;

    /**
     * 	(Android) 위치 권한 요청시 Alert창 제목
     */
    permissionAndroidTitle: string;

    /**
     * (Android) 위치 권한 요청시 Alert창 본문
     */
    permissionAndroidMessage: string;

    /**
     * 지도 이동시 변경되는 좌표값 반환
     */
    onRegionChange: (region: Region) => void;

    /**
     * 마커 핀을 선택한 경우
     * TODO: onMarkerSelect parameter type 수정
     */
    onMarkerSelect: any;

    /**
     * 마커 위 말풍선을 선택한 경우
     * TODO: onMarkerPress parameter type 수정
     */
    onMarkerPress: any;

    /**
     * 마커를 이동시킨 경우
     * TODO: onMarkerPress parameter type 수정
     */
    onMarkerMoved: any;

    /**
     * 트래킹 모드 사용중 좌표가 변경된 경우
     */
    onUpdateCurrentLocation: (region: Region) => void;

    /**
     * 나침반 모드 사용시 방향 각도 값이 변경된 경우
     */
    onUpdateCurrentHeading: (degree: any) => void;
}

export default class DaumMapView extends React.Component<any> {}
