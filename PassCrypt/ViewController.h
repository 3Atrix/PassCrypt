//
//  ViewController.h
//  gomobile_demo
//
//  Created by android on 2021/1/7.
//  Copyright © 2021 android. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

-(BOOL) isFileExist:(NSString*)filePath;
-(BOOL) createDir:(NSString*)pFold;

@property (nonatomic, copy) NSString* _plainName;
@property (nonatomic, copy) NSString* _plainPath;
@property (nonatomic, copy) NSString* _secretName;
@property (nonatomic, copy) NSString* _secretPath;
@property (nonatomic, copy) NSString* _input_text;

- (IBAction)TextField_DidBegin:(id)sender;
- (IBAction)TextField_DidEndOnExit:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *input_text_view;
@property (weak, nonatomic) IBOutlet UITextField *pass_1;
@property (weak, nonatomic) IBOutlet UITextField *pass_2;
@property (weak, nonatomic) IBOutlet UITextField *pass_3;
@property (weak, nonatomic) IBOutlet UISwitch *switch_show_pass;
@property (weak, nonatomic) IBOutlet UISwitch *switch_show_text;
@property (weak, nonatomic) IBOutlet UILabel *label_msg;

@property (weak, nonatomic) IBOutlet UIButton *btn_encrypt;
@property (weak, nonatomic) IBOutlet UIButton *btn_decrypt;
@property (weak, nonatomic) IBOutlet UIButton *btn_clean_pasteboard;
@property (weak, nonatomic) IBOutlet UIButton *btn_exit;
@property (weak, nonatomic) IBOutlet UIButton *btn_encrypt_file;
@property (weak, nonatomic) IBOutlet UIButton *btn_decrypt_file;
@property (weak, nonatomic) IBOutlet UIButton *btn_clean_passes;

- (IBAction)btn_click_encrypt:(id)sender;
- (IBAction)btn_click_decrypt:(id)sender;
- (IBAction)btn_click_exit:(id)sender;
- (IBAction)switch_click_show_pass:(id)sender;
- (IBAction)switch_click_show_text:(id)sender;
- (IBAction)btn_click_clean_pasteboard:(id)sender;
- (IBAction)btn_click_encrypt_file:(id)sender;
- (IBAction)btn_click_decrypt_file:(id)sender;
- (IBAction)btn_click_clean_passes:(id)sender;

@end
