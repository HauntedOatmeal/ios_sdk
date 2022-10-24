#!/bin/bash

PROD_VER='12.6'		#Replace this with the output of sw_vers -productVersion on your Mac, or set IOS_PROD_VER env var
BUILD_VER='21G115'	#Replace this with the output of sw_vers -buildVersion on your Mac, or set IOS_BUILD_VER env var

IPROD="${IOS_PROD_VER:-$PROD_VER}"
IBUILD="${IOS_BUILD_VER:-$BUILD_VER}"
case $1 in
	"-buildVersion")
		echo $IBUILD
		;;

	"-productVersion")
		echo $IPROD
		;;

	"-productName")
		echo "Mac OS X"
		;;

	*)
	echo "Unknown argument, please specify -buildVersion, -productVersion, or -productName"
esac

