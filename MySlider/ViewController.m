//
//  ViewController.m
//  MySlider
//
//  Created by Do Minh Hai on 11/18/15.
//  Copyright (c) 2015 Do Minh Hai. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIColor+Extend.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

{
   // UISlider* mySlider;
    UIView* thumbValue;
    UIView* remainRunValue;
    UILabel* thumbValueLabel;
    UILabel* remainRunValueLabel;
    UILabel* minusLabel ;
    NSTimer* timer;
    CGFloat thumbRadius;
    AVAudioPlayer *audioPlayer;
    UIImageView* playButton;
    IBOutlet UISlider *mySlider;
    
    BOOL PlayOrPause ;
}



@end

@implementation ViewController
{
    UIImageView* imageView;
    
    CGFloat circleRadius;
    CGPoint circleCenter;
    
    CAShapeLayer* maskLayer;
    CAShapeLayer* circleLayer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    thumbRadius=9;
    
    
    [self addBackground];
    [self addPicture];
    [self designSlider];
    [self addPlayButton];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(updateTime)
                                           userInfo:nil
                                            repeats:YES];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"One Direction - History " ofType:@"mp3"]];
    
    audioPlayer = [[AVAudioPlayer alloc]
                            initWithContentsOfURL:fileURL error:nil];
    

    
    mySlider.minimumValue = 0;
    
    mySlider.maximumValue = audioPlayer.duration;
    
    //[audioPlayer play];
    [mySlider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    
    playButton.userInteractionEnabled = YES;
    playButton.multipleTouchEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(playAndPause:)];
    [playButton addGestureRecognizer:tap];
    
    UITapGestureRecognizer*tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(changeValue2:)];
    [mySlider addGestureRecognizer:tap1];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(changeValue3:)];
    [mySlider addGestureRecognizer:pan];
    [self runSpinAnimationWithDuration:4];
    
}
-(void) addPicture
{
    
    CGRect imageRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height*0.75);
    imageView = [[UIImageView alloc] initWithFrame: imageRect];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //imageView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    imageView.image = [UIImage imageNamed:@"OneDirection1.jpeg"];

    
    imageView.userInteractionEnabled = true;
    imageView.multipleTouchEnabled = true;
    [self.view addSubview:imageView];
    
    maskLayer = [CAShapeLayer layer];
    
    imageView.layer.mask = maskLayer;
    
    circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = 3.0;
    circleLayer.fillColor = [[UIColor clearColor] CGColor];
    circleLayer.strokeColor = [[UIColor blackColor] CGColor];
    [imageView.layer addSublayer:circleLayer];
    
      circleCenter = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height /2*0.75);
    circleRadius = self.view.bounds.size.width * 0.3;
    
    [self updateCirclePathLocation:circleCenter andRadius:circleRadius];
    
    // create circle path
    
   
    
}
-(void) addPlayButton
{
    playButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64 , 64)];
    playButton.image = [UIImage imageNamed:@"play"];
    playButton.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height*4.6/5);
    [self.view addSubview:playButton];
}

-(void)updateCirclePathLocation:(CGPoint)center andRadius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // draw circle
    [path addArcWithCenter:circleCenter
     radius:circleRadius
     startAngle:0.0
     endAngle:M_PI * 2.0
     clockwise:YES];
    
    // draw polygon (4 points)
    /*
    [path moveToPoint:CGPointMake(circleCenter.x, circleCenter.y - circleRadius)];
    [path addLineToPoint:CGPointMake(circleCenter.x - circleRadius * 0.5, circleCenter.y)];
    [path addLineToPoint:CGPointMake(circleCenter.x, circleCenter.y + circleRadius)];
    [path addLineToPoint:CGPointMake(circleCenter.x + circleRadius * 0.5, circleCenter.y)];
    [path closePath];
    */
    maskLayer.path = [path CGPath];
    circleLayer.path = [path CGPath];
    
}

- (void) runSpinAnimationWithDuration:(CGFloat) duration;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/  ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 500;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
-(void) addBackground
{
    UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    background.frame = self.view.bounds;
    background.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:background];
    
    
   }
