#!/usr/local/bin/perl

#$B=i4|@_Dj(J

$rfile_of_team_html = "my_group.html";
$rfile_of_top_group_html = "top_groups.html";
$rfile_of_current_date = "current_date.dat";
$rwfile_of_data = "my_setidata.dat";
$wfile_of_result_html = "stat.html";

@address_of_team_members = (1,2,1);
@address_of_team_result_received = (1,3,1);
@address_of_team_total_CPU_time = (1,4,1);
@address_of_toprank_reUnits = (0,3,100);

##################################################################
#
#get team stat
#
##################################################################


#$B%A!<%`(JstatHTML$B$+$i%F!<%V%k$NH4$-<h$j(J
@tables = &table_from_HTML($rfile_of_team_html);

#$BH4$-<h$C$?%F!<%V%k$r#3<!852=(J
@tables = &tables_to_3d_array(@tables);

###############################
###debug######################
#print "$tables[1]->[2]->[1]\n";
#print "\n\n-----getten$B$&$,(J----\n\n\n";
#&debug_print_3d_array(@tables);
#print "\n\n-----getten$B$&$,(J----\n\n\n";
#
##############################

#$B3F%a%s%P!<$r<hF@(J
$team_members = &get_member(@address_of_team_members,@tables);
$team_result_received = &get_member(@address_of_team_result_received ,@tables);
$team_total_CPU_time = &get_member(@address_of_team_total_CPU_time ,@tables);

############################
#debug######################
#print $team_members;
#print $team_result_received;
#print $team_total_CPU_time;
#############################

##################################################################
#
#get stat of lank 100
#
##################################################################

@tables = &table_from_HTML($rfile_of_top_group_html);
@tables = &tables_to_3d_array(@tables);

$rank100_reUnits = &get_member(@address_of_toprank_reUnits,@tables);

###
#get statdate
###
open (datefile ,$rfile_of_current_date);
while(<datefile>){
  $current_date = $_;
  last;
}

###
#write stat
###

open (statfile,'>>' . $rwfile_of_data);
print statfile << EOF;

---start $


#&read_stat;
#&make_html;
#exit;

#$BEO$5$l$?(JHTML$B%U%!%$%k$+$i!"%F!<%V%kItJ,$rH4$-<h$jG[Ns$K$$$l$k!#(J

sub table_from_HTML{
#print "hello\n";
#print "$_[0]\n";

  my($in_table,$tabletext,@tabletext_array);
  open (HTML ,"$_[0]");
  $in_table = 0;
  $tabletext ="";
  $/ = ">";
  while(<HTML>){
	s/\n//;
	$in_table = 1 if $_ =~ m|.*<table.*|;
	
	if ($in_table == 1) {
	  #	if ($first_line == 0) {
	  #	  $first_line = 0;
	  #	  s/.*(<table.*>)$/$1/;
	  #	  $tabletext = $_;
	  #	}else{
	
	  unless (m|.*</table.*|) {
		
		$tabletext = $tabletext . $_;
		#print "now in unless\n";
	  }else{
		
		$in_table = 0;
		#$first_line = 1;
		
		$tabletext = $tabletext . $_;
		
		@tabletext_array = (@tabletext_array ,$tabletext);
		$tabletext = "";
		#print "now in unless else\n";
		
	  }
	  #  }
	}
  }
close (HTML);
@tabletext_array;
}

#$BF~NO$5$l$?0l<!85$N%F!<%V%kG[Ns$r%F!<%V%k!"Ns!"%;%k$N#3<!85$NG[Ns$K$7$FJV$9!#(J
sub tables_to_3d_array{
  my(@in,@lines,@cells,@lines_with_cells,@tables_with_lines);
	
  @in = @_;
  #$, = "\n\n";
  #print @in;

  foreach (@in) {
	@lines = split (m!</tr>!);
	
	foreach(@lines){
	
	  #print @lines;
	  @cells = split (m!</th>|</td>!);
	  #print @cells;
	  $ref_2d = [@$ref_2d,[@cells]];
	  #print $@lines_with_cells;
	}
	@tables_with_lines = (@tables_with_lines,[@$ref_2d]);
	$ref_2d = "";
  }




  foreach (@tables_with_lines) {
	foreach (@$_) {
	  foreach (@$_) {
		
		s!<th>|</th>|<tr>|</tr>|<td>|</td>|<table.*>|</table.*>!!g;
	  }
	}
  }
  @tables_with_lines;
}

#$B#3<!85$NG[Ns$+$i;XDj$5$l$?%"%I%l%9$N0l<!85$N%a%s%P!<$r<h$j=P$9!#(J
sub get_member{
  local ($a, $b ,$c , @my_3d_array)= @_;
  my ($mymember);

  print @my_address;
  $mymember=$my_3d_array[$a]->[$b]->[$c];
  $mymember;
}
##$B;0<!85$NG[Ns$+$i;XDj$5$l$?%"%I%l%9$N#2<!85$NG[Ns$N%a%s%P!<$N%3%T!<$rJV$9!#(J
#sub get_lines{
#  my($my_table_number ,$my_offset, @my_3d_array)= @_;
#  my(@lines);

#  $
#}
sub read_stat{


}

sub make_html{

}





sub debug_print_3d_array{

  my(@in);

  @in = @_;
	foreach (@in) {
	  foreach (@$_) {
		foreach (@$_) {
		  print $_ . "->->->->->";
		}
		print "\n";
	  }
	  print "\n_____ end table_____\n\n-----begin table----\n";
	}

}
