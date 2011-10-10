#sortah 

##For sortin' your friggin' mail.

This readme is presently comprised of lies and wishes. It's all part of README
driven development

--------------------------------------------------------------------------------

Sortah sort's mail. It provides a ruby (EDSL)[Embedded DSL] for manipulating
email objects. The DSL allows the definition of three principle components:

- Destinations

A destination takes in an Email object, and returns a system path. This is where
the email object passed into it will be saved. Ex:

    destination :spam, "spam/" 
    destination :ham, "/"

These are -- in essence -- simple delcarations of the structure of your sorting
system. They may take one of several forms. The examples above are relative to
the mail directory, and will transparently manage organization south of that.
They can also be absolute paths, eg:

    destination :devnull, :abs => "/dev/null"
    destination :tldr, :devnull 

which is regarded as an absolutely qualified path. It may also be a route to an
external service, for instance, ElasticSearch, eg:

    destination :search_index do
      ElasticSearchMagicObject.index { :sender => email.from, :body => email.text, ... }
      send_to :devnull
    end

Notice how the destination itself returns a "real" destination. This last type
of destination are termed "pseudodestinations" and, while they do not require
a destination to be returned, they may optionally do so. If no destination is
provided, then the email will not be saved. The destination may also return
a router, which will be used to route the email afterward. 

Finally, a pseudodestination may imply lenses, which will get run before the 
destination is executed. So the ElasticSearch example from before may be 
refactored to be:

    lens :search_hash do
      { :sender => email.from, :body => email.text, ... }
    end

    destination :search_index , :lenses => [:search_hash] do
      ElasticSearchMagicObject.index email.search_hash
      send_to :devnull
    end

- Lenses

Lenses are functions which produce a value given an input email. This value is
interpreted as metadata to be used by the routers. Ex:

    lens :spam_value do
      x = 0
      email.text.each_line do |line|
        x += (line =~ /extension/) ? 1 : 0
      end
      x
    end

    lens :word_count do
      email.text.split.size
    end

lenses can also depend on other lenses.

    lens :spam_ratio :lenses => [:spam_value, :word_count] do
      email.spam_value / email.word_count 
    end

- Routers

This is the core of the language, a router is an object which produce either a
router object, or a destination. If it produces a destination, then the email is
delivered to that destination. If it produces another router, then the email is
passed along to the router produced. A router also 'depends' on lenses. These
lenses get applied when the router is called. There is one router which is
special, the "root" router, this is the first router which gets called. To
declare it, simply declare a router without a name. Ex:

    router :spam_filter, :lenses => [:spam_value] do
      if email.spam_value < 10
        send_to :ham
      else
        send_to :spam 
      end
    end

    router :lenses => [:word_count] do
      if email.word_count > 100 
        send_to :tldr
      else
        send_to :spam_filter 
      end
    end

`send_to` will first search for a destination with the given name, if it cannot
find one, it will send it search for the corresponding router.

