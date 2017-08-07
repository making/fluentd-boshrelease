#!/bin/bash

DIR=`pwd`

mkdir -p .downloads

pushd .downloads

if [ ! -f ${DIR}/blobs/ruby/bundler-1.10.6.gem ];then
    curl -L -O -J https://rubygems.org/downloads/bundler-1.10.6.gem
    bosh add-blob --dir=${DIR} bundler-1.10.6.gem ruby/bundler-1.10.6.gem
fi
if [ ! -f ${DIR}/blobs/ruby/ruby-2.3.0.tar.gz ];then
    curl -L -O -J http://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.gz 
    bosh add-blob --dir=${DIR} ruby-2.3.0.tar.gz ruby/ruby-2.3.0.tar.gz
fi
if [ ! -f ${DIR}/blobs/ruby/rubygems-2.6.2.tgz ];then
    curl -L -O -J http://production.cf.rubygems.org/rubygems/rubygems-2.6.2.tgz
    bosh add-blob --dir=${DIR} rubygems-2.6.2.tgz ruby/rubygems-2.6.2.tgz
fi
if [ ! -f ${DIR}/blobs/ruby/yaml-0.1.6.tar.gz ];then
    curl -L -O -J http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz
    bosh add-blob --dir=${DIR} yaml-0.1.6.tar.gz ruby/yaml-0.1.6.tar.gz
fi
if [ ! -f ${DIR}/blobs/fluentd-vendor/fluentd-vendor-v0.12.39.tgz ];then
    export BOSH_INSTALL_TARGET=${DIR}/.bosh_install
    export BOSH_COMPILE_TARGET=${DIR}/.bosh_compile

    rm -rf ${BOSH_INSTALL_TARGET} ${BOSH_COMPILE_TARGET}
    mkdir -p ${BOSH_INSTALL_TARGET}
    mkdir -p ${BOSH_COMPILE_TARGET}

    cp -r ${DIR}/src/* ${BOSH_COMPILE_TARGET}/
    cp -r ${DIR}/blobs/* ${BOSH_COMPILE_TARGET}/
    pushd ${BOSH_COMPILE_TARGET}
    bash ${DIR}/packages/fluentd/packaging
    popd

    export PATH=${BOSH_INSTALL_TARGET}/bin:$PATH
    
    pushd ${DIR}/src/fluentd
    ${BOSH_INSTALL_TARGET}/bin/bundle install --path vendor/bundle
    tar czf fluentd-vendor.tgz vendor
    bosh add-blob --dir=${DIR} fluentd-vendor.tgz fluentd-vendor/fluentd-vendor-v0.12.39.tgz
    rm -rf vendor .bundle fluentd-vendor.tgz
    popd
fi


popd
