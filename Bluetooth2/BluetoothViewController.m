//
//  BluetoothViewController.m
//  Bluetooth1
//
//  Created by Gurupur Sushma Pai & Aparna Srinivasan on 2/19/13.
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.
//
#import "BluetoothViewController.h"
#import <GameKit/GameKit.h>
#include <stdlib.h>
#import "GameScoreViewController.h"
#import "HelpViewController.h"
#import "OptionsViewController.h"
#import "ScoreViewController.h"
#import "gameView.h"


@implementation BluetoothViewController

// Generates setter and getter methods.
@synthesize currentSession,
            game,
            gkpeerId,
            totalLives,
            gameTime,
            gameScore,
            minesLeft;

//bluetooth message types to send across the network
const int gkCoinToss=0;
const int gkMovePeer =1;
const int gkChangeTurnScore =2;
const int gkPeerMines =3;
const int gkPeerDeath= 4;
const int gkGameOver= 5;
const int gkGoldPick=6;



GKPeerPickerController *picker;


- (void)peerPickerController:(GKPeerPickerController *)picker
              didConnectPeer:(NSString *)peerID
                   toSession:(GKSession *) session {
    //displays a list of all iOS devices to which a user can connect
    self.currentSession = session;
    session.delegate = self;
    self.gkpeerId=peerID;
    NSLog(@"peerId: %@",gkpeerId);
    [session setDataReceiveHandler:self withContext:NULL];
    picker.delegate = nil;
    
    [picker dismiss];
    
    [self coinToss];
      }
-(void)startGame
{
    //start the play by calling the subview:gameView
    CGRect gameScreen = CGRectMake(0, 60, 480, 260);
    game=[[gameView alloc]initWithFrame:gameScreen andLabel:gameTime andScore:gameScore andLives:totalLives andMines:minesLeft andDelegate:self];
    [self.view addSubview:game];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    //if the selected peer cancelled the request
    picker.delegate = nil;
    [self disconnectSession];
    
}


