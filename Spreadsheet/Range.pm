package Range;
use Moose;
use v5.10;

use Data::Dumper qw(Dumper);
use List::Util;

has 'limits' => (
    is  => 'rw', 
    isa => 'Str', 
    required => 1, 
);

has 'spreadsheet' => (
    is  => 'rw', 
    isa => 'Spreadsheet', 
    required => 1, 
);

has '_positions' => (
    is  => 'ro', 
    isa => 'ArrayRef[ArrayRef]', 
    lazy => 1, 
    builder => '_gather_positions', 
    init_arg => undef,
);

has '_cell_values' => (
    is  => 'ro', 
    isa => 'ArrayRef[Num|Str]', 
    lazy => 1, 
    builder => '_gather_cell_values', 
    init_arg => undef,
);

## allow non hashref input
#around BUILDARGS => sub {
#    my $orig  = shift;
#    my $class = shift;
#
#    if ( @_ == 1 && !ref $_[0] ) {
#        my ($start, $end)             = split /:/, $_[0]; 
#        my ($col_start, $row_start) = split //,  $start; 
#        my ($col_end,   $row_end)     = split //,  $end; 
#
#        my $positions = _gather_positions(
#                                    $col_start, $row_start,
#                                    $col_end,     $row_end,
#                                 );
#
#        return $class->$orig( limits         => $_[0],
#                              _positions    => $positions,
#                            );
#    }
#    else {
#        return $class->$orig(@_);
#    }
#};

sub _gather_positions {
    my ($self) = @_; 

    my ($start, $end)           = split /:/, $self->limits; 
    my ($col_start, $row_start) = $start =~ /([A-Z]+)(\d+)/; 
    my ($col_end,   $row_end)   = $end   =~ /([A-Z]+)(\d+)/; 

    die "Error : the start of the range must be above the end of the range" 
                            if ($row_start > $row_end) || (($row_start == $row_end) && ($col_start > $col_end));

    my @positions = ();
    foreach my $row ( $row_start .. $row_end ) {
        my ($col_start, $col_end) = ( 'A', 'H' );
    
        $col_start = $col_start if $row == $row_start;
        $col_end   = $col_end   if $row == $row_end;
    
        foreach my $col ( $col_start .. $col_end ) {
            push @positions, [ $row, $col ];
        }
    }

    return \@positions;
}

sub _gather_cell_values {
    my ($self) = @_; 

    my @cell_values = ();
    foreach my $pos ( @{$self->_positions} ) {
            my $value = $self->spreadsheet->cells->[$pos->[0]]{$pos->[1]}->value;
            $value    = $self->spreadsheet->cells->[$pos->[0]]{$pos->[1]}->calc_value if $value =~ /=/;
            push @cell_values, $value if $value;
    }
    return \@cell_values;
}

sub COUNT {
    my ($self) = @_;

    return scalar @{$self->_positions};
}

sub SUM {
    my ($self) = @_;

    return List::Util::sum(@{$self->_cell_values});
}

sub MAX {
    my ($self) = @_;

    return List::Util::max(@{$self->_cell_values});
}

sub MIN {
    my ($self) = @_;

    return List::Util::min(@{$self->_cell_values});
}

1;
