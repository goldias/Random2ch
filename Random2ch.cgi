#!/usr/bin/perl

### Random2ch.cgi
### Random2ch本体
### $Id: Random2ch.cgi,v 1.4 2002/10/13 08:36:52 okada Exp $
###
###
use Socket;
eval {require 'jcode.pl'}
or error('jcode.pl が見つかりません');

# 設定をハッシュにまとめた
my %option = (
			  httpPort     => 80,
			  nameSubback  => 'subback.html',
			  pathReadCgi  => 'test/read.cgi',
			  regexNeedUrl => qr{^http://(?:[^.]+\.)+(?:2ch\.net|bbspink\.com)/\S+/$}i,
			  replaceWords => [qw(BoardName BoardUrl ThreadName ThreadUrl)],
			  urlBbsmenu   => 'http://www.ff.iij4u.or.jp/~ch2/bbsmenu.html',
);

#################################################################################
sub resultHtml {
	return \<<'EOF';
Content-type: text/html; charset=EUC-JP

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html lang="ja">

<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=EUC-JP">
<title>Randam2ch:Link</title>
</head>
<body>
<h1>てきとーにスレを選びました</h1>
<hr>
	<p>
		<a href="__BoardUrl__">__BoardName__</a>板の
		<a href="__ThreadUrl__">__ThreadName__</a>スレへいってらっしゃい
	</p>
</body>
</html>
EOF
}

sub error {
	print <<EOF;
Content-type: text/html; charset=EUC-JP

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html lang="ja">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=EUC-JP">
<title>Randam2ch:error</title>
</head>
<body>
	<h1>エラー</h1>
	<hr>
	<p>@_</p>
</body>
</html>
EOF

exit;
}
#################################################################################

# 本体

sub getLinks;
sub getHtml;

my %Link =();

# 板を決定
{
	my %board = %{ getLinks getHtml @option{'urlBbsmenu','httpPort'} };

	my $key = '';
	/$option{'regexNeedUrl'}/o or delete $board{$key}
		while ($key, $_) = each %board;

	my @key = keys %board;
	$link{'BoardName'} = $key[int(rand 1000) % $#key];
	$link{'BoardUrl'}  = $board{$link{'BoardName'}};
}

# スレを決定
{
	my $subback = $link{'BoardUrl'} . $option{'nameSubback'};
	my %thread  = %{ getLinks getHtml $subback, $option{'httpPort'} };

	my @key = keys %thread;
	$link{'ThreadName'} = $key[int(rand 2000) % $#key];

	my($server, $bbs) = ($link{'BoardUrl'} =~ m|^http://([^/]+)/([^/]+)/$|i);
	$link{'ThreadUrl'} = join '/', (
		'http:/', $server, $option{'pathReadCgi'},
		$bbs, $thread{$link{'ThreadName'}}
	);

}

# 結果を出力
{
	my $result = ${ resultHtml() };
	$result =~ s/__${_}__/$link{$_}/g for @{ $option{'replaceWords'} };
	print $result;	
}


sub getHtml {
	my($host, $path, $port) = (shift =~ m|^http://([^/]+)(/.*)|, shift);

	my $iaddr = inet_aton($host)
		or error("$host can't be found.");
	socket(SOCKET, PF_INET, SOCK_STREAM, 0)
		or error("Can't generate socket.");
	connect(SOCKET, pack_sockaddr_in($port, $iaddr))
		or error("Can't connect port:$port at $host.");
	
	my $refContent = '';
	select SOCKET;
	{
		my $n = "\x0d\x0a";
		local $| = 1;
		print(
			'GET ', $path, ' HTTP/1.0', $n,
			'HOST: ', $host, ':', $port, $n,
			$n,
	    );
		
		'skip' until <SOCKET> =~ /^$n$/o;
		
		local $/ = undef;
		$refContent = \<SOCKET>
	}
	select STDOUT;

	return $refContent;
}

sub getLinks {
	my $html = ${ $_[0] };

	jcode::convert(\$html, 'euc');

	my($content, %links) = ();
	while ($html =~ m|<[Aa]([^>]+)>(.*?)</[Aa]>|gs) {
		$content = $2;
		$1 =~ m#[Hh][Rr][Ee][Ff]=([-./0-9:A-Za-z_]+|"[^"]+"|'[^']+')#s or next; #"''
		($_ = $1) =~ s/^(["'])// and s/$1$//;	#'"]] クォートされていれば除去
		
	   $links{$content} = $_;
	}

	return \%links;
}
