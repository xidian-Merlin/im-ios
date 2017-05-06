//
//  ViewController.m
//  静态列表——编辑资料
//
//  Created by Rannie on 13-9-4.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import "ThirdViewController.h"
#import "EditViewController.h"
#import "Person.h"
#import "InfoViewController.h"

#define rTableSectionCount 1

@interface ThirdViewController () <EditViewControllerDelegate, InfoViewControllerDelegate, UISearchDisplayDelegate>
{
    InfoViewController *_infoVC;
    
    NSMutableArray *_personList;
    NSMutableArray *_resultList;
    
    NSInteger _personIndex;
    NSInteger _resultIndex;
}

@end

@implementation ThirdViewController

#pragma mark -
#pragma mark File Method

- (NSString *)pathForPersonList
{
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documents[0] stringByAppendingPathComponent:@"person.plist"];
    
    return path;
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    NSLog(@"view did load");
    [super viewDidLoad];
    
    NSString *path = [self pathForPersonList];
    _personList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return _resultList.count;
    }
    else
    {
        return _personList.count;   
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return rTableSectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"PersonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Person *p;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        p = _resultList[indexPath.row];
    }
    else
    {
        p = _personList[indexPath.row];
    }

    cell.textLabel.text = p.name;
    cell.detailTextLabel.text = p.signature;
    cell.imageView.image = p.headerImage;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *person;
    if (tableView == self.tableView)
    {
        person = _personList[indexPath.row];
        _infoVC.person = person;
        _personIndex = indexPath.row;
    }
    else
    {
        [self performSegueWithIdentifier:@"InfoSegue" sender:nil];
        person = _resultList[indexPath.row];
        _infoVC.person = person;
        _personIndex = [_personList indexOfObject:person];
        _resultIndex = indexPath.row;
    }
}

#pragma mark -
#pragma mark EditVC DelegateMethod

- (void)sendAddPerson:(Person *)person
{
    if (!_personList)
    {
        _personList = [NSMutableArray array];
    }
    
    [_personList addObject:person];
    [self.tableView reloadData];
    
    NSString *path = [self pathForPersonList];
    [NSKeyedArchiver archiveRootObject:_personList toFile:path];
}

- (void)refreshPersonData:(Person *)personData
{
    [_personList removeObjectAtIndex:_personIndex];
    [_personList insertObject:personData atIndex:_personIndex];
    [_resultList removeObjectAtIndex:_resultIndex];
    [_resultList insertObject:personData atIndex:_resultIndex];
    
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self.tableView reloadData];
    
    NSString *path = [self pathForPersonList];
    [NSKeyedArchiver archiveRootObject:_personList toFile:path];
}

#pragma mark -
#pragma mark Stroyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddSegue"])
    {
        EditViewController *evc = (EditViewController *)segue.destinationViewController;
        evc.editDelegate = self;
    }
    if ([segue.identifier isEqualToString:@"InfoSegue"])
    {
        _infoVC = (InfoViewController *)segue.destinationViewController;
        _infoVC.infoDelegate = self;
    }
}

#pragma mark -
#pragma mark Search Method

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[c] %@", searchString];
    
    if (_resultList)
    {
        [_resultList removeAllObjects];
    }
    
    _resultList = [NSMutableArray arrayWithArray:[_personList filteredArrayUsingPredicate:predicate]];
    
    return YES;
}

@end
