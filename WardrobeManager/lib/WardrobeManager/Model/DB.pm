package WardrobeManager::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'WardrobeManager::Schema',
    
    connect_info => {
        dsn => 'dbi:mysql:dbname=wardrobe',
        user => 'wardrobe',
        password => 'StRaW101',
        mysql_enable_utf8 => 1,
    }
);

=head1 NAME

WardrobeManager::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<WardrobeManager>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<WardrobeManager::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.4

=head1 AUTHOR

Tamara Kaufler

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
