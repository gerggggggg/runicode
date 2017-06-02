# runicode

Simple gem that provides a method for stripping non-visible unicode characters.

This is achieved using regular expressions that match specific unicode [character categories](https://en.wikipedia.org/wiki/Unicode_character_property#General_Category)

## Install the gem

    gem install runicode
    
## Usage

```ruby
    require 'runicode'
    
    bytes = [0xE2, 0x80, 0x8E, 102, 111, 111]
    str = bytes.pack('C*').force_encoding('UTF-8')
    
    str #=> "foo"
    str.length #=> 4
    str.bytes.length #=> 6
    
    stripped_str = Runicode.strip(str)
    stripped_str #=> "foo"
    stripped_str.length #=> 3
    stripped_str.bytes.length #=> 3
```