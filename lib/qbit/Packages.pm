
=head1 Name

qbit::Packages - Functions to manipulate data in packages.

=cut

package qbit::Packages;

use strict;
use warnings;
use utf8;

use base qw(Exporter);

use qbit::StringUtils qw(fix_utf);
use qbit::Exceptions;
use qbit::GetText qw(gettext);

BEGIN {
    our (@EXPORT, @EXPORT_OK);

    @EXPORT = qw(
      package_sym_table
      package_stash
      package_merge_isa_data
      require_class
      );
    @EXPORT_OK = @EXPORT;
}

=head1 Functions

=head2 package_sym_table

B<Arguments:>

=over

=item

B<$package> - string, package name.

=back

B<Return value:> hash ref, all package's symbols.

=cut

sub package_sym_table($) {
    my ($package) = @_;

    no strict 'refs';
    return \%{$package . '::'};
}

=head2 package_stash

B<Arguments:>

=over

=item

B<$package> - string, package name.

=back

B<Return value:> hash ref, package stash.

=cut

sub package_stash($) {
    my ($package) = @_;

    no strict 'refs';
    *{$package . '::QBitStash'} = {} unless *{$package . '::QBitStash'};
    return \%{$package . '::QBitStash'};
}

=head2 package_merge_isa_data

B<Arguments:>

=over

=item

B<$package> - string, package name;

=item

B<$res> - scalar, result's stash;

=item

B<$func> - code, function to merge. Arguments:

=over

=item

B<$package> - string, package name;

=item

B<$res> - scalar, result's stash;

=back

=item

B<$baseclass> - string, upper level package name.

=back

Recursive merge data into $res from all levels packages hierarchy.

=cut

sub package_merge_isa_data {
    my ($package, $res, $func, $baseclass) = @_;

    my $isa;
    {
        no strict 'refs';
        $isa = \@{$package . '::ISA'};
    }
    foreach my $pkg (@$isa) {
        next if defined($baseclass) && !$pkg->isa($baseclass);
        package_merge_isa_data($pkg, $res, $func, $baseclass);
    }

    $func->($package, $res);
}

=head2 require_class

B<Arguments:>

=over

=item

B<$class> - string, class name.

=back

Convert class name to .pm file path and require it.

B<Return value:> return value of CORE::require if all is Ok or throw Exception if cannot load .pm file.

=cut

sub require_class {
    my ($class) = @_;

    my $file_name = "$class.pm";
    $file_name =~ s/::/\//g;

    my $result;
    try {
        $result = require($file_name);
    }
    catch {
        throw fix_utf($_[0]->message);
    };

    return $result || throw Exception gettext('Cannot requre class "%s": %s', $class, fix_utf($@ || $!));
}

1;
