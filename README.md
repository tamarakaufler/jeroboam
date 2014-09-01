jeroboam
========

miscellany of small web applications

Perl based
==========

TokensCMS:
---------
my first Mojolicious application/NoSQL database

Mojolicious framework, MongoDB

Purpose:
implemented to provide mock input through an RESTful API for a Photobox Universal Checkout project while the system for providing the API was being built

Provides:
* script for populating Mongo database with tokens and their translations
* very basic GUI for updating token translations
* RESTful API for providing token translations for a specified brand/page/locale
                                    brand:  default
                                    page:   billing, delivery, address - show local page tokens
                                            global - shows global tokens
                                    locale: en, fr

VotingPoll:
----------

Catalyst application, MySQL

Purpose:
implemented to use Google visualization

Provides:
* basic GUI for a straw poll
* shows a pie chart of votes on a national and constituency level

