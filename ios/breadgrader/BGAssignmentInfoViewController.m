//
//  BGAssignmentInfoViewController.m
//  breadgrader
//
//  Created by Brian Kim on 6/5/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGAssignmentInfoLayout.h"
#import "BGAssignmentInfoViewController.h"

#import "BGGradeInfo.h"
#import "Course+methods.h"
#import "Criteria+methods.h"
#import "Assignment+methods.h"

@interface BGAssignmentInfoViewController ()
@property (weak, nonatomic) UITextField *nameTextField;
@property (weak, nonatomic) UILabel *dateLabel;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (weak, nonatomic) UITextField *receivedTextField;
@property (weak, nonatomic) UITextField *maxTextField;
@property (weak, nonatomic) UITextView *notesTextView;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *due;
@property (nonatomic, strong) NSNumber *received;
@property (nonatomic, strong) NSNumber *max;
@property (nonatomic, strong) NSString *notes;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation BGAssignmentInfoViewController
@synthesize infoLayout = _infoLayout;
@synthesize shareableItem = _shareableItem;

#pragma mark - accesor methods

- (BIShareableItem *)shareableItem
{
    if (!_shareableItem)
    {
        _shareableItem = [[BIShareableItem alloc] initWithTitle: @"breadgrader"];
        _shareableItem.shortDescription = [NSString stringWithFormat: @"I got a %@ for %@ in %@!", self.assignment.grade.stringValue, self.assignment.name, self.assignment.criteria.course.title
                                           ];
        _shareableItem.description = [NSString stringWithFormat: @"Check out breadgrader at %@", breadgradersite];
    }
    return _shareableItem;
}

- (BIInfoLayout *)infoLayout
{
    if (!_infoLayout)
    {
        _infoLayout = [BGAssignmentInfoLayout defaultLayout];
    }
    return _infoLayout;
}

- (UITextField *)nameTextField
{
    if (!_nameTextField)
    {
        _nameTextField = [(BIInfoCell *)[self.tableView cellForRowAtIndexPath: [self.infoLayout indexPathForKey: kAssignmentNameKey]] textField1];
        _nameTextField.delegate = self;
    }
    return _nameTextField;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel)
    {
        _dateLabel = [[self.tableView cellForRowAtIndexPath: [self.infoLayout indexPathForKey: kAssignmentDueDateKey]] detailTextLabel];
    }
    return _dateLabel;
}

- (UITextField *)receivedTextField
{
    if (!_receivedTextField)
    {
        _receivedTextField = [(BIInfoCell *)[self.tableView cellForRowAtIndexPath: [self.infoLayout indexPathForKey: kAssignmentGradeKey]] textField1];
        _receivedTextField.delegate = self;
    }
    return _receivedTextField;
}

- (UITextField *)maxTextField
{
    if (!_maxTextField)
    {
        _maxTextField = [(BIInfoCell *)[self.tableView cellForRowAtIndexPath: [self.infoLayout indexPathForKey: kAssignmentGradeKey]] textField2];
        _maxTextField.delegate = self;
    }
    return _maxTextField;
}

- (UITextView *)notesTextView
{
    if (!_notesTextView)
    {
        _notesTextView = [(BIInfoCell *)[self.tableView cellForRowAtIndexPath: [self.infoLayout indexPathForKey: kAssignmentNotesKey]] textView];
        _notesTextView.delegate = self;
    }
    return _notesTextView;
}

- (NSString *)name
{
    if (!_name)
    {
        _name = self.assignment.name;
    }
    return _name;
}

- (NSDate *)due
{
    if (!_due)
    {
        _due = self.assignment.due;
        if (!_due) _due = [NSDate date];
    }
    return _due;
}

- (NSNumber *)received
{
    if (!_received)
    {
        if (self.assignment.received.floatValue < -0.99)
        {
            return nil;
        }
        else if (self.assignment)
        {
            _received = self.assignment.received;
        }
    }
    return _received;
}

