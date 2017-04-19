//
//  EmotionFinder.m
//  Emoticam
//
//

#import "EmotionFinder.h"
#import <Carbon/Carbon.h> // for kVK_* names

@interface EmotionFinder ()

@property (nonatomic) NSArray *alphaChars;
@property (nonatomic) NSArray *numberChars;
@property (nonatomic) NSArray *symbolChars;

@property (nonatomic) NSArray *exceptions;

@property (nonatomic) NSArray *exactMatches;
@property (nonatomic) NSArray *exactMatchesCaseInsensitive;

@property NSMutableString *stringBuffer;
@property BOOL potential;
@property int maxLength;

@end

@implementation EmotionFinder

- (id)init
{
    self.stringBuffer = [NSMutableString stringWithString:@""];
    self.maxLength = 500;
    self.potential = YES;
    
    NSArray *alphaChars;
    alphaChars = [NSArray arrayWithObjects:
                  [NSNumber numberWithChar:'A'],
                  [NSNumber numberWithChar:'B'],
                  [NSNumber numberWithChar:'C'],
                  [NSNumber numberWithChar:'D'],
                  [NSNumber numberWithChar:'E'],
                  [NSNumber numberWithChar:'F'],
                  [NSNumber numberWithChar:'G'],
                  [NSNumber numberWithChar:'H'],
                  [NSNumber numberWithChar:'I'],
                  [NSNumber numberWithChar:'J'],
                  [NSNumber numberWithChar:'K'],
                  [NSNumber numberWithChar:'L'],
                  [NSNumber numberWithChar:'M'],
                  [NSNumber numberWithChar:'N'],
                  [NSNumber numberWithChar:'O'],
                  [NSNumber numberWithChar:'P'],
                  [NSNumber numberWithChar:'Q'],
                  [NSNumber numberWithChar:'R'],
                  [NSNumber numberWithChar:'S'],
                  [NSNumber numberWithChar:'T'],
                  [NSNumber numberWithChar:'U'],
                  [NSNumber numberWithChar:'V'],
                  [NSNumber numberWithChar:'W'],
                  [NSNumber numberWithChar:'X'],
                  [NSNumber numberWithChar:'Y'],
                  [NSNumber numberWithChar:'Z'],
                  
                  [NSNumber numberWithChar:'a'],
                  [NSNumber numberWithChar:'b'],
                  [NSNumber numberWithChar:'c'],
                  [NSNumber numberWithChar:'d'],
                  [NSNumber numberWithChar:'e'],
                  [NSNumber numberWithChar:'f'],
                  [NSNumber numberWithChar:'g'],
                  [NSNumber numberWithChar:'h'],
                  [NSNumber numberWithChar:'i'],
                  [NSNumber numberWithChar:'j'],
                  [NSNumber numberWithChar:'k'],
                  [NSNumber numberWithChar:'l'],
                  [NSNumber numberWithChar:'m'],
                  [NSNumber numberWithChar:'n'],
                  [NSNumber numberWithChar:'o'],
                  [NSNumber numberWithChar:'p'],
                  [NSNumber numberWithChar:'q'],
                  [NSNumber numberWithChar:'r'],
                  [NSNumber numberWithChar:'s'],
                  [NSNumber numberWithChar:'t'],
                  [NSNumber numberWithChar:'u'],
                  [NSNumber numberWithChar:'v'],
                  [NSNumber numberWithChar:'w'],
                  [NSNumber numberWithChar:'x'],
                  [NSNumber numberWithChar:'y'],
                  [NSNumber numberWithChar:'z'],
                  nil];
    self.alphaChars = alphaChars;
    
    
    
    NSArray *numberChars;
    numberChars = [NSArray arrayWithObjects:
                   [NSNumber numberWithChar:'0'],
                   [NSNumber numberWithChar:'1'],
                   [NSNumber numberWithChar:'2'],
                   [NSNumber numberWithChar:'3'],
                   [NSNumber numberWithChar:'4'],
                   [NSNumber numberWithChar:'5'],
                   [NSNumber numberWithChar:'6'],
                   [NSNumber numberWithChar:'7'],
                   [NSNumber numberWithChar:'8'],
                   [NSNumber numberWithChar:'9'],
                   nil];
    self.numberChars = numberChars;
    
    
    
    NSArray *symbolChars;
    symbolChars = [NSArray arrayWithObjects:
                    [NSNumber numberWithChar:'='],
                    [NSNumber numberWithChar:'+'],
                    [NSNumber numberWithChar:'-'],
                    [NSNumber numberWithChar:'_'],
                    [NSNumber numberWithChar:'['],
                    [NSNumber numberWithChar:'{'],
                    [NSNumber numberWithChar:']'],
                    [NSNumber numberWithChar:'}'],
                    [NSNumber numberWithChar:'/'],
                    [NSNumber numberWithChar:'?'],
                    [NSNumber numberWithChar:'\\'],
                    [NSNumber numberWithChar:'|'],
                    [NSNumber numberWithChar:','],
                    [NSNumber numberWithChar:'<'],
                    [NSNumber numberWithChar:'.'],
                    [NSNumber numberWithChar:'>'],
                    [NSNumber numberWithChar:'\''],
                    [NSNumber numberWithChar:'"'],
                    [NSNumber numberWithChar:';'],
                    [NSNumber numberWithChar:':'],
                    [NSNumber numberWithChar:'`'],
                    [NSNumber numberWithChar:'~'],
                    [NSNumber numberWithChar:'!'],
                    [NSNumber numberWithChar:'@'],
                    [NSNumber numberWithChar:'#'],
                    [NSNumber numberWithChar:'$'],
                    [NSNumber numberWithChar:'%'],
                    [NSNumber numberWithChar:'^'],
                    [NSNumber numberWithChar:'&'],
                    [NSNumber numberWithChar:'*'],
                    [NSNumber numberWithChar:'('],
                    [NSNumber numberWithChar:')'],
                    nil];
    self.symbolChars = symbolChars;
    
    
    NSArray *exceptions;
    exceptions = [NSArray arrayWithObjects:
                  @"face",
                  @"head",
                  @"i",
                  @"tee",
                  @"hee",
                  nil];
    self.exceptions = exceptions;
    
    NSArray *exactMatches;
    exactMatches = [NSArray arrayWithObjects:
                    @":)",
                    @":-)",
                    @":D",
                    @":-D",
                    @":P",
                    @":-P",
                    @":p",
                    @":-p",
                    @"(:",
                    @"(-:",
                    @"):",
                    @")-:",
                    @"D:",
                    @"D-:",
                    @"D8",
                    @"D-8",
                    @"8D",
                    @"8-D",
                    @":o",
                    @":-o",
                    @":O",
                    @":-O",
                    @":-|",
                    @":-\\",
                    @":-/",
                    @">:)",
                    @">:-)",
                    @">:(",
                    @">:-(",
                    @":3",
                    @":-3",
                    @":-x",
                    @":-X",
                    @":-S",
                    //@":*",
                    //@":-*",
                    @":()",
                    @":-()",
                    @"o.o",
                    @"o.O",
                    @"O.o",
                    @"O.O",
                    @">.<",
                    @">.<'",
                    @"^_^",
                    @"^__^",
                    @"^___^",
                    @"^____^",
                    @"^_____^",
                    @"yhxtSjqH", // Version 1.3 activation code
                    nil];
    self.exactMatches = exactMatches;
    
    NSArray *exactMatchesCaseInsensitive;
    exactMatchesCaseInsensitive = [NSArray arrayWithObjects:
                    @"lmao",
                    @"rofl",
                    @"roflecopter",
                    @"roflecopters",
                    @"lolerskates",
                    @"lolersk8s",
                    @"har",
                    @"harhar",
                    @"harharhar",
                    @"harharharhar",
                    @"harharharharhar",
                    @"lols",
                    @"lolz",
                    @"luls",
                    @"lulz",
                    @"lollerskates",
                    @"lollersk8s",
                    @"l0llersk8s",
                    @"l0lersk8s",
                    @"facepalm",
                    @"face-palm",
                    @"face palm",
                    @"headdesk",
                    @"head-desk",
                    @"head desk",
                    @"i lold",
                    @"i lolld",
                    @"i loled",
                    @"i lolled",
                    @"i lol'd",
                    @"i loll'd",
                    @"i lol'ed",
                    @"i loll'ed",
                    @"smh",
                    @"smdh",
                    @":yawn:",
                    @":sniffle:",
                    @":sniff:",
                    @":tear:",
                    @":blink:",
                    @"tee hee",
                    @"hee hee",
                    nil];
    self.exactMatchesCaseInsensitive = exactMatchesCaseInsensitive;

    return self;
}

