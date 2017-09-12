//
//  EventViewController.m
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/9/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController (){
    UIDatePicker *datePicker;
    UITextField *currentTextField;
    UITextField *titleTextField;
    UITextField *startDateTextField;
    UITextField *endDateTextField;
    UIButton *rightButton;
}

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-15];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setYear:+15];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate  options:0];
   
    datePicker = [[UIDatePicker alloc]init];
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    
    // Do any additional setup after loading the view.
    
    rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setTitle:@"Save" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [rightButton addTarget:self action:@selector(saveEventAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *btnDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteEvent)];
    
    if (self.isShowToDetailEvent) {
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBarButton,btnDelete, nil]];
        [rightButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else{
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    

}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([rightButton.titleLabel.text isEqualToString:@"Edit"]) {
        [self setTextFieldEditable:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Data Source / Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    headerView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width-20, 25)];
    label.font = [UIFont fontWithName:@"Helvetica" size:14];
    
    if (section == 0) {
        label.text = @"Title";
    }
    else if (section == 1) {
        label.text = @"Event Date";
    }
    
    [headerView addSubview:label];
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        // If the cell is nil, then dequeue it. Make sure to dequeue the proper cell based on the row.
        if (cell == nil) {
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellEventTitle"];
            }
        }
        titleTextField = (UITextField *)[cell.contentView viewWithTag:10];
        titleTextField.delegate = self;
        titleTextField.text = self.event.title;
    }
    else if (indexPath.section == 1){
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellDate"];
        }
        switch (indexPath.row) {
            case 0:
                
                 ((UILabel *)[cell.contentView viewWithTag:12]).text = @"Start Date";
                // The event start date.
                if (self.event.startDate == nil) {
                   startDateTextField = (UITextField *)[cell.contentView viewWithTag:11];
                    startDateTextField.inputView = datePicker;
                    startDateTextField.placeholder = @"Start Date";
                }
                else{
                    startDateTextField = (UITextField *)[cell.contentView viewWithTag:11];
                    startDateTextField.text = [self getStringFromDate:self.event.startDate];
                }
                break;
                
            case 1:
                
                ((UILabel *)[cell.contentView viewWithTag:12]).text = @"End Date";
                // The event end date.
                if (self.event.endDate == nil) {
                    endDateTextField = (UITextField *)[cell.contentView viewWithTag:11];
                    endDateTextField.inputView = datePicker;
                    endDateTextField.placeholder = @"End Date";
                }
                else{
                    endDateTextField = (UITextField *)[cell.contentView viewWithTag:11];
                    endDateTextField.text = [self getStringFromDate:self.event.endDate];
                }
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - Private Methods

-(NSString *)getStringFromDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    [dateFormatter setDateFormat:@"dd MMM yyyy, HH:mm"];
    NSString *stringFromDate = [dateFormatter stringFromDate:date];
    return stringFromDate;
}

-(void) dateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)currentTextField.inputView;
//    [picker setMaximumDate:[NSDate date]];
    NSDate *eventDate = picker.date;
    NSString *dateString = [self getStringFromDate:eventDate];
    currentTextField.text = [NSString stringWithFormat:@"%@",dateString];

}

- (void) saveEventAction:(id)sender {

    if([rightButton.titleLabel.text isEqualToString:@"Edit"]){
        [rightButton setTitle:@"Save" forState:UIControlStateNormal];
        [self setTextFieldEditable:YES];
    }
    else{
        [currentTextField resignFirstResponder];
        // Check if a title was typed in for the event.
        if (titleTextField.text.length == 0) {
            // In this case, just do nothing.
            return;
        }
        // Check if a start and an end date was selected for the event.
        if (startDateTextField.text.length == 0 || endDateTextField.text.length == 0) {
            // In this case, do nothing too.
            return;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMM yyyy, HH:mm"];
        
        [self setEvent:titleTextField.text withStartDate:[dateFormatter dateFromString:startDateTextField.text] withEndDate:[dateFormatter dateFromString:endDateTextField.text] withResecheduling:NO completion:nil];
    }
}

- (void) deleteEvent{
    
    EKEventStore* store = [[EKEventStore alloc] init];
    
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted)
        {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSError *err = nil;
            [store removeEvent:self.event span:EKSpanThisEvent error:&err];
            // NSString *savedEventId = event.eventIdentifier;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Event Deleted" message:@"Event has been deleted in your calendar." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    }];
    
}

-(void)setEvent:(NSString *)title withStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate withResecheduling:(BOOL)rescheduling completion:(void (^)(void))completionBlock
{
    
    EKEventStore* store = [[EKEventStore alloc] init];
    
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted)
        {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = title;
            event.startDate = startDate;
            event.endDate = endDate;
            [event setCalendar:[store defaultCalendarForNewEvents]];
            NSError *err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            // NSString *savedEventId = event.eventIdentifier;
            if (!rescheduling) {
                
                NSString* alertTitle;
                NSString* msg;
                if (err) {
                    
                    alertTitle = @"Calendar was not set";
                    msg = @"Please set default calendar in settings.";
                }
                else
                {
                    alertTitle = @"Event added";
                    msg = @"Event has been added in your calendar.";
                }
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:msg preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }]];
                [self presentViewController:alertController animated:YES completion:nil];

            }
        });
    }];
}

#pragma mark - TextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (startDateTextField == textField) {
        startDateTextField = currentTextField;
    }
    else if(endDateTextField == textField){
        endDateTextField = currentTextField;
    }
    [textField resignFirstResponder];
    [self.view endEditing:YES];
}

- (void) setTextFieldEditable:(BOOL) isEditable{
    
    titleTextField.userInteractionEnabled = isEditable;
    startDateTextField.userInteractionEnabled = isEditable;
    endDateTextField.userInteractionEnabled = isEditable;
}


@end
