#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw(no_plan);
use FindBin;
use lib "$FindBin::Bin/../lib";

BEGIN {
    use_ok "Zen::Koans", qw(@koans koan_as_html num_koans);
}

NUM_KOANS: {
    is scalar(@koans), 101;
    is num_koans(), 101;
}

CHECK_KOAN: {
    my $k = $koans[0];
    is $k->{num}, 1;
    is $k->{title}, 'A Cup of Tea';
    like $k->{koan}, qr/Nan-in, a Japanese master/;
    like $k->{koan}, qr/visitor's cup/;
    like $k->{koan}, qr/said, "you are full/;
}

my @koan_html_tests = (
    qr#<div id='koan_title'>A Cup of Tea</div>#s,
    qr#<div id='koan_body'>\n<p>Nan-in, a Japanese#s,
    qr#about Zen\.</p>\n<p>Nan-in served tea#,
    qr#cup\?"</p>\n</div>#s,
);

KOAN_AS_HTML: {
    my $k = koan_as_html(1);
    like $k, $_ for @koan_html_tests;
}

my $koan_cgi = "$FindBin::Bin/../web/koan.pl";
KOAN_CGI: {
    ok -x $koan_cgi, "-x $koan_cgi";

    # invalid parameters
    my $no_num = run_cgi();
    like $no_num, qr#^Content-Type: text/html.+\n\s*\nError: You must supply#s;
    my $too_heigh = run_cgi("num=20000");
    like $too_heigh, qr#^Content-Type: text/html.+\n\s*\nError: Please set num#s;

    my $content = run_cgi("num=1");
    like $content, qr#^Content-Type: text/html.+\n\s*\n<div id='koan_title'#;
    like $content, $_ for @koan_html_tests;
}

sub run_cgi {
    qx($^X -Ilib $koan_cgi @_);
}
