#!/usr/bin/perl

###############################################################################
# @file build.pl
# @brief Load Build Script
#
# Related Files:
# @li build.xml - Load Build Schema
# @li build.template - Makefile Template
#
# Copyright (C) 2011 Lissy Lau <Lissy.Lau@gmail.com>
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
    my $class = shift;

    my $self = [0, undef, 0, 0, 1, {}, {}, {}];

    bless $self, $class;
}

package BuildElement;

sub new
{
    my $class = shift;
    my $self = [0, "", 0, {}];
    bless $self, $class;
}

package main;

use strict;
use English;
use Switch;

use constant
{
    COUNT  => 0,
    MINLEV => 1,
    SEEN   => 2,
    CHARS  => 3,
    EMPTY  => 4,
    PTAB   => 5,
    KTAB   => 6,
    ATAB   => 7,
};

use constant
{
    BUILD     => 0,
    CATEGORY  => 1,
    COMPONENT => 2,
    MODULE    => 3,
};

use constant
{
    TYPE  => 0,
    PATH  => 1,
    BUILD => 2,
    CHILD => 3,
};

my %elements;
my $seen = 0;
my $root;

my %buildelements;
my %buildcategories;
my %buildcomponents;
my %buildmodules;
my $buildroot;

my $TOPDIR = "..";
my $file = "build.xml";

my $subform = '      @<<<<<<<<<<<<<<<      @>>>>';

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

set_minlev($root, 0);

my $elem;

foreach $elem (sort bystruct keys %elements)
{
    my $ref = $elements{$elem};
    print "\n================\n$elem: ", $ref->[COUNT], "\n";
    print "Had ", $ref->[CHARS], " bytes of character data\n"
        if $ref->[CHARS];
    print "Always empty\n"
        if $ref->[EMPTY];

    showtab('Parents', $ref->[PTAB], 0);
    showtab('Children', $ref->[KTAB], 1);
    showtab('Attributes', $ref->[ATAB], 0);
}

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

    my $eleminfo = $elements{$tag};

    if (not defined($eleminfo))
    {
        $elements{$tag} = $eleminfo = new ElemInfo;
        $eleminfo->[SEEN] = $seen++;
    }

    $eleminfo->[COUNT]++;

    my $partab = $eleminfo->[PTAB];

    my $parent = $e->current_element;
    if (defined($parent))
    {
        $partab->{$parent}++;
        my $pinfo = $elements{$parent};

        # Increment our slot in parent's child table
        $pinfo->[KTAB]->{$tag}++;
        $pinfo->[EMPTY] = 0;
    }
    else
    {
        $root = $tag;
        # Me
        $buildroot = new BuildElement;
        $buildroot->[TYPE] = BUILD;
    }

    # Deal with attributes

    my $atab = $eleminfo->[ATAB];

    #while (@_)
    #{
    #    my $att = shift;
        
    #    $atab->{$att}++;
    #    shift;  # Throw away value
    #}

    my $buildelem = $buildelements{$attr{name}};
    if (not defined $buildelem)
    {
        $buildelements{$attr{name}} = $buildelem = new BuildElement;
        $buildelem->[PATH] = $attr{path};
    }
    else
    {
        print "Duplicated build element ($attr{name}) is found.\n";
    }

    switch ($tag)
    {
        case "Build"
        {
            print "Start building $attr{name} ...\n";
        }
        case "Category"
        {
            my $buildcategory = $buildcategories{$attr{name}};
            if (not defined $buildcategory)
            {
                $buildcategories{$attr{name}} = $buildcategory = new BuildElement;
                $buildcategory->[TYPE] = CATEGORY;
                $buildcategory->[PATH] = $attr{path};
            }
            else
            {
                print "Duplicated build category ($attr{name}) is found.\n";
            }
            print "# Building Category $attr{name} at $TOPDIR/$attr{path} ...\n";
        }
        case "Component"
        {
            print "## Building Component $attr{name} ...\n";
        }
        case "Module"
        {
            print "### Building Module $attr{name} ...\n";
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

sub set_minlev
{
    my ($el, $lev) = @_;

    my $eleminfo = $elements{$el};
    if (! defined($eleminfo->[MINLEV]) or $eleminfo->[MINLEV] > $lev)
    {
        my $newlev = $lev + 1;

        $eleminfo->[MINLEV] = $lev;
        foreach (keys %{$eleminfo->[KTAB]})
        {
            set_minlev($_, $newlev);
        }
    }
}

sub bystruct
{
    my $refa = $elements{$a};
    my $refb = $elements{$b};

    $refa->[MINLEV] <=> $refb->[MINLEV] or $refa->[SEEN] <=> $refb->[SEEN];
}

sub showtab
{
    my ($title, $table, $dosum) = @_;

    my @list = sort keys %{$table};

    if (@list)
    {
        print "\n   $title:\n";

        my $item;
        my $sum = 0;
        foreach $item (@list)
        {
            my $cnt = $table->{$item};
            $sum += $cnt;
            formline($subform, $item, $cnt);
            print $ACCUMULATOR, "\n";
            $ACCUMULATOR = '';
        }

        if ($dosum and @list > 1)
        {
            print  "                            =====\n";
            formline($subform, '', $sum);
            print $ACCUMULATOR, "\n";
            $ACCUMULATOR = '';
        }
    }
}

sub print_summary
{
    $cnt_category  = $elements{Category}->[COUNT];
    $cnt_component = $elements{Component}->[COUNT];
    $cnt_module    = $elements{Module}->[COUNT];

    print "\n===== Build Summary =====\n\n";
    print "Categories:  $cnt_category\n";
    print "Components:  $cnt_component\n";
    print "Modules:     $cnt_module\n\n";
}

