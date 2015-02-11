//
//  ViewController.m
//  DXFileManager
//
//  Created by xiekw on 15/2/10.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import "ViewController.h"
#import "DXFileManager.h"

#define NSLog(format, ...) do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)

static NSString * const commentDirectory = @"play/play1";

@interface ViewController ()

@property (nonatomic, strong) NSArray *sysPaths;
@property (nonatomic, strong) NSArray *contentsArray;
@property (nonatomic, strong) NSArray *contentsFilesArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetPath:nil];
    
    NSArray *array = @[@"1", @"2", @"3", @"4", @"5"];
    array = [[array reverseObjectEnumerator] allObjects];
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:NULL];
    NSDictionary *dictionary = @{@"1" : @(1), @"2" : @(2), @"3" : @(4)};
    NSString *string = @"pppppppppp";
    self.contentsArray = @[array, data, dictionary, string, self.view];
}

- (IBAction)createDire:(id)sender {
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *path in self.sysPaths) {
        NSString *rPath = [path stringByAppendingPathComponent:commentDirectory];
        BOOL suc = [DXFileManager createDirectoriesForPath:rPath error:NULL];
        [result addObject:rPath];
    }
    self.sysPaths = result;
    NSLog(@"self.sysPaths is %@", self.sysPaths);
}

- (IBAction)resetPath:(id)sender {
    NSString *a = [DXFileManager cachesDirectory];
    NSString *b = [DXFileManager documentsDirectory];
    NSString *c = [DXFileManager libraryDirectory];
    NSString *d = [DXFileManager temporaryDirectory];
    NSString *e = [DXFileManager mainBundleDirectory];
    self.sysPaths = @[a, b, c, d, e];
    NSLog(@"self.sysPaths is %@", self.sysPaths);
    
//    [self removeItem:nil];
}

- (IBAction)writeFile:(id)sender {
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *path in self.sysPaths) {
        [self.contentsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *appendPath = [NSString stringWithFormat:@"%lu.%lu", (unsigned long)idx, (unsigned long)idx];
            appendPath = [path stringByAppendingPathComponent:appendPath];
            BOOL suc = [DXFileManager writeFileAtPath:appendPath content:obj];
            [result addObject:appendPath];
        }];
    }
    self.contentsFilesArray = [result copy];
    NSLog(@"self.contentsFilesArray is %@", self.contentsFilesArray);
}

- (IBAction)removeItem:(id)sender {
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *path in self.sysPaths) {
        BOOL suc = [DXFileManager removeItemAtPath:path error:NULL];
        [result addObject:@(suc)];
    }
    NSLog(@"result is %@", result);
}

- (IBAction)removeFileWithExtension:(id)sender {
    //remove file
    NSMutableArray *fileResult = [NSMutableArray array];
    for (NSString *path in self.sysPaths) {
        BOOL suc = [DXFileManager removeFilesInDirectoryAtPath:path withExtension:@"1"];
        [fileResult addObject:@(suc)];
    }
    NSLog(@"file Result is %@", fileResult);
}

- (IBAction)removeFileWithPredicate:(id)sender {
    
    NSMutableArray *fileResult = [NSMutableArray array];
    for (NSString *path in self.sysPaths) {
        BOOL suc = [DXFileManager removeFilesInDirectoryAtPath:path withPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
            NSString *pathComponent = [evaluatedObject pathExtension];
            if (pathComponent.integerValue > 3) {
                return YES;
            }
            return NO;
        }]];
        [fileResult addObject:@(suc)];
    }
    NSLog(@"file Result is %@", fileResult);
}

- (IBAction)moveItemCoverYes:(id)sender {
    NSError *errorY;
    BOOL sucY = [DXFileManager moveItemAtPath:self.sysPaths[0] toPath:self.sysPaths[1] ifCover:YES error:&errorY];
    NSLog(@"sucY is %d errorY is %@", sucY, errorY);
    
    NSError *error;
    BOOL suc = [DXFileManager moveItemAtPath:self.contentsFilesArray[0] toPath:self.contentsFilesArray[6] ifCover:YES error:&error];
    NSLog(@"suc is %d error is %@", suc, error);

}

- (IBAction)moveItemCoverNo:(id)sender {
    NSError *errorY;
    BOOL sucY = [DXFileManager moveItemAtPath:self.sysPaths[2] toPath:self.sysPaths[3] ifCover:NO error:&errorY];
    NSLog(@"sucY is %d errorY is %@", sucY, errorY);
    
    NSError *error;
    BOOL suc = [DXFileManager moveItemAtPath:self.contentsFilesArray[1] toPath:self.contentsFilesArray[7] ifCover:NO error:&error];
    NSLog(@"suc is %d error is %@", suc, error);

    NSError *errorN;
    BOOL sucN = [DXFileManager renameItemAtPath:self.contentsFilesArray[8] withName:@"hello" error:&errorN];
    NSLog(@"suc is %d error is %@ path is %@", sucN, errorN, self.contentsFilesArray[8]);

    NSError *erroF;
    BOOL sucF = [DXFileManager renameItemAtPath:self.sysPaths[3] withName:@"fuck" error:&erroF];
    NSLog(@"suc is %d error is %@ path is %@", sucF, erroF, self.sysPaths[3]);
}

- (IBAction)copyItemCoverYes:(id)sender {
    NSError *errorY;
    BOOL sucY = [DXFileManager copyItemAtPath:self.sysPaths[0] toPath:self.sysPaths[1] ifCover:YES error:&errorY];
    NSLog(@"sucY is %d errorY is %@", sucY, errorY);
    
    NSError *error;
    BOOL suc = [DXFileManager copyItemAtPath:self.contentsFilesArray[0] toPath:self.contentsFilesArray[6] ifCover:YES error:&error];
    NSLog(@"suc is %d error is %@", suc, error);
}

- (IBAction)copyItemCoverNo:(id)sender {
    NSError *errorY;
    BOOL sucY = [DXFileManager copyItemAtPath:self.sysPaths[2] toPath:self.sysPaths[3] ifCover:NO error:&errorY];
    NSLog(@"sucY is %d errorY is %@", sucY, errorY);
    
    NSError *error;
    BOOL suc = [DXFileManager copyItemAtPath:self.contentsFilesArray[1] toPath:self.contentsFilesArray[7] ifCover:NO error:&error];
    NSLog(@"suc is %d error is %@", suc, error);
}

- (IBAction)totalSize:(id)sender {
    NSInteger totalSize = [DXFileManager totalSizeOfItemAtPath:self.sysPaths[0] recursively:YES];
    NSInteger size = [DXFileManager totalSizeOfItemAtPath:self.sysPaths[0] recursively:NO];
    NSLog(@"totalSize is %lu and size is %lu", totalSize, size);
}

- (IBAction)pathsAtPath:(id)sender {
    NSArray *totalPaths = [DXFileManager listingPathsAtPath:self.sysPaths[0] recursively:YES withPredicate:nil];
    NSArray *paths = [DXFileManager listingPathsAtPath:self.sysPaths[0] recursively:NO withPredicate:nil];
    NSLog(@"totalPaths is %@ and paths is %@", totalPaths, paths);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
