$_ = 'http://natto.2ch.net/jsdf/';

#$str =~ m|/(\S+)/$|;

#print ($1 ."\n");



#$str =~ m|/(\w+)/$|;

#print ($1 ."\n");

print ($_. "\n");
#$str =~ m|/[^/](\S+)?/|;
#$str =~ m|/(^S+)([^/\S+])/$|;
#m|/(^http://[^/]*/)([^/]*/)$|;
m|(^http://[^/]*/)([^/]*/)$|i;
print ($1 ."\n");

print ($2 ."\n");
