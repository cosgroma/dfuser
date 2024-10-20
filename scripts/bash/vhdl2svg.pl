#!/usr/bin/perl
#===============================================================================
#
#  FILE:        vhdl2svg.pl
#
#  USAGE:       ./vhdl2svg.pl <VHDL-FILENAME> <SVG-FILENAME>
#
#  DESCRIPTION: this perl scripts takes an VHDL file as input, parses the entity port declaration and creates a svg image from it
#
# OPTIONS:      <VHDL-FILENAME> <SVG-FILENAME>
# REQUIREMENTS: PERL SVG Module
# BUGS:         ---
# NOTES:        ---
# AUTHOR:       Dominik Meyer <dmeyer@federationhq.de>
# COMPANY:      private
# VERSION:      0.1
# CREATED:      20.02.2014 21:00:41 CET
# LICENSE:	GPLv2
#===============================================================================
use strict;
use warnings;
use SVG;


#===  FUNCTION  ================================================================
#  NAME:        usage
#  PURPOSE:     print usage information
#  DESCRIPTION: none
#  PARAMETERS:  none
#  RETURNS:     none
#===============================================================================
sub usage {
	print "USAGE: vhdl2svg.pl <vhdl-filename> <svg-filename>\n";
	print "\n";
	print "vhdl-filename\t- filename of the VHDL file to parse\n";
	print "svg-filename\t- filename of the SVG File to create. Existing File will be overwritten\n";
}


#===  FUNCTION  ================================================================
#  NAME:        getPorts
#  PURPOSE:     get the port definition from a VHDL File
#  DESCRIPTION: describtion
#  PARAMETERS:  filename of the vhdl file
#  RETURNS:     array of hashrefs, each representing one port
#===============================================================================
sub getPorts {
    my $file=shift;
    my @ports;

    if (!defined($ARGV[0])) {
    	usage();
    	die("");
    }

    if (!defined($ARGV[1])) {
        usage();
        die("");
    }

    if ( ! -e $file) {
        die("VHDL file does not exists !");
    }


    my $portFound=0;
    my $entity="";
    open my $fh, "< " . $file;
    while (my $line=<$fh>) {

        # just save the entity name for later usage
        if ($line =~ /entity\s+([a-zA-Z0-9\-\_]+)\s+is/) {
            $entity=$1;
        }

        # if we are within a port declaration
        if ($portFound==1) {

            if ($line=~/^\s+([a-zA-Z\_\-0-9]+)\s*:\s*(in|out|inout)\s+([a-zA-Z\s0-9\_\(\)]+)/) {
                my %port;
                $port{name}=$1;
                $port{dir}=lc($2);
                $port{type}=lc($3);
                $port{type}=~s/;//;
                $port{entity}=$entity;

                push(@ports,\%port);
            }

        }

        #search for a port declaration
        if (lc($line)=~/\sport\s*\(/) {
            $portFound=1;
        }

        #search for a end of port declaration
        if ($portFound==1 && lc($line)=~/\s\);/) {
            $portFound=9;
        }

    }

    close $fh;

    return @ports;
}

