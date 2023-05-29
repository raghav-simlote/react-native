//
//  Copyright © 2018-2022 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "RCTPSPDFKitView.h"
#import <React/RCTUtils.h>
#import "RCTConvert+PSPDFAnnotation.h"
#import "RCTConvert+PSPDFViewMode.h"
#import "RCTConvert+UIBarButtonItem.h"
#import "PSPDFKitDemo.h"


//#import "PSPDFKitDemo-Swift.h"


#define VALIDATE_DOCUMENT(document, ...) { if (!document.isValid) { NSLog(@"Document is invalid."); if (self.onDocumentLoadFailed) { self.onDocumentLoadFailed(@{@"error": @"Document is invalid."}); } return __VA_ARGS__; }}
@interface CustomButtonAnnotationToolbar : PSPDFAnnotationToolbar

@property (nonatomic) PSPDFToolbarButton *clearAnnotationsButton;

@property (nonatomic) PSPDFToolbarButton *issueAnnotationsButton;

@end
@interface RCTPSPDFKitViewController : PSPDFViewController
@end

@interface RCTPSPDFKitView ()<PSPDFDocumentDelegate, PSPDFViewControllerDelegate, PSPDFFlexibleToolbarContainerDelegate>

@property (nonatomic, nullable) UIViewController *topController;

@end

@implementation RCTPSPDFKitView

/*- (void)setupDefaultStylesIfNeeded {
 // Line widths.
 [self setLastUsedValue:@(4) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, nil)];
 [self setLastUsedValue:@(4) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, nil)];
 [self setLastUsedValue:@(4) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkPen)];
 [self setLastUsedValue:@(30) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkHighlighter)];
 [self setLastUsedValue:@(5) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringSquare, nil)];
 [self setLastUsedValue:@(5) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringCircle, nil)];
 [self setLastUsedValue:@(3) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringPolygon, nil)];
 [self setLastUsedValue:@(3) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringPolygon, PSPDFAnnotationVariantStringPolygonCloud)];
 [self setLastUsedValue:@(3) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringLine, nil)];
 [self setLastUsedValue:@(4) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringLine, PSPDFAnnotationVariantStringLineArrow)];
 [self setLastUsedValue:@(3) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringPolyLine, nil)];
 [self setLastUsedValue:@(2) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringSignature, nil)];
 [self setLastUsedValue:@(10) forProperty:@"lineWidth" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringEraser, nil)];
 
 // Colors.
 UIColor *black = UIColor.blackColor;
 UIColor *blue = [UIColor colorWithRed:0.141f green:0.573f blue:0.984f alpha:1.0f]; // #2492FB
 UIColor *red = [UIColor colorWithRed:0.871f green:0.278f blue:0.31f alpha:1.0f]; // #DE474F
 UIColor *yellow = [UIColor colorWithRed:0.996f green:0.91f blue:0.196f alpha:1.0f]; // #FEE832
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
 }
 
 - (void)setLastUsedValue:(nullable id)value forProperty:(NSString *)styleProperty forKey:(PSPDFAnnotationString)key {
 [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:value forProperty:styleProperty forKey:key];
 }*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    NSLog(@"Color change");
    /*  [self setupDefaultStylesIfNeeded];
     NSArray<PSPDFColorPreset *> *presets = @[[PSPDFColorPreset presetWithColor:UIColor.blackColor],
     [PSPDFColorPreset presetWithColor:UIColor.redColor],
     [PSPDFColorPreset presetWithColor:UIColor.greenColor],
     [PSPDFColorPreset presetWithColor:UIColor.blueColor]];
     PSPDFDefaultAnnotationStyleManager *styleManager = (PSPDFDefaultAnnotationStyleManager *)PSPDFKitGlobal.sharedInstance.styleManager;
     PSPDFAnnotationStateVariantID key1 = PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringLine, nil);
     [styleManager setPresets:presets forKey:key1 type:PSPDFAnnotationStyleTypeColorPreset];
     */
    if ((self = [super initWithFrame:frame])) {
        //[self setupDefaultStylesIfNeeded];
        
        
        NSLog(@"Color change 1");
        UIColor *drawingColor = [UIColor redColor];
        UIColor *highlightingColor = [UIColor redColor];
        NSString *colorProperty = NSStringFromSelector(@selector(color));
        
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:drawingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, nil)];
        
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:highlightingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkHighlighter)];
        
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:highlightingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringSquare, nil)];
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:highlightingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringCircle, nil)];
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:highlightingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringLine, nil)];
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:highlightingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringFreeText, nil)];
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:highlightingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringUnderline, nil)];
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:highlightingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringStrikeOut, nil)];
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:highlightingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringSquiggly, nil)];
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:highlightingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringHighlight, nil)];
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:highlightingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringRedaction, nil)];
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:drawingColor forProperty:colorProperty forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, PSPDFAnnotationVariantStringInkPen)];
        
        NSLog(@"Border change 1");
        
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:@(PSPDFAnnotationBorderEffectCloudy) forProperty:@"borderEffect" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringSquare, PSPDFAnnotationVariantStringPolygonCloud)];
        
        
        [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:@(2) forProperty:@"borderEffectIntensity" forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringSquare, PSPDFAnnotationVariantStringPolygonCloud)];
        NSLog(@"Border change 1");
        
        NSLog(@"Color change 2");
        
        // Set configuration to use the custom annotation toolbar when initializing the `PSPDFViewController`.
        // For more details, see `PSCCustomizeAnnotationToolbarExample.m` from the Catalog app and our documentation here: https://pspdfkit.com/guides/ios/customizing-the-interface/customize-the-annotation-toolbar/
        _pdfController = [[PSPDFViewController alloc] initWithDocument:nil configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
            [builder overrideClass:PSPDFAnnotationToolbar.class withClass:CustomButtonAnnotationToolbar.class
            ];
        }]];
        
        _pdfController.delegate = self;
        _pdfController.annotationToolbarController.delegate = self;
        _closeButton = [[UIBarButtonItem alloc] initWithImage:[PSPDFKitGlobal imageNamed:@"x"] style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonPressed:)];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(annotationChangedNotification:) name:PSPDFAnnotationChangedNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(annotationChangedNotification:) name:PSPDFAnnotationsAddedNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(annotationChangedNotification:) name:PSPDFAnnotationsRemovedNotification object:nil];
        
        [_pdfController updateConfigurationWithoutReloadingWithBuilder:^(PSPDFConfigurationBuilder * _Nonnull builder) {
            NSLog(@"updated username");
            builder.shouldAskForAnnotationUsername = !builder.shouldAskForAnnotationUsername;
            
        }];
        
    }
    
    return self;
}

