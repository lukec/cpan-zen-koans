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
                 indent_level => 0,
                 current_indent => 0,
               };

    bless $self, $class;
    return $self;
}

sub title { $_[0]->{title} }
sub body  { $_[0]->{body} }

sub as_html {
    my $self = shift;
    my $body = '';
    for my $p (split "\n", $self->{body}) {
        next if $p =~ /^\s*$/;
        chomp $p;
        if ($p =~ s/^(\s+)//) {
            my $indent = length $1;
            if ($indent > $self->{current_indent}) {
                $self->{indent_level}++;
                $body .= "<blockquote>\n";
            }
            elsif ($indent < $self->{current_indent}) {
                $self->{indent_level}--;
                $body .= "</blockquote>\n";
            }
            $self->{current_indent} = $indent;
        }
        elsif ($self->{indent_level}) {
            while ($self->{indent_level}) {
                $self->{indent_level}--;
                $body .= "</blockquote>\n";
            }
        }
        $body .= "<p>$p</p>\n";
    }
    while ($self->{indent_level}) {
        $self->{indent_level}--;
        $body .= "</blockquote>\n";
    }
    return <<EOT;
<div id='koan_title'>$self->{title}</div>
<div id='koan_body'>
$body</div>
EOT
}

sub AUTOLOAD {
    return <<EOT
You are expecting too much from this koan.  

Look within for more answers.
EOT
}

1;
