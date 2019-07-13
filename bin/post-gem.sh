#!/bin/bash
# post-gem.sh: -*- Shell-script -*-  DESCRIPTIVE TEXT.
# 
#  Copyright (c) 2019 Brian J. Fox Opus Logica, Inc.
#  Author: Brian J. Fox (bfox@opuslogica.com)
#  Birthdate: Sat Jul 13 07:01:49 2019.
RUBYGEM_HASH=$(cat .rubygem-hash)
RUBYGEM_API="https://rubygems.org/api/v1/gems"
GEM_NAME=$(echo *.gem)
echo curl --data-binary ${GEM_NAME} -H "Authorization:${RUBYGEM_HASH}" ${RUBYGEM_API}
