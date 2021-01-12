//
//  ViewController.m
//  gomobile_demo
//
//  Created by android on 2021/1/7.
//  Copyright © 2021 android. All rights reserved.
//
#import <UIKit/UITextPasteDelegate.h>

#import "ViewController.h"

#import "A1/A1.h"

BOOL IS_CRYPTING = NO;

static BOOL isNSStringEmpty(NSString* nstr) {
    return (nil == nstr) || ([nstr length] == 0);
}

@interface ViewController () <UITextPasteDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.input_text_view.pasteDelegate = self;
    
    self._input_text = @"";
    
    self._plainName = @"plain";
    self._secretName = @"secret";
    
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self._plainPath = [docPath stringByAppendingFormat:@"/%@", self._plainName];
    self._secretPath = [docPath stringByAppendingFormat:@"/%@", self._secretName];
    [self createDir:self._plainPath];
    [self createDir:self._secretPath];
}

-(BOOL) isFileExist:(NSString*)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

-(BOOL) createDir:(NSString*)pFold {
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:pFold isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        return [fileManager createDirectoryAtPath:pFold withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

//Set a Hook to know there's a paste action while I'm the first responder - fired when Paste was tapped
- (void)textPasteConfigurationSupporting:(id<UITextPasteConfigurationSupporting>)textPasteConfigurationSupporting transformPasteItem:(id<UITextPasteItem>)item API_AVAILABLE(ios(11.0)) {
    [self paste:textPasteConfigurationSupporting];
}

// refer : https://developer.apple.com/forums/thread/91809
//generic paste action handler
- (void)paste:(id)sender {
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    if ([gpBoard hasStrings]) {
        id<UITextPasteConfigurationSupporting> pasteItem = (id<UITextPasteConfigurationSupporting>)sender;
        if ([pasteItem isKindOfClass:[UITextView class]]) {
            self._input_text = [gpBoard string];
            gpBoard.string = @"";
            if (isNSStringEmpty(self._input_text)) {
                [self.label_msg setText:NSLocalizedString(@"ciphertext_cant_empty", nil)];
                return;
            }
            
            [self.switch_show_text setOn:NO];
            [self.input_text_view setEditable:NO];
            [self.input_text_view setText:@""];
            
            [self.label_msg setText:NSLocalizedString(@"ciphertext_is_hidden_and_decrypt", nil)];
        }
    }
}

- (IBAction)TextField_DidBegin:(id)sender {
    if ([self.switch_show_text isOn]) {
        if (isNSStringEmpty(self.input_text_view.text)) {
            return;
        }
        
        [self.switch_show_text setOn:NO];
        
        [self.input_text_view setEditable:NO];
        self._input_text = self.input_text_view.text;
        [self.input_text_view setText:@""];
        
        [self.label_msg setText:NSLocalizedString(@"text_is_hidden_and_not_editable", nil)];
    }
}

- (IBAction)TextField_DidEndOnExit:(id)sender {
    // hide keyboard
    [sender resignFirstResponder];
}

- (IBAction)btn_click_encrypt:(id)sender {
    if (IS_CRYPTING) {
        [[self label_msg] setText:NSLocalizedString(@"encrypting_or_decrypting_and_wait", nil)];
        return;
    }
    
    NSString* nstr_input_text = @"";
    if ([self.switch_show_text isOn]) {
        nstr_input_text = self.input_text_view.text;
    }
    else {
        nstr_input_text = self._input_text;
    }
    if (isNSStringEmpty(nstr_input_text)) {
        [[self label_msg] setText:NSLocalizedString(@"text_cant_empty", nil)];
        return;
    }
    
    NSString* nstr_pass_1 = [[self pass_1] text];
    NSString* nstr_pass_2 = [[self pass_2] text];
    NSString* nstr_pass_3 = [[self pass_3] text];
    BOOL hasPass = NO;
    hasPass |= (nil != nstr_pass_1 && [nstr_pass_1 length] > 0);
    hasPass |= (nil != nstr_pass_2 && [nstr_pass_2 length] > 0);
    hasPass |= (nil != nstr_pass_3 && [nstr_pass_3 length] > 0);
    if (!hasPass) {
        [[self label_msg] setText:NSLocalizedString(@"at_lease_one_pass", nil)];
        return;
    }
    
    IS_CRYPTING = YES;
    [[self label_msg] setText:NSLocalizedString(@"encrypting___", nil)];
    [[self input_text_view] setText:@""];
    [self.input_text_view setEditable:NO];
    [self.switch_show_text setOn:NO];
    [self.switch_show_text setEnabled:NO];
    //Main Thread
    dispatch_queue_t queue;
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString* result = A1A3_encrypt_str(nstr_input_text, nstr_pass_1, nstr_pass_2, nstr_pass_3);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = result;
            [[self label_msg] setText:NSLocalizedString(@"hidden_ciphertext_copyed_into_pasteboard", nil)];
            [self.input_text_view setEditable:NO];
            [[self input_text_view] setText:@""];
            [self.switch_show_text setOn:NO];
            [self.switch_show_text setEnabled:YES];
            self._input_text = result;
            
            IS_CRYPTING = NO;
        });
    });
}

