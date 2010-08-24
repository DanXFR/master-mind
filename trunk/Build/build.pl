#!/usr/bin/perl

###############################################################################
# @file build.pl
# @brief Load Build Script
#
# Related Files:
# @li build.xml - Load Build Schema
# @li build.template - Makefile Template
#
# Copyright (C) 2009 Lissy Lau <Lissy.Lau@gmail.com>
#
# MasterMind is free software: you can redistribute it and / or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
###############################################################################

# http://blog.csdn.net/tq02h2a/archive/2008/09/06/2892898.aspx
# http://search.cpan.org/~msergeant/XML-Parser-2.36/Parser.pm#Element_(Expat,_Name,_Model)
# http://search.cpan.org/~msergeant/XML-Parser-2.36/Expat/Expat.pm#XML::Parser::ContentModel_Methods
# http://blog.chinaunix.net/u/5958/showart_406680.html

package ElemInfo;

sub new
{
    my ($class) = @_;

    my $self =
    {
        _name       => undef,
        _idx        => undef,
        _components => undef
    };

    bless $self, $class;
    return $self;
}

package main;

use strict;
use XML::Parser;
use Switch;

my $TOPDIR = "..";
my $file = "$TOPDIR/Build/build.xml";

die "Can't find file \"$file\"" unless -f $file;

my $cnt_category  = 0;
my $cnt_component = 0;
my $cnt_module    = 0;

my $parser = new XML::Parser(Style        => 'Tree',
                             ErrorContext => 2);

$parser->setHandlers(Init    => \&init_handler,        # StartDocument
                     Start   => \&start_handler,       # StartTag
                     Char    => \&char_handler,        # Text
                     End     => \&end_handler,         # EndTag
                     Final   => \&final_handler,       # EndDocument
                     Proc    => \&proc_handler,        # Proc
                     Comment => \&comment_handler,     # Comment
		     Default => \&default_handler);    # Default

$parser->parsefile($file);

my $line     = 0;
my $col      = 0;
my $elem_idx = 0;

print_summary();

###############################################################################
# End of Main
###############################################################################

sub init_handler
{
    my $e = shift;

    print "\nProcessing load build schema $file ...\n\n"
}

sub start_handler
{
    my ($e, $tag, %attr) = @_; 

    $line     = $e->current_line;
    $col      = $e->current_column;
    $elem_idx = $e->element_index;

    switch ($tag)
    {
        case "Build"
        {
            print "Start building $attr{name} ...\n";
        }
        case "Category"
        {
            print "# Building Category $attr{name} ...\n";
            $cnt_category++;
        }
        case "Component"
        {
            print "## Building Component $attr{name} ...\n";
            $cnt_component++;
        }
        case "Module"
        {
            print "### Building Module $attr{name} ...\n";
            $cnt_module++;
        }
        else
        {
            print "ERROR: Unexpected TAG is found!\n";
        }
    }
}

sub char_handler
{
    my ($e, $string) = @_;

    # Do nothing
}

sub end_handler
{
    my ($e, $tag, %attr) = @_; 

    # Do nothing
}

sub final_handler
{
    my $e = shift;

    print "\nBuild completed!\n";
}

sub proc_handler
{
    # Do nothing
}

sub comment_handler
{
    my ($e, $data) = @_;

    # Do nothing
}

sub default_handler
{
    my ($e, $data) = @_;

    # Do nothing
}

sub print_summary
{
    print "\n===== Build Summary =====\n\n";
    print "Categories:  $cnt_category\n";
    print "Components:  $cnt_component\n";
    print "Modules:     $cnt_module\n\n";
}

