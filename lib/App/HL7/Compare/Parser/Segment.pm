package App::HL7::Compare::Parser::Segment;

use v5.10;
use strict;
use warnings;

use Moo;
use Mooish::AttributeBuilder -standard;
use Types::Standard qw(Str);

use App::HL7::Compare::Parser::Cell;

my $sep = '|';

sub part_separator
{
	$sep = pop
		if @_ == 2;

	return $sep;
}

has field 'name' => (
	isa => Str,
	lazy => 1,
);

with qw(
	App::HL7::Compare::Parser::Role::Partible
	App::HL7::Compare::Parser::Role::RequiresInput
	App::HL7::Compare::Parser::Role::Subpart
);

sub _build_parts
{
	my ($self) = @_;

	return $self->split_and_build($self->consume_input, 'App::HL7::Compare::Parser::Cell');
}

sub _build_name
{
	my ($self) = @_;

	return $self->parts->[0]->parts->[0]->parts->[0]->value;
}

1;

