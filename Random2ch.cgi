#!/usr/bin/perl

### Random2ch.cgi
### Random2ch�����ƥ�Υ��󥿡��ե�������ʬ
### $Log: Random2ch.cgi,v $
### Revision 1.1  2002/09/11 22:14:05  okada
### Initial revision
###
###
require "./Random2ch.pl";



open(HEAD, 'head.html');

while(<HEAD>){
	print;
}
close HEAD;

%structYourThread = Random2ch::Random2ch();

print <<EOF;
<p><a href=$structYourThread{bordUrl}>$structYourThread{bordName}</a>�Ĥ�
<a href=$structYourThread{threadUrl}>
$structYourThread{threadName}</a>����ؤ��äƤ�ä��㤤</p>
EOF


open(FOOT, 'foot.html');

while(<FOOT>){
	print;
}



