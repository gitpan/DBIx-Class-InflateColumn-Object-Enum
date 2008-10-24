package DBIx::Class::InflateColumn::Object::Enum;

use warnings;
use strict;
use self;
use Carp qw/croak confess/;
use Object::Enum;

=head1 NAME

DBIx::Class::InflateColumn::Object::Enum - Allows a DBIx::Class user to define a Object::Enum column

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Load this module via load_components and utilize is_enum and values property
to define Enumuration columns via Object::Enum

    package TableClass;
    
    use strict;
    use warnings;
    use base 'DBIx::Class';
    
    __PACKAGE__->load_components(qw/InflateColumn::Object::Enum Core/);
    __PACKAGE__->table('testtable');
    __PACKAGE__->add_columns(
        color => {
            data_type => 'varchar',
            is_nullable => 1,
            is_enum => 1,
            values => [qw/red green blue/]
        }
    );
    
    1;
    
Now you may treat the column as an L<Object::Enum> object.
    
    my $table_rs = $db->resultset('TableClass')->create({
        color => undef
    });
    
    $table_rs->color->set_red; # sets color to red
    $table_rs->color->is_red; # would return true
    $table_rs->color->is_green; # would return false
    print $table_rs->color->value; # would print 'red'
    $table_rs->color->unset; # set the value to 'undef' or 'null'
    $table_rs->color->is_red; # returns false now
    

=head1 METHODS

=head2 register_column

Internal chained method with L<DBIx::Class::Row/register_column>.
Users do not call this directly!

=cut

sub register_column {
    my ($column, $info) = args;
    
    self->next::method(args);
    
    return unless defined $info->{is_enum} and $info->{is_enum};
    
    croak("Object::Enum column '$column' must define 'values' property")
        unless defined  $info->{values};
        
    croak("'$column' is an Object::Enum column but 'values' property is not an ARRAY reference")
        unless ref $info->{values} eq 'ARRAY';
    
    my $values = $info->{values};
    
    self->inflate_column(
        $column => {
            inflate => sub {
                return Object::Enum->new({
                  values => $values,
                  value => shift
                });
            },
            deflate => sub {
                return shift->value
            }
        }
    );
    
}

=head1 AUTHOR

Jason M. Mills, C<< <jmmills at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-dbix-class-inflatecolumn-object-enum at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DBIx-Class-InflateColumn-Object-Enum>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DBIx::Class::InflateColumn::Object::Enum


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DBIx-Class-InflateColumn-Object-Enum>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DBIx-Class-InflateColumn-Object-Enum>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DBIx-Class-InflateColumn-Object-Enum>

=item * Search CPAN

L<http://search.cpan.org/dist/DBIx-Class-InflateColumn-Object-Enum>

=back


=head1 SEE ALSO

L<Object::Enum>, L<DBIx::Class>, L<DBIx::Class::InflateColumn::URI>


=head1 COPYRIGHT & LICENSE

Copyright 2008 Jason M. Mills, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of DBIx::Class::InflateColumn::Object::Enum