endeca
  by Rein Henrichs and Andy Stone

== DESCRIPTION:

An Endeca client library for Ruby.

== FEATURES/PROBLEMS:

== SYNOPSIS:
  class Listing < Endeca::Document
    path 'http://endeca.example.com/api'
 
    map :id => 'R'
    map(:expand_refinements => :expand_all_dims).into(:M)
 
    float_reader \
      :latitude,
      :longitude,
 
    integer_reader :endeca_id
 
    boolean_reader :isawesome => :awesome?
  end

  Listing.find(1234).awesome? # => true
  Listing.find(:all, :per_page => 10).size # => 10

== REQUIREMENTS:

* FakeWeb (for running tests)

== INSTALL:

  sudo gem install primedia-endeca --source=http://gems.github.com

== LICENSE:

(The MIT License)

Copyright (c) 2008 PRIMEDIA Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
