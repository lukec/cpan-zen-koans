#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw(no_plan);
use FindBin;
use lib "$FindBin::Bin/../lib";

BEGIN {
    use_ok "Zen::Koan";
}

Create_Koan: {
    my $k = Zen::Koan->new( title => 'foo', body => 'bar' );
    isa_ok $k, 'Zen::Koan';
    is $k->title, 'foo';
    is $k->body,  'bar';
    is $k->as_html, <<EOT;
<div id='koan_title'>foo</div>
<div id='koan_body'>
<p>bar</p>
</div>
EOT
}

Create_by_hashref: {
    my $k = Zen::Koan->new( { title => 'foo' } );
    isa_ok $k, 'Zen::Koan';
    is $k->title, 'foo';
}

Multi_paragraph_koan: {
    my $body = "this\nand that\n\nand others.\n";
    my $k = Zen::Koan->new( title => 'foo', 
                            body => $body,
                          );
    isa_ok $k, 'Zen::Koan';
    is $k->title, 'foo';
    is $k->body,  $body;
    is $k->as_html, <<EOT;
<div id='koan_title'>foo</div>
<div id='koan_body'>
<p>this</p>
<p>and that</p>
<p>and others.</p>
</div>
EOT
}

Less_specified_koans: {
    my $k = Zen::Koan->new;
    isa_ok $k, 'Zen::Koan';
    is $k->title, 'A koan by no other name';
    is $k->body,  'This koan offers little wisdom.  It just is.';
}

Other_functions: {
    my $k = Zen::Koan->new;
    isa_ok $k, 'Zen::Koan';
    like $k->underlying_meaning, qr#You are expecting too much#;
}