- (IBAction)btn_click_decrypt:(id)sender {
    if (IS_CRYPTING) {
        [[self label_msg] setText:NSLocalizedString(@"encrypting_or_decrypting_and_wait", nil)];
        return;
    }
    
    NSString* nstr_input_text = @"";
    if ([self.switch_show_text isOn]) {
        nstr_input_text = self.input_text_view.text;
    }
    else {
        nstr_input_text = self._input_text;
    }
    if (isNSStringEmpty(nstr_input_text)) {
        [[self label_msg] setText:NSLocalizedString(@"text_cant_empty", nil)];
        return;
    }
    
    NSString* nstr_pass_1 = [[self pass_1] text];
    NSString* nstr_pass_2 = [[self pass_2] text];
    NSString* nstr_pass_3 = [[self pass_3] text];
    BOOL hasPass = NO;
    hasPass |= (nil != nstr_pass_1 && [nstr_pass_1 length] > 0);
    hasPass |= (nil != nstr_pass_2 && [nstr_pass_2 length] > 0);
    hasPass |= (nil != nstr_pass_3 && [nstr_pass_3 length] > 0);
    if (!hasPass) {
        [[self label_msg] setText:NSLocalizedString(@"at_lease_one_pass", nil)];
        return;
    }
    
    IS_CRYPTING = YES;
    [[self label_msg] setText:NSLocalizedString(@"decrypting___", nil)];
    [[self input_text_view] setText:@""];
    [self.input_text_view setEditable:NO];
    [self.switch_show_text setEnabled:NO];
    [self.switch_show_text setOn:NO];
    //Main Thread
    dispatch_queue_t queue;
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString* result = A1A3_decrypt_str(nstr_input_text, nstr_pass_1, nstr_pass_2, nstr_pass_3);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self label_msg] setText:NSLocalizedString(@"plaintext_hidden", nil)];
            [self.input_text_view setEditable:NO];
            [[self input_text_view] setText:@""];
            [self.switch_show_text setOn:NO];
            [self.switch_show_text setEnabled:YES];
            self._input_text = result;
            
            IS_CRYPTING = NO;
        });
    });
}

- (IBAction)btn_click_exit:(id)sender {
    [[self input_text_view] setText:@""];
    [[self pass_1] setText:@""];
    [[self pass_2] setText:@""];
    [[self pass_3] setText:@""];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *tmpDir = NSTemporaryDirectory();
    A1Util_clear_dir(docDir);
    A1Util_clear_dir(libDir);
    A1Util_clear_dir(cachesDir);
    A1Util_clear_dir(tmpDir);
    
    exit(0);
}

- (IBAction)btn_click_encrypt_file:(id)sender {
    if (IS_CRYPTING) {
        [[self label_msg] setText:NSLocalizedString(@"encrypting_or_decrypting_and_wait", nil)];
        return;
    }
    
    NSString* nstr_pass_1 = [[self pass_1] text];
    NSString* nstr_pass_2 = [[self pass_2] text];
    NSString* nstr_pass_3 = [[self pass_3] text];
    BOOL hasPass = NO;
    hasPass |= (nil != nstr_pass_1 && [nstr_pass_1 length] > 0);
    hasPass |= (nil != nstr_pass_2 && [nstr_pass_2 length] > 0);
    hasPass |= (nil != nstr_pass_3 && [nstr_pass_3 length] > 0);
    if (!hasPass) {
        [[self label_msg] setText:NSLocalizedString(@"at_lease_one_pass", nil)];
        return;
    }
    
    if (![self isFileExist:self._plainPath]) {
        [self.label_msg setText:[NSString stringWithFormat:@"%@/%@%@", @"Documents", self._plainName, NSLocalizedString(@"not_existed", nil)]];
        return;
    }
    [self createDir:self._secretPath];
    
    IS_CRYPTING = YES;
    [[self label_msg] setText:NSLocalizedString(@"encrypting___", nil)];
    [[self input_text_view] setText:@""];
    //Main Thread
    dispatch_queue_t queue;
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        int32_t count = A1A3_encrypt_dir_to_dir(self._plainPath, nstr_pass_1, nstr_pass_2, nstr_pass_3, self._secretPath);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (0 < count) {
                [[self label_msg] setText:[NSString stringWithFormat:@"%@%@/%@", NSLocalizedString(@"Encrypted_files_in", nil), @"Documents", self._secretName]];
            }
            else {
                [[self label_msg] setText:[NSString stringWithFormat:@"%@/%@%@", @"Documents", self._plainName, NSLocalizedString(@"directory_empty_not_encrypt", nil)]];
            }
            IS_CRYPTING = NO;
        });
    });
}

