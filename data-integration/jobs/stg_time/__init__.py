from lib.etl import StaLayer
from lib.db_utils import DWHConnect
import os


class StgTime(StaLayer):

    def __init__(self, checkpoint, config="config") -> None:
        """
        A StgTime job
        @:var
        checkpoint =  checkpoint value to continue the incremental data loading
        """

        StaLayer.__init__(self)
        self.config = f"config/{config}.json"
        self.db = DWHConnect(self.config)
        self.table = "stg.time"
        self.schema_path = f"{os.path.dirname(__file__)}/schema.sql"
        self.query_path = f"{os.path.dirname(__file__)}/query.sql"
        self.checkpoint = checkpoint



