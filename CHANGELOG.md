##11/02/11

- fixed the "sortah hangs when redirecting to another router" bug
  - this required changing cleanroom to be a normal Object subclass, instead of
    a BasicObject subclass, I need to investigate re-adding certain methods to
    Object so that the throw/catch machinery will be in place for BasicObject
- made bin/sortah more verbose
