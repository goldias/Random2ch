package linksFromHTML;
##
## linksFromHtml.pl
##
## �ѿ���ˤ���HTML�ɥ�����Ȥ���Link��ʬ��ȴ���Ф���
## <a href>...</a>�˰Ϥޤ줿�ƥ����Ȥ�key�Ȥ���Hash���֤���
##
## Tag������ɽ����HTML���Ф�������Υ��르�ꥺ��˴ؤ���
## http://www.din.or.jp/~ohzaki/perl.htm
## �򻲹ͤˤ�����
##
## 
## $Log: linksFromHtml.pl,v $
## Revision 1.1  2002/09/11 22:14:05  okada
## Initial revision
## 
## 
## 

require "./jcode.pl";


sub linksFromHTML{

	my($HTML,$tag_regex_,$comment_tag_regex,$tag_regex,$text_regex,
	   %Links,$boolInLink,$strTmpText,$strTmpTag,$strTmpName);
# See http://www.din.or.jp/~ohzaki/perl.htm#HTML_Tag
	$tag_regex_ = q{[^"'<>]*(?:"[^"]*"[^"'<>]*|'[^']*'[^"'<>]*)*(?:>|(?=<)|$(?!\n))}; #'}}}}
	$comment_tag_regex =
		'<!(?:--[^-]*-(?:[^-]+-)*?-(?:[^>-]*(?:-[^>-]+)*?)??)*(?:>|$(?!\n)|--.*$)';
	$tag_regex = qq{$comment_tag_regex|<$tag_regex_};
	$text_regex = q{[^<]*};
	#$http_url_regex = q{s?https?://[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#]+}; #'}}
	
	($HTML) = @_;
	jcode::convert(\$HTML, 'euc');
	
	%Links = ();
	
	$boolInLink = 0;
	while($HTML =~ /($text_regex)($tag_regex)?/gso){
		last if $1 eq '' and $2 eq '';
		$strTmpText = $1;
		$strTmpTag = $2;
		
		
		if($boolInLink){
			$strTmpName .= $strTmpText;
			if ($strTmpTag =~ /<\/a>/i){
				
				$Links{$strTmpName} = $strTmpUrl;

				$boolInLink = 0;				
				$strTmpText = "";
				$strTmpName = "";
				$strTmpUrl = "";
			}
		}elsif($strTmpTag =~ /^<a\shref.*=(\S+)>/i ){
			
			$strTmpUrl = $1;
			$strTmpUrl =~ s/"//g; #"
			$boolInLink = 1;
		}
	}

	%Links;
}





































