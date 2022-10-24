#!/bin/bash

PROD_VER='12.6'		#Replace this with the output of sw_vers -productVersion on your Mac
BUILD_VER='21G115'	#Replace this with the output of sw_vers -buildVersion on your Mac

case $1 in
	"-buildVersion")
		echo $BUILD_VER
		;;

	"-productVersion")
		echo $PROD_VER
		;;

	"-productName")
		echo "Mac OS X"
		;;

	*)
	echo "Unknown argument, please specify -buildVersion, -productVersion, or -productName"
esac