- (IBAction)btn_click_decrypt_file:(id)sender {
    if (IS_CRYPTING) {
        [[self label_msg] setText:NSLocalizedString(@"encrypting_or_decrypting_and_wait", nil)];
        return;
    }
    
    NSString* nstr_pass_1 = [[self pass_1] text];
    NSString* nstr_pass_2 = [[self pass_2] text];
    NSString* nstr_pass_3 = [[self pass_3] text];
    BOOL hasPass = NO;
    hasPass |= (nil != nstr_pass_1 && [nstr_pass_1 length] > 0);
    hasPass |= (nil != nstr_pass_2 && [nstr_pass_2 length] > 0);
    hasPass |= (nil != nstr_pass_3 && [nstr_pass_3 length] > 0);
    if (!hasPass) {
        [[self label_msg] setText:NSLocalizedString(@"at_lease_one_pass", nil)];
        return;
    }
    
    if (![self isFileExist:self._secretPath]) {
        [self.label_msg setText:[NSString stringWithFormat:@"%@/%@%@", @"Documents", self._secretName, NSLocalizedString(@"not_existed", nil)]];
        return;
    }
    [self createDir:self._plainPath];
    
    IS_CRYPTING = YES;
    [[self label_msg] setText:NSLocalizedString(@"decrypting___", nil)];
    [[self input_text_view] setText:@""];
    //Main Thread
    dispatch_queue_t queue;
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        int32_t count = A1A3_decrypt_dir_to_dir(self._secretPath, nstr_pass_1, nstr_pass_2, nstr_pass_3, self._plainPath);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (0 < count) {
                [[self label_msg] setText:[NSString stringWithFormat:@"%@%@/%@", NSLocalizedString(@"Decrypted_files_in", nil), @"Documents", self._plainName]];
            }
            else {
                [[self label_msg] setText:[NSString stringWithFormat:@"%@/%@%@", @"Documents", self._secretName, NSLocalizedString(@"directory_empty_not_decrypt", nil)]];
            }
            IS_CRYPTING = NO;
        });
    });
}

- (IBAction)btn_click_clean_passes:(id)sender {
    [[self pass_1] setText:@""];
    [[self pass_2] setText:@""];
    [[self pass_3] setText:@""];
    [[self label_msg] setText:NSLocalizedString(@"passwords_clean", nil)];
}

- (IBAction)btn_click_clean_pasteboard:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"";    ///< nil app crash
    [[self label_msg] setText:NSLocalizedString(@"pasteboard_clean", nil)];
}

- (IBAction)switch_click_show_text:(id)sender {
    BOOL isShow = NO;
    if ([[self switch_show_text] isOn]) {
        //show text
        isShow = YES;
    }
    
    if (isShow) {
        [self.input_text_view setEditable:YES];
        [self.input_text_view setText:self._input_text];
        self._input_text = @"";
        
        [self.label_msg setText:NSLocalizedString(@"input_text_for_encryption_or_decryption", nil)];
    }
    else {
        [self.input_text_view setEditable:NO];
        self._input_text = self.input_text_view.text;
        [self.input_text_view setText:@""];
        
        [self.label_msg setText:NSLocalizedString(@"text_is_hidden_and_not_editable", nil)];
    }
}

- (IBAction)switch_click_show_pass:(id)sender {
    BOOL isShow = NO;
    if ([[self switch_show_pass] isOn]) {
        //show pass
        isShow = YES;
    }
    
    [[self pass_1] setSecureTextEntry:!isShow];
    [[self pass_2] setSecureTextEntry:!isShow];
    [[self pass_3] setSecureTextEntry:!isShow];
}

@end
