//
//  DishTableViewCell.m
//  Menyou
//
//  Created by Noah Martin on 5/6/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "DishTableViewCell.h"

@interface DishTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *background;
@property CAGradientLayer* gradient;
@property CGPoint startCenter;
@property UIDynamicAnimator* animator;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property BOOL isSelected;
@end

@implementation DishTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.gradient.frame = self.background.bounds;
}

- (IBAction)addItem:(id)sender {
    [self setDishSelected:!self.isSelected];  // Toggle selected state
    [self.delegate itemSelected:self];
}

-(void)setDishSelected:(BOOL)selected
{
    self.isSelected = selected;
    if(self.isSelected)
    {
        [self.checkButton setImage:[UIImage imageNamed:@"checkSelected"] forState:UIControlStateNormal];
    }
    else
    {
        [self.checkButton setImage:[UIImage imageNamed:@"checkUnselected"] forState:UIControlStateNormal];
    }
}

-(void)setColor:(UIColor *)color
{
    [self.background setBackgroundColor:color];
}

-(void)setup
{
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.background.bounds;
    self.gradient.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                              (id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                              (id)[[UIColor clearColor] CGColor],
                              (id)[[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
    self.gradient.locations = @[@0.00f, @0.01f, @0.95f, @1.00f];
    [self.background.layer insertSublayer:self.gradient atIndex:0];
    self.background.layer.cornerRadius = 8;
    self.background.layer.masksToBounds = YES;
    [self.background setOpaque:YES];
    UIPanGestureRecognizer* gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    gestureRecognizer.delegate = self;
    [self addGestureRecognizer:gestureRecognizer];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer respondsToSelector:@selector(translationInView:)])
    {
        CGPoint p = [((UIPanGestureRecognizer*) gestureRecognizer) translationInView:[self superview]];
        if(fabs(p.x) > fabs(p.y))
        {
            return [self.delegate canRemove:self];
        }
    }
    return NO;
}

-(void)handlePan:(UIPanGestureRecognizer*)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self.animator removeAllBehaviors];
        self.startCenter = self.center;
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
      CGPoint translation = [gestureRecognizer translationInView:self];
      self.center = CGPointMake(self.startCenter.x + translation.x, self.center.y);
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGFloat vx = [gestureRecognizer velocityInView:self.superview].x;
        if (self.frame.origin.x <= self.frame.size.width/4 || vx < 0) {
            UISnapBehavior* snap = [[UISnapBehavior alloc] initWithItem:self snapToPoint:self.startCenter];
            snap.damping = 0.5;
            UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
            item.allowsRotation = NO;
            item.resistance = 0.5;
            [self.animator addBehavior:snap];
            [self.animator addBehavior:item];
        }
        else {
            UIPushBehavior* push = [[UIPushBehavior alloc] initWithItems:@[self] mode:UIPushBehaviorModeInstantaneous];
            push.angle = 0;
            __weak DishTableViewCell* const weakSelf = self;
            push.action = ^{
                if(weakSelf.frame.origin.x > weakSelf.frame.size.width)
                {
                    [weakSelf.animator removeAllBehaviors];
                    [weakSelf.delegate itemRemoved:weakSelf];
                }
            };
            UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
            item.allowsRotation = NO;
            item.resistance = 0.5;
            [self.animator addBehavior:push];
            [self.animator addBehavior:item];
            if(vx < 10)
              vx = 10;
            else if(vx > 30)
              vx = 30;
            push.pushDirection = CGVectorMake(vx, 0);
            push.active = YES;
        }
    }
}

- (void)awakeFromNib
{
    [self setup];
}

@end
