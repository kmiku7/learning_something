
## sqlite3
```
dagster job execute -f ./resources.py -c ./resources_local_sqlite3.yaml
```

Need to insert the following codes:
```python
conn.commit()
conn.close()
```
Else it will insert nothing in the sqlite3 DB.


## Postgresql

### Errors
1. **sqlalchemy.exc.NoSuchModuleError: Can't load plugin: sqlalchemy.dialects:postgres**  
SQLAlchemy 1.4 removed the `postgres` dialect name, the name `postgresql` should be used instead now.  
From https://stackoverflow.com/a/66794960/1155688
2. **ModuleNotFoundError: No module named 'psycopg2'**  
Need to install too much packages under the Mac OS.  
