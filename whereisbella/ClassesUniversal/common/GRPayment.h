//
//  GRPayment.h
//  Finding Hidden
//
//  Created by Alexis Lin on 2013/4/26.
//  Copyright 2013 Goldrock Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@protocol GRPaymentDelegate <NSObject>
@required
-(void)paymentDidStart;
-(void)paymentDidStop;
-(void)transactionDidCompleted;
@end

@interface GRPayment : NSObject <SKProductsRequestDelegate,SKPaymentTransactionObserver> {
	NSMutableArray *arrProducts;
    id <GRPaymentDelegate> myDelegate;
}

@property(nonatomic,retain) NSMutableArray *arrProducts;
@property(assign) id <GRPaymentDelegate> myDelegate;

-(void)buyProduct:(NSString*)productId;
-(void)restoreProduct;

@end
