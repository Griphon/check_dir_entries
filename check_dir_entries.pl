#!/usr/bin/perl -w

# check_dir_entires.pl Copyright (C) 2015 Roman Garifullin <romaasis@gmail.com>
#
# Counts entries (optionally with regexp) of a directory. Checks it with thresholds
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# you should have received a copy of the GNU General Public License
# along with this program (or with Nagios);  if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA

use Nagios::Plugin;

my $np = Nagios::Plugin->new(
           usage => "Usage: %s [ -f|--filter <filter>]"
           . " [ -c|--critical=<threshold> ] [ -w|--warning=<threshold> ] path",
                            );

my @args = ({
              spec => 'filter|f=s',
              help => '--filter|-f <filter> list regular expression',
            },{
              spec => 'warning|w=s',
              help => '--warning|-w <threshold>',
            },{
              spec => 'critical|c=s',
              help => '--critical|-c <threshold>',
            });

foreach my $arg (@args) {
   $np->add_arg(%$arg);
}

$np->getopts;

defined($ARGV[0]) || $np->nagios_die("No path!");
opendir(my $dh, $ARGV[0]) || $np->nagios_die("can't opendir ${ARGV[0]}: $!");
my $filter = $np->opts->get("filter");
$filter = defined($filter) ? $filter : ".";
$dir_content = ( grep { /$filter/ && ! /^\./ } readdir($dh) ) + 0;
closedir $dh;
$np->nagios_exit( $np->check_threshold( $dir_content ), "$dir_content in ${ARGV[0]}" );

