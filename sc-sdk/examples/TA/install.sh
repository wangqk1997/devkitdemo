#!/bin/bash
# Copyright 2022 Huawei Technologies Co., Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ $# != 2 ]; then
  echo "Parameter should contain signed_config and TA_cert."
  exit 1
fi

cd cloud

# copy signed_config and TA_cert
cp -r $1 .
cp -r $2 .

# build
mkdir build
cd build
cmake ..
make
cd ..

# install
if [ ! -d "/data" ]; then
  mkdir -p /data
fi

ta_uuid=$(grep appID manifest.txt | awk -F ' ' '{print $2}' | tr -d '\r')
if [ -f "/data/${ta_uuid}.sec" ]; then
  rm -rf /data/${ta_uuid}.sec
fi

cp ${ta_uuid}.sec /data

# clean temp file
rm -rf build *.sec libcombine.so manifest.txt signed_config TA_cert
cd ..