- (BOOL)checkLol:(BOOL)isFinal
{
    NSString *checkString = [self.stringBuffer lowercaseString];
    
    if(!isFinal){
        for(int i=0; i<[checkString length]; i++){
            if(([checkString characterAtIndex:i] != 'l') && ([checkString characterAtIndex:i] != 'o')){
                return NO;
            }
        }
        return YES;
    } else if (([checkString length] > 2) && ([checkString rangeOfString:@"lol"].location != NSNotFound)) {
        for(int i=0; i<[checkString length]; i++){
            if(([checkString characterAtIndex:i] != 'l') && ([checkString characterAtIndex:i] != 'o')){
                return NO;
            }
        }
        return YES;
    }
    
    return NO;
}

- (BOOL)checkTehe:(BOOL)isFinal
{
    NSString *checkString = [self.stringBuffer lowercaseString];
    NSString *baseString = @"tehe";
        
    if(!isFinal && [checkString length] < 4 && [[baseString substringToIndex:[checkString length]] isEqualToString:checkString]){
        return YES;
    } else if (([checkString length] == 4) && ([checkString isEqualToString:@"tehe"])) {
        return YES;
    } else if(([checkString length] > 4) && ([checkString hasPrefix:@"tehe"])){
        checkString = [checkString substringFromIndex:4];
        for(int i=0; i<[checkString length]; i++){
            if(([checkString characterAtIndex:i] != 'h') && ([checkString characterAtIndex:i] != 'e')){
                return NO;
            }
        }
        return YES;
    }
    
    return NO;
}

