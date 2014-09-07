package Cell;

=head1 Cell

Class for creating spreadsheet cell instances

=head2 Accessors

=over 6

=item C<value>

=item C<calc_value>

=item C<spreadsheet>

=back

=cut

use Moose;
use v5.10;

use Scalar::Util qw(dualvar);
#use Data::Dumper qw(Dumper);

use Range;

has 'ident' => (
    is  => 'ro', 
    isa => 'Str', 
    required => 1, 
    init_arg => '_ident',
);

has 'column' => (
    is  => 'ro', 
    isa => 'Str', 
    init_arg => '_column',
);

has 'row' => (
    is  => 'ro', 
    isa => 'Int', 
    init_arg => '_row',
);

has 'value' => (
    is  => 'rw', 
    isa => 'Num|Str', 
    default => sub { my $value = dualvar 0, ''; }, 
    trigger => \&_update_calc_value,
);

has 'calc_value' => (
    is  => 'rw', 
    isa => 'Num|Str', 
    init_arg => undef,
);

has 'spreadsheet' => (
    is  => 'rw', 
    isa => 'Str|Spreadsheet', 
    weak_ref => 1,
    lazy => 1,
    default => '',
    init_arg => undef,
);


## allow non hashref input
around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    if ( @_ == 1 && !ref $_[0] ) {
        my ($col, $row) = $_[0]=~ /([A-Z]+)(\d+)/; 
        return $class->$orig( _ident  => $_[0],
                              _row    => $row,
                              _column => $col,
                            );
    }
    else {
        return $class->$orig(@_);
    }
};

=head2 Public method

=head3 clear

clears the cell value

IN:     $self
OUT:    NA

=cut

sub clear {
    my ($self) = @_;

    my $dualvar = dualvar 0,  '';
    $self->value($dualvar);
}



sub as_string {
    my ($self) = @_;

    sprintf "%s", $self->value ;
}

sub as_number {
    my ($self) = @_;

    ($self->calc_value) ? $self->calc_value : 0 ;
}

=head2 B<Private methods>

=head3 _update_calc_value

triggered by changing cell value
calls a private method _assess_value to calculate the numeric value if the cell content is a function

=cut

sub _update_calc_value {
    my ($self) = @_;

    $self->calc_value(0) and return if ! $self->value;

    my $value =  $self->_assess_value;
    $value    = ($value) ? $value : 0;

    $self->calc_value($value);
}

=head3 _assess_value

private method to provide the calculated value if the cell content is a function

=cut

sub _assess_value {
    my ($self) = @_;

    my ($spreadsheet, $value) = ($self->spreadsheet, $self->value);

    ## Dealing with a function
    if ($value =~ /=/) {

        die 'Error' unless $spreadsheet;

        my ($function, $limits) = $value =~ /\A=([A-Z]+)\(([A-Z]+[0-9]+:[A-Z]+[0-9]+)\)\z/;

        die 'Error' unless $function && $limits;

        my $range = Range->new( limits         => $limits,  
                                spreadsheet => $spreadsheet);

        $value = $range->$function;
    }

    return $value;
}

1;
