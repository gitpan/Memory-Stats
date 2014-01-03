#
# This file is part of Memory-Stats
#
# This software is copyright (c) 2013 by celogeek <me@celogeek.com>.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
package Memory::Stats;

# ABSTRACT: Memory Usage Consumption of your process

use strict;
use warnings;
our $VERSION = '0.01';    # VERSION
use Proc::ProcessTable;
use Carp qw/croak/;
use Moo;

my $pt = Proc::ProcessTable->new;
my $current_memory_usage;
my $delta_memory_usage;

sub _get_current_memory_usage {
    my %info = map { $_->pid => $_ } @{ $pt->table };
    return $info{$$}->rss;
}

sub start {
    $current_memory_usage = _get_current_memory_usage();
    return;
}

sub stop {
    croak "Please call the method 'start' first !"
        if !defined $current_memory_usage;
    $delta_memory_usage = _get_current_memory_usage() - $current_memory_usage;
    $current_memory_usage = undef;
    return;
}

sub get_memory_usage {
    croak "Please call the method 'start' then 'stop' first !"
        if !defined $delta_memory_usage;
    return $delta_memory_usage;
}

1;

__END__

=pod

=head1 NAME

Memory::Stats - Memory Usage Consumption of your process

=head1 VERSION

version 0.01

=head1 DESCRIPTION

This module give you the memory usage (resident RSS), of a part of your process. It use L<Proc::ProcessTable> and should work on all platforms supported by this module.

You can check this link to for explanation : L<http://blog.celogeek.com/201312/394/perl-universal-way-to-get-memory-usage-of-a-process/>

=head1 SYNOPSIS

  use Memory::Stats;

  my $stats = Memory::Stats->new;

  $stats->start;
  # do something
  $stats->stop;
  say "Memory consumed : ", $stats->get_memory_usage;

=head1 METHODS

=head2 start

Init the recording

=head2 stop

Stop the recording

=head2 get_memory_usage

Return the last recording memory in KB

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/celogeek/perl-memory-stats/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

celogeek <me@celogeek.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by celogeek <me@celogeek.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
