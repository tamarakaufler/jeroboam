use Mojolicious::Lite;

use MongoDB;
use MongoDB::OID;
use URI::Escape;
use Data::Dumper qw(Dumper);

use encoding 'utf8';

## connect to mongodb,database uc_token_translations db
##    properties: token, brand, page, locale, value

my $mongo_conn     = MongoDB::Connection->new;
my $mongo_db        = $mongo_conn->uc_token_translations;
my $tokens_table = $mongo_db->tokens;

get '/tokens_cms/:brand/:page/:locale' => sub {
  my $self = shift;

  my ($brand, $page, $locale) = ($self->param('brand'), $self->param('page'), $self->param('locale'));
  my @tokens = _get_tokens($brand, $locale, $page);

  $self->stash(tokens => $tokens[0]);
  $self->render('tokens_cmsbrandpagelocale', { brand  => $brand, page => $page, locale => $locale, });
};

get '/tokens_cms_crud/save/:id/:value' => sub {
  my $self = shift;

say "in tokens_cms_crud/save";

  my $token_id    = $self->param('id');
  my $token_value = uri_unescape($self->param('value'));

  my $token = $tokens_table->find_one({_id => MongoDB::OID->new(value => $token_id)});

  say "\t old value = $token->{value}";

  $tokens_table->update( { _id => MongoDB::OID->new(value => $token_id) }, { '$set' => { value => $token_value } } );
  my $token_after = $tokens_table->find_one({ _id => MongoDB::OID->new(value => $token_id) });

  say "\t new value = $token_after->{value}";

  $self->render(json => { id => $token_id, value => $token_after->{value}});

};

get '/tokens_cms3/delete/:id' => sub {
  my $self = shift;

  say "in tokens_cms3/delete";

  my $token_id     = $self->param('id');
  my $token_oid = MongoDB::OID->new(value => $token_id);
  $tokens_table->remove( { _id => $token_oid } );

  my $token = $tokens_table->find_one({_id => MongoDB::OID->new(value => $token_id)});
  say "Did not delete" if $token;

  $self->render(json => { id => $token_id });
};

get '/api/tokens_cms/:brand/:locale' => sub {
  my $self = shift;

  my ($brand, $locale) = ($self->param('brand'), $self->param('locale'));
  my @tokens = _get_tokens($brand, $locale);

  $self->render(json => $tokens[1]);
};

sub _get_tokens {
    my ($brand, $locale, $page) = @_;

    my $search = {};
    if ($brand) {
        $search->{brand} = $brand;
    }
    elsif ($locale) {
        $search->{locale} = $locale;
    }
    elsif ($page) {
        $search->{page} = $page;
    }

    print Dumper($search);

        my $tokens_on_demand = $tokens_table->find($search);

    my $found4page     = [];
    my $json      = {};

    while (my $page_token = $tokens_on_demand->next) {
        my $name = $page_token->{token}; 
        $name    =~ s/_/./; 
        my $token = { 
               name   => $name,
               value  => $page_token->{value},
               id      => $page_token->{_id}{value},
             };
        push @$found4page, $token if $page && $page eq $page_token->{page};

        $json->{ $page_token->{page} }{ $name }{ value } = $page_token->{value};
    }
    
    return ($found4page, $json);
}

app->start;
__DATA__

@@ tokens_cmsbrandpagelocale.html.ep

<!DOCTYPE html>
<html>
  <head>
  <title>Tokens CMS - Mojolicious rocks!</title>
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

  <script>
    $(document).ready(function() {
          $(".update_token").click(function(){
            var token_id   = $(this).attr('token_id');
            var token_value=$("input[id='" + token_id + "']").val();

            var jqxhr = $.get( "http://127.0.0.1:3000/tokens_cms_crud/save/" + token_id + '/' + encodeURI(token_value), function( data ) {
              }).fail(function(jqxhr, error) { error });

          }); 
          $(".delete_token").click(function(){
            alert('deleting');
            var token_id   = $(this).attr('token_id');

            var jqxhr = $.get( "http://127.0.0.1:3000/tokens_cms3/delete/" + token_id, function( data ) {
                alert( "Deleted" );
                $("#token_" + token_id).remove();
              }).fail(function(jqxhr, error) { alert(error) });

          }); 

          $("#create_button").click(function(){
            alert('creating');


//            $("body")
//            .append('<div id="foo">')
//            .append('<input type="text" id="bar">')
//            ;


            // create the tr element with 4 td elements
            $("table")
            .css({ color:"red" })
            .append('<tr id="foo">');

            for ( var i = 0; i < 4; i++ ) {
                var afoo = 'afoo' + i;
                var abar = 'abar' + i;
                var bfoo = 'bfoo' + i;
                var bbar = 'bbar' + i;
                $("#foo")
                     .append('<td id="' + afoo + '">');                
                $("#" + afoo)
                     .append('<input id="' + abar + '">');
                if (i == 3) {
                    $("#foo")
                         .append('<td id="' + bfoo + '">');
                    $("#" + bfoo)
                          .append('<button id="' + bbar + '" value="Save new token">');
                else if (i == 4) {
                    $("#foo")
                         .append('<td id="' + cfoo + '">');
                }
            }
//            $("#foo")
//                 .append('<td id="' + bfoo + '">');
//            $("#bfoo")
//                 .append('<button id="' + bbar + '" value="Save new token">');
//            $("#foo")
//                 .append('<td id="' + cfoo + '">');

          }); 
      }); 
  </script>
  </head>
  <body>

  <h2>Brand <%= $brand %> - Page <%= $page %> - Locale <%= $locale %></h2>

    <table>
        % for my $token (@$tokens) {
        <tr id="token_<%= $token->{id} %>">
              <td><%= $token->{name} %></td>
            <td><input id="<%=$token->{id} %>" type="text" value="<%= $token->{value} %>"></td>
            <td><button class="update_token" token_id="<%= $token->{id} %>">Update</button></td>
              <td><button class="delete_token" token_id="<%= $token->{id} %>">Delete</button></td>
        </tr>
        % }
        <tr>
              <td></td>
              <td></td>
              <td></td>
              <td id="create_token"><button id="create_button">Add new token</button></td>
        </tr>
    </table>

  </body>
</html>
