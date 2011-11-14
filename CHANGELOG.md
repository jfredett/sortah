##11/14/11

### IMPROVEMENTS

- added "dynamic" destinations. If you do:

    send_to dynamic: "path/to/your/dynamic/dest"

  sortah will append it to the given maildir with all the usual treatment
  (maildir support, mostly), useful for dynamically handling things like
  mailinglists (which is the impetus for creating this).


##11/04/11

### IMPROVEMENTS

- if you specify "type :maildir" in the sortah rc file, then sortah will
  automatically scaffold your destinations into maildir directories (eg, it'll
  `mkdir -p #{maildir}/#{dest}/{cur,new,tmp}` your destinations), and it will
  automatically write any new mail into the `/new` subdirectory of your
  destination.

- Rather than dumping error-causing emails into the vast oblivion, sortah now
  puts them in the directory specified by the `#error_dest` method 

### ADDITIONS

- added `#error_dest` to the main sortah file

##11/02/11

### BUG FIXES

- fixed the "sortah hangs when redirecting to another router" bug
  - this required changing cleanroom to be a normal Object subclass, instead of
    a BasicObject subclass, I need to investigate re-adding certain methods to
    Object so that the throw/catch machinery will be in place for BasicObject
- fixed an error in the bin/sortah script which caused emails to sometimes be
  read with the headers as part of the body.

### MINOR IMPROVEMENTS

- made bin/sortah more verbose
