package App::HL7::Compare;

use v5.10;
use strict;
use warnings;

use Moo;
use Mooish::AttributeBuilder -standard;
use App::HL7::Compare::Parser;
use Types::Standard qw(Tuple Str InstanceOf);
use List::Util qw(max);

has param 'files' => (
	isa => Tuple [Str, Str],
);

has field 'parser' => (
	isa => InstanceOf ['App::HL7::Compare::Parser'],
	default => sub { App::HL7::Compare::Parser->new },
);

sub _compare_line
{
	my ($self, $segment, $field, $component, $subcomponent, $message_num, $comps) = @_;

	my $order = $comps->{order}{$segment->name} //= @{$comps->{segments}};
	$comps->{segments}[$order]
		[$field->number][$component->number][$subcomponent->number]
		[$message_num] = $subcomponent->value;
}

sub _gather_recursive
{
	my ($self, $item, $levels_down) = @_;
	$levels_down -= 1;

	my @results;
	foreach my $subitem (@{$item->parts}) {
		if ($levels_down == 0) {
			push @results, [$subitem];
		}
		else {
			push @results, map {
				[$subitem, @{$_}]
			} @{$self->_gather_recursive($subitem, $levels_down)};
		}
	}

	return \@results;
}

sub _build_comparison_recursive
{
	my ($self, $parts, $levels_down) = @_;
	$levels_down -= 1;

	if ($levels_down == 0) {
		return [
			{
				path => [],
				value => [@{$parts}[0, 1]],
			}
		];
	}

	my @results;
	foreach my $part_num (0 .. $#{$parts}) {
		my $part = $parts->[$part_num];
		next unless defined $part;

		my $deep_results = $self->_build_comparison_recursive($part, $levels_down);
		if (@{$deep_results} == 1 && defined $deep_results->[0]{path}[0]) {
			$deep_results->[0]{path}[0] = $part_num
				if $deep_results->[0]{path}[0] == 1;
			push @results, $deep_results->[0];
		}
		else {
			push @results, map {
				unshift @{$_->{path}}, $part_num;
				$_
			} @{$deep_results};
		}
	}

	return \@results;
}

sub _build_comparison
{
	my ($self, $comps) = @_;

	my %reverse_order = map { $comps->{order}{$_} => $_ } keys %{$comps->{order}};
	my @results;

	foreach my $segment_num (0 .. $#{$comps->{segments}}) {
		my $segment = $comps->{segments}[$segment_num];
		push @results, {
			segment => $reverse_order{$segment_num},
			compared => $self->_build_comparison_recursive($segment, 4)
		};
	}

	return \@results;
}

sub _compare_messages
{
	my ($self, $message1, $message2) = @_;

	my %comps = (
		order => {},
		segments => [],
	);

	my $message_num = 0;
	foreach my $message ($message1, $message2) {
		my $parts = $self->_gather_recursive($message, 4);
		foreach my $part (@{$parts}) {
			$self->_compare_line(@{$part}, $message_num, \%comps);
		}

		$message_num += 1;
	}

	return $self->_build_comparison(\%comps);
}

sub compare
{
	my ($self) = @_;

	# TODO: load files
	return $self->_compare_messages(map { $self->parser->parse($_) } @{$self->files});
}

sub print
{
}

1;

# ABSTRACT: compare two HL7 messages against one another

