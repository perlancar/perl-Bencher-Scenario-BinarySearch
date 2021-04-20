package Bencher::Scenario::BinarySearch;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use Tie::Simple;

our @ary_10k_num = (1..10_000);

our @ary_10k_num_tie;
tie @ary_10k_num_tie, 'Tie::Simple', my($data),
    FETCH     => sub { my ($self, $index) = @_; $ary_10k_num[$index] },
    FETCHSIZE => sub { my $self = shift; scalar(@ary_10k_num) };

our $scenario = {
    summary => 'Benchmark binary searching',
    participants => [
        {module=>'List::BinarySearch::PP', name=>'List::BinarySearch::PP-10k-num'    , code_template=>'List::BinarySearch::PP::binsearch(sub {$a<=>$b}, int(10_000*rand()), \\@Bencher::Scenario::BinarySearch::ary_10k_num)'},
        {module=>'List::BinarySearch::XS', name=>'List::BinarySearch::XS-10k-num'    , code_template=>'List::BinarySearch::XS::binsearch(sub {$a<=>$b}, int(10_000*rand()), \\@Bencher::Scenario::BinarySearch::ary_10k_num)'},
        {module=>'List::BinarySearch::PP', name=>'List::BinarySearch::PP-10k-num-tie', code_template=>'List::BinarySearch::PP::binsearch(sub {$a<=>$b}, int(10_000*rand()), \\@Bencher::Scenario::BinarySearch::ary_10k_num_tie)'},
        #{module=>'List::BinarySearch::XS', name=>'List::BinarySearch::XS-10k-num-tie', code_template=>'List::BinarySearch::XS::binsearch(sub {$a<=>$b}, int(10_000*rand()), \\@Bencher::Scenario::BinarySearch::ary_10k_num_tie)'},
    ],
};

1;
# ABSTRACT:

=head1 BENCHMARK NOTES

L<List::BinarySearch::XS> is an order of magnitude faster, but does not support
tied arrays. On my laptop, binary searching a tied array is about three times
faster than binary searching a regular array.
