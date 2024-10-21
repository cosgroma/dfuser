

DOCSTRING='''Usage:
    history_manager.py <history_file>...
    history_manager.py (-h | --help)
    history_manager.py --version
    
Options:
    -h --help       Show this screen.
    --version       Show version.

Arguments:
    <history_file>  The history file to read and add to the database.
'''

import docopt
import os
import json
import pydantic
from typing import List, Dict, Any, Set, Tuple

import logging
from pathlib import Path
# import pydantic BaseModel for type hinting
class CommandData(pydantic.BaseModel):
    count: int
    list_of_examples: List[str]
    run_as_sudo: bool


DATABASE_FILENAME = '~/.config/sgt/history_database.json'
HISTORY_PROCESSOR_LOG_FILENAME = '~/.config/sgt/history_processor.log'

COMMON_COMMAND_IGNORE_LIST = ['ls', 'cd', 'pwd', 'echo', 'clear', 'exit', 'history', 'cat']


class HistoryManager:
    def __init__(self):
        self.database = self.read_database()
        
    
    def setup_logging(self):
        # check if log file exists
        log_file = os.path.expanduser(HISTORY_PROCESSOR_LOG_FILENAME)
        print(f'Log file: {log_file}')
        # setup directory for log file
        os.makedirs(os.path.dirname(log_file), exist_ok=True)
        logging.basicConfig(filename=log_file, level=logging.DEBUG)

    def read_database(self):
        database = {}
        database_file = os.path.expanduser(DATABASE_FILENAME)
        database_p = Path(database_file)
        print(f'Reading database file: {database_file}')
        # check if database file exists
        if database_p.exists():
            with Path.open(database_p, 'r') as f:
                database = json.load(f)
        else:
            logging.debug(f'Creating new database file: {database_file}')
            # create the database file and directory if it does not exist
            os.makedirs(os.path.dirname(database_file), exist_ok=True)
            with Path.open(database_p, 'w') as f:
                json.dump(database, f)
        
        # convert list to set for list_of_examples
        for command in database:
            database[command]['list_of_examples'] = set(database[command]['list_of_examples'])
            
        return database

    def write_database(self):
        database_file = os.path.expanduser(DATABASE_FILENAME)
        database_p = Path(database_file)
        # convert set to list for list_of_examples
        for command in self.database:
            self.database[command]['list_of_examples'] = list(self.database[command]['list_of_examples'])
        with Path.open(database_p, 'w') as f:
            json.dump(self.database, f)

    def get_command_from_line(self, line):
        if line.startswith('!'):
            return line[1:], False
        if line.startswith('sudo') and len(line.split()) >= 2:
            return line.split()[1], True
        return line.split()[0], line.startswith('sudo')
    
    def process_line(self, line):
        # check if line is a common command that we want to ignore
        if self.get_command_from_line(line) in COMMON_COMMAND_IGNORE_LIST:
            logging.debug(f'Ignoring common command: {line}')
            return False
        
        # check if line is commented out or from multiline command
        if line.startswith('#') or line.startswith(' '):
            logging.debug(f'Ignoring commented out or multiline command: {line}')
            return False
        
        command, sudo = self.get_command_from_line(line)
        if command is None:
            logging.debug(f'Could not get command from line: {line}')
            return False
        
        self.add_command_to_database(command)
        
        self.database[command]['count'] += 1
        self.database[command]['list_of_examples'].add(line)
        self.database[command]['run_as_sudo'] = sudo
        
        return True
        
    def add_command_to_database(self, command: str):
        if command not in self.database:
            logging.debug(f'Adding command to database: {command}')
            self.database[command] = {'count': 0, 'list_of_examples': set(), 'run_as_sudo': False}

    def process_history_file(self, history_file):
        history_stats = {'total_commands': 0, 'lines_processed': 0}
        with open(history_file, 'r') as f:
            for line in f:
                if self.process_line(line):
                    history_stats['lines_processed'] += 1
        history_stats['total_commands'] = len(self.database)
        return history_stats


def main():
    args = docopt.docopt(DOCSTRING, version='History Manager 1.0')
    history_files = args['<history_file>']
    
    history_manager = HistoryManager()
    history_manager.setup_logging()
    
    for history_file in history_files:
        history_stats = history_manager.process_history_file(history_file)
        logging.info(f'Processed {history_stats["lines_processed"]} lines from {history_file}')
        logging.info(f'Total commands in database: {history_stats["total_commands"]}')
    
    history_manager.write_database()
    logging.info('Finished processing history files')
    
if __name__ == '__main__':
    main()