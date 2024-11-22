# I ran this on vscode terminal
# Guide followed by : https://www.youtube.com/watch?v=zUpbZRmITZQ 

# etherumbook - solc-select 
$solc-select install 0.6.4
#Installing solc '0.6.4'...
#Version '0.6.4' installed.
$solc-select use 0.6.4
#Switched global version to 0.6.4
$solc --version
#solc, the solidity compiler commandline interface
#Version: 0.6.4+commit.1dca32f3.Linux.g++
$dir
#Faucet.sol  workspace.code-workspace
$solc Faucet.sol 
#Compiler run successful, no output requested.
