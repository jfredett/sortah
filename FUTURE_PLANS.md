#Ideas

- speed

it's pretty slow, as it stands, could definitely use some speed up. Major
improvement would be a sortah server, which could run persistently, so that
starting/stopping a ruby vm wouldn't be necessary. Also, parallizing sortah 
would be nice, potential for that could be batch execution or the server idea
from above.

- proxy destinations

Difficulty: middling

To allow for non-filesystem storage locations (say, redis, elasticsearch, w/e),
it would be nice to have "pseudo" destinations, like:

    destination :redis do
      RedisHandler.acquire_conn do |redis|
        redis.put email.key, email.to_s
      end
    end

    lens :key do
      email.key = SHA1_of(email)
    end

    router :root, :lenses => [:key] do
      send_to :redis
    end

- multi-target `send_to`

Difficulty: easy

It would be nice to say:

    router do
      send_to [:foo, :bar, :baz]
    end

and have a copy be sent to each destination, optionally, it could take a
parameter, "linked", so that the others would only be soft-links to the
canonical one (specifed by link), eg:

    router do
      send_to [:foo, :bar, :baz], :link => :foo
    end

In the above, :bar and :baz would be softlinks to :foo

- contrib

Difficulty: easy
Prereq: Having a community.

Set up an easy-to-use 'contrib' repo for community sortah libraries.

- getmail integration

Difficulty: easy | hard

This comes in two flavors, the easy flavor is to just provide a wrapper
for defining a getmailrc. Perhaps making it easy to define a gmail rc and
also allowing for safe password injections (eg, not storing the password
plaintext in the rc file).

The harder version would be to just implement getmail as part of sortah.
This would allow for fine-grained control over how sortah gets fired, allowing
for better concurrency.











