//
//  ViewController.m
//  SampleAppClient
//
//  Created by James Wang on 1/17/14.
//  Copyright (c) 2014 James Wang. All rights reserved.
//

#import "IndexViewController.h"
#import "ResponseContentViewController.h"

@interface IndexViewController ()
@property (weak, nonatomic) IBOutlet UITextField *url;
@property (weak, nonatomic) IBOutlet UITextField *callTimes;

@end

@implementation IndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initFieldValues];
}

- (void) initFieldValues
{
    self.url.text = @"http://10.8.255.210:8080/javaee-sample/jdbcandjmsqueue";
    self.callTimes.text = @"1";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSMutableArray * contents = [self visitUrl];
    ResponseContentViewController *dvc = [segue destinationViewController];
    dvc.contents = contents;
}

- (NSMutableArray *)visitUrl
{
    int callTimes = [self.callTimes.text intValue];
    NSMutableArray *contents = [NSMutableArray new];
    
    for (int i = 0; i < callTimes; i++)
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url.text]];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (content != nil)
        {
            [contents addObject:content];
        }
    }
    
    return contents;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.callTimes resignFirstResponder];
}

@end