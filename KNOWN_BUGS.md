doing 

    sortah.sort(email)
    sortah.metadata#blahblahblah

does not behave as expected (it doens't preserve metadata to the next line)
this has something to do with how I pull the data in the Kernel patch. it works
if you do

    sortah.sort(email).metadata#blahblah

--------

if you try to metaprogram routers or w/e, it doesn't actually define them.