- (BOOL)checkTeehe:(BOOL)isFinal
{
    NSString *checkString = [self.stringBuffer lowercaseString];
    NSString *baseString = @"teehe";
    
    if(!isFinal && [checkString length] < 5 && [[baseString substringToIndex:[checkString length]] isEqualToString:checkString]){
        return YES;
    } else if (([checkString length] == 5) && ([checkString isEqualToString:@"teehe"])) {
        return YES;
    } else if(([checkString length] > 5) && ([checkString hasPrefix:@"teehe"])){
        checkString = [checkString substringFromIndex:5];
        for(int i=0; i<[checkString length]; i++){
            if(([checkString characterAtIndex:i] != 'h') && ([checkString characterAtIndex:i] != 'e')){
                return NO;
            }
        }
        return YES;
    }
    
    return NO;
}


- (BOOL)checkHa:(BOOL)isFinal
{
    NSString *checkString = [self.stringBuffer lowercaseString];
    BOOL hPresent = NO;
    BOOL aPresent = NO;
    
    if(!isFinal && [checkString length] < 2){
        
        for(int i=0; i<[checkString length]; i++){
            if([checkString characterAtIndex:i] == 'a'){
                aPresent = YES;
            } else if([checkString characterAtIndex:i] == 'h'){
                hPresent = YES;
            } else {
                return NO;
            }
        }
        if(hPresent && aPresent){
            return YES;
        }
        return NO;
    }
    
    if([checkString length] < 2)
        return NO;
    
    if([checkString length] == 2 && [checkString isEqualToString:@"ah"] && isFinal)
        return NO;
    
    if([checkString length] == 3 && [checkString isEqualToString:@"aha"] && isFinal)
        return NO;
    
    for(int i=0; i<[checkString length]; i++){
        if([checkString characterAtIndex:i] == 'a'){
            aPresent = YES;
        } else if([checkString characterAtIndex:i] == 'h'){
            hPresent = YES;
        } else {
            return NO;
        }
    }
    if(hPresent && aPresent){
        return YES;
    }
    return NO;

}

