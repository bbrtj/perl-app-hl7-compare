package App::HL7::Compare::Parser::Role::Subpart;

use v5.10;
use strict;
use warnings;

use Mooish::AttributeBuilder -standard;
use Types::Common::Numeric qw(PositiveInt);
use Moo::Role;

has param 'number' => (
	isa => PositiveInt,
);

1;

