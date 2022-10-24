# Generating SDK.zip for iOS Builder

These are instructions for generating the iOS SDK files needed for iOS Builder for Unity. 

By running these commands in a Windows Subsystem for Linux (WSL) Ubuntu container, and by using iOS Builder, you can build iOS apps entirely on Windows. You may still need to generate signing certs and provisioning profiles on a Mac, but there are ways to do that on Windows as well. That is beyond the scope of this repo however.

# Ubuntu
Install Ubuntu for Windows 10/11 WSL
```
wsl --install -d Ubuntu
```

Now we will setup the build environments, download and extract XCode, and run the migration tool.

My main working directory in these examples is ```~/src```

# Build Xar
Download ```xar.X.X.X.tar.gz``` from https://mackyle.github.io/xar/
```
wget https://github.com/downloads/mackyle/xar/xar-1.6.1.tar.gz
tar -xf xar-1.6.1.tar.gz 
```

Install the dependencies and build Xar
```
sudo apt-get install gcc make libxml2-dev libz-dev zip
sudo apt-get install libssl1.0-dev
./configure
make
sudo make install
```

## Fixing libssl
If you have issues installing ```libssl1.0-dev```, try the following:
```
sudo nano /etc/apt/sources.list
```
Append this line to the sources.list file
```
deb http://security.ubuntu.com/ubuntu bionic-security main
```
Now run
```
sudo apt update && apt-cache policy libssl1.0-dev
sudo apt-get install libssl1.0-dev
```


# Build PBZX
Download Git repo and change to the directory (cd pbzx)

https://github.com/nrosenstein-stuff/pbzx


## Setup Brew

Run the following (replace /home/wsl with your home directory i.e. /home/your_username)
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# The next three commands are generated in the above script, and you can copy them directly from the console to get proper paths

echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/wsl/.profile
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/wsl/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

sudo apt-get install build-essential
brew install xz && brew link xz
```

## Install dependencies and build
```
sudo apt -y install liblzma-dev clang
clang -llzma -lxar -I /usr/local/include pbzx.c -o pbzx
```

Set your PATH variable to include folder containing the pbzx binary you just built (in this example I am using /home/wsl/src/pbzx as my build folder for pbzx)
```
PATH=$PATH:~/src/pbzx
```

# XCode
Download latest XCode .xip file from
https://developer.apple.com/download/all/?q=xcode

Extract it with xar and pbzx (replace .xip filename with whatever version you downloaded)
```
mkdir xcode
xar -xf Xcode_14.1_Release_Candidate.xip -C xcode
cd xcode
pbzx -n Content | cpio -i
```

# Migration Script
There are two ways you can make the migration script work on Ubuntu.
## Option 1 - Download sw_vers.sh
Download sw_vers.sh from this Git repo and flag it as an executable
```
wget https://raw.githubusercontent.com/HauntedOatmeal/ios_sdk/main/sw_vers.sh -P ~/
chmod +x ~/sw_vers.sh
```

Next modify the iOS Builder Mac migration cmd file (```MigrationAsssistant/Migration assistant (step 1, Mac).command```)

You can find this in your iOS Builder install directory.

Add the following two lines right below ```#!/bin/bash```
```
shopt -s expand_aliases
alias sw_vers='~/sw_vers.sh'
```
Now if you ever need to update your product/build versions, you can just modify ```sw_vers.sh``` and change the ```PROD_VER``` and ```BUILD_VER``` variables, without having to touch the migration script.
## Option 2 - Hard code the values
Open ```MigrationAsssistant/Migration assistant (step 1, Mac).command```
Find the following two lines:
```
sw_vers -productVersion > osx-version
sw_vers -buildVersion   > osx-build
```
and change them to look like this
```
echo '12.6' > osx-version
echo '21G115' > osx-build
```
You can change these values to be the correct product and build versions for your Mac (or whatever is latest)
These values can be found by running the following commands on a Mac device
```
sw_vers -productVersion
sw_vers -buildVersion
```
If you don't have a Mac just leave them as is, or Google what the updated values should be.

# Final Steps
Add a junction to ```/Applications/XCode.app``` so the migration tool can find it.

In this case ```~/src/xcode``` is just where I extracted the XCode .xip file to
```
sudo ln -s /Applications/Xcode.app ~/src/xcode/Xcode.app
```

Now copy the migration script to Ubuntu, easiest method is to use explorer.
```
explorer.exe .
```
which will let you copy the file directly via Windows Explorer.

Rename the script to ```migrate.sh``` and then run it via:
```
sudo chmod +x ./migrate.sh 
./migrate.sh 
```

Finally you can run ```explorer.exe``` inside your Ubuntu terminal to navigate to that Ubuntu folder via Windows Explorer
```
explorer.exe .
```

You can now copy the SDK.zip file and extract it to your iOS Builder folder, i.e. ```C:\iOS\iOS Project Builder for Unity\SDK```
