//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Luke Paulo on 6/23/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar ()

@property(nonatomic, strong) NSArray *currentTitles;
@property(nonatomic, strong) NSArray *colors;
@property(nonatomic, strong) NSArray *buttons;
@property(nonatomic, weak) UILabel *currentLabel;
@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property(nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation AwesomeFloatingToolbar

-(instancetype) initWithFourTitles:(NSArray *)titles {
    // First, callthe superclass (UIView)'s initializer, to make sure we do all that setup first
    self = [super init];
    
    if (self) {
        //Save the titles and set 4 colors
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
        
        //Make the 4 labels
//        for (NSString *currentTitle in self.currentTitles) {
//            UILabel *label = [[UILabel alloc] init];
//            label.userInteractionEnabled = NO;
//            label.alpha = 0.25;
//            
//            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle];
//            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
//            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
//            
//            label.textAlignment = NSTextAlignmentCenter;
//            label.font = [UIFont systemFontOfSize:10];
//            label.text = titleForThisLabel;
//            label.backgroundColor = colorForThisLabel;
//            label.textColor = [UIColor whiteColor];
//            
//            [labelsArray addObject:label];
//        }
//        
//        self.labels = labelsArray;
//        
//        for (UILabel *thisLabel in self.labels) {
//            [self addSubview:thisLabel];
//        }
        
        //Make the 4 buttons
        for (NSString *currentTitle in self.currentTitles) {
            
            UIButton *button = [[UIButton alloc] init];
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            button.userInteractionEnabled = NO;
            button.alpha = 0.25;
    
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle];
            NSString *titleForThisButton = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisButton = [self.colors objectAtIndex:currentTitleIndex];

                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                button.titleLabel.font = [UIFont systemFontOfSize:10];
                button.titleLabel.text = titleForThisButton;
                button.titleLabel.backgroundColor = colorForThisButton;
                button.titleLabel.textColor = [UIColor whiteColor];
        
                    [buttonsArray addObject:button];
                }
        
                self.buttons = buttonsArray;
                
                for (UIButton *thisButton in self.buttons) {
                    [self addSubview:thisButton];
                }
        
//        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
//        [self addGestureRecognizer:self.tapGesture];
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        [self addGestureRecognizer:self.longPressGesture];
        
    }
    
    return self;
}

//- (void) tapFired:(UITapGestureRecognizer *)recognizer {
//    if (recognizer.state == UIGestureRecognizerStateRecognized) {
//        CGPoint location = [recognizer locationInView:self];
//        UIView *tappedView = [self hitTest:location withEvent:nil];
//        
//        if ([self.button containsObject:tappedView]) {
//            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
//                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
//            }
//        }
//    }
//}

- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGFloat lastScale = 1;
        CGPoint lastPoint = [recognizer locationInView:self];
        
        CGFloat scale = 1.0 - (lastScale - recognizer.scale);
        [self.layer setAffineTransform:
         CGAffineTransformScale([self.layer affineTransform], scale, scale)];
        
        lastScale = recognizer.scale;
        
        CGPoint point = [recognizer locationInView:self];
        [self.layer setAffineTransform:
         CGAffineTransformTranslate([self.layer affineTransform], point.x - lastPoint.x, point.y - lastPoint.y)];
        lastPoint = [recognizer locationInView:self];
    }
    
    
}

- (void) longPressFired:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [recognizer.view setBackgroundColor:[UIColor colorWithRed:121/255.0 green:97/255.0 blue:134/255.0 alpha:1]];
    }
}
- (void) layoutSubviews {
    //set the frames for the four labels
    
    for (UILabel *thisButton in self.buttons) {
        NSUInteger currentLabelIndex = [self.buttons indexOfObject:thisButton];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        //adjust labelX & labelY
        if (currentLabelIndex < 2) {
            //0 or 1, so on top
            labelY = 0;
        } else {
            //2 or 3, so on button
            labelY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentLabelIndex % 2 == 0) {
            //0 or 2 so on left
            labelX = 0;
        } else {
            //1 or 3, so on the right
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisButton.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
        
    }
}

#pragma mark - Touch Handling

- (UILabel *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subView = [self hitTest:location withEvent:event];
    
    if ([subView isKindOfClass:[UILabel class]]) {
        return (UILabel *)subView;
    } else {
        return nil;
    }
}

#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UILabel *button = [self.buttons objectAtIndex:index];
        button.userInteractionEnabled = enabled;
        button.alpha = enabled ? 1.0 : 0.25;
    }
}

@end
