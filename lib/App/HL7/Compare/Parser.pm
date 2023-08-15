package App::HL7::Compare::Parser;

use v5.10;
use strict;
use warnings;

use Moo;
use Mooish::AttributeBuilder -standard;
use App::HL7::Compare::Parser::Message;

sub parse
{
	my ($self, $input, %opts) = @_;

	return App::HL7::Compare::Parser::Message->new(%opts, input => $input);
}

1;

