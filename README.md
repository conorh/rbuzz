Ruby Buzz - RBuzz
=================

A simple Ruby wrapper to help retrieve and parse the Google Buzz Atom Feed.

Coming soon - subscribing to updates, posting to feed

Note: This library was renamed from Buzzr to Ruby Buzz. Buzzr.com sent me a friendly trademark 
infringement notice and threatened a lawsuit.

Install
-------

gem install rbuzz

Example
-------

    require 'rbuzz'
  
    feed_url = Rbuzz::Feed.discover("conorhunt")
    # Or, using [webfinger](https://groups.google.com/group/webfinger/browse_thread/thread/fb56537a0ed36964/c51e559c8f8d5455)
    # Rbuzz::Feed.discover_by_email("bradfitz@gmail.com")
    feed = Rbuzz::Feed.retrieve(feed_url)
  
    feed.entries.each do |entry|
      puts "Title: #{entry.title}"
      puts "Author: #{entry.author.name}"
      puts "Comment Count: #{entry.comment_count}"
      puts "Content"
      puts entry.content
      puts
  
      if entry.urls.length > 0
        puts "Links"
        entry.urls.each {|u| puts "URI: #{u}" }
        puts
      end
  
      if entry.images.length > 0
        puts "Images"
        entry.images.each {|i| puts "URI: #{i}" }
        puts
      end
  
      if entry.videos.length > 0
        puts "Videos"
        entry.videos.each {|v| puts "URI: #{v}" }
        puts
      end
  
      if entry.comment_count > 0
        puts "Comments"
        puts
        entry.comments.each do |comment|
          puts "Author: #{comment.author.name}"
          puts "#{comment.content}"
          puts
        end
      end
      puts "------"
      puts
    end

CONTRIBUTORS
------------

Alexandr Zykov (github: alexandrz)

COPYRIGHT
---------

Copyright (c) 2010 Conor Hunt <conor.hunt@gmail.com>
Released under the MIT license