//
//  ViewController.m
//  UITest
//
//  Created by 孟云 on 15/8/11.
//  Copyright (c) 2015年 Bar. All rights reserved.
//

#import "GOFViewController.h"
//#import "GOFmodel.h"
//#import "StartViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)NSMutableArray *tmpdata;
@property(nonatomic,assign)int firstBtnIndex;
@property(nonatomic,assign)int generation;
@property(nonatomic,assign)int nSize;
//@property(nonatomic,assign)NSInteger currentBtnId;

@property(nonatomic,strong)NSTimer *timer;

- (int) getAliveOrDie:(int)btnID;
- (int) getAroundAliveNum:(int)btnID;

@end

@implementation ViewController

- (NSMutableArray *)data
{
    //AppDelegate *appDlg = [[UIApplication sharedApplication] delegate];
    //self.nSize = appDlg.nSize;
    if (!_data)
    {
        _data = [NSMutableArray array];
        for (int i=0;i<self.nSize*self. nSize;++i)
        {
            [_data addObject:[NSNumber numberWithBool:NO]];
        }
        //int startPos = 10;
        //_data[startPos+1] = [NSNumber numberWithBool:YES];
        //_data[startPos+self.nSize] = [NSNumber numberWithBool:YES];
        //_data[startPos+self.nSize*2] = [NSNumber numberWithBool:YES];
        //_data[startPos+self.nSize*2+1] = [NSNumber numberWithBool:YES];
        //_data[startPos+self.nSize*2+2] = [NSNumber numberWithBool:YES];
    }
    return _data;
}

