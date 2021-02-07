#!C:/xampp/perl/bin/perl.exe
#!/usr/bin/perl -w

use CGI ":standard";
use DBI;

$q = new CGI;
my $numpg = 0;
my $numwords = 0;
my $firstsentences = "";
my @stop_words = qw(a able about across after all almost also am among an and any are as at be because been but by can cannot could dear did do does either else ever every for from get got had has have he her hers him his how however i if in into is isn it its just least let like likely may me might most must my neither no nor not of off often on only or other our own rather s said say says she should since so some t than that the their them then there these they this tis to too twas us wants was we were what when where which while who whom why will with would yet you your);
my %count;
if($q->param("testfile")) 
{
   $filehandle = $q->param("testfile");
   open ($fh, $filehandle);
   open (OUTFILE, ">article.txt");
   while (my $line = <$fh>) 
   {
      print OUTFILE $line;
   }
   close OUTFILE;
   close $fh;
    
   open ($fh2, "article.txt");
   my $const = " ";
    while (my $line2 = <$fh2>)
    {
        # count number of paragraphs in file
        if (index($line2, "\n") != -1) {
            $numpg++;
        }

        # count number of words in line
        my $num_occur = () = $line2 =~ /$const/g;
        $numwords += $num_occur;

        # take substring until first period of each line, add to $firstsentences
        $sentence = substr($line2, 0, index($line2, '.'));
        if ($sentence eq "") {
            $sentence .= ". ";
        } 
        $firstsentences .= $sentence;

        # find number of occurrences of words not in array stop_words
        chomp $line2;
        foreach my $str (split /\s+/, $line2) {
            if (lc($str) ~~ @stop_words) {} else {
                $count{$str}++;
            }
        }
    }
   close $fh2;
   $numpg = $numpg / 2;
    $result_pg = "<h2>Number of paragraphs: $numpg</h2>";
    $result_words = "<h2>Number of words: $numwords</h2>";
    $result_sentences = "<h2>Article Summary:</h2><h4>Using the first sentence of each paragraph...</h4><p>$firstsentences</p>";
}

print header();
print start_html("Analysis");

print "<h1>Abstraction Analysis</h1>";
print $result_pg;
print $result_words;
print "<h2>Top 10 Words</h2>";

$counter = 0;
# print the top 10 most frequently occuring words, sorted
foreach my $word (reverse sort { $count{$a} <=> $count{$b} } keys %count) {
    if ($counter > 9) { last; }
    printf "<b>%-31s:</b> %s\n", $word, $count{$word};
    printf("<br>");
    $counter++;
}
print $result_sentences;
print end_html();