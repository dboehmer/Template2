#============================================================= -*-perl-*-
#
# t/strict.t
#
# Test strict mode.
#
# Written by Andy Wardley <abw@wardley.org>
#
# Copyright (C) 1996-2009 Andy Wardley.  All Rights Reserved.
#
# This is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.
#
#========================================================================

use strict;
use warnings;
use lib qw( ../lib );
use Template;
use Template::Test;

local $Template::Config::STASH = 'Template::Stash';

test_expect(
    \*DATA, 
    { STRICT => 1 }, 
    { foo => 10, bar => undef, baz => { boz => undef }, empty => '' }
);

__DATA__
-- test --
-- name defined variable --
[% foo %]
-- expect --
10

-- test --
-- name variable with empty string --
[% empty %]
-- expect --
# empty output

-- test --
-- name inexistent variable --
[% TRY; bla; CATCH; error; END %]
-- expect --
var.inexistent error - inexistent variable: bla

-- test --
-- name undefined variable --
[%# TRY; bar; CATCH; error; END %]
[% bar %]
-- expect --
# TODO warning
# empty string

-- test --
-- name existence of inexistent variable --
[% TRY; IF bla.exists; 'true'; ELSE; 'false'; END; CATCH; error; END %]
-- expect --
false

-- test --
-- name definedness of inexistent variable --
[% TRY; IF bla.defined; 'true'; ELSE; 'false'; END; CATCH; error; END %]
-- expect --
var.inexistent error - inexistent variable: bla.defined

-- test --
-- name definedness of undefined variable --
[% IF bar.defined; 'true'; ELSE; 'false'; END %]
-- expect --
false

-- test --
-- name truthiness of undefined variable --
[% IF bar; 'true'; ELSE; 'false'; END %]
-- expect --
false

-- test --
-- name truthiness of inexistent variable --
[% TRY; IF bla; 'true'; ELSE; 'false'; END; CATCH; error; END %]
-- expect --
var.inexistent error - inexistent variable: bla
