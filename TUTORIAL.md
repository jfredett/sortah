#How to use Sortah

First, I reccommend the following setup. In your `$HOME` directory, create a file
called '.sortah/', and beneath that, create 'rc', then execute the command 

    ln -s .sortah/rc .sortahrc 

from your `$HOME` directory to link the `.sortahrc` file to the "real" rc file.
Next, I would initialize a git repo (or whatever VCS you prefer) in the
`.sortah` directory, and add your rc to it.

Next, create an rvmrc file in the sortah directory with a gemset of 'sortahrc'
(or whatever you prefer), this is where you will marshall all your dependencies
for sortah -- at the moment, it's only going to be one. You can use bundler for
this if you like, but if you just need vanilla sortah, it may be worth just
using `gem` to install sortah and eliminate the bundler overhead, YMMV.

Now that we've done that, we can wire up our getmailrc to point to sortah, as
follows:

    [destination]
    type = MDA_external
    path = $HOME/.sortah/sortah.sh
    arguments = ("--log-errors", )

Where `path` should point to your `.sortah` directory. Next, we need to create
the starter script, `sortah.sh`, this should look like:

    #!/bin/sh
    rvm 1.9.2@sortahrc exec sortah $@
   
then run

    chmod a+x ~/.sortah/sortah.sh

This wraps the sortah executable so that we can always call it in the context of
the sortahrc gemset -- if you install this directly to your system, then this
shouldn't be necessary.

Once you've done this, getmail should automatically use sortah to sort your
email, now you just need to write your sortah definitions in the `~/.sortah/rc`
file!

