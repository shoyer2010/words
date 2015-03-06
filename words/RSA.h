// RSA.h
//
// Copyright (c) 2012 scott ban
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


// from: http://code4app.com/ios/RSA-Encrypt-and-Decrypt/5061d6476803faf86c000001

#import <Foundation/Foundation.h>

typedef void (^GenerateSuccessBlock)(void);

@interface RSA : NSObject{
@private
    NSData * _publicTag;
    NSData * _privateTag;
    NSOperationQueue * _cryptoQueue;
    GenerateSuccessBlock _success;
}

/**
 @property publicKeyRef Reference to SecKeyRef point
 */
@property (nonatomic,readonly) SecKeyRef publicKeyRef;

/**
 @property privateKeyRef Reference to SecKeyRef point
 */
@property (nonatomic,readonly) SecKeyRef privateKeyRef;

/**
 Thanks to Berin with this property at link:
 http://blog.wingsofhermes.org/?p=42
 
 @property publicKeyBits Public key that generated.
 */
@property (nonatomic,readonly) NSData   *publicKeyBits;

/**
 @property publicKeyBits Private key that generated.
 */
@property (nonatomic,readonly) NSData   *privateKeyBits;

/**
 Creates and initializes an `RSA` object with the specified string.
 
 @return The newly-initialized RSA
 */
+ (id)shareInstance;

/**
 This method will take a few time and it's based on the security attribute key size in bits.
 
 @param _success Call back block
 */
- (void)generateKeyPairRSACompleteBlock:(GenerateSuccessBlock)_success;

/**
 Encrypt using public key
 
 @param data String or something
 */
- (NSData *)RSA_EncryptUsingPublicKeyWithData:(NSData *)data;

/**
 Decrypt using private key
 
 @param data String or something
 */
- (NSData *)RSA_DecryptUsingPrivateKeyWithData:(NSData*)data;

@end