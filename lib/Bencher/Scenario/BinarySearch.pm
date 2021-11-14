package Bencher::Scenario::BinarySearch;

use 5.010001;
use strict;
use warnings;

use Tie::Simple;

# AUTHORITY
# DATE
# DIST
# VERSION

our @ary_10k_num = (0..9999);
our @ary_10k_str = ("aaa".."oup");

our @ary_10k_num_tie;
tie @ary_10k_num_tie, 'Tie::Simple', my($data_num),
    FETCH     => sub { my ($self, $index) = @_; $ary_10k_num[$index] },
    FETCHSIZE => sub { my $self = shift; scalar(@ary_10k_num) };

our @ary_10k_str_tie;
tie @ary_10k_str_tie, 'Tie::Simple', my($data_str),
    FETCH     => sub { my ($self, $index) = @_; $ary_10k_str[$index] },
    FETCHSIZE => sub { my $self = shift; scalar(@ary_10k_str) };

our $scenario = {
    summary => 'Benchmark binary searching Perl arrays',
    participants => [
        {module=>'List::BinarySearch::PP', name=>'List::BinarySearch::PP-10k-num'    , code_template=>'List::BinarySearch::PP::binsearch(sub {$a <=> $b}, int(10_000*rand()), \\@Bencher::Scenario::BinarySearch::ary_10k_num)'},
        {module=>'List::BinarySearch::XS', name=>'List::BinarySearch::XS-10k-num'    , code_template=>'List::BinarySearch::XS::binsearch(sub {$a <=> $b}, int(10_000*rand()), \\@Bencher::Scenario::BinarySearch::ary_10k_num)'},
        {module=>'List::BinarySearch::PP', name=>'List::BinarySearch::PP-10k-num-tie', code_template=>'List::BinarySearch::PP::binsearch(sub {$a <=> $b}, int(10_000*rand()), \\@Bencher::Scenario::BinarySearch::ary_10k_num_tie)'},
        #{module=>'List::BinarySearch::XS', name=>'List::BinarySearch::XS-10k-num-tie', code_template=>'List::BinarySearch::XS::binsearch(sub {$a <=> $b}, int(10_000*rand()), \\@Bencher::Scenario::BinarySearch::ary_10k_num_tie)'},

        {module=>'List::BinarySearch::PP', name=>'List::BinarySearch::PP-10k-str'    , code_template=>'List::BinarySearch::PP::binsearch(sub {$a cmp $b}, $Bencher::Scenario::BinarySearch::ary_10k_str[(10_000*rand())], \\@Bencher::Scenario::BinarySearch::ary_10k_str)'},
        {module=>'List::BinarySearch::XS', name=>'List::BinarySearch::XS-10k-str'    , code_template=>'List::BinarySearch::XS::binsearch(sub {$a cmp $b}, $Bencher::Scenario::BinarySearch::ary_10k_str[(10_000*rand())], \\@Bencher::Scenario::BinarySearch::ary_10k_str)'},
        {module=>'List::BinarySearch::PP', name=>'List::BinarySearch::PP-10k-str-tie', code_template=>'List::BinarySearch::PP::binsearch(sub {$a cmp $b}, $Bencher::Scenario::BinarySearch::ary_10k_str[(10_000*rand())], \\@Bencher::Scenario::BinarySearch::ary_10k_str_tie)'},
        #{module=>'List::BinarySearch::XS', name=>'List::BinarySearch::PP-10k-str-tie', code_template=>'List::BinarySearch::XS::binsearch(sub {$a cmp $b}, $Bencher::Scenario::BinarySearch::ary_10k_str[(10_000*rand())], \\@Bencher::Scenario::BinarySearch::ary_10k_str_tie)'},
    ],
};

1;
# ABSTRACT:

=head1 BENCHMARK NOTES

L<List::BinarySearch::XS> is an order of magnitude faster, but does not support
tied arrays. On my laptop, binary searching a tied array is about three times
flower than binary searching a regular array.
