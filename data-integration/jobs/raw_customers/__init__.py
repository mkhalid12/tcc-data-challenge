from lib.etl import RawLayer
from lib.db_utils import DWHConnect
import os

class RawCustomers(RawLayer):

    def __init__(self, checkpoint, config="config") -> None:
        """
        A StaCustomers job
        @:var
        checkpoint =  checkpoint value to conitnue the incremental data loading
        """

        RawLayer.__init__(self)
        self.config = f"config/{config}.json"
        self.db = DWHConnect(self.config)
        self.table = "raw.customers"
        self.schema_path = f"{os.path.dirname(__file__)}/schema.sql"
        self.query_path = f"{os.path.dirname(__file__)}/query.sql"
        self.checkpoint = checkpoint
