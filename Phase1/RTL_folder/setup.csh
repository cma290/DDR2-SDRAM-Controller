#/bin/csh

#if ( ! ${?denali72} ) then

	setenv DENALI /usr/usc/cadence/2009/VIPCAT113/tools.sun4v/denali #for aludra - will be modified to the new path
 
	#setenv DENALI /usr/local/cadence/VIPCAT113/tools.lnx86/denali  #for viterbi
	setenv LD_LIBRARY_PATH ${DENALI}/verilog:${DENALI}/lib:${LD_LIBRARY_PATH}
	if (  ${?LM_LICENSE_FILE} ) then
        	echo ${LM_LICENSE_FILE} | grep 1900@license29.usc.edu > /dev/null
        	if ( $status != 0  ) then
                	setenv LM_LICENSE_FILE 1900@license29.usc.edu:$LM_LICENSE_FILE
        	endif
	else
        setenv LM_LICENSE_FILE 1900@license29.usc.edu
	endif

#endif

