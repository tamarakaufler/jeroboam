jeroboam
========

miscellany of small web applications and web non related projects

Perl based
==========

TokensCMS:
---------
my first attempt at using Mojolicious application and NoSQL database

Mojolicious framework, MongoDB

Purpose:
provides mock input through an RESTful API for a work project while the system for providing the API was being built

Provides:
* script for populating Mongo database with tokens and their translations
* very basic GUI for updating token translations
* RESTful API for providing token translations for a specified brand/page/locale
                                    brand:  default
                                    page:   billing, delivery, addresses_add - show local page tokens
                                            global - shows global tokens
                                    locale: en, fr

VotingPoll:
----------

Perl, Catalyst, DBIx::Class, Template::Toolkit, MySQL, jQuery

Purpose:
use of Google visualization

Provides:
* basic GUI for a straw poll
* shows a pie chart of votes on a national and constituency level

Spreadsheet:
-----------

Perl, OOP, Moose
game.pl ... script to test the implementation 

SnapGame:
--------

Perl, OOP
game.pl ... play snap
(matching both value and suit is buggy)

