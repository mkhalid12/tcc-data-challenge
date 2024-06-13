from abc import ABC, abstractmethod
from lib.utils import get_query_from_file, get_pg_connection_uri, get_config_value
from string import Template
import polars as pl


class AbstractLayer(ABC):

    @abstractmethod
    def create_schema(self):
        pass

    @abstractmethod
    def run(self):
        pass


class RawLayer(AbstractLayer):
    def __init__(self):
        super().__init__()
        self.config = None
        self.db = None
        self.table = None
        self.schema_path = None
        self.query_path = None
        self.checkpoint = None

    def create_schema(self) -> None:
        print('creating a schema')
        sql_commands = get_query_from_file(self.schema_path)
        self.db.execute_query(sql_commands)

    def run(self) -> None:
        sql_commands = get_query_from_file(self.query_path)
        query = Template(sql_commands).substitute(
            checkpoint=self.checkpoint
        )
        src_uri = get_pg_connection_uri(get_config_value('TCC_SRC_CONN', self.config))
        dwh_uri = get_pg_connection_uri(get_config_value('DWH_CONN', self.config))
        df = pl.read_database_uri(query=query, uri=src_uri, engine='adbc')
        df.write_database(table_name=self.table, connection=dwh_uri, if_table_exists="append")

    def run_wrapper(self) -> None:
        self.create_schema()
        self.run()


class StaLayer(AbstractLayer):
    def __init__(self):
        super().__init__()
        self.config = None
        self.db = None
        self.table = None
        self.schema_path = None
        self.query_path = None
        self.checkpoint = None

    def create_schema(self) -> None:
        print('creating a schema')
        sql_commands = get_query_from_file(self.schema_path)
        self.db.execute_query(sql_commands)

    def run(self) -> None:
        sql_commands = get_query_from_file(self.query_path)
        query = Template(sql_commands).substitute(
            checkpoint=self.checkpoint
        )
        self.db.execute_query(query)

    def run_wrapper(self) -> None:
        self.create_schema()
        self.run()
