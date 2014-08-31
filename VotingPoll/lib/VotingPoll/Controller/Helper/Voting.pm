package VotingPoll::Controller::Helper::Voting;

use v5.14;

=head1 SYNOPSIS

This library contains helper subroutines for the Voting controller

=cut

use parent 'Exporter';

use Data::Serializer;
use Data::Dumper qw(Dumper);

our @EXPORT_OK = qw(
                        get_vote_results
                        get_counties_info
                        get_parties_info
                        store_yes_vote
                        get_current_stats4constituency
                        create_results_chart
                        get_chart_config
                   );
 
## Configuration : should be in an external file or database
my $cachetime = 604800;            ## a week

=head3 get_vote_results

=cut

sub get_vote_results {
    my ($c, $const) = @_;

    my $search = {};
    $search->{ constituency } = $const if $const;

    my $options = { 
                     '+select'    => [ { count => 'party', -as => 'count' } ],
                      columns     => [ ('party') ],
                      distinct    => 1,
                      order_by    => { '-desc' => 'count' },
                  };

    
    my @results  = $c->model('VotingPollDB::VotingStat')->search( $search,
                                                                 $options);

    my $massaged = _massage_votes(\@results);

    return $massaged;

}

=head3 get_counties_info

gets county information:     name
                             constituencies

IN:    Catalyst object
OUT:   hashref of hashrefs, keyed on id: 
                                {
                                        name => ...,
                                        constituencies =>     [
                                                                    { 
                                                                            name => ...,
                                                                            id   => ...,
                                                                    }
                                                                ]
                                }

=cut

sub get_counties_info {
    my ($c) = @_;

    my ($counties);

    #$c->cache->set('counties', '');

    my $serializer = Data::Serializer->new();

    my $cacheinfo  = $c->cache->get( 'counties' );

    if ( $cacheinfo ) {
        return $serializer->deserialize( $cacheinfo );
    }
    else {
        $counties = _get_counties_info($c);

        $c->cache->set( 'counties', $serializer->serialize($counties), $cachetime );

        return $counties;
    }    

}

sub _get_counties_info {
    my ($c) = @_;

    my ($county_info, $county_rs, $constituencies_rs, $county, $constituencies);

    $county_info = {};

    $county_rs = $c->model('VotingPollDB::County')->search({}, { prefetch => 'constituencies' });
    while ( my $county = $county_rs->next ) {
        $constituencies_rs = $county->constituencies;
        $constituencies    = _massage_constituency_data($constituencies_rs);

        $county_info->{ $county->id } = {
                                            name            => $county->name, 
                                            constituencies  => $constituencies,
                                        };
        
    }
    return $county_info;

}

sub get_parties_info {
    my ($c, $const) = @_;

    my (@parties, $party_info, $party_rs);

    $party_info = [];

    $const       = $c->model('VotingPollDB::Constituency')->find({ id => $const });
    $party_rs = $const->parties;

    while ( my $party = $party_rs->next ) {
        my $info = {
                        id    => $party->id, 
                        name  => $party->name, 
                   };
        push @$party_info, $info;
        
    }
    return $party_info;

}

=head3

=cut

sub _massage_constituency_data {
    my ($const_rs) = @_;

    my $massaged = [];
    while (my $const = $const_rs->next) {
        push @$massaged, { 
                            id      => $const->id,
                            name    => $const->name,
                         };     
    }

    return $massaged;
}

=head3 store_yes_vote

IN:     Catalyst object
        vote info hashref:
                    {
                            constituency => const_id,
                            party        => party_id
                    }

=cut

sub store_yes_vote {
    my ($c, $vote) = @_;

    eval {
        $c->model('VotingPollDB::YesNoVoting')->create({ votes => 'Yes'});
        $c->model('VotingPollDB::VotingStat')->create($vote);
    };

    return if $@;
    return 1;
}

sub get_current_stats4constituency {
    my ($c, $const_id) = @_;

    my $stats = $c->model('VotingPollDB::VotingStats')->find($const_id);
}

=head3 create_results_chart
creates javascript body of callback for drawing a chart

IN:     $chart_config ... {
                            dom_id ... DOM element id (for attaching the chart) 
                            title
                            column header 1 (party)
                            column header 2 (votes)
                            width
                            height
                          }
        $data    ... array of arrays ... [[party, vote count], [party, vote_count], ...]

=cut

sub create_results_chart {
    my ($chart_config, $data) = @_;

    my $rows = _create_js_structure($data);
    
    my $callback = <<CALLBACK;
    // Set a callback to run when the Google Visualization API is loaded.
    google.setOnLoadCallback(drawNationalChart);

    // Callback that creates and populates a data table,
    // instantiates the pie chart, passes in the data and
    // draws it.
    function drawNationalChart() {
        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', '$chart_config->{party_header}');
        data.addColumn('number', '$chart_config->{votes_header}');
    
        var rows = $rows;
        data.addRows(rows);
    
        // Set chart options
        var options_nat = { 'title':  '$chart_config->{title}',
                            'width':   $chart_config->{width},
                            'height':  $chart_config->{height}};
    
        // Instantiate and draw our chart, passing in some options.
        var nat_chart   = new google.visualization.PieChart(document.getElementById('$chart_config->{dom_id}'));
        nat_chart.draw(data, options_nat);
    }
CALLBACK

    return $callback;

}

=head3

=cut

sub get_chart_config {
    my ($c, $constituency) = @_;

    my ($dom_id, $type, $title, $config);

    if ($constituency) {
        $dom_id = 'constit_results_chart';
        $type   = 'Constituency';
        $title  = 'Constituency Results';
    }
    else {
        $dom_id = 'nat_results_chart';
        $type   = 'National';
        $title  = 'National Results';
    }

    $config =  { dom_id       => $dom_id,
                 type         => $type,
                 title        => $title,
                 party_header => "Party",
                 votes_header => "Votes",
                 width        => 400,
                 height       => 300,
               };

}

=head3 _massage_national_voting

=cut

sub _massage_votes {
    my ($votes) = @_;

    my $national_results = [];
    foreach my $vote ( @$votes ) {
        #push @$national_results, { 
        #                                        name    => $vote->party->name,
        #                                        count    => $vote->get_column('count'), 
        #                                 };
        push @$national_results, [$vote->party->name, $vote->get_column('count')];
    }
    return $national_results;
}

=head3 _create_js_structure
creates a string that is used to represent a javascript data structure within the injected javascript

NOTE: Using JSON or Data::Dumper in various approaches, to avoid manual stringification, did not work.

IN:     $data .......... Perl data structure
OUT:    $stringified ... stringified input
 
=cut

sub _create_js_structure {
    my ($data) = @_; 

    my $rows = '[';
    foreach my $party_result (@$data) {
        $rows .= "['$party_result->[0]', $party_result->[1]],"
    }
    $rows .= ']';

}

1;