- (void)removeFromSuperview {
    // When the React Native `PSPDFKitView` in unmounted, we need to dismiss the `PSPDFViewController` to avoid orphan popovers.
    // See https://github.com/PSPDFKit/react-native/issues/277
    [self.pdfController dismissViewControllerAnimated:NO completion:NULL];
    [super removeFromSuperview];
}

- (void)dealloc {
    [self destroyViewControllerRelationship];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)didMoveToWindow {
    NSLog(@"Yes moved to window ");
    
    
   
    //[self.pdfController.navigationItem.rightBarButtonItems addObject:barButtonItem];
    //[self.pdfController.navigationItem setRightBarButtonItem:barButtonItem animated:NO ];
    NSLog(@"%@",self.pdfController.navigationItem.rightBarButtonItems);
    NSLog(@"Yes moved to window 1");
    
    UIViewController *controller = self.pspdf_parentViewController;
    if (controller == nil || self.window == nil || self.topController != nil) {
        return;
    }
    
    if (self.pdfController.configuration.useParentNavigationBar || self.hideNavigationBar) {
        self.topController = self.pdfController;
    } else {
        self.topController = [[PSPDFNavigationController alloc] initWithRootViewController:self.pdfController];
    }
    
    UIView *topControllerView = self.topController.view;
    topControllerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:topControllerView];
    [controller addChildViewController:self.topController];
    [self.topController didMoveToParentViewController:controller];
    
    [NSLayoutConstraint activateConstraints:
     @[[topControllerView.topAnchor constraintEqualToAnchor:self.topAnchor],
       [topControllerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
       [topControllerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
       [topControllerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
     ]];
    
    self.pdfController.pageIndex = self.pageIndex;
}

- (void)destroyViewControllerRelationship {
    if (self.topController.parentViewController) {
        [self.topController willMoveToParentViewController:nil];
        [self.topController removeFromParentViewController];
    }
}

- (void)closeButtonPressed:(nullable id)sender {
    
    if ( [self.prevDoc isEqual:NULL]) {
        
        
        NSLog(@"Prev Doc 1");
    } else {
        self.pdfController.document = self.prevDoc;
        NSLog(@"Prev Doc 2");
    }
    
    if (self.onCloseButtonPressed) {
        self.onCloseButtonPressed(@{});
        
    } else {
        // try to be smart and pop if we are not displayed modally.
        BOOL shouldDismiss = YES;
        if (self.pdfController.navigationController) {
            UIViewController *topViewController = self.pdfController.navigationController.topViewController;
            UIViewController *parentViewController = self.pdfController.parentViewController;
            if ((topViewController == self.pdfController || topViewController == parentViewController) && self.pdfController.navigationController.viewControllers.count > 1) {
                [self.pdfController.navigationController popViewControllerAnimated:YES];
                shouldDismiss = NO;
            }
        }
        if (shouldDismiss) {
            [self.pdfController dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

- (UIViewController *)pspdf_parentViewController {
    UIResponder *parentResponder = self;
    while ((parentResponder = parentResponder.nextResponder)) {
        if ([parentResponder isKindOfClass:UIViewController.class]) {
            return (UIViewController *)parentResponder;
        }
    }
    return nil;
}
- (void)closeButtonPressed1:(nullable id)sender {
    
    if ( [self.prevDoc isEqual:NULL]) {
        NSLog(@"Prev Doc 3");
    } else {
        NSLog(@"Prev Doc 4");
    }
    
    NSLog(@"ios closed called");
    
    if (self.onCloseButtonPressed1) {
        self.onCloseButtonPressed1(@{});
        
    } else {
        // try to be smart and pop if we are not displayed modally.
        BOOL shouldDismiss = YES;
        if (self.pdfController.navigationController) {
            UIViewController *topViewController = self.pdfController.navigationController.topViewController;
            UIViewController *parentViewController = self.pdfController.parentViewController;
            if ((topViewController == self.pdfController || topViewController == parentViewController) && self.pdfController.navigationController.viewControllers.count > 1) {
                [self.pdfController.navigationController popViewControllerAnimated:YES];
                shouldDismiss = NO;
            }
        }
        if (shouldDismiss) {
            [self.pdfController dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}
- (void)privateButtonPressed:(nullable id)sender {
    
    NSLog(@"ios closed 21212 %@ " , sender);
    
    if (self.onPrivateButtonPressed) {
        NSLog(@"if part public ");
        self.onPrivateButtonPressed(@{});
        
    } else {
        NSLog(@"else part public ");
    }
}


- (BOOL)enterAnnotationCreationMode {
    [self.pdfController setViewMode:PSPDFViewModeDocument animated:YES];
    [self.pdfController.annotationToolbarController updateHostView:self container:nil  viewController:self.pdfController];
    
    NSLog(@"Enter Square Changes");
    
    PSPDFAnnotationVariantString cloudyRectangleVariant = @"MyCustomCloudyRectangle";
    
    // Set the initial style to use a cloudy border. For simplicity, this example sets this every time but this info is persisted so usually you only want to set this once otherwise each time the app is run you might be overwriting the user’s last used styles.
    PSPDFAnnotationStateVariantID cloudyRectangleID = PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringSquare, cloudyRectangleVariant);
    
    
    [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:@(PSPDFAnnotationBorderEffectCloudy) forProperty:@"borderEffect" forKey:cloudyRectangleID];
    [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:@2 forProperty: @"borderEffectIntensity" forKey: cloudyRectangleID];
    [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:@2 forProperty: @"borderEffectIntensity" forKey: cloudyRectangleID];
    
    UIColor *drawingColor = [UIColor redColor];
    NSString *colorProperty = NSStringFromSelector(@selector(color));
    
    [PSPDFKitGlobal.sharedInstance.styleManager setLastUsedValue:drawingColor forProperty:colorProperty forKey:cloudyRectangleID];
    
    
    // Define our tools for the annotation toolbar.
    PSPDFAnnotationGroupItem *straightRectangleTool = [PSPDFAnnotationGroupItem itemWithType: PSPDFAnnotationStringSquare];
    PSPDFAnnotationGroupItem *cloudyRectangleTool = [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringSquare variant:cloudyRectangleVariant configurationBlock:^UIImage * _Nonnull(PSPDFAnnotationGroupItem * _Nonnull item, id  _Nullable container, UIColor * _Nonnull tintColor) {
        //return [[UIImage alloc] initWithNameInCatalog:@"rectangle_cloudy"];
        //return [[PSPDFKitGlobal imageNamed:@"rectangle_cloudy"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        return [UIImage imageNamed:@"cloud"];
        
    }];
    
    
    NSLog(@"Closing Square Changes");
    PSPDFAnnotationToolbarConfiguration *configuration =
    [[PSPDFAnnotationToolbarConfiguration alloc] initWithAnnotationGroups:@[
        [PSPDFAnnotationGroup groupWithItems:@[
            [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringInk variant:PSPDFAnnotationVariantStringInkPen configurationBlock:[PSPDFAnnotationGroupItem inkConfigurationBlock]]
        ]],
        [PSPDFAnnotationGroup groupWithItems: @[
            cloudyRectangleTool
        ]],
        [PSPDFAnnotationGroup groupWithItems:@[
            [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringLine
                                           variant:PSPDFAnnotationVariantStringLineArrow],
            [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringSquare],
            [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringCircle],
            [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringPolyLine],
        ]],
        [PSPDFAnnotationGroup groupWithItems:@[
            [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringPolygon
                                           variant:PSPDFAnnotationVariantStringPolygonCloud]
        ]],
        [PSPDFAnnotationGroup groupWithItems:@[
            [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringFreeText
                                           variant:PSPDFAnnotationVariantStringFreeTextCallout]
        ]],
        [PSPDFAnnotationGroup groupWithItems:@[
            [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringHighlight],
            [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringStrikeOut],
            [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringUnderline],
        ]],
    ]];
    [self.pdfController.annotationToolbarController showToolbarAnimated:YES completion:NULL];
    return self.pdfController.annotationToolbarController.annotationToolbar.configurations = @[configuration];
    /* return [self.pdfController.annotationToolbarController showToolbarAnimated:YES completion:NULL];*/
}

- (BOOL)exitCurrentlyActiveMode {
    return [self.pdfController.annotationToolbarController hideToolbarAnimated:YES completion:NULL];
}

- (BOOL)saveCurrentDocumentWithError:(NSError *_Nullable *)error {
    return [self.pdfController.document saveWithOptions:nil error:error];
}

// MARK: - PSPDFDocumentDelegate

- (void)pdfDocumentDidSave:(nonnull PSPDFDocument *)document {
    if (self.onDocumentSaved) {
        self.onDocumentSaved(@{});
    }
}

- (void)pdfDocument:(PSPDFDocument *)document saveDidFailWithError:(NSError *)error {
    if (self.onDocumentSaveFailed) {
        self.onDocumentSaveFailed(@{@"error": error.description});
    }
}

// MARK: - PSPDFViewControllerDelegate

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnAnnotation:(PSPDFAnnotation *)annotation annotationPoint:(CGPoint)annotationPoint annotationView:(UIView<PSPDFAnnotationPresenting> *)annotationView pageView:(PSPDFPageView *)pageView viewPoint:(CGPoint)viewPoint {
    NSLog(@"Annotation clicked");
    if (self.onAnnotationTapped) {
        self.tapAnnotation = annotation;
        NSData *annotationData = [annotation generateInstantJSONWithError:NULL];
        NSDictionary *annotationDictionary = [NSJSONSerialization JSONObjectWithData:annotationData options:kNilOptions error:NULL];
        NSLog(@"Annotation clicked1 %@",annotationData);
        NSLog(@"Annotation clicked2 %@",annotationDictionary);
        NSDictionary *custDataDict = annotationDictionary[@"customData"];
        
        self.accessName=custDataDict[@"access"];
        
        NSString *accessStr = custDataDict[@"access"];
        NSLog(@"Access is %@",accessStr);
        
        self.onAnnotationTapped(annotationDictionary);
    } else if (self.tapAnnotation) {
        self.tapAnnotation = annotation;
    }
    return self.disableDefaultActionForTappedAnnotations;
}

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldSaveDocument:(nonnull PSPDFDocument *)document withOptions:(NSDictionary<PSPDFDocumentSaveOption,id> *__autoreleasing  _Nonnull * _Nonnull)options {
    return !self.disableAutomaticSaving;
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didConfigurePageView:(PSPDFPageView *)pageView forPageAtIndex:(NSInteger)pageIndex {
    [self onStateChangedForPDFViewController:pdfController pageView:pageView pageAtIndex:pageIndex];
}

- (void)pdfViewController:(PSPDFViewController *)pdfController willBeginDisplayingPageView:(PSPDFPageView *)pageView forPageAtIndex:(NSInteger)pageIndex {
    [self onStateChangedForPDFViewController:pdfController pageView:pageView pageAtIndex:pageIndex];
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeDocument:(nullable PSPDFDocument *)document {
    VALIDATE_DOCUMENT(document)
}

// MARK: - PSPDFFlexibleToolbarContainerDelegate

- (void)flexibleToolbarContainerDidShow:(PSPDFFlexibleToolbarContainer *)container {
    PSPDFPageIndex pageIndex = self.pdfController.pageIndex;
    PSPDFPageView *pageView = [self.pdfController pageViewForPageAtIndex:pageIndex];
    [self onStateChangedForPDFViewController:self.pdfController pageView:pageView pageAtIndex:pageIndex];
}

- (void)flexibleToolbarContainerDidHide:(PSPDFFlexibleToolbarContainer *)container {
    PSPDFPageIndex pageIndex = self.pdfController.pageIndex;
    PSPDFPageView *pageView = [self.pdfController pageViewForPageAtIndex:pageIndex];
    [self onStateChangedForPDFViewController:self.pdfController pageView:pageView pageAtIndex:pageIndex];
}

// MARK: - Instant JSON

- (NSDictionary<NSString *, NSArray<NSDictionary *> *> *)getAnnotations:(PSPDFPageIndex)pageIndex type:(PSPDFAnnotationType)type error:(NSError *_Nullable *)error {
    NSLog(@"Get annotation1 %lu",(PSPDFAnnotationType)type);
    NSLog(@"Get annotation %lu",(PSPDFPageIndex)pageIndex);
    NSLog(@"Get annotation2 %lu",type);
    PSPDFDocument *document = self.pdfController.document;
    VALIDATE_DOCUMENT(document, nil);
    
    NSArray <PSPDFAnnotation *> *annotations = [document annotationsForPageAtIndex:pageIndex type:type];
    NSArray <NSDictionary *> *annotationsJSON = [RCTConvert instantJSONFromAnnotations:annotations error:error];
    return @{@"annotations" : annotationsJSON};
}

- (NSDictionary<NSString *, NSArray<NSDictionary *> *> *)compareOpen:(NSString*)url url1:(NSString*)url1 error:(NSError *_Nullable *)error {
    self.compareOpenify = url;
    if ([self.compareOpenify isEqual:@"true"]) {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compare"] style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonPressed1:)];
        NSLog(@"%@",self.pdfController.navigationItem.rightBarButtonItems);
        self.pdfController.navigationItem.rightBarButtonItems = [self.pdfController.navigationItem.rightBarButtonItems arrayByAddingObject:barButtonItem];
    }
    return NULL;
};
- (NSDictionary<NSString *, NSArray<NSDictionary *> *> *)getVersions:(NSString*)url url1:(NSString*)url1 error:(NSError *_Nullable *)error {
    
    NSLog(@"Get url %@",url);
    NSLog(@"Get url2 %@",url1);
    
    NSLog(@"Start Loading");
    
   // UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
   // indicator.hidesWhenStopped = YES;
   // indicator.frame = CGRectMake(50, 50, 50, 50);
   // indicator.layer.zPosition = 1000;
   // indicator.center = self.center;
   // [self.pdfController.view addSubview:indicator];
   // [indicator startAnimating];
    
    PSPDFComparisonConfiguration *configuration = [[PSPDFComparisonConfigurationBuilder alloc] build ];
    PSPDFComparisonProcessor *processor = [[PSPDFComparisonProcessor alloc]initWithConfiguration:configuration];
    
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURL *nsurl1=[NSURL URLWithString:url1];
    
    NSLog(@" nsurl %@ ", nsurl);
    NSLog(@" nsurl1 %@ ", nsurl1);
    /*
    PSPDFDocument *oldDocument = [[PSPDFDocument alloc] initWithURL:nsurl];
    PSPDFDocument *newDocument = [[PSPDFDocument alloc] initWithURL:nsurl1];
    
    self.pdfController.document = [processor comparisonDocumentWithOldDocument:oldDocument pageIndex:0 newDocument:newDocument pageIndex:0 transform:CGAffineTransformIdentity error:NULL];
    */
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    
    __block NSURL *location1 = NULL;
    __block NSURL *location2 = NULL;
    
    NSURLSessionTask *downloadTask1 = [session downloadTaskWithURL:nsurl completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {

            NSLog(@" response %@", response);
            
            location1 = [location copy];
            NSLog(@"finished %@", location);
        
            NSURLSessionTask *downloadTask2 = [session downloadTaskWithURL:nsurl1 completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {

                location2 = location;
                NSLog(@" response %@", response);

                NSLog(@"finished %@", location2);
                
                NSLog(@" location1 %@ ", location1);
                NSLog(@" location2 %@ ", location2);
                
                PSPDFDocument *oldDocument = [[PSPDFDocument alloc] initWithURL:location1];
                PSPDFDocument *newDocument = [[PSPDFDocument alloc] initWithURL:location2];
                
             //   self.allDocument = self.pdfController.document;
                //self.pdfController.document = self.allDocument;
                
                TestSw
                
                DocumentComparator *comparator = [[DocumentComparator alloc] init];

                self.prevDoc = self.pdfController.document;
                self.pdfController.document = [processor comparisonDocumentWithOldDocument:oldDocument pageIndex:0 newDocument:newDocument pageIndex:0 transform:CGAffineTransformIdentity error:NULL];
                
                NSLog(@"Stop Loading");
             //   [indicator stopAnimating];
                self.pdfController.userInterfaceView.userInteractionEnabled = PSPDFControllerStateDefault;
                
            }];
            [downloadTask2 resume];
        
        }];
        [downloadTask1 resume];
   
    PSPDFDocument *document = self.pdfController.document;
    VALIDATE_DOCUMENT(document, nil);
    
    NSArray <PSPDFAnnotation *> *annotations = [document annotationsForPageAtIndex:0 type:PSPDFAnnotationTypeLink];
    NSArray <NSDictionary *> *annotationsJSON = [RCTConvert instantJSONFromAnnotations:annotations error:error];
    return @{@"annotations" : annotationsJSON};
}

- (BOOL)addAnnotation:(id)jsonAnnotation error:(NSError *_Nullable *)error {
    NSData *data;
    if ([jsonAnnotation isKindOfClass:NSString.class]) {
        data = [jsonAnnotation dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([jsonAnnotation isKindOfClass:NSDictionary.class])  {
        data = [NSJSONSerialization dataWithJSONObject:jsonAnnotation options:0 error:error];
    } else {
        NSLog(@"Invalid JSON Annotation.");
        return NO;
    }
    
    PSPDFDocument *document = self.pdfController.document;
    VALIDATE_DOCUMENT(document, NO)
    PSPDFDocumentProvider *documentProvider = document.documentProviders.firstObject;
    
    BOOL success = NO;
    if (data) {
        PSPDFAnnotation *annotation = [PSPDFAnnotation annotationFromInstantJSON:data documentProvider:documentProvider error:error];
        if (annotation) {
            success = [document addAnnotations:@[annotation] options:nil];
        }
    }
    
    if (!success) {
        NSLog(@"Failed to add annotation.");
    }
    
    return success;
}

- (BOOL)removeAnnotationWithUUID:(NSString *)annotationUUID {
    PSPDFDocument *document = self.pdfController.document;
    VALIDATE_DOCUMENT(document, NO)
    BOOL success = NO;
    
    NSArray<PSPDFAnnotation *> *allAnnotations = [[document allAnnotationsOfType:PSPDFAnnotationTypeAll].allValues valueForKeyPath:@"@unionOfArrays.self"];
    for (PSPDFAnnotation *annotation in allAnnotations) {
        // Remove the annotation if the uuids match.
        if ([annotation.uuid isEqualToString:annotationUUID]) {
            success = [document removeAnnotations:@[annotation] options:nil];
            break;
        }
    }
    
    if (!success) {
        NSLog(@"Failed to remove annotation.");
    }
    return success;
}

- (NSDictionary<NSString *, NSArray<NSDictionary *> *> *)getAllUnsavedAnnotationsWithError:(NSError *_Nullable *)error {
    PSPDFDocument *document = self.pdfController.document;
    VALIDATE_DOCUMENT(document, nil)
    
    PSPDFDocumentProvider *documentProvider = document.documentProviders.firstObject;
    NSData *data = [document generateInstantJSONFromDocumentProvider:documentProvider error:error];
    NSDictionary *annotationsJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
    return annotationsJSON;
}

- (NSDictionary<NSString *, NSArray<NSDictionary *> *> *)getAllAnnotations:(PSPDFAnnotationType)type error:(NSError *_Nullable *)error {
    PSPDFDocument *document = self.pdfController.document;
    VALIDATE_DOCUMENT(document, nil)
    
    NSArray<PSPDFAnnotation *> *annotations = [[document allAnnotationsOfType:type].allValues valueForKeyPath:@"@unionOfArrays.self"];
    NSArray <NSDictionary *> *annotationsJSON = [RCTConvert instantJSONFromAnnotations:annotations error:error];
    return @{@"annotations" : annotationsJSON};
}

- (BOOL)addAnnotations:(id)jsonAnnotations error:(NSError *_Nullable *)error {
    NSData *data;
    if ([jsonAnnotations isKindOfClass:NSString.class]) {
        data = [jsonAnnotations dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([jsonAnnotations isKindOfClass:NSDictionary.class])  {
        data = [NSJSONSerialization dataWithJSONObject:jsonAnnotations options:0 error:error];
    } else {
        NSLog(@"Invalid JSON Annotations.");
        return NO;
    }
    
    PSPDFDataContainerProvider *dataContainerProvider = [[PSPDFDataContainerProvider alloc] initWithData:data];
    PSPDFDocument *document = self.pdfController.document;
    VALIDATE_DOCUMENT(document, NO)
    PSPDFDocumentProvider *documentProvider = document.documentProviders.firstObject;
    BOOL success = [document applyInstantJSONFromDataProvider:dataContainerProvider toDocumentProvider:documentProvider lenient:NO error:error];
    if (!success) {
        NSLog(@"Failed to add annotations.");
    }
    [self.pdfController reloadData];
    return success;
}

// MARK: - Forms

- (NSDictionary<NSString *, id> *)getFormFieldValue:(NSString *)fullyQualifiedName {
    if (fullyQualifiedName.length == 0) {
        NSLog(@"Invalid fully qualified name.");
        return nil;
    }
    
    PSPDFDocument *document = self.pdfController.document;
    VALIDATE_DOCUMENT(document, nil)
    
    for (PSPDFFormElement *formElement in document.formParser.forms) {
        if ([formElement.fullyQualifiedFieldName isEqualToString:fullyQualifiedName]) {
            id formFieldValue = formElement.value;
            return @{@"value": formFieldValue ?: [NSNull new]};
        }
    }
    
    return @{@"error": @"Failed to get the form field value."};
}

- (BOOL)setFormFieldValue:(NSString *)value fullyQualifiedName:(NSString *)fullyQualifiedName {
    if (fullyQualifiedName.length == 0) {
        NSLog(@"Invalid fully qualified name.");
        return NO;
    }
    
    PSPDFDocument *document = self.pdfController.document;
    VALIDATE_DOCUMENT(document, NO)
    
    BOOL success = NO;
    for (PSPDFFormElement *formElement in document.formParser.forms) {
        if ([formElement.fullyQualifiedFieldName isEqualToString:fullyQualifiedName]) {
            if ([formElement isKindOfClass:PSPDFButtonFormElement.class]) {
                if ([value isEqualToString:@"selected"]) {
                    [(PSPDFButtonFormElement *)formElement select];
                    success = YES;
                } else if ([value isEqualToString:@"deselected"]) {
                    [(PSPDFButtonFormElement *)formElement deselect];
                    success = YES;
                }
            } else if ([formElement isKindOfClass:PSPDFChoiceFormElement.class]) {
                ((PSPDFChoiceFormElement *)formElement).selectedIndices = [NSIndexSet indexSetWithIndex:value.integerValue];
                success = YES;
            } else if ([formElement isKindOfClass:PSPDFTextFieldFormElement.class]) {
                formElement.contents = value;
                success = YES;
            } else if ([formElement isKindOfClass:PSPDFSignatureFormElement.class]) {
                NSLog(@"Signature form elements are not supported.");
                success = NO;
            } else {
                NSLog(@"Unsupported form element.");
                success = NO;
            }
            break;
        }
    }
    return success;
}

// MARK: - Notifications

- (void)annotationChangedNotification:(NSNotification *)notification {
    id object = notification.object;
    NSArray <PSPDFAnnotation *> *annotations;
    if ([object isKindOfClass:NSArray.class]) {
        annotations = object;
    } else if ([object isKindOfClass:PSPDFAnnotation.class]) {
        annotations = @[object];
    } else {
        if (self.onAnnotationsChanged) {
            self.onAnnotationsChanged(@{@"error" : @"Invalid annotation error."});
        }
        return;
    }
    
    NSString *name = notification.name;
    NSString *change;
    if ([name isEqualToString:PSPDFAnnotationChangedNotification]) {
        change = @"changed";
    } else if ([name isEqualToString:PSPDFAnnotationsAddedNotification]) {
        change = @"added";
    } else if ([name isEqualToString:PSPDFAnnotationsRemovedNotification]) {
        change = @"removed";
    }
    
    NSArray <NSDictionary *> *annotationsJSON = [RCTConvert instantJSONFromAnnotations:annotations error:NULL];
    if (self.onAnnotationsChanged) {
        self.onAnnotationsChanged(@{@"change" : change, @"annotations" : annotationsJSON});
    }
}

- (void)spreadIndexDidChange:(NSNotification *)notification {
    PSPDFDocumentViewController *documentViewController = self.pdfController.documentViewController;
    if (notification.object != documentViewController) { return; }
    PSPDFPageIndex pageIndex = [documentViewController.layout pageRangeForSpreadAtIndex:documentViewController.spreadIndex].location;
    PSPDFPageView *pageView = [self.pdfController pageViewForPageAtIndex:pageIndex];
    [self onStateChangedForPDFViewController:self.pdfController pageView:pageView pageAtIndex:pageIndex];
}

// MARK: - Customize the Toolbar

- (void)setLeftBarButtonItems:(nullable NSArray <NSString *> *)items forViewMode:(nullable NSString *) viewMode animated:(BOOL)animated {
    NSMutableArray *leftItems = [NSMutableArray array];
    for (NSString *barButtonItemString in items) {
        UIBarButtonItem *barButtonItem = [RCTConvert uiBarButtonItemFrom:barButtonItemString forViewController:self.pdfController];
        if (barButtonItem && ![self.pdfController.navigationItem.rightBarButtonItems containsObject:barButtonItem]) {
            [leftItems addObject:barButtonItem];
        }
    }
    
    if (viewMode.length) {
        [self.pdfController.navigationItem setLeftBarButtonItems:[leftItems copy] forViewMode:[RCTConvert PSPDFViewMode:viewMode] animated:animated];
    } else {
        [self.pdfController.navigationItem setLeftBarButtonItems:[leftItems copy] animated:animated];
    }
}

- (void)setRightBarButtonItems:(nullable NSArray <NSString *> *)items forViewMode:(nullable NSString *) viewMode animated:(BOOL)animated {
    NSLog(@"righttoolbar 2");
    NSMutableArray *rightItems = [NSMutableArray array];
    for (NSString *barButtonItemString in items) {
        UIBarButtonItem *barButtonItem = [RCTConvert uiBarButtonItemFrom:barButtonItemString forViewController:self.pdfController];
        if (barButtonItem && ![self.pdfController.navigationItem.leftBarButtonItems containsObject:barButtonItem]) {
            [rightItems addObject:barButtonItem];
        }
    }
    
    if (viewMode.length) {
        [self.pdfController.navigationItem setRightBarButtonItems:[rightItems copy] forViewMode:[RCTConvert PSPDFViewMode:viewMode] animated:animated];
    } else {
        [self.pdfController.navigationItem setRightBarButtonItems:[rightItems copy] animated:animated];
    }
}

- (NSArray <NSString *> *)getLeftBarButtonItemsForViewMode:(NSString *)viewMode {
    NSArray *items;
    if (viewMode.length) {
        items = [self.pdfController.navigationItem leftBarButtonItemsForViewMode:[RCTConvert PSPDFViewMode:viewMode]];
    } else {
        items = [self.pdfController.navigationItem leftBarButtonItems];
    }
    
    return [self buttonItemsStringFromUIBarButtonItems:items];
}


- (NSArray <NSString *> *)getRightBarButtonItemsForViewMode:(NSString *)viewMode {
    NSArray *items;
    if (viewMode.length) {
        items = [self.pdfController.navigationItem rightBarButtonItemsForViewMode:[RCTConvert PSPDFViewMode:viewMode]];
    } else {
        items = [self.pdfController.navigationItem rightBarButtonItems];
    }
    
    return [self buttonItemsStringFromUIBarButtonItems:items];
}

// MARK: - Helpers

- (void)onStateChangedForPDFViewController:(PSPDFViewController *)pdfController pageView:(PSPDFPageView *)pageView pageAtIndex:(NSInteger)pageIndex {
    if (self.onStateChanged) {
        BOOL isDocumentLoaded = [pdfController.document isValid];
        PSPDFPageCount pageCount = pdfController.document.pageCount;
        BOOL isAnnotationToolBarVisible = [pdfController.annotationToolbarController isToolbarVisible];
        BOOL hasSelectedAnnotations = pageView.selectedAnnotations.count > 0;
        BOOL hasSelectedText = pageView.selectionView.selectedText.length > 0;
        BOOL isFormEditingActive = NO;
        for (PSPDFAnnotation *annotation in pageView.selectedAnnotations) {
            if ([annotation isKindOfClass:PSPDFWidgetAnnotation.class]) {
                isFormEditingActive = YES;
                break;
            }
        }
        
        self.onStateChanged(@{@"documentLoaded" : @(isDocumentLoaded),
                              @"currentPageIndex" : @(pdfController.pageIndex),
                              @"pageCount" : @(pageCount),
                              @"annotationCreationActive" : @(isAnnotationToolBarVisible),
                              @"affectedPageIndex": @(pageIndex),
                              @"annotationEditingActive" : @(hasSelectedAnnotations),
                              @"textSelectionActive" : @(hasSelectedText),
                              @"formEditingActive" : @(isFormEditingActive)
                            });
    }
}

- (NSArray <NSString *> *)buttonItemsStringFromUIBarButtonItems:(NSArray <UIBarButtonItem *> *)barButtonItems {
    NSMutableArray *barButtonItemsString = [NSMutableArray new];
    [barButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull barButtonItem, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *buttonNameString = [RCTConvert stringBarButtonItemFrom:barButtonItem forViewController:self.pdfController];
        if (buttonNameString) {
            [barButtonItemsString addObject:buttonNameString];
        }
    }];
    return [barButtonItemsString copy];
}


- (NSArray<PSPDFMenuItem *> *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray<PSPDFMenuItem *> *)menuItems atSuggestedTargetRect:(CGRect)rect forAnnotations:(NSArray<PSPDFAnnotation *> *)annotations inRect:(CGRect)annotationRect onPageView:(PSPDFPageView *)pageView {
    
    NSMutableArray *newMenuItems = [menuItems mutableCopy];
    
    NSString *string1 = @"private";
    NSLog(@" custom data221 %@ ", self.accessName);
    if ( [self.accessName length] > 0 ) {
       // string1 = self.accessName;
        if ([self.accessName isEqual:@"private"]) {
            string1 = @"public";
        }else {
            string1 = @"private";
        }
    } else {
        string1 = @"public";
         NSLog(@" custom data %@ ", self.accessName);
    }
    
    // Add the option to google for the currently selected text.
        PSPDFMenuItem *privItem = [[PSPDFMenuItem alloc] initWithTitle:NSLocalizedString(string1, nil) block:^{
            
            if ( [self.tapAnnotation isEqual:NULL]) {
                
            } else {
                
                NSData *annotationData = [self.tapAnnotation generateInstantJSONWithError:NULL];
                NSDictionary *annotationDictionary = [NSJSONSerialization JSONObjectWithData:annotationData options:kNilOptions error:NULL];
                NSDictionary *custDataDict = annotationDictionary[@"customData"];
                NSMutableDictionary *customData = [custDataDict mutableCopy];
                NSLog(@" custom data %@ ", customData);
                
                NSLog(@"Button is called %@", self.tapAnnotation);
                if ([self.accessName isEqual:@"private"]) {
                    [customData setValue:@"public" forKey:@"access" ];
                    self.tapAnnotation.customData = customData;
                    
                    self.accessName = @"public";
                } else {
                    [customData setValue:@"private" forKey:@"access" ];
                    self.tapAnnotation.customData = customData;
                    self.accessName = @"private";
                }
               
            }
            
            [self privateButtonPressed:NULL];
        
        } identifier:string1];
    
    [newMenuItems addObject:privItem];
    NSLog(@"added menu item");
    
    return newMenuItems;
}


@end

@implementation RCTPSPDFKitViewController

- (void)viewWillTransitionToSize:(CGSize)newSize withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:newSize withTransitionCoordinator:coordinator];
  
  /* Workaround for internal issue 25653:
   We re-apply the current view state to workaround an issue where the last page view would be layed out incorrectly
   in single page mode and scroll per spread page trasition after device rotation.
   We do this because the `PSPDFViewController` is not embedded as recommended in
   https://pspdfkit.com/guides/ios/current/customizing-the-interface/embedding-the-pdfviewcontroller-inside-a-custom-container-view-controller
   and because React Native itself handles the React Native view.
   TL;DR: We are adding the `PSPDFViewController` to `RCTPSPDFKitView` and not to the container controller's view.
   */
  [coordinator animateAlongsideTransition:NULL completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    [self applyViewState:self.viewState animateIfPossible:NO];
  }];
}

@end
@implementation CustomButtonAnnotationToolbar

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle

- (instancetype)initWithAnnotationStateManager:(PSPDFAnnotationStateManager *)annotationStateManager {
    
    NSLog(@"name %@",self.annotationGroups);
    
    NSArray<PSPDFColorPreset *> *presets = @[[PSPDFColorPreset presetWithColor:UIColor.blackColor],
                                         [PSPDFColorPreset presetWithColor:UIColor.redColor],
                                         [PSPDFColorPreset presetWithColor:UIColor.greenColor],
                                         [PSPDFColorPreset presetWithColor:UIColor.blueColor]];
PSPDFDefaultAnnotationStyleManager *styleManager = (PSPDFDefaultAnnotationStyleManager *)PSPDFKitGlobal.sharedInstance.styleManager;
PSPDFAnnotationStateVariantID key = PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringLine, nil);
[styleManager setPresets:presets forKey:key type:PSPDFAnnotationStyleTypeColorPreset];
    
  if ((self = [super initWithAnnotationStateManager:annotationStateManager])) {
    // The biggest challenge here isn't the Clear button, but rather correctly updating the Clear button's states.
    NSNotificationCenter *dnc = NSNotificationCenter.defaultCenter;
    [dnc addObserver:self selector:@selector(annotationChangedNotification:) name:PSPDFAnnotationChangedNotification object:nil];
    [dnc addObserver:self selector:@selector(annotationChangedNotification:) name:PSPDFAnnotationsAddedNotification object:nil];
    [dnc addObserver:self selector:@selector(annotationChangedNotification:) name:PSPDFAnnotationsRemovedNotification object:nil];

    // We could also use the delegate, but this is cleaner.
    [dnc addObserver:self selector:@selector(willShowSpreadViewNotification:) name:PSPDFDocumentViewControllerWillBeginDisplayingSpreadViewNotification object:nil];

    // Add Clear button.
    UIImage *clearImage = [[PSPDFKitGlobal imageNamed:@"trash"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _clearAnnotationsButton = [PSPDFToolbarButton new];
    _clearAnnotationsButton.accessibilityLabel = @"Clear";
    [_clearAnnotationsButton setImage:clearImage];
    [_clearAnnotationsButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self updateClearAnnotationButton];
    self.additionalButtons = @[_clearAnnotationsButton];
// Add Custom Stamp
  //   PSPDFDocument *document = self.pdfController.document;
      NSLog(@"issue change ");
      UIImage *ulearImage = [[PSPDFKitGlobal imageNamed:@"stamp"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      _issueAnnotationsButton = [PSPDFToolbarButton new];
_issueAnnotationsButton.accessibilityLabel = @"Clear";
                             [_issueAnnotationsButton setImage:ulearImage];
                             [_issueAnnotationsButton addTarget:self action:@selector(stampPressed:) forControlEvents:UIControlEventTouchUpInside];
      NSLog(@"%@",self.annotationGroups);
      self.additionalButtons = @[_issueAnnotationsButton];
      NSLog(@"issue change 1");
      
    
    // Hide the callout and the signature buttons from the annotation toolbar.
    NSMutableArray <PSPDFAnnotationToolbarConfiguration *> *toolbarConfigurations = [NSMutableArray<PSPDFAnnotationToolbarConfiguration *> new];
      NSLog(@"check1 %@",toolbarConfigurations);
    for(PSPDFAnnotationToolbarConfiguration *toolbarConfiguration in self.configurations) {
      NSMutableArray<PSPDFAnnotationGroup *> *filteredGroups = [NSMutableArray<PSPDFAnnotationGroup *> new];
        NSLog(@"check2 %@",filteredGroups);
      for (PSPDFAnnotationGroup *group in toolbarConfiguration.annotationGroups) {
        NSMutableArray<PSPDFAnnotationGroupItem *> *filteredItems = [NSMutableArray<PSPDFAnnotationGroupItem *> new];
          NSLog(@"check3 %@",filteredItems);
        for(PSPDFAnnotationGroupItem *item in group.items) {
          BOOL isCallout = [item.variant isEqualToString:PSPDFAnnotationVariantStringFreeTextCallout];
          BOOL isSignature = [item.type isEqualToString:PSPDFAnnotationStringSignature];
          if (!isCallout && !isSignature) {
            [filteredItems addObject:item];
          }
            
        }
        NSLog(@"name2 %@",filteredItems);
        if (filteredItems.count) {
          /*  PSPDFAnnotationGroupItem *cloudItem = [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringSquare variant:PSPDFAnnotationVariantStringPolygonCloud];
            [filteredItems addObject:cloudItem];*/
          [filteredGroups addObject:[PSPDFAnnotationGroup groupWithItems:filteredItems]];
        }
      }
       
        PSPDFAnnotationVariantString cloudyRectangleVariant = @"MyCustomCloudyRectangle";
        PSPDFAnnotationGroupItem *cloudyRectangleTool = [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringSquare variant:cloudyRectangleVariant configurationBlock:^UIImage * _Nonnull(PSPDFAnnotationGroupItem * _Nonnull item, id  _Nullable container, UIColor * _Nonnull tintColor) {
            //UIImage *rectImg = [[UIImage alloc] initWithNameInCatalog:@"rectangle_cloudy"];
            //return [[PSPDFKitGlobal imageNamed:@"rectangle_cloudy"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            return [UIImage imageNamed:@"cloud"];
            
            
        }];
        [filteredGroups addObject:[PSPDFAnnotationGroup groupWithItems: @[
            cloudyRectangleTool
            ]]
        ];
        NSLog(@"Added cloud markup");
      [toolbarConfigurations addObject:[[PSPDFAnnotationToolbarConfiguration alloc] initWithAnnotationGroups:filteredGroups]];
        NSLog(@"name3 %@",filteredGroups);
    }

    self.configurations = [toolbarConfigurations copy];
  }
   
  return self;
}

- (void)dealloc {
  [NSNotificationCenter.defaultCenter removeObserver:self];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Clear Button Action

- (void)clearButtonPressed:(id)sender {
  // Iterate over all visible pages and remove everything but links and widgets (forms).
  PSPDFViewController *pdfController = self.annotationStateManager.pdfController;
  PSPDFDocument *document = pdfController.document;
  for (PSPDFPageView *pageView in pdfController.visiblePageViews) {
    NSArray<PSPDFAnnotation *> *annotations = [document annotationsForPageAtIndex:pageView.pageIndex type:PSPDFAnnotationTypeAll & ~(PSPDFAnnotationTypeLink | PSPDFAnnotationTypeWidget)];
    [document removeAnnotations:annotations options:nil];

    // Remove any annotation on the page as well (updates views).
    // Alternatively, you can call `reloadData` on the `pdfController` as well.
    for (PSPDFAnnotation *annotation in annotations) {
      [pageView removeAnnotation:annotation options:nil animated:YES];
    }
  }
}
- (void)stampPressed:(id)sender {
  // Iterate over all visible pages and remove everything but links and widgets (forms).
  PSPDFViewController *pdfController = self.annotationStateManager.pdfController;
  PSPDFDocument *document = pdfController.document;
    NSString *string1 = @"I";
    NSString *string12 = @"Issue";
    NSString *string13 = @"Custom";
   // UIColor *color = [UIColor whiteColor];
   // UIColor *color1 = [UIColor blackColor];
    for (PSPDFPageView *pageView in pdfController.visiblePageViews) {
    PSPDFStampAnnotation *imageStamp = [[PSPDFStampAnnotation alloc] init];
    NSLog(@"issue change 3");
    // Set the image.
  //  imageStamp.image = [UIImage imageNamed:@"exampleexampleimage.jpg"];
        imageStamp.title = string1;
        imageStamp.subtitle = string12;
      //  imageStamp.color = color;
        imageStamp.stampType = string13;
      //  imageStamp.fillColor = color;
    // Set the bounding box.
    CGRect boundingBox = { .origin.x = 300.f, .origin.y = 150.f, .size.height = 100.f, .size.width = 100.f };
    imageStamp.boundingBox = boundingBox;

    // Add the newly created annotation to the document.
    
        [document addAnnotations:@[imageStamp] options:nil];
    }
    NSLog(@"issue change 4 ");
}
///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notifications

// If we detect annotation changes, schedule a reload.
- (void)annotationChangedNotification:(NSNotification *)notification {
  // Reevaluate toolbar button.
  if (self.window) {
    [self updateClearAnnotationButton];
  }
}

- (void)willShowSpreadViewNotification:(NSNotification *)notification {
  [self updateClearAnnotationButton];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFAnnotationStateManagerDelegate

- (void)annotationStateManager:(PSPDFAnnotationStateManager *)manager didChangeUndoState:(BOOL)undoEnabled redoState:(BOOL)redoEnabled {
  [super annotationStateManager:manager didChangeUndoState:undoEnabled redoState:redoEnabled];
  [self updateClearAnnotationButton];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)updateClearAnnotationButton {
  __block BOOL annotationsFound = NO;
  PSPDFViewController *pdfController = self.annotationStateManager.pdfController;
  [pdfController.visiblePageIndexes enumerateIndexesUsingBlock:^(NSUInteger pageIndex, BOOL *stop) {
    NSArray<PSPDFAnnotation *> *annotations = [pdfController.document annotationsForPageAtIndex:pageIndex type:PSPDFAnnotationTypeAll & ~(PSPDFAnnotationTypeLink | PSPDFAnnotationTypeWidget)];
    if (annotations.count > 0) {
      annotationsFound = YES;
      *stop = YES;
    }
  }];
  self.clearAnnotationsButton.enabled = annotationsFound;
}

@end
