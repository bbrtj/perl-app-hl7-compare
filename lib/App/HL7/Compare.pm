package App::HL7::Compare;

use v5.10;
use strict;
use warnings;

use Moo;
use Mooish::AttributeBuilder -standard;
use App::HL7::Compare::Parser;
use Types::Standard qw(Tuple Str);

has param 'files' => (
	isa => Tuple[Str, Str],
);

sub _compare_messages
{
	my ($self, $message1, $message2) = @_;
}

1;

# ABSTRACT: compare two HL7 messages against one another