#===  FUNCTION  ================================================================
#  NAME:        drawSVG
#  PURPOSE:     draw a SVG Image
#  DESCRIPTION: draws a SVG Images using the given port declarations
#  PARAMETERS:  reference to port list, output file name
#  RETURNS:     nothing
#===============================================================================
sub drawSVG {
    my $ports_ref=shift;
    my @ports=@{$ports_ref};
    my $file=shift;

    # calculate svg sizes
    my $border=300;
    my $maxwidth=600;
    my $name_font_size=30;
    my $signal_font_size=20;
    my $type_font_size=15;
    my $component_height=@ports*30;
    my $component_width=$component_height;
    if ($component_width>$maxwidth) {
    	$component_width=$maxwidth;
    }



    if (-e $file) {
        warn("SVG file already exist");
    }

    my $svg= SVG->new(width=>$component_width+2*$border,height=>$component_height+2*$border);
    my $component = $svg->rectangle(
       x=>$border, y=>$border,
       width=>$component_width, height=>$component_height,
       rx=>5.2, ry=>2.4,
       id=>"component",
       style=>{
                   'stroke'=>'black',
                   'stroke-width'=>'2',
                   'stroke-opacity'=>'1.0',
                   'fill' => 'white'
                   #'fill-opacity'=>'1.0'
               }

    );

     my $text1 = $svg->text(
               id=>'name', x=>$border+$component_width/2,
               y=>$border+$component_height/2+$name_font_size/2-2,
               style     => {
                   'font'      => 'sans',
                   'font-size' => $name_font_size,
                   'fill'      => 'black',
                   'text-anchor'=> 'middle'
               },
           )->cdata($ports[0]->{entity});


    my $nr=0;
    my $swap=0;
    my $x=$border;
    my $y=$border+30;
    for my $p (@ports) {

        $svg->line(
               id=>'port' . $nr,

               x1=>$x-100, y1=>$y,
               x2=>$x, y2=>$y,
               style=>{
                   'stroke'=>'black',
                   'stroke-width'=>'2',
                   'stroke-opacity'=>'1.0',
                   'fill' => 'black'
                   #'fill-opacity'=>'1.0'
               }
           );

        if ($swap == 0 && ($p->{dir} eq "in" || $p->{dir} eq "inout") ) {
            $svg->line(
                   x1=>$x-15, y1=>$y-10,
                   x2=>$x, y2=>$y,
                   style=>{
                       'stroke'=>'black',
                       'stroke-width'=>'2',
                       'stroke-opacity'=>'1.0',
                       'fill' => 'black'
                   }
               );

           $svg->line(
                   x1=>$x-15, y1=>$y+10,
                   x2=>$x, y2=>$y,
                   style=>{
                       'stroke'=>'black',
                       'stroke-width'=>'2',
                       'stroke-opacity'=>'1.0',
                       'fill' => 'black'
                   }
               );
        }

        if ($swap == 0 && ($p->{dir} eq "out" || $p->{dir} eq "inout") ) {
            $svg->line(
                   x1=>$x-(100-15), y1=>$y-10,
                   x2=>$x-100, y2=>$y,
                   style=>{
                       'stroke'=>'black',
                       'stroke-width'=>'2',
                       'stroke-opacity'=>'1.0',
                       'fill' => 'black'
                   }
               );

           $svg->line(
                   x1=>$x-(100-15), y1=>$y+10,
                   x2=>$x-100, y2=>$y,
                   style=>{
                       'stroke'=>'black',
                       'stroke-width'=>'2',
                       'stroke-opacity'=>'1.0',
                       'fill' => 'black'
                   }
               );
        }

        if ($swap == 1 && ( $p->{dir} eq "in" || $p->{dir} eq "inout")) {
            $svg->line(
                   x1=>$x-(100-15), y1=>$y-10,
                   x2=>$x-100, y2=>$y,
                   style=>{
                       'stroke'=>'black',
                       'stroke-width'=>'2',
                       'stroke-opacity'=>'1.0',
                       'fill' => 'black'
                   }
               );

           $svg->line(
                   x1=>$x-(100-15), y1=>$y+10,
                   x2=>$x-100, y2=>$y,
                   style=>{
                       'stroke'=>'black',
                       'stroke-width'=>'2',
                       'stroke-opacity'=>'1.0',
                       'fill' => 'black'
                   }
               );
        }

        if ($swap == 1 && ($p->{dir} eq "out" || $p->{dir} eq "inout" ) ) {
            $svg->line(
                   x1=>$x-15, y1=>$y-10,
                   x2=>$x, y2=>$y,
                   style=>{
                       'stroke'=>'black',
                       'stroke-width'=>'2',
                       'stroke-opacity'=>'1.0',
                       'fill' => 'black'
                   }
               );

           $svg->line(
                   x1=>$x-15, y1=>$y+10,
                   x2=>$x, y2=>$y,
                   style=>{
                       'stroke'=>'black',
                       'stroke-width'=>'2',
                       'stroke-opacity'=>'1.0',
                       'fill' => 'black'
                   }
               );
        }


        if ($p->{type}=~/std_logic_vector\(\s*(\d+)\s*downto\s(\d+)\s*\)/) {

            my $count=0;
            for(my $i=$2; $i<=$1; $i++) {
                $count++;
            }


            $svg->line(
                   x1=>$x-55, y1=>$y+10,
                   x2=>$x-35, y2=>$y-10,
                   style=>{
                       'stroke'=>'black',
                       'stroke-width'=>'2',
                       'stroke-opacity'=>'1.0',
                       'fill' => 'black'
                   }
               );

          $svg->text(
               x=>$x-45,
               y=>$y-15,
               style     => {
                   'font'      => 'sans',
                   'font-size' => $type_font_size,
                   'fill'      => 'black',
                   'text-anchor'=> "middle"
               },
           )->cdata($count);


        }


        my $text_x_type=$x-110;
        my $text_x_name=$x-110;
        my $text_anchor="end";
        if ($swap == 1) {
            $text_x_type=$x+10;
            $text_x_name=$x+10;
            $text_anchor="start";
        }

        $svg->text(
               id=>'text_'.$nr, x=>$text_x_name,
               y=>$y+2,
               style     => {
                   'font'      => 'sans',
                   'font-size' => $signal_font_size,
                   'fill'      => 'black',
                   'text-anchor'=> $text_anchor
               },
           )->cdata($p->{name});



        #$svg->text(
        #       id=>'type_'.$nr, x=>$text_x_type,
        #       y=>$y+3,
        #       style     => {
        #           'font'      => 'sans',
        #           'font-size' => $type_font_size,
        #           'fill'      => 'black',
        #           'text-anchor'=> $text_anchor
        #       },
        #   )->cdata($p->{type});


        $y+=60;
        $nr++;
        if ($nr>= @ports/2 && $swap==0) {
           $x=$border+$component_width+100;
           $y=$border+30;
           $swap=1;
        }
    }


    open my $fh,">" . $file;
    print $fh $svg->xmlify;
    close $fh;


}

#
# main program
#

my @ports=getPorts($ARGV[0]);

drawSVG(\@ports, $ARGV[1]);

