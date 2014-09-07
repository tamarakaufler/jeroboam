package Spreadsheet;
 
use v5.10;
use Moose;
use List::Util;

use Data::Dumper qw(Dumper);

use Cell;

has 'columns' => (
    is  => 'ro', 
    isa => 'ArrayRef[Str]',
    default => sub { return [('A' .. 'H')] },
    init_arg => '_columns',
);

has 'rows' => (
    is  => 'ro', 
    isa => 'ArrayRef[Int]',
    default => sub { return [ 1 .. 10 ] },
    init_arg => '_columns',
);

has 'cells' => (
    lazy => 1, 
    is  => 'rw', 
    isa => 'ArrayRef',
    builder => '_create_cells', 
);

=head2 _create_cells

builder method for the cells attribute

IN:        $self
OUT:    arrayref of Cell objects: arref->[row]{column} = cell_instance

=cut

sub _create_cells {
    my ($self) = @_;

    my $cells = [];
    foreach my $ss_row (@{$self->rows}) {
        foreach my $ss_col (@{$self->columns}) {
            my $ident = "$ss_col$ss_row";
            my $cell = Cell->new($ident);
            $cell->spreadsheet($self);
            $cells->[$ss_row]{ $ss_col } = $cell;
        }
    }    

    return $cells;
}

sub cell {
    my ($self, $ident) = @_;
    my ($col, $row) = $ident =~ /([A-Z]+)(\d+)/;

    die "format error" unless $col =~ /\A[A-Z]+\z/                              && 
                              $row =~ /\A\d+\z/                                 && 
                              scalar (grep{ /\A$col\z/ }  @{$self->columns}) &&
                              scalar (grep{ $_ == $row  } @{$self->rows})    ;

    return $self->cells->[$row]{$col};
}

sub print {
    my ($self) = @_;

    print "     ";
    map { print " *$_   " } @{$self->columns};
    print "\n";
    foreach my $row (@{$self->rows}) {
        print "=$row: ";
        foreach my $col (@{$self->columns}) {
             print " [" . $self->cells->[$row]{$col}->as_string;

             ## This is just to check the true value of the cell if a function was provided
             print "(" . $self->cells->[$row]{$col}->as_number . ")]";
        }
        say '';
    }

}

1;
