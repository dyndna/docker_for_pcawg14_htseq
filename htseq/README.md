## HTSeq patch:

Original version used: version 0.6.1p1 as present in *parent_dockerfile*, https://registry.hub.docker.com/u/genomicpariscentre/htseq/dockerfile/

Patched to override error related to *maximum alignment buffer size exceeded*

	4200000 SAM alignment record pairs processed.
	4300000 SAM alignment record pairs processed.
	Error occured when processing SAM input (line 11752798):
	  Maximum alignment buffer size exceeded while pairing SAM alignments.
	  [Exception type: ValueError, raised in __init__.py:671]

#### Credits:

>André Kahles, MSKCC  
>https://www.mskcc.org/research-areas/labs/members/andre-kahles  

Modify your local HTSeq installation by editing line number 100 in HTSeq source file, `HTSeq/scripts/count.py` 
 
from 

	read_seq = HTSeq.pair_SAM_alignments_with_buffer( read_seq )

to

	read_seq = HTSeq.pair_SAM_alignments_with_buffer( read_seq, max_buffer_size=30000000 )

Recompile HTSeq binaries:

	python setup.py build && python setup.py install

Modified source version: HTSeq-0.6.1p2  
Modified source filename: HTSeq-0.6.1p2.tar.gz  
Modified source tarball MD5: 053d4bb7df769eb5d85d082b5a2eed99 ;

END
