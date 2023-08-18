use v5.10;
use strict;
use warnings;

use Test::More;
use App::HL7::Compare;

subtest 'should compare simple messages' => sub {
	my $comparer = App::HL7::Compare->new(
		files => [
			\('MSH|^~\&|test1|test2' . "\n" .
				'PID|a|b|c|y1&y2^||'),
			\('MSH|^~\&|test3|test2' . "\n" .
				'PID|d|e|f|^y3|x'),
		],
	);
	my $comparison = $comparer->compare;

	is_deeply $comparison, [
		{
			'segment' => 'PID',
			'compared' => [
				{
					'path' => [1],
					'value' => ['a', 'd']
				},
				{
					'value' => ['b', 'e'],
					'path' => [2]
				},
				{
					'value' => ['c', 'f'],
					'path' => [3]
				},
				{
					'value' => ['y1', undef],
					'path' => [4, 1, 1]
				},
				{
					'value' => ['y2', undef],
					'path' => [4, 1, 2]
				},
				{
					'value' => [undef, 'y3'],
					'path' => [4, 2]
				},
				{
					'value' => [undef, 'x'],
					'path' => [5]
				}
			]
		}
	];
};

subtest 'should stringify a comparison' => sub {
	my $comparer = App::HL7::Compare->new(
		files => ['t/data/test1.hl7', 't/data/test2.hl7'],
	);

	my $comparison = $comparer->compare_stringify;
	is $comparison, join(
		"\n",
		'PID[1][1][1]: y1 => (empty)',
		'PID[1][1][2]: y2 => (empty)',
		'PID[1][2]: (empty) => y3',
		'PID[2]: (empty) => x',
		'ORC.1[1]: 1 => 1',
		'ORC.1[2]: ab => ab',
		'ORC.2[1]: 2 => 2',
		'ORC.2[2]: cd => cc',
	);
};

done_testing;

