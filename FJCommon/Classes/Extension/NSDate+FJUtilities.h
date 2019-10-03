/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

#define FJ_MINUTE	60
#define FJ_HOUR		3600
#define FJ_DAY		86400
#define FJ_WEEK		604800
#define FJ_YEAR		31556926

@interface NSDate (FJUtilities)
+ (NSCalendar *) currentCalendar; // avoid bottlenecks

// Relative dates from the current date
+ (NSDate *) fj_dateTomorrow;
+ (NSDate *) fj_dateYesterday;
+ (NSDate *) fj_dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) fj_dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) fj_dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) fj_dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) fj_dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) fj_dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Short string utilities
- (NSString *) fj_stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;
- (NSString *) fj_stringWithFormat: (NSString *) format;
@property (nonatomic, readonly) NSString *fj_shortString;
@property (nonatomic, readonly) NSString *fj_shortDateString;
@property (nonatomic, readonly) NSString *fj_shortTimeString;
@property (nonatomic, readonly) NSString *fj_mediumString;
@property (nonatomic, readonly) NSString *fj_mediumDateString;
@property (nonatomic, readonly) NSString *fj_mediumTimeString;
@property (nonatomic, readonly) NSString *fj_longString;
@property (nonatomic, readonly) NSString *fj_longDateString;
@property (nonatomic, readonly) NSString *fj_longTimeString;

// Comparing dates
- (BOOL) fj_isEqualToDateIgnoringTime: (NSDate *) aDate;

- (BOOL) fj_isToday;
- (BOOL) fj_isTomorrow;
- (BOOL) fj_isYesterday;

- (BOOL) fj_isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) fj_isThisWeek;
- (BOOL) fj_isNextWeek;
- (BOOL) fj_isLastWeek;

- (BOOL) fj_isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) fj_isThisMonth;
- (BOOL) fj_isNextMonth;
- (BOOL) fj_isLastMonth;

- (BOOL) fj_isSameYearAsDate: (NSDate *) aDate;
- (BOOL) fj_isThisYear;
- (BOOL) fj_isNextYear;
- (BOOL) fj_isLastYear;

- (BOOL) fj_isEarlierThanDate: (NSDate *) aDate;
- (BOOL) fj_isLaterThanDate: (NSDate *) aDate;

- (BOOL) fj_isInFuture;
- (BOOL) fj_isInPast;

// Date roles
- (BOOL) fj_isTypicallyWorkday;
- (BOOL) fj_isTypicallyWeekend;

// Adjusting dates
- (NSDate *) fj_dateByAddingYears: (NSInteger) dYears;
- (NSDate *) fj_dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *) fj_dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) fj_dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *) fj_dateByAddingDays: (NSInteger) dDays;
- (NSDate *) fj_dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) fj_dateByAddingHours: (NSInteger) dHours;
- (NSDate *) fj_dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) fj_dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) fj_dateBySubtractingMinutes: (NSInteger) dMinutes;

// Date extremes
- (NSDate *) fj_dateAtStartOfDay;
- (NSDate *) fj_dateAtEndOfDay;

// Retrieving intervals
- (NSInteger) fj_minutesAfterDate: (NSDate *) aDate;
- (NSInteger) fj_minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) fj_hoursAfterDate: (NSDate *) aDate;
- (NSInteger) fj_hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) fj_daysAfterDate: (NSDate *) aDate;
- (NSInteger) fj_daysBeforeDate: (NSDate *) aDate;
- (NSInteger) fj_distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger fj_nearestHour;
@property (readonly) NSInteger fj_hour;
@property (readonly) NSInteger fj_minute;
@property (readonly) NSInteger fj_seconds;
@property (readonly) NSInteger fj_day;
@property (readonly) NSInteger fj_month;
@property (readonly) NSInteger fj_week;
@property (readonly) NSInteger fj_weekday;
@property (readonly) NSInteger fj_nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger fj_year;
@end
