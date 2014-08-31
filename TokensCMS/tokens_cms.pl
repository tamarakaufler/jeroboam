use Mojolicious::Lite;

use MongoDB;
use MongoDB::OID;
use URI::Escape;
use Data::Dumper qw(Dumper);

use encoding 'utf8';

## connect to mongodb,database uc_token_translations db
##	properties: token, brand, page, locale, value

my $mongo_conn = MongoDB::Connection->new;
my $mongo_db   = $mongo_conn->uc_token_translations;
my $tokens_table     = $mongo_db->tokens;

get '/magnolia_mock/:brand/:page/:locale' => sub {
  my $self = shift;

  my ($brand, $page, $locale) = ($self->param('brand'), $self->param('page'), $self->param('locale'));
  my @tokens = _get_tokens($brand, $locale, $page);

  $self->stash(tokens => $tokens[0]);
  $self->render('magnolia_mockbrandpagelocale', { brand  => $brand, page => $page, locale => $locale, });
};

get '/magnolia_mock2/save/:id/:value' => sub {
  my $self = shift;

say "in magnolia_mock2/save";

  my $token_id    = $self->param('id');
  my $token_value = uri_unescape($self->param('value'));

  my $token = $tokens_table->find_one({_id => MongoDB::OID->new(value => $token_id)});

  say "\t old value = $token->{value}";

  $tokens_table->update( { _id => MongoDB::OID->new(value => $token_id) }, { '$set' => { value => $token_value } } );
  my $token_after = $tokens_table->find_one({ _id => MongoDB::OID->new(value => $token_id) });

  say "\t new value = $token_after->{value}";

  $self->render(json => { id => $token_id, value => $token_after->{value}, value_fr => $token_after->{value_fr}});

};

get '/magnolia_api_mock/:brand/:locale' => sub {
  my $self = shift;

 say ">>> brand = "  . $self->param('brand');
 say ">>> locale = " . $self->param('locale');

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
	if ($locale) {
		$search->{locale} = $locale;
	}
	if ($page) {
		$search->{page} = $page;
	}

	print Dumper($search);

    my $tokens_on_demand = $tokens_table->find($search);

	my $found4page 	= [];
	my $json  	= {};

	while (my $page_token = $tokens_on_demand->next) {
		my $name = $page_token->{token}; 
		$name    =~ s/_/./; 
		my $token = { 
			   name   => $name,
			   value  => $page_token->{value},
			   id	  => $page_token->{_id}{value},
			 };
		push @$found4page, $token if $page && $page eq $page_token->{page};

        my $page = ($page_token->{page} eq 'global') ? '' : $page_token->{page} . '/';
        my $magnolia_page = '/' . $page_token->{website} . '/my/checkout/' . $page;

		$json->{ $magnolia_page }{ $name }{ value } = $page_token->{value};
	}
	
	return ($found4page, $json);
}

app->start;
__DATA__

@@ magnolia_mockbrandpagelocale.html.ep

<!DOCTYPE html>
<html>
  <head>
  <title>Mock Magnolia - Mojolicious rocks!</title>
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

  <script>
	$(document).ready(function() {
		  $(".update_token").click(function(){
			var token_id   = $(this).attr('token_id');
			var token_value=$("input[id='" + token_id + "']").val();
			// alert(token_id  + ' - ' + token_value);
	
			var jqxhr = $.get( "http://127.0.0.1:3000/magnolia_mock2/save/" + token_id + '/' + encodeURI(token_value), function( data ) {
				alert(data);
		  	}).fail(function(jqxhr, error) { error });

		  }); 
	  }); 
  </script>
  </head>
  <body>

  <h2>Brand <%= $brand %> - Page <%= $page %> - Locale <%= $locale %></h2>

	<table>
		% for my $token (@$tokens) {
		<tr>
  			<td><%= $token->{name} %></td>
			<td><input id="<%=$token->{id} %>" type="text" value="<%= $token->{value} %>"></td>
			<td><button class="update_token" token_id="<%= $token->{id} %>">Update</button></td>
		</tr>
		% }
	</table>

  </body>
</html>