- (BOOL)checkXo:(BOOL)isFinal
{
    NSString *checkString = [self.stringBuffer lowercaseString];
    BOOL xPresent = NO;
    BOOL oPresent = NO;
    
    if(!isFinal && [checkString length] < 2){
        
        for(int i=0; i<[checkString length]; i++){
            if([checkString characterAtIndex:i] == 'o'){
                oPresent = YES;
            } else if([checkString characterAtIndex:i] == 'x'){
                xPresent = YES;
            } else {
                return NO;
            }
        }
        if(xPresent || oPresent){
            return YES;
        }
        return NO;
    }
    
    if([checkString length] < 2)
        return NO;
    
   // if([checkString length] == 2 && [checkString isEqualToString:@"ah"] && isFinal)
     //   return NO;
    
   // if([checkString length] == 3 && [checkString isEqualToString:@"aha"] && isFinal)
    //    return NO;
    
    for(int i=0; i<[checkString length]; i++){
        if([checkString characterAtIndex:i] == 'o'){
            oPresent = YES;
        } else if([checkString characterAtIndex:i] == 'x'){
            xPresent = YES;
        } else {
            return NO;
        }
    }
    
    if(!isFinal && (xPresent || oPresent)){
        return YES;
    }
    
    if(xPresent && oPresent){
        return YES;
    }
    return NO;
    
}

- (BOOL)checkZ:(BOOL)isFinal
{
    NSString *checkString = [self.stringBuffer lowercaseString];
    
    if(!isFinal){
        
        for(int i=0; i<[checkString length]; i++){
            if([checkString characterAtIndex:i] != 'z'){
                return NO;
            }
        }
        return YES;
    }
    
    if([checkString length] < 2)
        return NO;
    
    for(int i=0; i<[checkString length]; i++){
        if([checkString characterAtIndex:i] != 'z'){
            return NO;
        }
    }

    return YES;
    
}

- (BOOL)checkHaWithPrefix:(BOOL)isFinal
{
    NSString *checkString = [self.stringBuffer lowercaseString];
    
    if(!isFinal && ([checkString isEqualToString:@"ba"] || [checkString isEqualToString:@"bw"] || [checkString isEqualToString:@"mw"] || [checkString isEqualToString:@"mu"] || [checkString isEqualToString:@"b"] || [checkString isEqualToString:@"m"]))
        return YES;
    
    if([checkString length] <= 2)
        return NO;
    
    if(![checkString hasPrefix:@"ba"] && ![checkString hasPrefix:@"bw"] && ![checkString hasPrefix:@"mw"] && ![checkString hasPrefix:@"mu"])
        return NO;
    
    checkString = [checkString substringFromIndex:2];
    
    if([checkString length] < 3 && !isFinal){
        for(int i=0; i<[checkString length]; i++){
            if(([checkString characterAtIndex:i] != 'a') && ([checkString characterAtIndex:i] != 'h')){
                return NO;
            }
        }
        return YES;
    }
    
    if([checkString length] >= 3){
        for(int i=0; i<[checkString length]; i++){
            if(([checkString characterAtIndex:i] != 'a') && ([checkString characterAtIndex:i] != 'h')){
                return NO;
            }
        }
        return YES;
    }
    
    return NO;
}

