#!/bin/bash
# SPDX-License-Identifier: EPL-1.0
##############################################################################
# Copyright (c) 2020 The Linux Foundation and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
##############################################################################

echo "---> dentos-build.sh"

# be careful and verbose
set -eux -o pipefail

sudo apt-get install -y binfmt-support
# Build issue under investigation, commenting for now...
#bash tools/autobuild/build.sh -9 -b $STREAM ${BUILD_ARGS:-}
make docker

# Push artifact for the merge job
if [[ "$JOB_NAME" =~ "merge" ]]; then
    find "${WORKSPACE}"/builds/amd64/installer/installed/builds/stretch/ -name '*' -type f -exec curl -u "${DENTOSUSER}" -T {} https://nexus.dent.dev/content/repositories/snapshots/org/dent/dentos/ \;
    find "${WORKSPACE}"/builds/arm64/installer/installed/builds/stretch/ -name '*' -type f -exec curl -u "${DENTOSUSER}" -T {} https://nexus.dent.dev/content/repositories/snapshots/org/dent/dentos/ \;
fi

echo "---> dentos-build.sh ends"
