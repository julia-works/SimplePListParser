# Simple PList Parser

There is now a [new version](https://github.com/ordovician/PLists.jl) of this parser. I am keeping this around because the implementation is very simply so it is useful in teaching or learning how to implement a lexer and a parser.

This is a Julia package which allows you to read OS X plists in ASCII format. This is the property list format that originated on NeXTSTEP. The binary and XML format commonly used on Mac today is presently not supported

Example of plist ASCII format:

	{
	  Dogs = (
	    {
	      Name = "Scooby Doo";
	      Age = 43;
	      Colors = (Brown, Black);
	    }
	  );
      BinaryData = <0fbd77 1c2735ae>;
	}
	
    
The plists can be read and written with `readplist` and `writeplist` which are designed to be similar to be similar to `readcsv` and `writecsv`. Example:

    dict = readplist("example.plist")
    writeplist("file.plist", dict)
    
I based the implementation on the documentation of [Old-Style ASCII Property Lists](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/PropertyLists/OldStylePlists/OldStylePLists.html) on Apple's Developer pages. Here is an example from Apple:

    {
        AnimalSmells = { pig = piggish; lamb = lambish; worm = wormy; };
        AnimalSounds = { pig = oink; lamb = baa; worm = baa;
                        Lisa = "Why is the worm talking like a lamb?"; };
        AnimalColors = { pig = pink; lamb = black; worm = pink; };
    }

[![Build Status](https://travis-ci.org/ordovician/PList.jl.svg?branch=master)](https://travis-ci.org/ordovician/PList.jl)

[![Coverage Status](https://coveralls.io/repos/github/ordovician/PList.jl/badge.svg?branch=master)](https://coveralls.io/github/ordovician/PList.jl?branch=master)

[![codecov.io](http://codecov.io/github/ordovician/PList.jl/coverage.svg?branch=master)](http://codecov.io/github/ordovician/PList.jl?branch=master)
