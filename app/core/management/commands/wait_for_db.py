import time
from django.db import connections
from django.db.utils import OperationalError
from django.core.management.base import BaseCommand


# used in docker-compose.yml before migrate and runserver commands.
# Without it you can get annoying errors in this project configuration
class Command(BaseCommand):
    """django command to pause execution till db is available"""

    def handle(self, *args, **options):
        self.stdout.write('Waiting for database...')
        db_conn = None
        while not db_conn:
            try:
                db_conn = connections['default']
            except OperationalError:
                self.stdout.write('database unavailable, wait 1 second then check again...')
                time.sleep(1)

        self.stdout.write(self.style.SUCCESS('Database available'))
