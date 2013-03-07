//
//  CDWPlayerViewModel.m
//  MVVM IOS Example
//
//  Created by Colin Wheeler on 3/4/13.
//  Copyright (c) 2013 Colin Wheeler. All rights reserved.
//

#import "CDWPlayerViewModel.h"

@interface CDWPlayerViewModel ()
@property(nonatomic, retain) NSArray *forbiddenNames;
@property(nonatomic, readwrite) NSUInteger maxPointUpdates;
@end

@implementation CDWPlayerViewModel

-(id)init {
	self = [super init];
	if(!self) return nil;
	
	_playerName = @"Colin";
	_points = 100.0;
	_stepAmount = 1.0;
	_maxPoints = 10000.0;
	_minPoints = 0.0;

	_maxPointUpdates = 10;
	
	//I guess we'll go with the ned flanders bad words
	//change this to whatever you want
	_forbiddenNames = @[ @"dag nabbit",
					  @"darn",
					  @"poop"
					  ];

	return self;
}

-(IBAction)resetToDefaults:(id)sender {
	self.playerName = @"Colin";
	self.points = 100.0;
	self.stepAmount = 1.0;
	self.maxPoints = 10000.0;
	self.minPoints = 0.0;
	self.maxPointUpdates = 10;
	self.forbiddenNames = @[ @"dag nabbit",
						  @"darn",
						  @"poop"
						  ];
}

-(IBAction)uploadData:(id)sender {
	[[RACScheduler scheduler] schedule:^{
		sleep(1);
		//pretend we are uploading to a server on a backround thread...
		//dont ever put sleep in your code
		//upload player & points...
		
		[[RACScheduler mainThreadScheduler] schedule:^{
			NSString *msg = [NSString stringWithFormat:@"Updated %@ with %.0f points",self.playerName,self.points];
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Successfull" message:msg delegate:self
												  cancelButtonTitle:@"ok" otherButtonTitles:nil];
			[alert show];
		}];
	}];
}

-(RACSignal *)forbiddenNameSignal {
	return [RACAble(self.playerName) filter:^BOOL(NSString *newName) {
		return [self.forbiddenNames containsObject:newName];
	}];
}

-(RACSignal *)modelIsValidSignal {
	__block CDWPlayerViewModel *bself = self;
	return [RACSignal
			combineLatest:@[ RACAbleWithStart(self.playerName), RACAbleWithStart(self.points) ]
			reduce:^id(NSString *name, NSNumber *playerPoints){
				return @((name.length > 0) && (![bself.forbiddenNames containsObject:name]) && (playerPoints.doubleValue >= bself.minPoints));
			}];
}

@end
