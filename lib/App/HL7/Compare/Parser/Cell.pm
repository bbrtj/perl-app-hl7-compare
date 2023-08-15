package App::HL7::Compare::Parser::Cell;

use v5.10;
use strict;
use warnings;

use Moo;

use App::HL7::Compare::Parser::CellPart;

my $sep = '^';

sub part_separator
{
	$sep = pop
		if @_ == 2;

	return $sep;
}

with qw(
	App::HL7::Compare::Parser::Role::Partible
	App::HL7::Compare::Parser::Role::Subpart
	App::HL7::Compare::Parser::Role::RequiresInput
);

sub _build_parts
{
	my ($self) = @_;

	return $self->split_and_build($self->consume_input, 'App::HL7::Compare::Parser::CellPart');
}

1;

