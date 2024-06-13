import psycopg2
from psycopg2.extras import RealDictCursor
from contextlib import contextmanager
import json


class DWHConnect:
    def __init__(self, config_file):
        self.config_file = config_file
        self._load_config()

    def _load_config(self):
        """Load database configuration from a JSON file."""
        with open(self.config_file, 'r') as file:
            config = json.load(file)
            self.host = config['DWH_CONN'].get('host')
            self.port = config['DWH_CONN'].get('port')
            self.dbname = config['DWH_CONN'].get('dbname')
            self.user = config['DWH_CONN'].get('user')
            self.password = config['DWH_CONN'].get('password')

    @contextmanager
    def get_connection(self):
        """Context manager to get a database connection."""
        conn = None
        try:
            conn = psycopg2.connect(
                host=self.host,
                port=self.port,
                dbname=self.dbname,
                user=self.user,
                password=self.password
            )
            yield conn
        finally:
            if conn:
                conn.close()

    @contextmanager
    def get_cursor(self):
        """Context manager to get a database cursor."""
        with self.get_connection() as conn:
            cursor = conn.cursor(cursor_factory=RealDictCursor)
            try:
                yield cursor
            finally:
                cursor.close()
                conn.commit()

    def execute_query(self, query, params=None):
        """Execute a query."""
        with self.get_cursor() as cursor:
            cursor.execute(query, params)

    def fetch_query(self, query, params=None):
        """Fetch results from a query."""
        with self.get_cursor() as cursor:
            cursor.execute(query, params)
            results = cursor.fetchall()
        return results
