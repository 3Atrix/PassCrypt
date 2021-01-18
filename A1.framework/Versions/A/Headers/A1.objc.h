// Objective-C API for talking to A1/A1 Go package.
//   gobind -lang=objc A1/A1
//
// File is generated by gobind. Do not edit.

#ifndef __A1_H__
#define __A1_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


FOUNDATION_EXPORT int32_t A1A3_decrypt_dir_to_dir(NSString* _Nullable src_path, NSString* _Nullable pass_1, NSString* _Nullable pass_2, NSString* _Nullable pass_3, NSString* _Nullable dest_path);

FOUNDATION_EXPORT void A1A3_decrypt_file_to_file(NSString* _Nullable src_path, NSString* _Nullable pass_1, NSString* _Nullable pass_2, NSString* _Nullable pass_3, NSString* _Nullable dest_path);

FOUNDATION_EXPORT NSString* _Nonnull A1A3_decrypt_str(NSString* _Nullable src, NSString* _Nullable pass_1, NSString* _Nullable pass_2, NSString* _Nullable pass_3);

FOUNDATION_EXPORT int32_t A1A3_encrypt_dir_to_dir(NSString* _Nullable src_path, NSString* _Nullable pass_1, NSString* _Nullable pass_2, NSString* _Nullable pass_3, NSString* _Nullable dest_path);

FOUNDATION_EXPORT void A1A3_encrypt_file_to_file(NSString* _Nullable src_path, NSString* _Nullable pass_1, NSString* _Nullable pass_2, NSString* _Nullable pass_3, NSString* _Nullable dest_path);

FOUNDATION_EXPORT NSString* _Nonnull A1A3_encrypt_str(NSString* _Nullable src, NSString* _Nullable pass_1, NSString* _Nullable pass_2, NSString* _Nullable pass_3);

FOUNDATION_EXPORT void A1Util_clear_dir(NSString* _Nullable path);

#endif
