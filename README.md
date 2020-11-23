Reed - Solomon error correcting code is an algorithm constructed to use polynomials over data blocks.\
The Reed - Solomon group of algorithms are addressing a common issue which occurs when transferred data is corrupted over the course of the travel to the final destination.\
The corruption may occur due to malfunctions, interruptions or “noise” in the transmission medium itself - leading to errors.\
These error correcting algorithms have many applications.\ The most prominent of which include consumer technologies:\
●	Storage devices (CDs, DVDs, Blu-rays discs, etc)\
●	QRs codes\
●	Wireless or mobile communications\
●	High-speed modems (ADSL, xDSL, etc)\
●	Satellite communication.\
●	Digital TV.\
The RS code consists with two major components: Encoder and Decoder.\
The **encoder** takes a block of digital data and adds extra "redundant" bits. It first visualized the message as a polynomial instead of representing the data simply as its value.\
The **decoder** processes each block and attempts to correct errors and recover the original data. By representing the data as a polynomial,
it can use tools from different mathematical fields and employ different methods in order to restore the original message and repair corrupted messages.\
The **result**: The number and type of errors that can be corrected depends on the characteristics of the Reed-Solomon code. Although when the error rate is greater, that decoder will not be able to output the correct result. 
Using a basic decoder one can correct up to (𝑛−𝑘)/2 errors.\
The code relies on a theorem from algebra that states that any k distinct points uniquely determine a polynomial of degree at most k-1 data points