- (BOOL)checkHeWithPrefix:(BOOL)isFinal
{
    NSString *checkString = [self.stringBuffer lowercaseString];
    
    if(!isFinal && ([checkString isEqualToString:@"he"] || [checkString isEqualToString:@"h"]))
        return YES;
    
    if([checkString length] <= 2)
        return NO;
    
    if(![checkString hasPrefix:@"he"])
        return NO;
    
    checkString = [checkString substringFromIndex:2];
    
    //if([checkString length] < 3 && !isFinal){
    //    for(int i=0; i<[checkString length]; i++){
    //        if(([checkString characterAtIndex:i] != 'e') && ([checkString characterAtIndex:i] != 'h')){
    //            return NO;
    //        }
    //    }
    //    return YES;
    //}
    
    for(int i=0; i<[checkString length]; i++){
        if(([checkString characterAtIndex:i] != 'e') && ([checkString characterAtIndex:i] != 'h')){
            return NO;
        }
    }
    return YES;
}

- (BOOL)checkSadness:(BOOL)isFinal
{
    if(!isFinal && [self.stringBuffer isEqualToString:@":"])
        return YES;
    
    if([self.stringBuffer length] == 1 || ![self.stringBuffer hasPrefix:@":"])
        return NO;
    
    NSString *checkString = [self.stringBuffer substringFromIndex:1];
    
    int mode = 0;
    for(int i=0; i<[checkString length]; i++){
        if(mode == 0){
            if([checkString characterAtIndex:i] == '-'){
                mode = 1;
                continue;
            }
            if([checkString characterAtIndex:i] == '('){
                mode = 2;
                continue;
            }
            if([checkString characterAtIndex:i] != '\'' && [checkString characterAtIndex:i] != ',')
                return NO;
        }
        if(mode == 1){
            if([checkString characterAtIndex:i] == '('){
                mode = 2;
                continue;
            }
            if([checkString characterAtIndex:i] != '(')
                return NO;
        }
        if(mode == 2 && [checkString characterAtIndex:i] != '(')
            return NO;
    }
    
    if(isFinal && mode < 2)
        return NO;

    return YES;
}

- (BOOL)checkKissy:(BOOL)isFinal
{
    NSString *checkString = [self.stringBuffer lowercaseString];
    
    if(!isFinal && ([checkString isEqualToString:@":"] || [checkString isEqualToString:@":-"] || [checkString isEqualToString:@":*"]))
        return YES;
    
    if([checkString isEqualToString:@":*"])
        return YES;
    
    if([checkString length] <= 2)
        return NO;
    
    if(![checkString hasPrefix:@":-"] && ![checkString hasPrefix:@":*"])
        return NO;
    
    checkString = [checkString substringFromIndex:2];
    
    for(int i=0; i<[checkString length]; i++){
        if([checkString characterAtIndex:i] != '*'){
            return NO;
        }
    }
    return YES;
}


/*
 * 0 = all-clear
 * 1 = alphabet
 * 2 = number
 * 3 = symbol
 */

- (int)getKeyType:(char)inputChar
{
    
    if([self.alphaChars containsObject:[NSNumber numberWithChar:inputChar]])
        return 1;
    
    if([self.numberChars containsObject:[NSNumber numberWithChar:inputChar]])
        return 2;
    
    if([self.symbolChars containsObject:[NSNumber numberWithChar:inputChar]])
        return 3;

    return 0;
}

- (BOOL)isValidChar:(NSUInteger)keyInput
{
    for(int i=0; i<[self.alphaChars count]; i++){
        if(keyInput == [[self.alphaChars objectAtIndex:i] unsignedIntegerValue])
            return YES;
    }
    
    // Need to also check against an array of conditionally valid characters, such as ( and )
    
    return NO;
}

// Return "Yes" if the current stringBuffer is a valid match, otherwise return "No"
- (BOOL)positiveMatch
{
    if([self.stringBuffer isEqualToString:@""])
        return NO;
    
    if([self.exactMatches containsObject:self.stringBuffer])
        return YES;
    
    if([self.exactMatchesCaseInsensitive containsObject:[self.stringBuffer lowercaseString]])
        return YES;
    
    if([self checkLol:YES])
        return YES;
    
    if([self checkTehe:YES])
        return YES;
    
    if([self checkTeehe:YES])
        return YES;
    
    if([self checkHa:YES])
        return YES;
    
    if([self checkHaWithPrefix:YES])
        return YES;
    
    if([self checkHeWithPrefix:YES])
        return YES;
    
    if([self checkXo:YES])
        return YES;
    
    if([self checkZ:YES])
        return YES;
    
    if([self checkKissy:YES])
        return YES;
    
    if([self checkSadness:YES])
        return YES;
    
    return NO;
    
}

