package Zen::Koan;
use strict;
use warnings;
use Carp qw/croak/;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my %opts;
    if (@_ == 1 and ref($_[0]) eq 'HASH') {
        %opts = %{ $_[0] };
    }
    else { %opts = @_ }
    $opts{title} ||= 'A koan by no other name';
    $opts{body}  ||= 'This koan offers little wisdom.  It just is.';

    my $self = { title => $opts{title},
                 body  => $opts{body},
               };

    bless $self, $class;
    return $self;
}

sub title { $_[0]->{title} }
sub body  { $_[0]->{body} }

sub as_html {
    my $self = shift;
    my @paragraphs = grep /^.+$/, split "\n", $self->{body};
    chomp @paragraphs;
    my $body = '<p>' . join("</p>\n<p>", @paragraphs) . '</p>';
    return <<EOT;
<div id='koan_title'>$self->{title}</div>
<div id='koan_body'>
$body
</div>
EOT
}

sub AUTOLOAD {
    return <<EOT
You are expecting too much from this koan.  

Look within for more answers.
EOT
}

1;
