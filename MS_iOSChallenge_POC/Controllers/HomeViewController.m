//
//  HomeViewController.m
//  MS_iOSChallenge_POC
//
//  Created by Singh, Vikaskumar on 9/8/17.
//  Copyright © 2017 Singh, Vikaskumar. All rights reserved.
//

#import "HomeViewController.h"
#import <EventKit/EventKit.h>
#import "EventViewController.h"

@interface HomeViewController ()< UITableViewDataSource,UITableViewDelegate,FSCalendarDataSource,FSCalendarDelegate,UIGestureRecognizerDelegate >
{
    void * _KVOContext;
    UIButton *titleButton;
    BOOL isTapped;
    NSMutableDictionary *eventDict;
    EKEvent *selectedEvent;
    BOOL isRowSelected;
    BOOL isTableViewScrolled;
}
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;

@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;

@property (strong, nonatomic) NSCache *cache;
@property (strong, nonatomic) NSCalendar *gregorian;

@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;
@property (strong, nonatomic) NSArray<EKEvent *> *events;



@end


@implementation HomeViewController

#pragma mark - Life cycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isRowSelected = FALSE;
    isTableViewScrolled = FALSE;
    if ([[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        self.calendarHeightConstraint.constant = 400;
    }
    [self setupNavigationTitle];
    
    [self.calendar selectDate:[NSDate date] scrollToDate:YES];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 3;
    [self.calendar addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    // While the scope gesture begin, the pan gesture of tableView should cancel.
    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
    
    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    
    self.calendar.scope = FSCalendarScopeWeek;
    self.calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    self.calendar.placeholderType = FSCalendarPlaceholderTypeNone;
  
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    self.minimumDate = [dateFormatter dateFromString:@"2016-02-03"];
    self.maximumDate = [dateFormatter dateFromString:@"2021-04-10"];
    
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    
//    UIBarButtonItem *weatherBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"weatherIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(pushWeatherView)];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"rain"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(pushWeatherView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *weatherBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = weatherBarButton;
    
}

- (void) viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
     [self loadCalendarEvents];

}

- (void)dealloc
{
    [self.calendar removeObserver:self forKeyPath:@"scope" context:_KVOContext];
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - Action Methods

- (void) setupNavigationTitle {
    
    //Set Navigation Title with button view
    titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 40)];
    [titleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM-yy";
    [titleButton setTitle:[dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;

}

- (void)titleButtonTapped{
    
    isTapped =!isTapped;
    FSCalendarScope selectedScope = FSCalendarScopeMonth;
    if (!isTapped) {
        selectedScope = FSCalendarScopeWeek;
    }
    [self.calendar setScope:selectedScope animated:YES];
}

- (void) pushWeatherView{

    [self performSegueWithIdentifier:@"weatherViewIdentifier" sender:nil];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == _KVOContext) {
//        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
//        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

// Whether scope gesture should begin
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
    if (shouldBegin) {
        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
        switch (self.calendar.scope) {
            case FSCalendarScopeMonth:
                return velocity.y < 0;
            case FSCalendarScopeWeek:
                return velocity.y > 0;
        }
    }
    return shouldBegin;
}

#pragma mark - <FSCalendarDelegate>

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    _calendarHeightConstraint.constant = CGRectGetHeight(bounds);
    [self.view layoutIfNeeded];
}


- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-mm-dd";
    NSLog(@"did select date %@",[dateFormatter stringFromDate:date]);
    
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedDates addObject:[dateFormatter stringFromDate:obj]];
    }];
    NSLog(@"selected dates is %@",selectedDates);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
    
    if ([[eventDict allKeys] containsObject:date]) {
        NSInteger counter = [[eventDict allKeys] indexOfObject:date];
        CGRect sectionRect = [self.tableView rectForSection:counter];
        sectionRect.size.height = self.tableView.frame.size.height;
        [self.tableView scrollRectToVisible:sectionRect animated:YES];
    }
    
}


- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    if (!isTapped) return 0;
    if (!self.events) return 0;
    NSArray<EKEvent *> *events = [self eventsForDate:date];
    return events.count;
}


- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if (!isTapped) return nil;
    if (!self.events) return nil;
    
    NSArray<EKEvent *> *events = [self eventsForDate:date];
    NSMutableArray<UIColor *> *colors = [NSMutableArray arrayWithCapacity:events.count];
    [events enumerateObjectsUsingBlock:^(EKEvent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [colors addObject:[UIColor colorWithCGColor:obj.calendar.CGColor]];
    }];
    return colors.copy;
}


- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM-yy";
    [titleButton setTitle:[dateFormatter stringFromDate:calendar.currentPage] forState:UIControlStateNormal];
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return eventDict.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (eventDict.count>0) {
        NSArray *sortedArray = [eventDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
        return [self eventsForDate:[sortedArray objectAtIndex:section]].count;
    }
    return 0;
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSArray *sortedArray = [eventDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSDate *date= [sortedArray objectAtIndex:indexPath.section];
    
    NSArray *eventArray = [self eventsForDate:date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *startTimeString = [formatter stringFromDate:((EKEvent *)[eventArray objectAtIndex:indexPath.row]).startDate];
    ((UILabel *)[cell viewWithTag:1001]).text = startTimeString;
    
    ((UILabel *)[cell viewWithTag:1002]).text = ((EKEvent *)[eventArray objectAtIndex:indexPath.row]).title;
    
    NSTimeInterval secondsBetween = [((EKEvent *)[eventArray objectAtIndex:indexPath.row]).endDate timeIntervalSinceDate:((EKEvent *)[eventArray objectAtIndex:indexPath.row]).startDate];
    NSInteger hours = secondsBetween/3600;
    ((UILabel *)[cell viewWithTag:1003]).text = [NSString stringWithFormat:@"%ldh",(long)hours];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    isRowSelected = TRUE;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *sortedArray = [eventDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSDate *date= [sortedArray objectAtIndex:indexPath.section];
    [self.calendar selectDate:date scrollToDate:YES];
    NSArray *events =  [self eventsForDate:date];
    selectedEvent = [events objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"eventViewIdentifier" sender:self];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 25)];
    headerView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _tableView.bounds.size.width-15, 25)];
    label.font = [UIFont fontWithName:@"Helvetica" size:13];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE, dd MMM yy";
    
    NSArray *sortedArray = [eventDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSDate *date =[sortedArray objectAtIndex:section];
    label.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    
    [headerView addSubview:label];
    
    return headerView;
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableView){
        isTableViewScrolled = TRUE;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
     NSIndexPath *firstVisibleIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
    NSArray *sortedArray = [eventDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSDate *date =[sortedArray objectAtIndex:firstVisibleIndexPath.section];
    if (isTableViewScrolled) {
         [self.calendar selectDate:date scrollToDate:YES];
    }
    CGRect frame = self.tableView.frame;
    CGFloat currentLocation = scrollView.contentOffset.y;
    
    if (frame.origin.y > currentLocation){
        [self.calendar setScope:FSCalendarScopeWeek animated:YES];
    }
    else if (frame.origin.y < currentLocation){
        
    }
}

#pragma mark - Private methods

- (void)loadCalendarEvents
{
    __weak typeof(self) weakSelf = self;
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        if(granted) {
            NSDate *startDate = self.minimumDate;
            NSDate *endDate = self.maximumDate;
            NSPredicate *fetchCalendarEvents = [store predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
            NSArray<EKEvent *> *eventList = [store eventsMatchingPredicate:fetchCalendarEvents];
            
            [eventList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable event, NSDictionary<NSString *,id> * _Nullable bindings) {
                return event.calendar.subscribed;
            }]];
            
            eventDict = [NSMutableDictionary new];
            for (EKEvent *event in eventList) {
                [eventDict setObject:event forKey:event.startDate];
            }
           
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!weakSelf) return;
                
                NSArray *sortedArray = [eventDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
                int counter;
                for (counter = 0; counter < sortedArray.count; counter++) {
                    
                    NSDate *date = (NSDate *) [sortedArray objectAtIndex:counter];
                    NSTimeInterval nextTimeInterval = [date timeIntervalSinceNow];
                    
                    if(nextTimeInterval >= 0)
                    {
                        NSLog(@"Next event date from today -> %@",date);
                        break;
                    }
                }
                weakSelf.events = eventList;
                [weakSelf.calendar reloadData];
                [self.tableView reloadData];
                
                CGRect sectionRect = [self.tableView rectForSection:counter];
                sectionRect.size.height = self.tableView.frame.size.height;
                [self.tableView scrollRectToVisible:sectionRect animated:NO];
            });
            
        } else {
            
            // Alert
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Permission Error" message:@"Permission of calendar is required for fetching events." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
}

- (NSArray<EKEvent *> *)eventsForDate:(NSDate *)date
{
    NSArray<EKEvent *> *events = [self.cache objectForKey:date];
    if ([events isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSArray<EKEvent *> *filteredEvents = [self.events filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        return [evaluatedObject.occurrenceDate isEqualToDate:date];
    }]];
    if (filteredEvents.count) {
        [self.cache setObject:filteredEvents forKey:date];
    } else {
        [self.cache setObject:[NSNull null] forKey:date];
    }
    return filteredEvents;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"eventViewIdentifier"] && isRowSelected) {
        isRowSelected = FALSE;
        EventViewController *controller = (EventViewController *)segue.destinationViewController;
        controller.event = selectedEvent;
        controller.isShowToDetailEvent = TRUE;
        
    }
}


@end

