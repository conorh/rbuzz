module Rbuzz
  class FeedError < Exception; end;

  class Feed
    attr :feed_url
    attr :atom_feed

    def initialize(feed_url, options = {})
      @feed_url = feed_url
    end
    
    def self.retrieve(feed_url)
      feed = Feed.new(feed_url)
      feed.fetch
      feed
    end
    
    # Extract the feed url from the users's google profile name
    def self.discover(profile_name)
      self.discover_by_url "http://www.google.com/profiles/#{profile_name}"
    end
    
    # Extract the feed url from the users's e-mail
    def self.discover_by_email(email)
      resource = Net::HTTP.get(URI.parse("http://www.google.com/s2/webfinger/?q=acct:#{email}"))
      begin
        doc = XML::Document.string(resource)
      rescue XML::Error => e
        raise FeedError, "Could not find google profile for #{email}"
      end
      if profile_url = doc.find('//XRD:Alias', 'XRD:http://docs.oasis-open.org/ns/xri/xrd-1.0').first
        self.discover_by_url profile_url.content
      else
        raise FeedError, "Could not find google profile page for #{email}"
      end
    end

    # Extract the feed url from the users's google profile page
    def self.discover_by_url(profile_url)
      begin
        page = open(profile_url).read
      rescue OpenURI::HTTPError => e
        if e.io.status[0] == '404'
          raise FeedError, "Could not find profile at #{profile_url}"
        end
      end
      
      if match = page.match(%r{<link rel="alternate" type="application/atom\+xml" href="([^"]+)})
        match[1]
      else
        raise FeedError, "Could not find atom feed on profile page"
      end
    end
    
    # Retrieve and parse the buzz atom feed
    def fetch
      @feed_entries = nil
      @atom_feed = Atom::Feed.load_feed(URI.parse(@feed_url))
    end
    
    # Retrieve the entries in the buzz atom feed as an array of FeedEntry objects
    # This will fetch the feed if it has not already been fetched
    def entries
      return @feed_entries if @feed_entries
      fetch if @atom_feed.nil?
      @feed_entries = @atom_feed.entries.collect {|e| FeedEntry.new(e) }
    end
  end
end