//
//  ViewController.m
//  TestNameSortAndSplit
//
//  Created by ethan on 13-4-27.
//  Copyright (c) 2013年 ethan. All rights reserved.
//
/*
#import "ViewController.h"
#import "pinyin.h"
#import "ChineseString.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize dataArr = _dataArr;
@synthesize sortedArrForArrays = _sortedArrForArrays;
@synthesize sectionHeadsKeys = _sectionHeadsKeys;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initData];
    [self createTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

#pragma mark -
#pragma mark create method

- (void)initData {
    //init
    _dataArr = [[NSMutableArray alloc] init];
    _sortedArrForArrays = [[NSMutableArray alloc] init];
    _sectionHeadsKeys = [[NSMutableArray alloc] init];      //initialize a array to hold keys like A,B,C ...

    //add test data
    [_dataArr addObject:@"郭靖"];
    [_dataArr addObject:@"黄蓉"];
    [_dataArr addObject:@"杨过"];
    [_dataArr addObject:@"苗若兰"];
    [_dataArr addObject:@"令狐冲"];
    [_dataArr addObject:@"小龙女"];
    [_dataArr addObject:@"胡斐"];
    [_dataArr addObject:@"水笙"];
    [_dataArr addObject:@"任盈盈"];
    [_dataArr addObject:@"白琇"];
    [_dataArr addObject:@"狄云"];
    [_dataArr addObject:@"石破天"];
    [_dataArr addObject:@"殷素素"];
    [_dataArr addObject:@"张翠山"];
    [_dataArr addObject:@"张无忌"];
    [_dataArr addObject:@"青青"];
    [_dataArr addObject:@"袁冠南"];
    [_dataArr addObject:@"萧中慧"];
    [_dataArr addObject:@"袁承志"];
    [_dataArr addObject:@"乔峰"];
    [_dataArr addObject:@"王语嫣"];
    [_dataArr addObject:@"段玉"];
    [_dataArr addObject:@"虚竹"];
    [_dataArr addObject:@"苏星河"];
    [_dataArr addObject:@"丁春秋"];
    [_dataArr addObject:@"庄聚贤"];
    [_dataArr addObject:@"阿紫"];
    [_dataArr addObject:@"阿朱"];
    [_dataArr addObject:@"阿碧"];
    [_dataArr addObject:@"鸠魔智"];
    [_dataArr addObject:@"萧远山"];
    [_dataArr addObject:@"慕容复"];
    [_dataArr addObject:@"慕容博"];
    [_dataArr addObject:@"Jim"];
    [_dataArr addObject:@"Lily"];
    [_dataArr addObject:@"Ethan"];
    [_dataArr addObject:@"Green小"];
    [_dataArr addObject:@"Green大"];
    [_dataArr addObject:@"DavidSmall"];
    [_dataArr addObject:@"DavidBig"];
    [_dataArr addObject:@"James"];
    [_dataArr addObject:@"Kobe Brand"];
    [_dataArr addObject:@"Kobe Crand"];
    
    
    self.sortedArrForArrays = [self getChineseStringArr:_dataArr];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [[self.sortedArrForArrays objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sortedArrForArrays count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionHeadsKeys objectAtIndex:section];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return self.sectionHeadsKeys;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
    }
    if ([self.sortedArrForArrays count] > indexPath.section) {
        NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
            cell.textLabel.text = str.string;
        } else {
            NSLog(@"arr out of range");
        }
    } else {
        NSLog(@"sortedArrForArrays out of range");
    }
        
    return cell;
}

- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=[NSString stringWithString:[arrToSort objectAtIndex:i]];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
        [chineseString release];
    }
    
    //sort the ChineseStringArr by pinYin 
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;

    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[[NSMutableArray alloc] initWithObjects:nil] autorelease];
            checkValueAtIndex = NO;
        }
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
           [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}

@end
*/