- (NSMutableArray *)tmpdata
{
    if (!_tmpdata)
    {
        _tmpdata = [self.data mutableCopy];
    }
    return _tmpdata;
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.timer !=nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //AppDelegate *appDlg = [[UIApplication sharedApplication] delegate];
    _nSize = 22;//appDlg.nSize;
    //NSLog(@"%@",self.data);
    //UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:nil action:nil];
    //self.navigationItem.rightBarButtonItem = bar;
    self.navigationItem.title = @"Game Of Life";
    
    //[self.window addSubview:self.view];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.generation=0;
    CGFloat navHeight = 51;
    CGFloat startX = 10;
    CGFloat startY = 0+navHeight;
    CGFloat width = (self.view.frame.size.width - 2*startX)/self.nSize;
    
    //CGFloat margin = (self.view.frame.size.width - self.nSize*APPVIEWW)/(self.nSize+1);
    NSUInteger count = [self.data count];
    
    for (int i=0;i<count;++i)
    {
        int row = i/self.nSize;
        int loc = i%self.nSize;
        
        CGFloat appviewX = startX+width*loc;
        CGFloat appviewY = startY+width*row;
        
        UIView *appView = [[UIView alloc]initWithFrame:CGRectMake(appviewX, appviewY, width, width)];
        [appView setBackgroundColor:[UIColor purpleColor]];
        //[appView addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appView];
        
        UIButton *appBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat spaceWidth = 1.1;
        appBtn.frame = CGRectMake(spaceWidth, spaceWidth, width-1.5*spaceWidth, width-1.5*spaceWidth);
        //if (self.data[i] == YES)
        if (self.data[i] == [NSNumber numberWithBool:NO])
            [appBtn setBackgroundColor:[UIColor grayColor]];
        else
            [appBtn setBackgroundColor:[UIColor blueColor]];
        [appBtn setAccessibilityIdentifier:[[NSString alloc]initWithFormat:@"%d",i]];
        if (self.nSize < 25)
        {
            [appBtn setTitle:@"o" forState:UIControlStateNormal];
            appBtn.titleLabel.font = [UIFont systemFontOfSize:[appBtn intrinsicContentSize].width/2.2];
        }
        [appView addSubview:appBtn];
        
        [appBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    width = 17;
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    preBtn.frame = CGRectMake(10, navHeight+380, width*5, width*2);
    [preBtn setBackgroundColor:[UIColor grayColor]];
    //[preBtn setAccessibilityIdentifier:[[NSString alloc]initWithFormat:@"%d",-2]];
    [preBtn setTitle:@"pre" forState:UIControlStateNormal];
    [preBtn setTitle:@"preDisabled" forState:UIControlStateDisabled];
    preBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [preBtn setEnabled:NO];
    [self.view addSubview:preBtn];
    [preBtn addTarget:self action:@selector(clickPre:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(100, navHeight+380, width*5, width*2);
    [nextBtn setBackgroundColor:[UIColor grayColor]];
    //[nextBtn setAccessibilityIdentifier:[[NSString alloc]initWithFormat:@"%d",-1]];
    [nextBtn setTitle:@"next" forState:UIControlStateNormal];
    [nextBtn setTitle:@"nextDisabled" forState:UIControlStateDisabled];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [nextBtn setEnabled:NO];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    timeBtn.frame = CGRectMake(190, navHeight+380, width*5, width*2);
    [timeBtn setBackgroundColor:[UIColor grayColor]];
    //[preBtn setAccessibilityIdentifier:[[NSString alloc]initWithFormat:@"%d",-2]];
    [timeBtn setTitle:@"timer" forState:UIControlStateNormal];
    [timeBtn setTitle:@"timerDisabled" forState:UIControlStateDisabled];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [timeBtn setEnabled:NO];
    [self.view addSubview:timeBtn];
    [timeBtn addTarget:self action:@selector(clickTime:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *restartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    restartBtn.frame = CGRectMake(280, navHeight+380, width*5, width*2);
    [restartBtn setBackgroundColor:[UIColor grayColor]];
    //[preBtn setAccessibilityIdentifier:[[NSString alloc]initWithFormat:@"%d",-2]];
    [restartBtn setTitle:@"restart" forState:UIControlStateNormal];
    //[restartBtn setTitle:@"disabled" forState:UIControlStateDisabled];
    restartBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [restartBtn setEnabled:NO];
    [self.view addSubview:restartBtn];
    [restartBtn addTarget:self action:@selector(clickRestart:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *genLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 600, width*9, width*2)];
    NSString *generStr  = [[NSString alloc]initWithFormat:@"自动机第(%d)代",self.generation];
    [genLable setText:generStr];
    [genLable setTag:121];
    [genLable setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:genLable];
    
    UITextField *xText = [[UITextField alloc]initWithFrame:CGRectMake(10, navHeight+420,  width*5, width*2)];
    xText.borderStyle = UITextBorderStyleRoundedRect;
    xText.autocorrectionType = UITextAutocorrectionTypeYes;
    xText.placeholder = @"xPoint";
    xText.returnKeyType = UIReturnKeyDone;
    xText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [xText setBackgroundColor:[UIColor colorWithRed:1.0 green:0.8 blue:0.7 alpha:0.8]];
    xText.keyboardType = UIKeyboardTypeNumberPad;
    xText.delegate = self;
    [self.view addSubview:xText];
    
    UITextField *yText = [[UITextField alloc]initWithFrame:CGRectMake(100, navHeight+420,  width*5, width*2)];
    yText.borderStyle = UITextBorderStyleRoundedRect;
    yText.autocorrectionType = UITextAutocorrectionTypeYes;
    yText.placeholder = @"yPoint";
    yText.returnKeyType = UIReturnKeyDone;
    yText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [yText setBackgroundColor:[UIColor colorWithRed:1.0 green:0.8 blue:0.7 alpha:0.7]];
    yText.keyboardType = UIKeyboardTypeNumberPad;
    //[yText setEnabled:NO];
    yText.delegate = self;
    [self.view addSubview:yText];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(190, navHeight+420, width*5, width*2);
    [addBtn setBackgroundColor:[UIColor grayColor]];
    [addBtn setTitle:@"addPoint" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    //[addBtn setEnabled:NO];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(clickAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(280, navHeight+420, width*5, width*2);
    [deleteBtn setBackgroundColor:[UIColor grayColor]];
    [deleteBtn setTitle:@"deletePoint" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    //[deleteBtn setEnabled:NO];
    [self.view addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    self.firstBtnIndex = 2;
    
}

- (void)click:(UIButton *)btn
{
    int btnID = [btn.accessibilityIdentifier intValue];
    NSLog(@"click!%d",btnID);
    if (self.data[btnID] == [NSNumber numberWithBool:NO])
    {
        self.data[btnID] = [NSNumber numberWithBool:YES];
        [btn setBackgroundColor:[UIColor blueColor]];
    }
    else if (self.data[btnID] == [NSNumber numberWithBool:YES])
    {
        self.data[btnID] = [NSNumber numberWithBool:NO];
        [btn setBackgroundColor:[UIColor grayColor]];
    }
    self.tmpdata = [self.data mutableCopy];
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize] setEnabled:NO];
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+1] setEnabled:YES];
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+2] setEnabled:YES];
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+3] setEnabled:YES];
    self.generation = 0;
    NSString *generStr  = [[NSString alloc]initWithFormat:@"自动机第(%d)代",self.generation];
    //UIView *vieww = [self.view subviews];
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+4] setText:generStr];
}

