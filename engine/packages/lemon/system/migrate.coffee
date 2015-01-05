db.migrations = []

db.migrate = (scope) -> script(scope) for script in db.migrations
