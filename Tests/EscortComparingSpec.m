#import "Kiwi.h"
#import "NSDate+Escort.h"
#import "FakeDateUtil.h"
#import "NSDate+AZDateBuilder.h"

SPEC_BEGIN(EscortComparingSpec)
    registerMatchers(@"AZ");// NSDate Custom Matcher
    describe(@"-isEqualToDateIgnoringTime", ^{
        NSDate *currentDate = [NSDate date];
        beforeEach(^{
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when same the date", ^{
            it(@"should be true", ^{
                BOOL isMatch = [currentDate isEqualToDateIgnoringTime:currentDate];
                [[theValue(isMatch) should] beYes];
            });

        });
        context(@"when target is today", ^{
            it(@"should be true", ^{
                NSDate *beginOfDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                NSDate *endOfDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.hour : @23,
                    AZ_DateUnit.minute : @59,
                    AZ_DateUnit.second : @59,
                }];
                BOOL isMatch_begin = [beginOfDate isEqualToDateIgnoringTime:currentDate];
                BOOL isMatch_end = [endOfDate isEqualToDateIgnoringTime:currentDate];
                [[theValue(isMatch_begin) should] beYes];
                [[theValue(isMatch_end) should] beYes];
            });
        });
        context(@"when target is a later day", ^{
            it(@"should be false", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] + 1),
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                BOOL isMatch = [laterDate isEqualToDateIgnoringTime:currentDate];
                [[theValue(isMatch) should] beNo];
            });
        });
        context(@"when target is a earler day", ^{
            it(@"should be false", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] - 1),
                    AZ_DateUnit.hour : @23,
                    AZ_DateUnit.minute : @59,
                    AZ_DateUnit.second : @59,
                }];
                BOOL isMatch = [laterDate isEqualToDateIgnoringTime:currentDate];
                [[theValue(isMatch) should] beNo];
            });
        });
    });
    describe(@"-isToday", ^{
        NSDate *currentDate = [NSDate date];
        beforeEach(^{
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when suject is same date", ^{
            it(@"should be true", ^{
                BOOL match = [currentDate isToday];
                [[theValue(match) should] beYes];
            });
        });
        context(@"when subject is a later day", ^{
            it(@"should be false", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] + 1),
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                BOOL isMatch = [laterDate isToday];
                [[theValue(isMatch) should] beNo];
            });
        });
        context(@"when subject is a earler day", ^{
            it(@"should be false", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] - 1),
                    AZ_DateUnit.hour : @23,
                    AZ_DateUnit.minute : @59,
                    AZ_DateUnit.second : @59,
                }];
                BOOL isMatch = [laterDate isToday];
                [[theValue(isMatch) should] beNo];
            });
        });
    });
    describe(@"-isTomorrow", ^{
        NSDate *currentDate = [NSDate date];
        beforeEach(^{
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when suject is same date", ^{
            it(@"should be false", ^{
                BOOL match = [currentDate isTomorrow];
                [[theValue(match) should] beNo];
            });
        });
        context(@"when subject is a tomorrow", ^{
            it(@"should be true", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] + 1),
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                BOOL isMatch = [laterDate isTomorrow];
                [[theValue(isMatch) should] beYes];
            });
        });
        context(@"when subject is 2day later", ^{
            it(@"should be false", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] + 2),
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                BOOL isMatch = [laterDate isTomorrow];
                [[theValue(isMatch) should] beNo];
            });
        });
    });
    describe(@"-isYesterday", ^{
        NSDate *currentDate = [NSDate date];
        beforeEach(^{
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when suject is same date", ^{
            it(@"should be false", ^{
                BOOL match = [currentDate isYesterday];
                [[theValue(match) should] beNo];
            });
        });
        context(@"when subject is a yesterday", ^{
            it(@"should be true", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] - 1),
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                BOOL isMatch = [laterDate isYesterday];
                [[theValue(isMatch) should] beYes];
            });
        });
        context(@"when subject is 2day ago", ^{
            it(@"should be false", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] - 2),
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                BOOL isMatch = [laterDate isYesterday];
                [[theValue(isMatch) should] beNo];
            });
        });
    });
    describe(@"-isSameWeekAsDate", ^{
        context(@"when suject is 2010-10-10(Sun)", ^{
            __block NSDate *currentDate;
            beforeEach(^{
                currentDate = [NSDate dateByUnit:@{
                    AZ_DateUnit.year : @2010,
                    AZ_DateUnit.month : @10,
                    AZ_DateUnit.day : @9,
                }];
                [FakeDateUtil stubCurrentDate:currentDate];
            });
            context(@"same week", ^{
                it(@"should be true", ^{
                    BOOL match = [currentDate isSameWeekAsDate:currentDate];
                    [[theValue(match) should] beYes];
                });
            });
            context(@"within the week", ^{
                context(@"firstOfWeek", ^{
                    it(@"should be true", ^{
                        // weekday 1...7
                        NSDate *firstOfWeek = [currentDate dateByUnit:@{
                            AZ_DateUnit.day : @([currentDate firstDayOfWeekday])
                        }];
                        BOOL match_first = [firstOfWeek isSameWeekAsDate:currentDate];
                        [[theValue(match_first) should] beYes];
                    });
                });
                context(@"lastOfWeek", ^{
                    it(@"should be true", ^{
                        NSDate *lastOfWeek = [currentDate dateByUnit:@{
                            AZ_DateUnit.day : @([currentDate firstDayOfWeekday])
                        }];
                        BOOL match_last = [lastOfWeek isSameWeekAsDate:currentDate];
                        [[theValue(match_last) should] beYes];
                    });
                });
            });
            context(@"next week", ^{
                NSDate *nextWeekDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.week : @([currentDate week] + 1)
                }];
                it(@"should be false", ^{
                    BOOL match = [nextWeekDate isSameWeekAsDate:currentDate];
                    [[theValue(match) should] beNo];
                });
            });
            context(@"previous week", ^{
                NSDate *nextWeekDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.week : @([currentDate week] - 1)
                }];
                it(@"should be false", ^{
                    BOOL match = [nextWeekDate isSameWeekAsDate:currentDate];
                    [[theValue(match) should] beNo];
                });
            });
        });
    });
    SPEC_END
