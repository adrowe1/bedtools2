set -e;
BT=${BT-../../bin/bedtools}

FAILURES=0;

check()
{
	if diff $1 $2; then
    	echo ok

	else
    	FAILURES=$(expr $FAILURES + 1);
		echo fail

	fi
}

# cat a.bed
# chr1	100	200	a1	1	+
# chr1	100	200	a2	2	-

###########################################################
# test shifting forward via -s
###########################################################
echo -e "    shift.t1...\c"
echo \
"chr1	105	205	a1	1	+
chr1	105	205	a2	2	-" > exp
$BT shift -i a.bed -s 5 -g tiny.genome > obs
check obs exp
rm obs exp

###########################################################
# test shifting backward via -s
###########################################################
echo -e "    shift.t2...\c"
echo \
"chr1	95	195	a1	1	+
chr1	95	195	a2	2	-" > exp
$BT shift -i a.bed -s -5 -g tiny.genome > obs
check obs exp
rm obs exp

###########################################################
# test shifting forward via -m and -p
###########################################################
echo -e "    shift.t3...\c"
echo \
"chr1	105	205	a1	1	+
chr1	105	205	a2	2	-" > exp
$BT shift -i a.bed -p 5 -m 5 -g tiny.genome > obs
check obs exp
rm obs exp

###########################################################
# test shifting backward via -m and -p
###########################################################
echo -e "    shift.t3...\c"
echo \
"chr1	95	195	a1	1	+
chr1	95	195	a2	2	-" > exp
$BT shift -i a.bed -p -5 -m -5 -g tiny.genome > obs
check obs exp
rm obs exp

###########################################################
# test just a -m shift (-p == 0)
###########################################################
echo -e "    shift.t4...\c"
echo \
"chr1	100	200	a1	1	+
chr1	95	195	a2	2	-" > exp
$BT shift -i a.bed -m -5 -p 0 -g tiny.genome > obs
check obs exp
rm obs exp

###########################################################
# test just a -p shift (-m == 0)
###########################################################
echo -e "    shift.t5...\c"
echo \
"chr1	105	205	a1	1	+
chr1	100	200	a2	2	-" > exp
$BT shift -i a.bed -m 0 -p 5 -g tiny.genome > obs
check obs exp
rm obs exp

###########################################################
# test going beyond the start of the chrom
###########################################################
echo -e "    shift.t6...\c"
echo \
"chr1	0	1	a1	1	+
chr1	0	1	a2	2	-" > exp
$BT shift -i a.bed -s -200 -g tiny.genome > obs
check obs exp
rm obs exp

###########################################################
# test going beyond the end of the chrom
###########################################################
echo -e "    shift.t7...\c"
echo \
"chr1	999	1000	a1	1	+
chr1	999	1000	a2	2	-" > exp
$BT shift -i a.bed -s 1000 -g tiny.genome > obs
check obs exp
rm obs exp

###########################################################
# test shift being larger than a signed int
###########################################################
echo -e "    shift.t8...\c"
echo \
"chr1	999	1000	a1	1	+
chr1	999	1000	a2	2	-" > exp
$BT shift -i a.bed -s 3000000000 -g tiny.genome > obs
check obs exp
rm obs exp

###########################################################
# test shift huge genome
###########################################################
echo -e "    shift.t9...\c"
echo \
"chr1	67000638	67217822	NM_032291	0	+
chr1	92146899	92352836	NR_036634	0	-" > exp
$BT shift -i b.bed -s 1000 -g huge.genome > obs
check obs exp
rm obs exp
[[ $FAILURES -eq 0 ]] || exit 1;
