# PCHTTP: A Simple Cocoa HTTP Client#

The mobile world (and more) is run on REST. Why is it such a pain in the ass?

Well, it's not any more. Introducing PCHTTP, a foolproof and simple interface to HTTP. It's been written from the ground up to be fundamentally less complex than many of the behemoth REST libraries out there. You don't need to include any external frameworks, and every HTTP method is its own PCHTTP method.

## The Whole of It ##

Sorry guys, but in order to keep it simple, PCHTTP requires at least iOS 4.0/OS X 10.6. Blocks, you know.

On the plus side, there's no need to muck about with .a or .framework files or linker flags. Just drag PCHTTP's files into your project, and `#import "PCHTTP.h"`. Done.

## Documentation ##

- [PCHTTP GitHub Page](http://pcperini.github.io/PCHTTP/PCHTTP_h/index.html)

## Oh, and... ##

PCHTTP is ARCed. A Flask test application (written in Python) is included in the test project. It is effectivly an echo server that can be run on local machines.

## License ##

PCHTTP is under the [Creative Commons Attribution License](http://creativecommons.org/licenses/by/3.0/). I'd love to be featured in your About page, but I understand that some commercial applications prevent this. If you need non-attribution access, drop me an email. Non-attribution licenses are generally free to a good home, but I'd like to hear about the project!

## CocoaPods ##

Until PCHTTP is in the master pod specs repository, add it to your specs using `pod repo add PCHTTPSpecs git@github.com:pcperini/PCHTTP.git specs`