//shows if a connection was established or not
- (void)session:(GKSession *)session
           peer:(NSString *)peerID
 didChangeState:(GKPeerConnectionState)state {
    switch (state)
    {
        case GKPeerStateConnected:
            NSLog(@"connection established");
            break;
        case GKPeerStateDisconnected:
        {
            NSLog(@"could not connect");//chk if this causes problem at start  of connection
            //currentSession=nil;
            //[self disconnectSession];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case GKPeerStateAvailable:
        case GKPeerStateConnecting:
        case GKPeerStateUnavailable:
            break;
    }
}
//to send data between the devices of the form NSData
- (void) mySendDataToPeers:(NSData *) data
{
    //if (currentSession)
        [self.currentSession sendDataToAllPeers:data
                                   withDataMode:GKSendDataReliable
                                          error:nil];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
//view methods and aautorotation

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [picker show];
    opponentScore=0;
   
}
-(void)viewDidAppear:(BOOL)animated
{
   // [NSTimer scheduledTimerWithTimeInterval:200 target:self selector:@selector(disconnectSession) userInfo:nil repeats:NO];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}
//to  receive data sent by the opponent/device to which bluetooth is established. 
- (void) receiveData:(NSData *)data
            fromPeer:(NSString *)peer
           inSession:(GKSession *)session
             context:(void *)context
{
    
    int len;
    len=[data length];
    //getting the messageType to classify the incoming messages;since we are sending this as an integer, we get a subset of
    //the incoming packet with 4 bytes range and check it for the message type being sent
    NSRange range={0,4};
    NSData *incomingPacketData = [data subdataWithRange:range];
    const char *incomingPkt=(const char *)[incomingPacketData bytes];
    
     int messageRx = *(int *)incomingPkt;
    
    
    //NSLog(@"message type %d",messageRx);
    //to filter the rest of the information in the packet
    NSRange range1={4,len-4};
    NSData *incomingMsgData=[data subdataWithRange:range1];
    const char *incomingMsg=(const char *)[incomingMsgData bytes];
    switch (messageRx)
    {
        
        case gkCoinToss:
        {
          //this message sends the random number generaetd by peer which is compared with the current user's random number
        //to determine who should play first or who won the coin toss to play first
            int peerRandNo=*(int *)(incomingMsg);
            if(myRandNo>peerRandNo)
            {
                //shows its the player's turn
                NSLog(@"Its your turn to play");
                NSLog(@"Wait...%d :%d",myRandNo,peerRandNo);

                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Turn" message:@"It is your turn to play now" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
                [self startGame];
            }            
            else if(myRandNo==peerRandNo)
            {
                //happens when the random number generated by both players are same
                NSLog(@"Wait...%d :%d",myRandNo,peerRandNo);
                //coinToss called again to resolve this conflict
                [self coinToss];
                return;
            }
            else
            {
                //shows that the turn is opponent's
                NSLog(@"Its the opponent's turn: Wait");
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Turn" message:@"It is the opponent's turn: Wait" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
                
                [self startGame];
                [game turnChange];

            }
            //calls the method to start the play
            
            break;
        }
        case gkMovePeer:
        {
            //to indicate that the peer moved and traces the path taken by the peer
            CGPoint receivePoint=*(CGPoint *)(incomingMsg);
            //NSLog(@"CGpoints %f %f",receivePoint.x,receivePoint.y);
            //call the opponentMove method in gameView to outline this path to current player
            [game opponentMove:receivePoint];
            break;
        }
        case gkChangeTurnScore:
        {
            //to enable the players to switch turns
            int temp=*(int *)(incomingMsg);
            opponentScore=temp;
            //NSLog(@"Change of turn ; enabling peer's turn %d",opponentScore);
            
            [game enableView];
            break;
        }
        case gkPeerMines:
        {
            //to indicate the locations where the peer placed a mine so that we can detect when the current player steps on it and he should be killed
            CGPoint point=*(CGPoint *)(incomingMsg);
            [game addOpponentMinePosition:point];
            break;
        }
        case gkPeerDeath:
        {
            //when a peer dies that position along with the gold value he took in this turn should be made visible to current player
            NSRange range2={0,8};
            NSData *incomingMsgData1=[incomingMsgData subdataWithRange:range2];
            const char *incomingMsg1=(const char *)[incomingMsgData1 bytes];
            CGPoint point=*(CGPoint *)(incomingMsg1);
            NSRange range3={8,4};
            NSData *incomingMsgData2=[incomingMsgData subdataWithRange:range3];
            const char *incomingMsg2=(const char *)[incomingMsgData2 bytes];
            int goldValue=*(int *)(incomingMsg2);
            NSRange range4={12,4};
            NSData *incomingMsgData3=[incomingMsgData subdataWithRange:range4];
            const char *incomingMsg3=(const char *)[incomingMsgData3 bytes];
            NSLog(@"inside oppo death %d",opponentScore);
            opponentScore=*(int *)(incomingMsg3);

            [game displayPeerDeath:point value:goldValue];
            break;
        }
        case gkGameOver:
        {
            //call to end the game
            int temp=*(int *)(incomingMsg);
            opponentScore=temp;
            NSLog(@"final scor %d",opponentScore);
            [self gameEnd];
            break;
        }
        case gkGoldPick:
        {
            //to indicate the position from where a player picked gold along with the label indicating if the label's value should be hidden or not
            NSRange range2={0,8};
            int lengthMsg=[incomingMsgData length];
            NSData *incomingMsgData1=[incomingMsgData subdataWithRange:range2];
            const char *incomingMsg1=(const char *)[incomingMsgData1 bytes];
            CGPoint point=*(CGPoint *)(incomingMsg1);
            NSRange range3={8,lengthMsg-8};
            NSData *incomingMsgData2=[incomingMsgData subdataWithRange:range3];
            const char *incomingMsg2=(const char *)[incomingMsgData2 bytes];
            bool boolVal=*(BOOL *)(incomingMsg2);
            [game goldDisappear:point withVal:boolVal];
            break;
        }
    }
       
    }

-(void)callToScoreView
{
    //method to push the gameScores into a new view controller
        UIStoryboard *storyboard = self.storyboard;
    GameScoreViewController *gamevc = [storyboard instantiateViewControllerWithIdentifier:@"gscoreVC"];
    NSLog(@"opponent score is %d",opponentScore);
    int yourScore = gameScore.text.integerValue;
    //the persona score and the opponent's score passed along to score view controller
   // [self.currentSession disconnectFromAllPeers];

    [self presentViewController:gamevc animated:YES completion:nil];
    [gamevc passScores:yourScore peerScore:opponentScore];
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)gameEnd
{
    //alert the player about game comin to an end
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Game Over" message:@"Game is over.Click here to view scores" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag=2;
    
    [alert show];
   
    
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2) {
        [self callToScoreView];
    }

    
}
-(void) displayScoreView:(gameView *)gameScreen andFinalScore:(int) finalScore
{
    //called using the delegate from gameView when player loses all three lives and this should be communicated to the peer
    NSMutableData *data1,*data2;
    int messageType = gkGameOver;
    
    data1 = [NSMutableData dataWithBytes:&messageType length:sizeof(int)];
    data2=[NSMutableData dataWithBytes:&finalScore length:sizeof(int)];
    [data1 appendData:data2];
       [self mySendDataToPeers:data1];
    //sleep(5);
    
    [self callToScoreView];
    
}
-(void) peerMoveDone:(gameView *)gameScreen score:(int)myscore
{
    //called using the delegate from gameView when the peer moves
    NSMutableData *data1,*data2;
    int messageType = gkChangeTurnScore;
    
    data1 = [NSMutableData dataWithBytes:&messageType length:sizeof(int)];
    data2=[NSMutableData dataWithBytes:&myscore length:sizeof(int)];
    [data1 appendData:data2];
    [self mySendDataToPeers:data1];
    
}
-(void) peerMine:(gameView *)gameScreen position:(CGPoint)point
{
    //called using the delegate from gameView when a mine is placed
    NSMutableData *data1,*data2;
    int messageType = gkPeerMines;
    
    data1 = [NSMutableData dataWithBytes:&messageType length:sizeof(int)];
    data2=[NSMutableData dataWithBytes:&point length:sizeof(CGPoint)];
    [data1 appendData:data2];
    [self mySendDataToPeers:data1];
}
-(void) sendGoldLocation:(gameView *)gameScreen position:(CGPoint)point label:(BOOL)goldLabel
{
    //called using the delegate from gameView when gold is picked
    NSMutableData *data1,*data2,*data3;
    int messageType = gkGoldPick;
    
    data1 = [NSMutableData dataWithBytes:&messageType length:sizeof(int)];
    data2=[NSMutableData dataWithBytes:&point length:sizeof(CGPoint)];
    data3=[NSMutableData dataWithBytes:&goldLabel length:sizeof(bool)];
    [data1 appendData:data2];
    [data1 appendData:data3];
    [self mySendDataToPeers:data1];
}
-(void) opponentDeath:(gameView *)gameScreen position:(CGPoint)point goldValue:(int)val andScore:(int)score
{
    //called using the delegate from gameView to indicate that opponent lost a life
    NSMutableData *data1,*data2,*data3,*data4;
    int messageType = gkPeerDeath;
    
    data1 = [NSMutableData dataWithBytes:&messageType length:sizeof(int)];
    data2=[NSMutableData dataWithBytes:&point length:sizeof(CGPoint)];
    data3=[NSMutableData dataWithBytes:&val length:sizeof(int)];
    data4=[NSMutableData dataWithBytes:&score length:sizeof(int)];
    [data1 appendData:data2];
    [data1 appendData:data3];
    [data1 appendData:data4];
    [self mySendDataToPeers:data1];
}

-(void)coinToss{
    //to choose who plays first
    NSMutableData *data1, *data2;
    int messageType = gkCoinToss;
    myRandNo=(arc4random()%100)+1;
    data1 = [NSMutableData dataWithBytes:&messageType length:sizeof(int)];
    data2 = [NSMutableData dataWithBytes:&myRandNo length:sizeof(int)];
    [data1 appendData:data2];
       
    [self mySendDataToPeers:data1];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationLandscapeRight);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//method to disconnect the bluetooth connection
-(void)disconnectSession
{
    //to disconnect from peers in bluetooth
    [self.currentSession disconnectFromAllPeers];
    [game removeFromSuperview];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    currentSession = nil;
    //[start setHidden:NO];
}

@end


