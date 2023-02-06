//
//  Copyright © 2018-2022 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "RCTConvert+PSPDFAnnotationToolbarConfiguration.h"

@implementation RCTConvert (PSPDFAnnotationToolbarConfiguration)

+ (PSPDFAnnotationToolbarConfiguration *)PSPDFAnnotationToolbarConfiguration:(id)json {
  NSArray *itemsToParse = [RCTConvert NSArray:json];
  NSMutableArray *parsedItems = [NSMutableArray arrayWithCapacity:itemsToParse.count];
  for (id itemToParse in itemsToParse) {
    if ([itemToParse isKindOfClass:[NSDictionary class]]) {
      NSDictionary *dict = itemToParse;
      NSArray *subArray = dict[@"items"];
      NSMutableArray *subItems = [NSMutableArray arrayWithCapacity:subArray.count];
      for (id subItem in subArray) {
        if (subItem) {
          PSPDFAnnotationString annotationString = [RCTConvert PSPDFAnnotationStringFromName:subItem];
          [subItems addObject:[PSPDFAnnotationGroupItem itemWithType:annotationString]];
        }
      }
      [parsedItems addObject:[PSPDFAnnotationGroup groupWithItems:subItems]];
    } else {
      PSPDFAnnotationString annotationString = [RCTConvert PSPDFAnnotationStringFromName:itemToParse];
      if (annotationString) {
        [parsedItems addObject:[PSPDFAnnotationGroup groupWithItems:@[[PSPDFAnnotationGroupItem itemWithType:annotationString]]]];
      }
    }
  }
  return  [[PSPDFAnnotationToolbarConfiguration alloc] initWithAnnotationGroups:parsedItems];
}

+ (PSPDFAnnotationString)PSPDFAnnotationStringFromName:(NSString *)name {
  
  static NSDictionary *nameToAnnotationStringMapping;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSMutableDictionary *mapping = [[NSMutableDictionary alloc] init];
    
    [mapping setValue:PSPDFAnnotationStringLink forKeyPath:@"link"];
    [mapping setValue:PSPDFAnnotationStringHighlight forKeyPath:@"highlight"];
    [mapping setValue:PSPDFAnnotationMenuStrikeout forKeyPath:@"strikeout"];
    [mapping setValue:PSPDFAnnotationStringUnderline forKeyPath:@"underline"];
    [mapping setValue:PSPDFAnnotationMenuSquiggle forKeyPath:@"squiggly"];
    [mapping setValue:PSPDFAnnotationStringNote forKeyPath:@"note"];
    [mapping setValue:PSPDFAnnotationStringFreeText forKeyPath:@"freetext"];
    [mapping setValue:PSPDFAnnotationStringInk forKeyPath:@"ink"];
    [mapping setValue:PSPDFAnnotationStringSquare forKeyPath:@"square"];
    [mapping setValue:PSPDFAnnotationStringCircle forKeyPath:@"circle"];
    [mapping setValue:PSPDFAnnotationStringLine forKeyPath:@"line"];
    [mapping setValue:PSPDFAnnotationStringPolygon forKeyPath:@"polygon"];
    [mapping setValue:PSPDFAnnotationStringPolyLine forKeyPath:@"polyline"];
    [mapping setValue:PSPDFAnnotationStringSignature forKeyPath:@"signature"];
    [mapping setValue:PSPDFAnnotationStringStamp forKeyPath:@"stamp"];
    [mapping setValue:PSPDFAnnotationStringEraser forKeyPath:@"eraser"];
    [mapping setValue:PSPDFAnnotationStringSound forKeyPath:@"sound"];
    [mapping setValue:PSPDFAnnotationStringImage forKeyPath:@"image"];
    [mapping setValue:PSPDFAnnotationStringRedaction forKeyPath:@"redaction"];
    
    UIColor *drawingColor = [UIColor greenColor];
UIColor *highlightingColor = [UIColor redColor];
NSString *colorProperty = NSStringFromSelector(@selector(color));
NSString *alphaProperty = NSStringFromSelector(@selector(alpha));
NSString *lineWidthProperty = NSStringFromSelector(@selector(lineWidth));

// Set ink color.
[PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:drawingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, nil)];
[PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:drawingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkPen)];