-(void) designSlider
{
    mySlider = [UISlider new];
    mySlider.frame = CGRectMake(0, 0, 200, 10);
    mySlider.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height*4/5);
    // set thumbSlider
    [mySlider setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    
    // set max, min value
    // [mySlider setMaximumValue:20];
    //[mySlider setMinimumValue:0];
    
    // set track
    UIEdgeInsets insetMaxTrack = UIEdgeInsetsMake(0, 0, 0, 10);
    UIEdgeInsets insetMinTrack = UIEdgeInsetsMake(0, 10, 0, 0);
    UIImage* maxTrack = [[UIImage imageNamed:@"maxtrack"] resizableImageWithCapInsets:insetMaxTrack];
    UIImage* minTrack = [[UIImage imageNamed:@"mintrack"] resizableImageWithCapInsets:insetMinTrack];
    [mySlider setMaximumTrackImage:maxTrack forState:UIControlStateNormal];
    [mySlider setMinimumTrackImage:minTrack forState:UIControlStateNormal];
    
    /*
    remainRunValue = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 13)];
    remainRunValue.center = CGPointMake(mySlider.center.x+ 125, mySlider.center.y);
    remainRunValue.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timerun.jpg"]];
    [self.view addSubview:remainRunValue];
     */
    //set remainRunValueLabel
    remainRunValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 11)];
    remainRunValueLabel.center = CGPointMake(mySlider.center.x+ 135, mySlider.center.y);
    remainRunValueLabel.attributedText = [self showTimeWithStyle1: mySlider.maximumValue - mySlider.value];
    remainRunValueLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remainRunValueLabel];
    
    //set thumbValue
    
    thumbValue = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 52, 37)];
    thumbValue.center = CGPointMake(mySlider.center.x - ((mySlider.bounds.size.width*(mySlider.maximumValue/2-mySlider.value)-thumbRadius)/mySlider.maximumValue)*182/200, mySlider.center.y- 35);
    thumbValue.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"thumb-value-bg"]];
    [self.view addSubview:thumbValue];
    thumbValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 10, 45, 11)];
    thumbValueLabel.attributedText = [self showTimeWithStyle2:( mySlider.value)];
    thumbValueLabel.textAlignment = NSTextAlignmentCenter;
    [thumbValue addSubview:thumbValueLabel];
    [self.view addSubview:mySlider];
    
    //set minusLabel
    
    minusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, 11)];
    minusLabel.center = CGPointMake(remainRunValueLabel.center.x-25, remainRunValueLabel.center.y);
    minusLabel.text = @"-";
    minusLabel.textColor = [[UIColor alloc] initWithHex:@"343838" alpha:1.0];
    minusLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.view addSubview:minusLabel];
}
-(NSString*) convertValueToTime: (float) number
{
    int minute;
    int second;
    minute = (int)(number/60);
    second = (number - minute*60);
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
    
}
- (NSAttributedString*)showTimeWithStyle1:(float)value {
    UIFont* font = [UIFont boldSystemFontOfSize:14.0f];
    UIColor* textColor = [[UIColor alloc] initWithHex:@"343838" alpha:1.0];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : textColor,
                             NSFontAttributeName : font
                             //NSTextEffectAttributeName : NSTextEffectLetterpressStyle, // Poor performance when //active Letter press style -> why ???
                            };
    
    
    NSString* stringTime = [self convertValueToTime:value];
    
    NSAttributedString* attrString = [[NSAttributedString alloc]
                                      initWithString:stringTime
                                      attributes:attrs];
    return attrString;
}
- (NSAttributedString*)showTimeWithStyle2:(float)value {
    UIFont* font = [UIFont boldSystemFontOfSize:14.0f];
    UIColor* textColor = [[UIColor alloc] initWithHex:@"F03C02" alpha:1.0];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : textColor,
                             NSFontAttributeName : font
                             //NSTextEffectAttributeName : NSTextEffectLetterpressStyle, // Poor performance when //active Letter press style -> why ???
                             };
    
    
    NSString* stringTime = [self convertValueToTime:value];
    
    NSAttributedString* attrString = [[NSAttributedString alloc]
                                      initWithString:stringTime
                                      attributes:attrs];
    return attrString;
}
-(void) updateTime
{
    remainRunValueLabel.attributedText = [self showTimeWithStyle1: mySlider.maximumValue - mySlider.value];
    thumbValueLabel.attributedText = [self showTimeWithStyle2:( mySlider.value)];
    thumbValue.center = CGPointMake(mySlider.center.x - ((mySlider.bounds.size.width*(mySlider.maximumValue/2-mySlider.value)-thumbRadius)/mySlider.maximumValue)*182/200, mySlider.center.y- 35);

    float progress = audioPlayer.currentTime;
    [mySlider setValue:progress];
    [self checkFinishSong];
    
     //thumbValueLabel.textColor = [UIColor colorWithRed:0x0D/255.0f green:0x0D/255.0f blue:0x72/255.0f alpha:1];
}

-(void) checkFinishSong
{
    if (mySlider.value > mySlider.maximumValue*0.995) {
        PlayOrPause = !PlayOrPause;
        playButton.image = [UIImage imageNamed:@"play"];
    }
}

- (IBAction)changeValue:(UISlider*) sender
{
    
    //NSLog(@"change");
    [audioPlayer setCurrentTime:mySlider.value];
    
}
-(void) changeValue2: (UITapGestureRecognizer*) tap
{
   
    CGPoint point = [tap locationInView:self.view];
    CGFloat newValue;
    newValue = mySlider.maximumValue*(mySlider.bounds.size.width/2-(mySlider.center.x-point.x))/mySlider.bounds.size.width;
    mySlider.value = newValue;
    [audioPlayer setCurrentTime:mySlider.value];
}
-(void) changeValue3: (UIPanGestureRecognizer*) pan
{
    CGPoint point = [pan locationInView:self.view];
    CGFloat newValue;
    newValue = mySlider.maximumValue*(mySlider.bounds.size.width/2-(mySlider.center.x-point.x))/mySlider.bounds.size.width;
    mySlider.value = newValue;
    [audioPlayer setCurrentTime:mySlider.value];
}
-(void) playAndPause: (UITapGestureRecognizer*) tap
{
    NSLog(@"abc");
    if (PlayOrPause) {
        playButton.image = [UIImage imageNamed:@"play"];
        [audioPlayer stop];
        PlayOrPause = !PlayOrPause;
    }else
    {
        playButton.image = [UIImage imageNamed:@"pause"];
        [audioPlayer play];
        PlayOrPause = !PlayOrPause;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]] &&
        [otherGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) {
        return true;
    } else {
        return false;
    }
}
@end
