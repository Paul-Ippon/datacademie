#
# Copyright (c) 2022 Airbyte, Inc., all rights reserved.
#


import sys

from airbyte_cdk.entrypoint import launch
from source_velib_metropole import SourceVelibMetropole

if __name__ == "__main__":
    source = SourceVelibMetropole()
    launch(source, sys.argv[1:])