// Return the number of possible matches (up to 2. Result of 2 == 2 or more
- (int)matchCount
{
    int counter = 0;
    
    for(int i=0; i<[self.exactMatches count]; i++){
        if([self.exactMatches[i] length] < [self.stringBuffer length])
            continue;
        
        if([[self.exactMatches[i] substringToIndex:[self.stringBuffer length]] isEqualToString:self.stringBuffer]){
            counter++;
            if(counter > 1)
                return counter;
        }
    }
    
    for(int i=0; i<[self.exactMatchesCaseInsensitive count]; i++){
        if([self.exactMatchesCaseInsensitive[i] length] < [self.stringBuffer length])
            continue;
        
        if([[self.exactMatchesCaseInsensitive[i] substringToIndex:[self.stringBuffer length]] isEqualToString:[self.stringBuffer lowercaseString]]){
            counter++;
            if(counter > 1)
                return counter;
        }
    }
    
    if([self checkLol:NO]){
        counter++;
        if(counter > 1){
            return counter;
        }
    }
    
    if([self checkTehe:NO]){
        counter++;
        if(counter > 1){
            return counter;
        }
    }
    
    if([self checkTeehe:NO]){
        counter++;
        if(counter > 1){
            return counter;
        }
    }
    
    if([self checkHa:NO]){
        counter++;
        if(counter > 1){
            return counter;
        }
    }
    
    if([self checkHaWithPrefix:NO]){
        counter++;
        if(counter > 1){
            return counter;
        }
    }
    
    if([self checkHeWithPrefix:NO]){
        counter++;
        if(counter > 1){
            return counter;
        }
    }
    
    if([self checkXo:NO]){
        counter++;
        if(counter > 1){
            return counter;
        }
    }
    
    if([self checkZ:NO]){
        counter++;
        if(counter > 1){
            return counter;
        }
    }
    
    if([self checkKissy:NO]){
        counter++;
        if(counter > 1){
            return counter;
        }
    }
    
    if([self checkSadness:NO]){
        counter++;
        if(counter > 1){
            return counter;
        }
    }
    
    return counter;
}

// Store confirmed emotion, converting characters as necessary
- (void)saveEmotion
{
    NSString *confirmedEmotion = [self.stringBuffer stringByReplacingOccurrencesOfString:@":" withString:@"_colon_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"-" withString:@"_dash_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"(" withString:@"_openparen_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@")" withString:@"_closeparen_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@" " withString:@"_space_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"," withString:@"_comma_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"'" withString:@"_apostrophe_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"|" withString:@"_bar_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"\\" withString:@"_backslash_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"/" withString:@"_slash_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@">" withString:@"_greaterthan_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"<" withString:@"_lessthan_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"*" withString:@"_asterix_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"." withString:@"_period_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"^" withString:@"_caret_"];
   // confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"_" withString:@"_underscore_"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"A" withString:@"_up_a"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"B" withString:@"_up_b"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"C" withString:@"_up_c"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"D" withString:@"_up_d"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"E" withString:@"_up_e"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"F" withString:@"_up_f"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"G" withString:@"_up_g"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"H" withString:@"_up_h"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"I" withString:@"_up_i"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"J" withString:@"_up_j"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"K" withString:@"_up_k"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"L" withString:@"_up_l"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"M" withString:@"_up_m"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"N" withString:@"_up_n"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"O" withString:@"_up_o"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"P" withString:@"_up_p"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"Q" withString:@"_up_q"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"R" withString:@"_up_r"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"S" withString:@"_up_s"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"T" withString:@"_up_t"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"U" withString:@"_up_u"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"V" withString:@"_up_v"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"W" withString:@"_up_w"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"X" withString:@"_up_x"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"Y" withString:@"_up_y"];
    confirmedEmotion = [confirmedEmotion stringByReplacingOccurrencesOfString:@"Z" withString:@"_up_z"];
    
    self.confirmedEmotion = confirmedEmotion;
    return;
}

