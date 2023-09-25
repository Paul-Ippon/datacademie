#
# Copyright (c) 2022 Airbyte, Inc., all rights reserved.
#


from abc import ABC
from typing import Any, Iterable, List, Mapping, MutableMapping, Optional, Tuple

import requests
from airbyte_cdk.sources import AbstractSource
from airbyte_cdk.sources.streams import Stream, IncrementalMixin
from airbyte_cdk.sources.streams.http import HttpStream
from airbyte_cdk.sources.streams.http.auth import TokenAuthenticator

# Basic full refresh stream
class VelibMetropoleStream(HttpStream, ABC):

    url_base = "https://velib-metropole-opendata.smoove.pro/opendata/Velib_Metropole/"

    def next_page_token(self, response: requests.Response) -> Optional[Mapping[str, Any]]:
        return None

    def parse_response(self, response: requests.Response, **kwargs) -> Iterable[Mapping]:

        lastUpdatedOther = response.json()["lastUpdatedOther"]
        ttl = response.json()["ttl"]
        for record in response.json()["data"]["stations"]:
            record["lastUpdatedOther"] = lastUpdatedOther
            record["ttl"] = ttl
            yield record

class StationInformation(VelibMetropoleStream):

    primary_key = "station_id"

    def path(
        self, stream_state: Mapping[str, Any] = None, stream_slice: Mapping[str, Any] = None, next_page_token: Mapping[str, Any] = None
    ) -> str:
        return "station_information.json"


# Basic incremental stream
class IncrementalVelibMetropoleStream(VelibMetropoleStream, IncrementalMixin):

    @property
    def state(self) -> Mapping[str, Any]:
        if hasattr(self,"_state"):
            return self._state
        
        else:
            return {self.cursor_field: 0}

    @state.setter
    def state(self, value: Mapping[str, Any]):
        self._state = value

    @property
    def cursor_field(self) -> str:
        return "last_reported"

    def read_records(self, *args, **kwargs) -> Iterable[Mapping[str, Any]]:
        
        # each record more recent that this date need to be loaded
        start_date = self.state[self.cursor_field] 

        for record in super().read_records(*args, **kwargs):
            record_date = record[self.cursor_field]
            if record_date > start_date:
                # update state to have finally the latest date
                if record_date > self.state[self.cursor_field]:
                    self.state = {self.cursor_field: record_date} 
                
                yield record

class StationStatus(IncrementalVelibMetropoleStream):
    primary_key = "station_id"

    def path(
        self, stream_state: Mapping[str, Any] = None, stream_slice: Mapping[str, Any] = None, next_page_token: Mapping[str, Any] = None
    ) -> str:
        return "station_status.json"


# Source
class SourceVelibMetropole(AbstractSource):
    def check_connection(self, logger, config) -> Tuple[bool, any]:

        # return True, None
        try:
            resp_station_status = requests.get("https://velib-metropole-opendata.smoove.pro/opendata/Velib_Metropole/station_status.json").status_code
            logger.info(f"Ping station_status response code: {resp_station_status}")
            resp_station_information = requests.get("https://velib-metropole-opendata.smoove.pro/opendata/Velib_Metropole/station_information.json").status_code
            logger.info(f"Ping station_information response code: {resp_station_information}")

            if resp_station_status == 200 and resp_station_information == 200:
                return True, None

            return False, "station_status or station_information not reachable"
            
        except Exception as e:
            return False, e


    def streams(self, config: Mapping[str, Any]) -> List[Stream]:

        return [
            StationInformation(),
            StationStatus()
        ]
