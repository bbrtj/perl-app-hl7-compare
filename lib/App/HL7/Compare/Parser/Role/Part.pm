package App::HL7::Compare::Parser::Role::Part;

use v5.10;
use strict;
use warnings;

use Mooish::AttributeBuilder -standard;
use Types::Common::Numeric qw(PositiveInt);
use Moo::Role;

has param 'number' => (
	isa => PositiveInt,
);

with qw(
	App::HL7::Compare::Parser::Role::PartOfMessage
);

1;

