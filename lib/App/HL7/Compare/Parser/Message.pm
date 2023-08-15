package App::HL7::Compare::Parser::Message;

use v5.10;
use strict;
use warnings;

use Moo;
use Mooish::AttributeBuilder -standard;
use Types::Standard qw(Str);

use App::HL7::Compare::Parser::Segment;

my $sep = "\n";

sub part_separator
{
	$sep = pop
		if @_ == 2;

	return $sep;
}

with qw(
	App::HL7::Compare::Parser::Role::Partible
	App::HL7::Compare::Parser::Role::RequiresInput
);

sub _build_parts
{
	my ($self) = @_;

	return $self->split_and_build($self->consume_input, 'App::HL7::Compare::Parser::Segment');
}

1;

