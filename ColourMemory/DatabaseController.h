//
//  DatabaseController.h
//  ColourMemory
//
//  Created by OsamaMac on 9/1/14.
//  Copyright (c) 2014 Osama Rabie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseController : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSMutableData* responseData;// This is used to apped the data returned by the server. The thing is, sometimes if the data is too big, the server sends it as chunks, then we need to store it locally until it is all done so we can process it.
    NSURLConnection* updateConnection; // This is used to contact the server and asks to sync me. It will be post data as also i have first to post to server what data i have in here.
}


/**
 This method to be called by the controller when he wants to make sure that the database with along the columns are stored locally.
 **/
-(void)createDatabaseIfNotExists;

/**
 This method to be called by the controller when he wants to get the top 10 scores the user achieved till now.
 **/
-(NSMutableArray*)loadTopTenScores;

/**
 This method to be called by the controller when he wants to insert new score record locally.
 **/
-(void)insertNewScoredRecord:(int)score;


/**
This method to be called by the controller when he wants to sync between the local stored DB and between the online one. It checks first if the app is connected, then it loads data from the server async.
 The server replies in the data in JSON format.
 Then it notifies the contoller DB is synced.**/
-(void)syncLocalWithOnlineDB;

@end
