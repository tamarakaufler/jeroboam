// Using jQuery

$(document).ready(function(){

    $("#counties_menu").hide();
    $("#constit_menu").hide();
    $("#parties_menu").hide();
    $("#submit").hide();
    $("#constit_results").hide();

    $(".yes_no_vote").click( function () {
        var response = $(this).val();
        if (response === 'No' || response === 'Undecided') {
            $('#message').html('Your respose has been recorded. Thank you for participating in the survey');

            hide_voting_option();
            $("#constit_results").hide();
        }
        else {
           $('#message').html('');
           setup_county_menu();
           $('#counties_menu').show();
        }
    });

    $("#counties_menu").change( function () {
        var county = $(this).val();

        if (county < 1) return;

        setup_constit_menu(county);
        $('#constit_menu').show();
        $('#parties_menu').hide();
    });

    $("#constit_menu").change( function () {
        var constituency = $(this).val();

        if (constituency < 1) return;

        setup_party_menu(constituency);
        get_vote_stats(constituency);

        $('#parties_menu').show();
        $('#constit_results').show();
    });

    $("#parties_menu").change( function () {
        var party = $(this).val();

        if (party < 1) return;

        $('#submit').show();
    });


    $("#submit").click( function () {
        store_vote();
        hide_voting_option();

        $("#national_results").html('');
        get_vote_stats();

        var constituency = $('#constit_menu').val();
        
        $("#constit_results").html('');
        get_vote_stats(constituency);
    });
});    

//----------------------------------------- FUNCTIONS -----------------------------------------

function setup_county_menu () {

    $.getJSON('/voting/get_counties',  function(data) {
        var counties = data.counties;

        console.log(counties);

        var menu = '<option value="-1">Select county</option>';

           $.each(counties, function(key, value) {
                     menu = menu + '<option value="' + key + '">' +
                                            counties[key].name +
                                '</option><br />';
           });
           $("#counties_menu").html(menu);

    });
}

function setup_constit_menu (county) {

    $.getJSON('/voting/get_constituencies/' + county,  function(data) {
        var constituencies = data.constituencies;

        console.log(constituencies);
        
        var menu = '<option value="-1">Select constituency</option>';

           $.each(constituencies, function(key, value) {
                     menu = menu + '<option value="' + value.id + '">' +
                                            value.name +
                                '</option><br />';
           });
           $("#constit_menu").html(menu);

    });
}

function setup_party_menu (constituency) {

    $.getJSON('/voting/get_parties/' + constituency,  function(data) {
        var parties = data.parties;

        console.log(parties);
        
        var menu = '<option value="-1">Select party</option>';

           $.each(parties, function(key, value) {
                menu = menu + '<option value="' + value.id + '">' +
                                            value.name +
                                '</option><br />';
           });
           $("#parties_menu").html(menu);

    });
}

function store_vote () {

    var constituency = $('#constit_menu').val();
    var party        = $('#parties_menu').val();

    $.getJSON('/voting/store_vote/' + constituency + '/' + party,  function(data) {
        var error = data.error;
        
        var message;
        if (error) {
            message = error;
        }
        else {
            message = 'Thank for providing your voting intentions. They have been recorded.';
        }
        
           $("#message").html(message);

    });
}

function get_vote_stats(constituency) {

    $.getJSON('/voting/get_vote_stats/' + constituency,  function(data) {
        var results = data.results;
        
        var table = '';
        //alert(JSON.stringify(data, undefined, 2));

        $.each(results, function(key, value) {
            table = table + '<tr><td>' + value[0] + '</td><td>' + value[1] + '</td></tr>';
        });

        if (constituency === undefined) {
                console.log('updating national');
                $("#national_results").html();
                $("#national_results").html(table);
                update_chart('nat', data);
        }
        else {
                console.log('updating constituency');
                $("#constit_results").html();
                $("#constit_results").html(table);
                update_chart('constit', data);
        }

    });
}

function hide_voting_option() {
    $('#intro').hide();
}

function update_chart(type, data) {

    var results      = data.results,
        chart_config = data.chart_config
    ;

    console.log(results);
    console.log(typeof results);
    //alert(JSON.stringify(results, undefined, 2));

    // Create the data table.
    var chart_data = new google.visualization.DataTable();
    chart_data.addColumn('string', chart_config.party_header);
    chart_data.addColumn('number', chart_config.votes_header);

    var rows = [];
    for (var i in results) {
        console.log('*** ' + results[i][0] + ' - ' + results[i][1]);
        rows.push([results[i][0],parseInt(results[i][1])]);
    }
    chart_data.addRows(rows);

    // Set chart options
    var options = { 'title':   chart_config.title,
                    'width':   chart_config.width,
                    'height':  chart_config.height};

    // Instantiate and draw our chart, passing in some options.
    var chart   = new google.visualization.PieChart(document.getElementById(chart_config.dom_id));
    chart.draw(chart_data, options);
}

