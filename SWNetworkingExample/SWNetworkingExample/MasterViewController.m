//
//  MasterViewController.m
//  Example
//
//  Created by Saman Kumara on 7/6/15.
//  Copyright (c) 2015 Saman Kumara. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()<UITableViewDelegate>

@property NSArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    
    self.objects = @[@{@"GET" : @[@"Simple Get", @"With response Type", @"With Loading View", @"With parameter", @"With Cache Data"]}, @{@"POST" : @[@"Simple Post", @"With Multipart"]}, @{@"PUT" : @[@"Simple Put"]}, @{@"PATCH" : @[@"Simple Patch"]}, @{@"DELETE" : @[@"Simple Delete"]}, @{@"HEAD" : @[@"Simple Head"]}, @{@"Session": @[@"Downlod file task", @"Upload file Task", @"Download Data task", @"Set Download progress", @"Set Upload progress"]}, @{@"Feataures" : @[@"Auto Loading View", @"Download Progress", @"Upload progress", @"Custom Header", @"Custom Content Type", @"Custom time out", @"Offline request", @"Response Encoding", @"Access Cache Data", @"UIImageView with url", @"Network availability", @"Multiple Opearations", @"Download Progress with UIProgressView", @"Upload Progress with UIProgressView", @"Session Maneger with Dowload progress", @"Session Maneger with Upload progress", ]}];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //[[[segue destinationViewController] detailDescriptionLabel] setText:[[[self.objects objectAtIndex:indexPath.section] objectForKey:[[[self.objects objectAtIndex:indexPath.section]allKeys] objectAtIndex:0]] objectAtIndex:indexPath.row]];
        [[segue destinationViewController] setDetailItem:indexPath];
    }
}

#pragma mark - Table View

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[[self.objects objectAtIndex:section]allKeys] objectAtIndex:0];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.objects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.objects objectAtIndex:section] objectForKey:[[[self.objects objectAtIndex:section]allKeys] objectAtIndex:0]]count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [[[self.objects objectAtIndex:indexPath.section] objectForKey:[[[self.objects objectAtIndex:indexPath.section]allKeys] objectAtIndex:0]] objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


@end
