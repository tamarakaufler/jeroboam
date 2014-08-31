#!/usr/bin/perl
use v5.14;
use autodie;

use MongoDB;
use MongoDB::OID;

use Data::Dumper qw(Dumper);

## connect to mongodb,database uc_token_translations db
##	properties: token, brand, page, locale, value

my $mongo_conn   = MongoDB::Connection->new;
my $mongo_db 	 = $mongo_conn->uc_token_translations;
my $tokens_table = $mongo_db->tokens;

my $tokens_on_demand = $tokens_table->find({ brand => 'default',
                                       page  => 'billing',
                                       locale => 'en' });

while (my $page_tokens = $tokens_on_demand->next) {
	say Dumper($page_tokens);
}

#exit;

##==============================================================

my $uc_base    = '/my/checkout/';
my $brand_info = { 
                    brand   => 'default',
                    website => 'photobox.com',
                 };
my $page_base = "/" . $brand_info->{website} . $uc_base;

my $input = {
           "global" => 
                { 
                  "CURRENCY.SYMBOL" => "£££",
                  "CURRENCY.POSITION" => "BEFORE",
                  "CURRENCY.SYMBOL_ISO_4217" => "GBP",
                  "TOKENS_LIVE_CHAT" => "I am so chatty",
                  "URLS_TERMS" => "I shall deal with you on my terms",
                  "META_PHONE_NUMBER" => "Call us!!!",
                  "META_EULARIAN" => "photobox-uk",
		        "ERRORS.NO_BASKET" => "There is no basket!!",
		        "ERRORS.NOT_LOGGED_IN" => "Log in, you rascal :O",
		        "ERRORS.MISMATCH_PASSWORD" => "They are different!!",
		        "ERRORS.EMPTY_BASKET" => "Why is your basket empty!!",
                  "TOKENS_PROGRESS_BAR_STAGE_1" => "Clubs",
                  "TOKENS_PROGRESS_BAR_STAGE_2" => "Spades",
                  "TOKENS_PROGRESS_BAR_STAGE_3" => "Hearts",
                  "TOKENS_PROGRESS_BAR_STAGE_4" => "Diamonds",
                  "TOKENS_PROGRESS_BAR_STAGE_5" => "Stars",
                },  
             "billing" =>
                {   
                  "CURRENCY.SYMBOL" => "£££",
                  "CURRENCY.POSITION" => "BEFORE",
                  "CURRENCY.SYMBOL_ISO_4217" => "GBP",
                  "TOKENS_LIVE_CHAT" => "I am so chatty",
                  "URLS_TERMS" => "I shall deal with you on my terms",
                  "META_PHONE_NUMBER" => "Call us!!!",
                  "META_EULARIAN" => "photobox-uk",
		        "ERRORS.NO_BASKET" => "There is no basket!!",
		        "ERRORS.NOT_LOGGED_IN" => "Log in, you rascal :O",
		        "ERRORS.MISMATCH_PASSWORD" => "They are different!!",
		        "ERRORS.EMPTY_BASKET" => "Why is your basket empty!!",
                  "TOKENS_PROGRESS_BAR_STAGE_1" => "Clubs",
                  "TOKENS_PROGRESS_BAR_STAGE_2" => "Spades",
                  "TOKENS_PROGRESS_BAR_STAGE_3" => "Hearts",
                  "TOKENS_PROGRESS_BAR_STAGE_4" => "Diamonds",
                  "TOKENS_PROGRESS_BAR_STAGE_5" => "Stars",
                  "TOKENS_TITLE" => "I am a billing page",
                  "META_ORDER_NEXT_STEP" => "Head for hell ",
                  "FIELDS_POSTCODE" => "Hello - your postcode",
                  "META_FIND_ADDRESS" => "Let's search",
                  "META_MANUAL_INPUT_ADDRESS" => "Input your address or else ",
                  "META_AUTO_INPUT_ADDRESS" => "We can do it for you "
                },  
             "login" =>
                { 
                  "CURRENCY.SYMBOL" => "£££",
                  "CURRENCY.POSITION" => "BEFORE",
                  "CURRENCY.SYMBOL_ISO_4217" => "GBP",
                  "TOKENS_LIVE_CHAT" => "I am so chatty",
                  "URLS_TERMS" => "I shall deal with you on my terms",
                  "META_PHONE_NUMBER" => "Call us!!!",
                  "META_EULARIAN" => "photobox-uk",
		        "ERRORS.NO_BASKET" => "There is no basket!!",
		        "ERRORS.NOT_LOGGED_IN" => "Log in, you rascal :O",
		        "ERRORS.MISMATCH_PASSWORD" => "They are different!!",
		        "ERRORS.EMPTY_BASKET" => "Why is your basket empty!!",
                  "TOKENS_PROGRESS_BAR_STAGE_1" => "Clubs",
                  "TOKENS_PROGRESS_BAR_STAGE_2" => "Spades",
                  "TOKENS_PROGRESS_BAR_STAGE_3" => "Hearts",
                  "TOKENS_PROGRESS_BAR_STAGE_4" => "Diamonds",
                  "TOKENS_PROGRESS_BAR_STAGE_5" => "Stars",
                "TOKENS_TITLE" => "I am a login page",
                  "META_SHIPPING" => "I am Shipping",
                  "META_ITEM_SINGLE" => "I am single item",
                  "FIELD_EMAIL" => "Your email please",
                  "FIELD_PASSWORD" => "Your password please"
                },  
             "deliverymethods" =>
                {   
                  "CURRENCY.SYMBOL" => "£££",
                  "CURRENCY.POSITION" => "BEFORE",
                  "CURRENCY.SYMBOL_ISO_4217" => "GBP",
                  "TOKENS_LIVE_CHAT" => "I am so chatty",
                  "URLS_TERMS" => "I shall deal with you on my terms",
                  "META_PHONE_NUMBER" => "Call us!!!",
                  "META_EULARIAN" => "photobox-uk",
		        "ERRORS.NO_BASKET" => "There is no basket!!",
		        "ERRORS.NOT_LOGGED_IN" => "Log in, you rascal :O",
		        "ERRORS.MISMATCH_PASSWORD" => "They are different!!",
		        "ERRORS.EMPTY_BASKET" => "Why is your basket empty!!",
                  "TOKENS_PROGRESS_BAR_STAGE_1" => "Clubs",
                  "TOKENS_PROGRESS_BAR_STAGE_2" => "Spades",
                  "TOKENS_PROGRESS_BAR_STAGE_3" => "Hearts",
                  "TOKENS_PROGRESS_BAR_STAGE_4" => "Diamonds",
                  "TOKENS_PROGRESS_BAR_STAGE_5" => "Stars",
                  "META_SHIPPING" => "I am Shipping",
                  "META_ITEM_SINGLE" => "I am that"
                },
             "delivery" =>
                {
                  "CURRENCY.SYMBOL" => "£££",
                  "CURRENCY.POSITION" => "BEFORE",
                  "CURRENCY.SYMBOL_ISO_4217" => "GBP",
                  "TOKENS_LIVE_CHAT" => "I am so chatty",
                  "URLS_TERMS" => "I shall deal with you on my terms",
                  "META_PHONE_NUMBER" => "Call us!!!",
                  "META_EULARIAN" => "photobox-uk",
		        "ERRORS.NO_BASKET" => "There is no basket!!",
		        "ERRORS.NOT_LOGGED_IN" => "Log in, you rascal :O",
		        "ERRORS.MISMATCH_PASSWORD" => "They are different!!",
		        "ERRORS.EMPTY_BASKET" => "Why is your basket empty!!",
                  "TOKENS_PROGRESS_BAR_STAGE_1" => "Clubs",
                  "TOKENS_PROGRESS_BAR_STAGE_2" => "Spades",
                  "TOKENS_PROGRESS_BAR_STAGE_3" => "Hearts",
                  "TOKENS_PROGRESS_BAR_STAGE_4" => "Diamonds",
                  "TOKENS_PROGRESS_BAR_STAGE_5" => "Stars",
                  "META_DELIV_NEXT_STEP" => "Head for hell ",
                  "TOKENS_DELIVERY_TITLE" => "I am Funny Delivery",
                  "TOKENS_SELECT_DELIVERY" => "Really funny delivery",
                  "TOKENS_TITLE" => "I am a delivery page",
                  "TOKENS_BILLING_TITLE" => "I shall bill you",
                  "META_SHIPPING" => "I am Shipping3",
                  "META_ITEM_SINGLE" => "I am single item"
                },
             "review" =>
                {
                  "CURRENCY.SYMBOL" => "£££",
                  "CURRENCY.POSITION" => "BEFORE",
                  "CURRENCY.SYMBOL_ISO_4217" => "GBP",
                  "TOKENS_LIVE_CHAT" => "I am so chatty",
                  "URLS_TERMS" => "I shall deal with you on my terms",
                  "META_PHONE_NUMBER" => "Call us!!!",
                  "META_EULARIAN" => "photobox-uk",
		        "ERRORS.NO_BASKET" => "There is no basket!!",
		        "ERRORS.NOT_LOGGED_IN" => "Log in, you rascal :O",
		        "ERRORS.MISMATCH_PASSWORD" => "They are different!!",
		        "ERRORS.EMPTY_BASKET" => "Why is your basket empty!!",
                  "TOKENS_PROGRESS_BAR_STAGE_1" => "Clubs",
                  "TOKENS_PROGRESS_BAR_STAGE_2" => "Spades",
                  "TOKENS_PROGRESS_BAR_STAGE_3" => "Hearts",
                  "TOKENS_PROGRESS_BAR_STAGE_4" => "Diamonds",
                  "TOKENS_PROGRESS_BAR_STAGE_5" => "Stars",
                  "META_SUBMIT_PAYMENT" => "FIRE!!!!"
                },
             "address_lookup" =>
                {
                  "CURRENCY.SYMBOL" => "£££",
                  "CURRENCY.POSITION" => "BEFORE",
                  "CURRENCY.SYMBOL_ISO_4217" => "GBP",
                  "TOKENS_LIVE_CHAT" => "I am so chatty",
                  "URLS_TERMS" => "I shall deal with you on my terms",
                  "META_PHONE_NUMBER" => "Call us!!!",
                  "META_EULARIAN" => "photobox-uk",
		        "ERRORS.NO_BASKET" => "There is no basket!!",
		        "ERRORS.NOT_LOGGED_IN" => "Log in, you rascal :O",
		        "ERRORS.MISMATCH_PASSWORD" => "They are different!!",
		        "ERRORS.EMPTY_BASKET" => "Why is your basket empty!!",
                  "TOKENS_PROGRESS_BAR_STAGE_1" => "Clubs",
                  "TOKENS_PROGRESS_BAR_STAGE_2" => "Spades",
                  "TOKENS_PROGRESS_BAR_STAGE_3" => "Hearts",
                  "TOKENS_PROGRESS_BAR_STAGE_4" => "Diamonds",
                  "TOKENS_PROGRESS_BAR_STAGE_5" => "Stars",
                  "META_SELECT_YOUR_ADDRESS" => "SELECT your ADDRESS"
                },
             "addresses_add" =>
                {
                  "CURRENCY.SYMBOL" => "£££",
                  "CURRENCY.POSITION" => "BEFORE",
                  "CURRENCY.SYMBOL_ISO_4217" => "GBP",
                  "TOKENS_LIVE_CHAT" => "I am so chatty",
                  "URLS_TERMS" => "I shall deal with you on my terms",
                  "META_PHONE_NUMBER" => "Call us!!!",
                  "META_EULARIAN" => "photobox-uk",
		        "ERRORS.NO_BASKET" => "There is no basket!!",
		        "ERRORS.NOT_LOGGED_IN" => "Log in, you rascal :O",
		        "ERRORS.MISMATCH_PASSWORD" => "They are different!!",
		        "ERRORS.EMPTY_BASKET" => "Why is your basket empty!!",
                  "TOKENS_PROGRESS_BAR_STAGE_1" => "Clubs",
                  "TOKENS_PROGRESS_BAR_STAGE_2" => "Spades",
                  "TOKENS_PROGRESS_BAR_STAGE_3" => "Hearts",
                  "TOKENS_PROGRESS_BAR_STAGE_4" => "Diamonds",
                  "TOKENS_PROGRESS_BAR_STAGE_5" => "Stars",
                  "FIELDS_FIRST_NAME" => "Give me your first name, buster",
                  "FIELDS_FIRST_NAME" => "Give me your last name, buster",
                  "META_SAVE_ADDRESS" => "Now save it",
                  "META_FIND_ADDRESS" => "Where is my address? Fetch it!"
                }
            };

foreach my $page (keys %$input) {
	foreach my $token (keys %{$input->{$page}}) {
	    my $data = {
				"brand"  => 'default',
				"website"=> 'photobox.com',
				"page"   => $page,
				"locale" => 'en',
				"token"  => $token,
				"value"  => $input->{$page}{$token},
	    };
	    $tokens_table->insert($data);
	    $data = {
				"brand"  => 'default',
				"website"=> 'photobox.com',
				"page"   => $page,
				"locale" => 'fr',
				"token"  => $token,
				"value"  => "© " . $input->{$page}{$token},
	    };
	    $tokens_table->insert($data);
	}
}

