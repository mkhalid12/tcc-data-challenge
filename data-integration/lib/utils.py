import os
import json


def get_pg_connection_uri(db_cred_param) -> str:
    uri = f"postgresql://{db_cred_param['user']}:{db_cred_param['password']}@{db_cred_param['host']}:{db_cred_param['port']}/{db_cred_param['dbname']}"
    # print(uri)
    return uri

def read_json_file(path_to_file: str) -> dict:
    with open(path_to_file) as json_file:
        data = json.load(json_file)
    return data


def get_config_value(identifier: str, config_path) -> str:
    data = read_json_file(config_path)
    return_value = data.get(identifier)
    assert return_value, f"Value missing for identifier {identifier}!"
    return return_value


def read_sql_commands_from_file(file_path:str) -> list:
    with open(file_path, 'r') as sql_file:
        file_content = sql_file.read().replace('\n', '')
        sql_commands = list(filter(str.strip, file_content.split(';')))

    return sql_commands


def get_query_from_file(file_path: str) -> str:
    with open(file_path, 'r') as sql_file:
        file_content = sql_file.read().replace('\n', ' ')
    return file_content


