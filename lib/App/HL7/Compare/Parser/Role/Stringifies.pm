package App::HL7::Compare::Parser::Role::Stringifies;

use v5.10;
use strict;
use warnings;

use Moo::Role;

requires qw(
	to_string
);

1;

