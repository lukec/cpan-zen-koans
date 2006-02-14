#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use Zen::Koans qw(koan_as_html);
use CGI qw(header param);

print header;

my $num = param("n") || param("num");
eval { print koan_as_html($num) };
if ($@) { 
    print "Error: $@";
}

