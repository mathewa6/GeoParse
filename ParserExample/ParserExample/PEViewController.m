//
//  PEViewController.m
//  ParserExample
//
//  Created by Adi Mathew on 9/6/14.
//  Copyright (c) 2014 RCPD. All rights reserved.
//

/*
 This example parses a GeoJSON file.(https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json)
 The output model is then used to draw an overlay on an MKMapView.
 */

#import "PEViewController.h"

@interface PEViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation PEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.mapView.delegate = self;
    
    //Initialize a parser object. It can even be a property if needed.
    GSNParser *parser = [[GSNParser alloc] init];
    //SET THE DELEGATE, as it's the only way to retrieve the parsed JSON.
    parser.delegate = self;
    //Call the parse function with the filename.
    [parser parseFile:@"Countries.geojson"];
}

-(void)didParseGeoJSONObject:(id)object
{
    NSMutableArray *overlays = [[NSMutableArray alloc] init];
    
    //Check if the root object is a Feature collection.
    if ([object isKindOfClass:[GSNFeatureCollection class]]) {
        GSNFeatureCollection *collection = (GSNFeatureCollection *)object;
        //Loop through all the GSNFeature objects in the collection.
        for (GSNFeature *feature in collection.featureObjects) {
//            NSLog(@"%@",feature.name); //We could've just stopped here, but nooo, we've got to put it on a map.
            
            //Extract the geometry of each feature as a GSNObject.
            GSNObject *geoObject = feature.geometryObject;
            
            //You could just overlay all the countries, but =/
            if ([feature.name isEqualToString:@"United States of America"]) {
                //Because the -shapeForMapKit function can return an MKPolygon for a GSNPolygon,
                //OR an NSArray of MKPolygons if it is a GSNMultiPolygon,
                //we've got to check for each type and handle it.
                if (feature.geometryType == kGSNGeometryTypePolygon) {
                    MKPolygon *polygon = [geoObject performSelector:@selector(shapeForMapKit)];
                    [overlays addObject:polygon];
                } else if (feature.geometryType == kGSNGeometryTypeMultiPolygon) {
                    NSArray *multiPolys = [geoObject performSelector:@selector(shapeForMapKit)];
                    for (MKPolygon *polygon in multiPolys) {
                        [overlays addObject:polygon];
                    }
                }
            }
        }
        
        //Put the overlays on the map.
        [self.mapView addOverlays:[overlays copy]];
    }
}

//Standard overlay stuff.
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKOverlayRenderer *returnRenderer = nil;
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonRenderer *polyRenderer = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon *)overlay];
        polyRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
        polyRenderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        polyRenderer.lineWidth = 1.5;
        returnRenderer = polyRenderer;
    }
    return returnRenderer;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