- (NSNumber *)max
{
    if (!_max && self.assignment)
    {
        _max = self.assignment.max;
    }
    return _max;
}

- (NSString *)notes
{
    if (!_notes)
    {
        _notes = self.assignment ? self.assignment.notes : @"\n";
    }
    return _notes;
}

#pragma mark - convenience methods

- (void)setupUI
{
    [super setupUI];
    
    self.title = @"Assignment Info";
    
    self.tl = self.backButton;
    self.tr = self.doneButton;
    self.br = self.deleteButton;

}

- (void)updateModel
{
    if (!(self.nameTextField.text.length > 0))
    {
        self.nameTextField.text = @"";
    }
    
    if (!(self.receivedTextField.text.length > 0))
    {
        self.receivedTextField.text = @"-1";
    }
    if (!(self.maxTextField.text.length > 0))
    {
        self.maxTextField.text = @"100";
    }
    
    if (!(self.notesTextView.text))
    {
        self.notes = @"";
    } else
    {
        self.notes = self.notesTextView.text;
    }
    
    self.name = self.nameTextField.text;
    self.due = [self.dateFormatter dateFromString: self.dateLabel.text];
    self.received = @(self.receivedTextField.text.floatValue);
    self.max = @(self.maxTextField.text.floatValue);
}

- (void)doneButtonPressed:(id)sender
{
    [self updateModel];
    
    NSNumber *didUpdate = @(YES);
    
    NSDictionary *dict = @{ kAssignmentNameKey : self.name,
                            kAssignmentDueDateKey : self.due,
                            kAssignmentReceivedGradeKey : self.received,
                            kAssignmentMaxGradeKey : self.max,
                            kAssignmentNotesKey : self.notes,
                            kAssignmentDidUpdateKey : didUpdate
                            };
    
    [self.delegate infoViewController: self didSaveWithInfo: dict];
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)updateUI
{
    self.nameTextField.text = self.name;
    self.dateLabel.text = [self.dateFormatter stringFromDate: self.due];
    [[self.tableView cellForRowAtIndexPath: [self.infoLayout indexPathForKey: kAssignmentDueDateKey]] setNeedsLayout];
    
    self.receivedTextField.text = self.received.stringValue;
    self.maxTextField.text = self.max.stringValue;
    
    self.notesTextView.text = self.notes;
    
    CGRect newFrame = self.notesTextView.frame;
    newFrame.size.height = self.notesTextView.contentSize.height;
    self.notesTextView.frame = newFrame;
    
    [super updateUI];
}

#pragma mark - date stuff

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self toggleDatePicker: self.datePicker turnOn: NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self toggleDatePicker: self.datePicker turnOn: NO];
}

- (void)wantsToPickValueForCellAtIndexPath:(NSIndexPath *)ip
{
    if ([self.infoLayout indexPathForKey: kAssignmentDueDateKey])
    {
        [self toggleDatePicker: self.datePicker turnOn: YES];
    }
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    self.due = datePicker.date;
    [self updateUI];
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
    }
    return _dateFormatter;
}

#pragma mark - uitablevc methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat ret;
    if ( [indexPath isEqual: [self.infoLayout indexPathForKey: kAssignmentNotesKey]] && _notesTextView)
    {
        ret = self.notesTextView.contentSize.height + 20;
    }
    else
        ret = self.tableView.rowHeight;
    return ret;
}

#pragma mark - uivc lifecycle

- (void)textViewDidChange:(UITextView *)textView
{
    self.notes = textView.text;
    [self.tableView beginUpdates];
    [self updateUI];
    [self.tableView endUpdates];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self updateUI];
}
#pragma mark - delete management

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *s = [alertView buttonTitleAtIndex: buttonIndex];
    if ([s isEqualToString: @"Delete"]) [self trash];
}


- (void)trash
{
    [self.assignment.criteria removeAssignmentsObject: self.assignment];
    [self.assignment.managedObjectContext deleteObject: self.assignment];
    [self.assignment.managedObjectContext save: nil];
    [self.navigationController popViewControllerAnimated: YES];
}

@end
