GeoParse
========

![Screenshot](https://github.com/mathewa6/GeoParse/blob/master/Screenshot.png)

A simple delegate based objective-C GeoJSON parser with some useful tools. GeoParse acts as a layer over NSJSONSerialization to get the root JSON object, which is then parsed into it's corresponding GeoJSON type, in strict accordance with the [GeoJSON format specification](http://www.geojson.org/geojson-spec.html)

## Setup ##

- Link the CoreLocation and MapKit framework to your project. (Used for data types.)
- Import GSNParser.h and set an object to adhere to GSNParserDelegate protocol.
- Create a GSNParser object and set it's delegate.
- Implement -didParseGeoJSONObject:

```obj-c
-(void)didParseGeoJSONObject:(id)object
{
    if ([object isKindOfClass:[GSNFeatureCollection class]]) {
        GSNFeatureCollection *collection = (GSNFeatureCollection *)object;
        for (GSNFeature *feature in collection.featureObjects) {
            NSLog(@"%@",feature.name);
    }
}
```

## Notes and Extras##
GeoJSON formats for
Bounding Boxes : [lowLong, lowLat, hiLong, hiLat]
Coordinates : (longitude, latitude)

GeoParse contains a very useful category on NSArray(NSArray+Coordinate2D). 
- It allows for easy conversions to CLLocationCoordinate2D, from an NSArray of coordinates parsed from NSJSONSerialization.
- If the NSArray is a bbox as specified above, you can find it's center, as well as check if it contains a point.

In addition, GeoParse allows conversion of geometry objects(only Points, LineStrings, Polygons and MultiPolygons for now) to their corresponding MKOverlay types, by calling the -shapeForMapKit method on them.

##License##
See included LICENSE file.