- (BOOL)processMouseInput
{
    if(self.potential == YES){
        if(self.positiveMatch == NO){
            self.potential = YES;
            self.stringBuffer = [NSMutableString stringWithString:@""];
            return NO;
        }
        
        [self saveEmotion];
        self.stringBuffer = [NSMutableString stringWithString:@""];
        return YES;
    }
    
    self.potential = YES;
    self.stringBuffer = [NSMutableString stringWithString:@""];
    return NO;
    
}


- (BOOL)processKeyInput:(NSUInteger)keyInput x: (NSString*)characterInput mod: (NSUInteger)modInput
{
    // check for delete key press
    if(keyInput == kVK_Delete){
        if([self.stringBuffer length] <= 1){
            self.stringBuffer = [NSMutableString stringWithString:@""];
            self.potential = YES;
            return NO;
        }
        else{
            self.potential = YES;
            self.stringBuffer = [NSMutableString stringWithString:[self.stringBuffer substringToIndex:[self.stringBuffer length]-1]];
            return NO;
        }
    }

    int keyType = -1;
    keyType = [self getKeyType:[characterInput characterAtIndex:0]];
    
    if(keyType == 0 || (modInput & NSCommandKeyMask) ){ // If all-clear character (including command keydown)
        if(keyInput == kVK_Space){ // check for exception cases!
            if([self.exceptions containsObject:[self.stringBuffer lowercaseString]]){
                self.potential = YES;
                self.stringBuffer = [NSMutableString stringWithFormat:@"%@%@", self.stringBuffer, characterInput];
                return NO;
            }
        }
            if(self.potential == YES){
                if(self.positiveMatch == NO){
                    self.potential = YES;
                    self.stringBuffer = [NSMutableString stringWithString:@""];
                    return NO;
                }
    
                [self saveEmotion];
                self.stringBuffer = [NSMutableString stringWithString:@""];
                return YES;
            }
        
        self.potential = YES;
        self.stringBuffer = [NSMutableString stringWithString:@""];
        return NO;
    }
    
    // if string is blank
    if([self.stringBuffer isEqualToString:@""]){
        self.stringBuffer = [NSMutableString stringWithString:characterInput];
        if(self.matchCount == 0)
            self.potential = NO;
        else
            self.potential = YES;
        return NO;
    }
    
    // get last character's key type
    int lastChar = -1;
    lastChar = [self getKeyType:[self.stringBuffer characterAtIndex:[self.stringBuffer length]-1]];
    
    // if string is not blank and possibly valid
    if(self.potential == YES){
        if(((keyType == 3 && lastChar != 3) || (keyType != 3 && lastChar == 3)) && self.positiveMatch == YES){
            [self saveEmotion];
            self.stringBuffer = [NSMutableString stringWithString:characterInput];
            return YES;
        }
        self.stringBuffer = [NSMutableString stringWithFormat:@"%@%@", self.stringBuffer, characterInput];
        if(self.matchCount == 0)
            self.potential = NO;
        else
            self.potential = YES;
        return NO;
    }
    
    // if string is not blank, invalid, and new char is of opposite type
    if((keyType == 3 && lastChar != 3) || (keyType != 3 && lastChar == 3)){
        self.stringBuffer = [NSMutableString stringWithString:characterInput];
        if(self.matchCount == 0)
            self.potential = NO;
        else
            self.potential = YES;
        return NO;
    } else if([self.stringBuffer length] > self.maxLength){
        self.stringBuffer = [NSMutableString stringWithString:characterInput];
        return NO;
    }
    
    self.stringBuffer = [NSMutableString stringWithFormat:@"%@%@", self.stringBuffer, characterInput];
    return NO;
}

@end
