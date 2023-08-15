use v5.10;
use strict;
use warnings;

use Test::More;
use App::HL7::Compare::Parser;

my $contents = do {
	open my $fh, '<', 't/data/template.hl7'
		or die "couldn't open test file: $!";

	local $/;
	readline $fh;
};

my $parser = App::HL7::Compare::Parser->new;
my $parsed = $parser->parse($contents);

is $parsed->parts->[0]->name, 'MSH', 'parsed file seems ok';

done_testing;

