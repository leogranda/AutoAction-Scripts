#!/bin/bash

#================================================================
# HEADER
#================================================================
# SYNOPSIS
#   Installs a root certificate to the system keychain.
#
# DESCRIPTION
#	Installs a root certificate to the system keychain. This method is
# 	only supported in Catalina and earlier.
#
# USAGE
#   ./install_root_certificate.sh
#
# END_OF_HEADER
#================================================================
#
# Let's set some variables!

# cat the certificate to populate this variable
rootCert=""
certName=""

# Determining OS version based on "Darwin Version"
# ie. 20 = Big Sur, 19 = Catalina, 18 = Mojave, 17 = High Sierra
darwinVersion=$(uname -r | cut -d "." -f1)

if [[ "$darwinVersion" -ge 20 ]]; then
    echo "Big Sur or later not supported. Exiting..."
	exit
else
    echo "Catalina or earlier OS detected. Proceeding..."
fi

echo "Creating and adding the root cert $certName..."
cat <<EOF > /var/tmp/"${certName}"
$rootCert
EOF

security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /var/tmp/"${certName}"

echo "Removing temp files and exiting..."
rm -f /var/tmp/"${certName}"

exit