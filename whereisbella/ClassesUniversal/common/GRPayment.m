//
//  GRPayment.m
//  Finding Hiddden
//
//  Created by Alexis Lin on 2013/4/26.
//  Copyright 2013 Goldrock Inc. All rights reserved.
//

#import "GRPayment.h"

@implementation GRPayment

@synthesize arrProducts;
@synthesize myDelegate;

- (id)init
{
	self = [super init];
    if (self) {
        [self loadProducts];
    }
    return self;
}

-(void)loadProducts
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"products" ofType:@"plist"];
	NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    self.arrProducts = array;
    
    [array release];
}

-(void)buyProduct:(NSString*)productId
{
    if (myDelegate != nil) {
        [myDelegate paymentDidStart];
    }
    
    if([SKPaymentQueue canMakePayments]) {
        //先檢查產品是否有效
        NSSet *productIdentifiers = [NSSet setWithObject:productId];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
        request.delegate = self;
        [request start];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"System" message:@"Please enable in-app purchase." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        if (myDelegate != nil) {
            [myDelegate paymentDidStop];
        }
    }
}

-(void)restoreProduct
{
    if (myDelegate != nil) {
        [myDelegate paymentDidStart];
    }
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark -
#pragma mark payment delegate method

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	if([response.invalidProductIdentifiers count]>0) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"system" message:@"The product identifier is invalid." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
        
        if (myDelegate != nil) {
            [myDelegate paymentDidStop];
        }
	}
	else {
        //開始購買動作
        //NSLog(@"didReceiveResponse");
		SKProduct *product = [response.products objectAtIndex:0];
		SKPayment *payment = [SKPayment paymentWithProduct:product];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for(SKPaymentTransaction *transaction in transactions) {
        
		switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchasing:
                NSLog(@"SKPaymentTransactionStatePurchasing");
				break;
				
			case SKPaymentTransactionStatePurchased:
                NSLog(@"SKPaymentTransactionStatePurchased");
				[self completeTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateFailed:
                NSLog(@"SKPaymentTransactionStateFailed");
				[self failedTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateRestored:
				NSLog(@"SKPaymentTransactionStateRestored");
				[self restoreTransaction:transaction];
				break;
				
			default:
				break;
		}
	}
}

- (void)completeTransaction: (SKPaymentTransaction *)transaction
{    
    //payment
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    if (myDelegate != nil) {
        [myDelegate paymentDidStop];
        [myDelegate transactionDidCompleted];
    }
    
    //alert
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thank You!" message:@"Transaction Completed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)failedTransaction: (SKPaymentTransaction *)transaction
{
	UIAlertView *alertView;
	
    //交易失敗
	if (transaction.error.code != SKErrorPaymentCancelled) {
		alertView = [[UIAlertView alloc] initWithTitle:@"Payment Failed" message:transaction.error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
    //交易取消
	else {
		alertView = [[UIAlertView alloc] initWithTitle:@"Payment Cancelled" message:transaction.error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
    
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    if (myDelegate != nil) {
        [myDelegate paymentDidStop];
    }
}

- (void)restoreTransaction: (SKPaymentTransaction *)transaction
{
    //save
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"purchasedProductIds"]];
    [arrTemp addObject:transaction.payment.productIdentifier];
	[userDefaults setObject:arrTemp forKey:@"purchasedProductIds"];
	[userDefaults synchronize];
    [arrTemp release];

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];    
}


//– paymentQueue:removedTransactions:
//– paymentQueue:restoreCompletedTransactionsFailedWithError:
//– paymentQueueRestoreCompletedTransactionsFinished:

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"yes");

    //payment
    if (myDelegate != nil) {
        [myDelegate paymentDidStop];
        [myDelegate transactionDidCompleted];
    }
    
    //alert
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thank You!" message:@"Restore Completed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    
}

#pragma mark -
#pragma mark end

- (void)dealloc {
    [arrProducts release];
    [super dealloc];
}

@end