- (int) getAliveOrDie:(int)btnID
{
    return (self.tmpdata[btnID] == [NSNumber numberWithBool:YES])?1:0;
}

- (int) getAroundAliveNum:(int)btnID
{
    int rlt = 0;
    int y = btnID/self.nSize;
    int x = btnID%self.nSize;
    for (int i=x-1;i<=x+1;++i)
        for (int j=y-1; j<=y+1; ++j) {
            if (i>=0 &&i<self.nSize &&j>=0 &&j<self.nSize)
                rlt = rlt+ [self getAliveOrDie:(j*self.nSize+i)];
        }
    rlt = rlt - [self getAliveOrDie:btnID];
    return rlt;
}

- (void)clickNext:(UIButton *)btn
{
    self.tmpdata = [self.data mutableCopy];
    id btnView =[self.view subviews];
    for (int i=0; i<self.nSize*self.nSize; ++i)
    {
        id tmpBtn = [btnView[self.firstBtnIndex+i] subviews][0];
        int aroundAliveNum = [self getAroundAliveNum:i];
        if (aroundAliveNum == 3)
        {
            self.data[i] = [NSNumber numberWithBool:YES];
        }
        else if (aroundAliveNum == 2)
        {
        }
        else
            self.data[i] = [NSNumber numberWithBool:NO];
        
        if (self.data[i] == [NSNumber numberWithBool:NO])
        {
            [tmpBtn setBackgroundColor:[UIColor grayColor]];
        }
        else if (self.data[i] == [NSNumber numberWithBool:YES])
        {
            [tmpBtn setBackgroundColor:[UIColor blueColor]];
        }
    }
    [btnView[self.firstBtnIndex+self.nSize*self.nSize] setEnabled:YES];
    self.generation = self.generation+1;
    NSString *generStr  = [[NSString alloc]initWithFormat:@"自动机第(%d)代",self.generation];
    [btnView[self.firstBtnIndex+self.nSize*self.nSize+4] setText:generStr];
}

- (void)clickPre:(UIButton *)btn
{
    self.data = [self.tmpdata mutableCopy];
    id btnView =[self.view subviews];
    for (int i=0; i<self.nSize*self.nSize; ++i)
    {
        id tmpBtn = [btnView[self.firstBtnIndex+i] subviews][0];
        if (self.data[i] == [NSNumber numberWithBool:NO])
        {
            [tmpBtn setBackgroundColor:[UIColor grayColor]];
        }
        else if (self.data[i] == [NSNumber numberWithBool:YES])
        {
            [tmpBtn setBackgroundColor:[UIColor blueColor]];
        }
    }
    [btn setEnabled:NO];
    self.generation = self.generation-1;
    NSString *generStr  = [[NSString alloc]initWithFormat:@"自动机第(%d)代",self.generation];
    [btnView[self.firstBtnIndex+self.nSize*self.nSize+4] setText:generStr];
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(paint:) userInfo:nil repeats:(YES)];
}

- (void)clickTime:(UIButton *)btn
{
    if (self.timer !=nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    else
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(paint:) userInfo:nil repeats:(YES)];
        [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+1] setEnabled:NO];
        [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize] setEnabled:NO];
    }
}

- (void)paint:(NSTimer *)paramTimer
{
    NSLog(@"timer");
    self.tmpdata = [self.data mutableCopy];
    id btnView =[self.view subviews];
    for (int i=0; i<self.nSize*self.nSize; ++i)
    {
        id tmpBtn = [btnView[self.firstBtnIndex+i] subviews][0];
        int aroundAliveNum = [self getAroundAliveNum:i];
        if (aroundAliveNum == 3)
        {
            self.data[i] = [NSNumber numberWithBool:YES];
        }
        else if (aroundAliveNum == 2)
        {
        }
        else
            self.data[i] = [NSNumber numberWithBool:NO];
        
        if (self.data[i] == [NSNumber numberWithBool:NO])
        {
            [tmpBtn setBackgroundColor:[UIColor grayColor]];
        }
        else if (self.data[i] == [NSNumber numberWithBool:YES])
        {
            [tmpBtn setBackgroundColor:[UIColor blueColor]];
        }
    }
    self.generation = self.generation+1;
    NSString *generStr  = [[NSString alloc]initWithFormat:@"自动机第(%d)代",self.generation];
    [btnView[self.firstBtnIndex+self.nSize*self.nSize+4] setText:generStr];
    
}

