# FWSwiftUIViews
This framework is for SwiftUI.

## Requirements
- iOS 13+
- macOS 10.15+

## Installation
It is avaiable through Swift Package Manager

## Usage
### FWArcSliderView
The following the the parameters available for users, most of them have default value.
```sh
_value: Binding<Double>,
range: ClosedRange<Double>,
step: Double = 0,
outerDiameter: CGFloat = 300,
lineWidth: CGFloat = 50,
endDegrees: Double = 360,
trackColor: Color = Color.blue,
progressColor: Color = Color.green,
dragCircleColor: Color = Color.black,
isDashed: Bool = false,
onValueChangeEnded: (() -> ())? = nil
```
note: if an invalid value has been set to FWArcSliderView, it will show an empty view. For example, "_value" has been set to out of the "range".
#### Examples
```sh
ZStack {
    FWArcSliderView(
        $value,
        range: 0...10
    )
            
    Text("\(String(format: "%.2f", value))")
}
```
![FWArcSliderView demo 1](FWArcSliderView01.gif)

```sh
ZStack {
    FWArcSliderView(
        $value,
        range: 0...10,
        step: 1
    )
            
    Text("\(String(format: "%.2f", value))")
}
```
![FWArcSliderView demo 2](FWArcSliderView02.gif)

```sh
ZStack {
    FWArcSliderView(
        $value,
        range: 0...10,
        step: 1,
        endDegrees: 180,
        isDashed: true
    )
            
    Text("\(String(format: "%.0f", value))")
}
```
![FWArcSliderView demo 3](FWArcSliderView03.png)

## Author
Fan Wu, fanwu9877@gmail.com

## License
It is available under the MIT license. See the LICENSE file for more info.
