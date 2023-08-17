package App::HL7::Compare::Parser::Role::Partible;

use v5.10;
use strict;
use warnings;

use Mooish::AttributeBuilder -standard;
use Types::Standard qw(ArrayRef ConsumerOf);
use List::Util qw(first);
use App::HL7::Compare::Exception;
use Moo::Role;

has field 'parts' => (
	isa => ArrayRef[ConsumerOf['App::HL7::Compare::Parser::Role::Part']],
	lazy => 1,
);

with qw(
	App::HL7::Compare::Parser::Role::Stringifies
	App::HL7::Compare::Parser::Role::PartOfMessage
);

requires qw(
	part_separator
	_build_parts
);

sub has_multiple_parts
{
	my ($self) = @_;

	return @{$self->parts} == 1;
}

sub part_with_number
{
	my ($self, $num) = @_;

	return first { $num == $_->number } @{$self->parts};
}

sub total_parts
{
	my ($self) = @_;

	return scalar @{$self->parts};
}

sub to_string
{
	my ($self) = @_;

	my $parts = $self->parts;
	return '' unless @{$parts} > 0;

	return join $self->part_separator, map { $_->to_string } @{$parts};
}

sub split_and_build
{
	my ($self, $string_to_split, $class_to_build) = @_;

	my @parts = split quotemeta($self->part_separator), $string_to_split;

	App::HL7::Compare::Exception->raise("empty value for $class_to_build")
		if @parts == 0;

	return [
		map {
			$class_to_build->new(
				msg_config => $self->msg_config,
				number => $_ + 1,
				input => $parts[$_],
			)
		} grep {
			length $parts[$_] > 0
		} 0 .. $#parts
	];
}

1;

