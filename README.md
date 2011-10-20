#sortah 

##For sortin' your friggin' mail.

This readme is presently comprised of lies and wishes. It's all part of README
driven development

--------------------------------------------------------------------------------

Sortah sort's mail. It provides a ruby [EDSL](# Embedded DSL) for manipulating
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

which is regarded as an absolutely qualified path. It may also alias another
path:

    destination :tldr, :devnull 

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

You may specify the `pass_through` option to cause the lens to not set any 
metadata. This is useful in two cases, updating old metadata, and interaction
(typically creational) with other services. Eg:

    lens :example_update, :pass_through => true do
      email.spam_value = 1000000 if email.sender == "annoying_guy0022493@hotmail.com"
    end

    lens :example_interaction, :pass_through => true, lenses => [:spam_value] do
      return unless email.spam_value >= 1000000
      HTTParty.post "http://spamblacklist.net/spammer/new", :body => email.sender
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

    router :root, :lenses => [:word_count] do
      if email.word_count > 100 
        send_to :tldr
      else
        send_to :spam_filter 
      end
    end

`send_to` will first search for a destination with the given name, if it cannot
find one, it will send it search for the corresponding router.

when defining a root router with lenses, you must specify ":root" as the title.

## Common problems, and how to solve them:

### Problem: Adding a mail to an external service, and then saving it.

As a user of sortah, you want to set up filters to save all email from the
address "searchable@somewhere.net" to the folder "foobar/", as well as register
it with the external service "RubberBandSearch". 

### Solution

    destination :foobar, "foobar/"

    lens :search_index , :pass_through => true do
      #code to register the email in RubberBandSearch
      email.indexed? = true
    end

    router :index_in_rubberband, :lenses => [:search_index] do
      send_to :foobar
    end

    router :lenses => [:spam] do
      send_to :devnull if email.spam? 
      send_to :index_in_rubberband 
    end

Here we've used a `pass_through` lens to do the actual indexing, and the router
is left as more of a proxy to call the lens. 

### Problem

As a user of sortah, you want to maintain a whitelist of people who should have
their own folders, and you want those people to be subsorted in some arbitrarily 
deep parent folders, eg:

    family/ 
      mom/
      dad/
      uncle_timmy/ 
    coworkers/
      pointy_hair/
      dilbert/
      old_coworkers/
        jim/
    personal/
      wife/
      friends/
        bob/
        mike/
        jack/

etc. Further, you'd like to only maintain the above file (or something like it), and
not have to write new sortah code every time you move jobs or make new friends.[1]

[1] Ideally, this code would maintain a directory structure for you. But as of right
now, sortah has no aspirations to do such a thing. Each edition which _moves_ files
in the yaml definition file will simply create new folders, it is up to the author 
of that yaml file to keep the directory coherent with the yaml file.

## Solution

First, define a yaml file like the following:

    personal: 
      - name: wife
        sender:
          - pretty-lady-who-feeds-me@scary.com
    family: 
      - name: mom
        sender:
          - mom@hotmail.com
          - mom@gmail.com
      - name: dad
        sender:
          - dad@work.org
    nested:
      - name: example
        reply-to: some_list@place.com
      - deeper-nesting:
        - name: deeper-nested-example
        - reply-to: somewhere_else@overtherainbow.biz.co.uk
    #...

This yaml file will represent the directory structure, as well as provide information
about how to determine whether the email is from that person or not.

Next, you could define a class `Contact`, which could be built with the following methods:

    class Contact
      # ... contains a definition for 'path' -- which is built from the yaml file.
      
      def destination 
        destination name, path
      end

      def wants?(email)
        search_fields.each do |f,v|
          return true if email[f] =~ /#{v}/
        end
      end

      def search_fields
        #these are the key/value pairs from the YAML file which are of the form:
        #  email-field: content_string
        #eg:
        #  sender: 'me@place.net'
        #  reply-to: 'mailing-list@majordomo.com'
        #etc
      end
      # ...
    end

All of this code could be bound up in a router, eg:

    router :contacts do
      contacts = Contact.load_from_file('contacts.yml') 
      contacts.select { |c| c.wants?(email) }.first.destination
    end

Much of this is left to pseudocode, but you can see how being able to use pure-ruby
allows for complex routes to be expressed simply.
