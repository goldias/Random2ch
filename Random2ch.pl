package Random2ch;
####
#### Random 2ch.pl
#### $Log: Random2ch.pl,v $
#### Revision 1.1  2002/09/11 22:14:06  okada
#### Initial revision
####
####
####

sub Random2ch{
	my($structMyThead);
##
## Preference
## 
	$urlBbsMenu = "http://www.ff.iij4u.or.jp/~ch2/bbsmenu.html";
	$pathWget ="/sw/bin/wget";
	$tmpdir = "./tmp/";
	$filePathHtmlBbsMenu = $tmpdir . "bbsmenu.html";
	$filePathHtmlSubBack = $tmpdir . "subback.html";
	
	%structMyThread = (
					   bordName   => '',
					   bordUrl    => '',
					   threadName => '',
					   threadUrl  => '',
					   );
	
	require "./linksFromHTML.pl";
	srand(time | $$); 
	
###
### main section
###

## Bord link from bbsmenu.html
##
	getFromHttp($urlBbsMenu , $filePathHtmlBbsMenu);
	open (BBSMENU, "$filePathHtmlBbsMenu");
	
	while(<BBSMENU>){
		$strHtmlTmp .= $_
		}
	close BBSMENU;
	%Bords = linksFromHTML::linksFromHTML($strHtmlTmp);
	$strHtmlTmp = "";
	
# remove needless member
#
	$regex2chUrl = q{^http://\S+\.2ch\.net/\S+};
	$regexBbspinkUrl = q{^http://\S+\.bbspink\.com/\S+};
	$regexNeedURL = qq{$regex2chUrl|$regexBbspinkUrl};
	
	while (($key,$value) = each %Bords){
		delete $Bords{$key} unless ($value =~ /$regexNeedURL/i);		
	}
	
	@keys = keys %Bords;
	
	$structMyThread{bordName} = @keys[rand(1000) % $#keys];
	
	$structMyThread{bordUrl} = $Bords{$structMyThread{bordName}};
	
## Thread link from subback.html
##
	getFromHttp( $structMyThread{bordUrl} ."subback.html" , $filePathHtmlSubBack);
	open(SUBBACK, "$filePathHtmlSubBack");
	while(<SUBBACK>){
		$strHtmlTmp .= $_;
	}
	close SUBBACK;
	%threads =  linksFromHTML::linksFromHTML( $strHtmlTmp );
	
	@keys = keys %threads;
	
	$structMyThread{threadName} = @keys[rand(2000) % $#keys];
	
	$strTmpThreadUrlSuffix = $threads{$structMyThread{threadName}};
			
	$structMyThread{threadUrl} = &makeThreadUrl($strTmpThreadUrlSuffix,$structMyThread{bordUrl}); 
	
	%structMyThread;
}
###
### sub routines
###

#
# Get from HTTP by wget
sub getFromHttp{
	my($url , $path) = @_;
	system ("$pathWget" , '-qO' , $path ,$url);  
}

#sub printHTML{
#	my(%structThread) = @_;
#	print %stuructThread;
#
#}
	  
sub makeThreadUrl{
	my($threadUrlSuffix,$bordUrl) = @_;
	my($strPartUrl,$threadUrlPre);
	$strPartUrl = "test/read.cgi/";
	$_ = $bordUrl;
	m|(^http://[^/]*/)([^/]*/)$|i;	

	$threadUrlPre = $1;
	$strBord = $2;
	$threadUrl = $threadUrlPre . $strPartUrl . $strBord . $threadUrlSuffix;
	$threadUrl;
}

1;
