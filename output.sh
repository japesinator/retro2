#!/bin/bash
clear
red='\033[0;31m'
NC='\033[0m'

echo -e "${red}test${NC}"

# cp -a /resources/level_3/. ./

testfun () {
  unalias test
  echo -e "${red}test${NC}"
  echo
  test
}
alias test='testfun'