// Set highlight color.
[PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:highlightingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkHighlighter)];
[PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:@(0.5f) forProperty:alphaProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkHighlighter)];

// Set line width of ink annotations.
[PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:@(5) forProperty:lineWidthProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, nil)];
[PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:@(5) forProperty:lineWidthProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkPen)];

// Set line width of highlight annotations.
[PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:@(20) forProperty:lineWidthProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkHighlighter)];
    
     let black = UIColor.blackColor;
    let blue = [UIColor colorWithRed:0.141f green:0.573f blue:0.984f alpha:1.0f]; // #2492FB
    let red = [UIColor colorWithRed:0.871f green:0.278f blue:0.31f alpha:1.0f]; // #DE474F
    let yellow = [UIColor colorWithRed:0.996f green:0.91f blue:0.196f alpha:1.0f]; // #FEE832
    [self setLastUsedValue:yellow forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringHighlight, nil)];
    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringUnderline, nil)];
    [self setLastUsedValue:red forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringSquiggly, nil)];
    [self setLastUsedValue:red forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringStrikeOut, nil)];

    // Set ink and variants.
    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, nil)];
    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkMagic)];
    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkPen)];
    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkHighlighter)];
    [self setLastUsedValue:@(0.5) forProperty:@"alpha" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkHighlighter)];

    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringSquare, nil)];
    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringCircle, nil)];

    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringPolygon, nil)];
    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringPolygon, PSPDFAnnotationVariantStringPolygonCloud)];

    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringLine, nil)];
    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringLine, PSPDFAnnotationVariantStringLineArrow)];
    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringPolyLine, nil)];
    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringSignature, nil)];
    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringFreeText, nil)];
    [self setLastUsedValue:black forProperty:@"color" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringRedaction, nil)];

    // Arrow speciality.
    [self setLastUsedValue:@(PSPDFLineEndTypeOpenArrow) forProperty:@"lineEnd2" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringLine, PSPDFAnnotationVariantStringLineArrow)];

    // Fonts.
    [self setLastUsedValue:@(12) forProperty:@"fontSize" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringFreeText, nil)];
    [self setLastUsedValue:@"Helvetica" forProperty:@"fontName" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringFreeText, nil)];

    // Border effect.
    [self setLastUsedValue:@(PSPDFAnnotationBorderEffectNoEffect) forProperty:@"borderEffect" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringCircle, nil)];
    [self setLastUsedValue:@(PSPDFAnnotationBorderEffectNoEffect) forProperty:@"borderEffect" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringSquare, nil)];
    [self setLastUsedValue:@(PSPDFAnnotationBorderEffectNoEffect) forProperty:@"borderEffect" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringPolygon, nil)];
    [self setLastUsedValue:@(PSPDFAnnotationBorderEffectCloudy) forProperty:@"borderEffect" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringPolygon, PSPDFAnnotationVariantStringPolygonCloud)];
    [self setLastUsedValue:@(2) forProperty:@"borderEffectIntensity" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringPolygon, PSPDFAnnotationVariantStringPolygonCloud)];

    // Blend mode.
    [self setLastUsedValue:@(kCGBlendModeMultiply) forProperty:@"blendMode" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringHighlight, nil)];
    [self setLastUsedValue:@(kCGBlendModeMultiply) forProperty:@"blendMode" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkHighlighter)];

    // Fill color.
    [self setLastUsedValue:black forProperty:@"fillColor" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringRedaction, nil)];

    // Outline color.
    [self setLastUsedValue:red forProperty:@"outlineColor" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringRedaction, nil)];
    [self setLastUsedValue:nil forProperty:@"overlayText" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringRedaction, nil)];
    
    nameToAnnotationStringMapping = [[NSDictionary alloc] initWithDictionary:mapping];
  });
  
  return nameToAnnotationStringMapping[name];
}

@end