- (void)clickRestart:(UIButton *)btn
{
    id btnView =[self.view subviews];
    for (int i=0; i<self.nSize*self.nSize; ++i)
    {
        self.data[i] = [NSNumber numberWithBool:NO];
        id tmpBtn = [btnView[self.firstBtnIndex+i] subviews][0];
        [tmpBtn setBackgroundColor:[UIColor grayColor]];
    }
    self.tmpdata = [self.data mutableCopy];
    self.generation = 0;
    NSString *generStr  = [[NSString alloc]initWithFormat:@"自动机第(%d)代",self.generation];
    [btnView[self.firstBtnIndex+self.nSize*self.nSize+4] setText:generStr];
    if (self.timer !=nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+0] setEnabled:NO];
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+1] setEnabled:NO];
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+2] setEnabled:NO];
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+3] setEnabled:NO];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.3f;
    CGRect frame = self.view.frame;
    //NSLog(@"%lf",frame.origin.y);
    if (frame.origin.y == 0) {
        frame.origin.y -= 216;
        frame.size.height +=216;
    }
    //self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame=frame;
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.3f;
    CGRect frame = self.view.frame;
    if (frame.origin.y == -216) {
        frame.origin.y += 216;
        frame.size.height -=216;
    }
    //self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    //id xTextField = [self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+6];
    //int xPosition = [xTextField.text intValue];
    int xPosition = [textField.text intValue];
    if (xPosition >=0&& xPosition <self.nSize)
        [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+6] setEnabled:YES];
    return YES;
}

- (void)clickAdd:(UIButton *)btn
{
    int textContentX = -1;
    int textContentY = -1;
    UITextField *textFieldX = [self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+5];
    //int textContentX = [textFieldX.text intValue];
    UITextField *textFieldY = [self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+6];
    //int textContentY = [textFieldY.text intValue];
    if (([textFieldX.text isEqualToString:@""]||[textFieldY.text isEqualToString:@""])== NO)
    {
        textContentX = [textFieldX.text intValue];
        textContentY = [textFieldY.text intValue];
    }
    
    NSLog(@"%d_%d",textContentX,textContentY);
    id btnView =[self.view subviews];
    if (textContentX >=0&& textContentX <self.nSize&& textContentY >=0&& textContentY <self.nSize)
    {
        self.data[textContentX+textContentY*self.nSize] = [NSNumber numberWithBool:YES];
        id tmpBtn = [btnView[self.firstBtnIndex+textContentX+textContentY*self.nSize] subviews][0];
        [tmpBtn setBackgroundColor:[UIColor blueColor]];
    }
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize] setEnabled:NO];
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+1] setEnabled:YES];
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+2] setEnabled:YES];
    [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+3] setEnabled:YES];
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(paint:) userInfo:nil repeats:(YES)];
}

- (void)clickDelete:(UIButton *)btn
{
    int textContentX = -1;
    int textContentY = -1;
    UITextField *textFieldX = [self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+5];
    //int textContentX = [textFieldX.text intValue];
    UITextField *textFieldY = [self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+6];
    //int textContentY = [textFieldY.text intValue];
    if (([textFieldX.text isEqualToString:@""]||[textFieldY.text isEqualToString:@""])== NO)
    {
        textContentX = [textFieldX.text intValue];
        textContentY = [textFieldY.text intValue];
    }
    NSLog(@"%d_%d",textContentX,textContentY);
    id btnView =[self.view subviews];
    if (textContentX >=0&& textContentX <self.nSize&& textContentY >=0&& textContentY <self.nSize)
    {
        self.data[textContentX+textContentY*self.nSize] = [NSNumber numberWithBool:NO];
        id tmpBtn = [btnView[self.firstBtnIndex+textContentX+textContentY*self.nSize] subviews][0];
        [tmpBtn setBackgroundColor:[UIColor grayColor]];
    }
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(paint:) userInfo:nil repeats:(YES)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}//test

@end

































