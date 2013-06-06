import time
import hashlib
from stratum import settings
import stratum.logger
log = stratum.logger.get_logger('DB_Mysql')

import MySQLdb
                
class DB_Mysql():
    def __init__(self):
        log.debug("Connecting to DB")
        
        required_settings = ['PASSWORD_SALT', 'DB_MYSQL_HOST', 
                             'DB_MYSQL_USER', 'DB_MYSQL_PASS', 
                             'DB_MYSQL_DBNAME', 'ARCHIVE_DELAY']
        
        for setting_name in required_settings:
            if not hasattr(settings, setting_name):
                raise ValueError("%s isn't set, please set in config.py" % setting_name)
        
        self.salt = getattr(settings, 'PASSWORD_SALT')
        self.database_extend = hasattr(settings, 'DATABASE_EXTEND') and getattr(settings, 'DATABASE_EXTEND') is True
        
        self.connect()
        
    def connect(self):
        self.dbh = MySQLdb.connect(
            getattr(settings, 'DB_MYSQL_HOST'), 
            getattr(settings, 'DB_MYSQL_USER'),
            getattr(settings, 'DB_MYSQL_PASS'), 
            getattr(settings, 'DB_MYSQL_DBNAME')
        )
        self.dbc = self.dbh.cursor()
            
    def check_password(self, username, password):
        log.debug("Checking username/password for %s", username)
        
        self.execute(
            """
            SELECT COUNT(*) 
            FROM `pool_worker`
            WHERE `username` = %(uname)s
              AND `password` = %(pass)s
            """,
            {
                "uname": username, 
                "pass": password
            }
        )
        
        data = self.dbc.fetchone()
        
        if data[0] > 0:
            return True
        
        return False



    def execute(self, query, args=None):
        try:
            self.dbc.execute(query, args)
        except MySQLdb.OperationalError:
            log.debug("MySQL connection lost during execute, attempting reconnect")
            self.connect()
            self.dbc = self.dbh.cursor()
            
            self.dbc.execute(query, args)
            
    def executemany(self, query, args=None):
        try:
            self.dbc.executemany(query, args)
        except MySQLdb.OperationalError:
            log.debug("MySQL connection lost during executemany, attempting reconnect")
            self.connect()
            self.dbc = self.dbh.cursor()
            
            self.dbc.executemany(query, args)

    def import_shares(self, data):
        log.debug("Importing Shares")
        checkin_times = {}
        total_shares = 0
        best_diff = 0
        
        for k, v in enumerate(data):
            if self.database_extend:
                total_shares += v[3]
                
                if v[0] in checkin_times:
                    if v[4] > checkin_times[v[0]]:
                        checkin_times[v[0]]["time"] = v[4]
                else:
                    checkin_times[v[0]] = {
                        "time": v[4], 
                        "shares": 0, 
                        "rejects": 0
                    }

                if v[5] == True:
                    checkin_times[v[0]]["shares"] += v[3]
                else:
                    checkin_times[v[0]]["rejects"] += v[3]

                if v[10] > best_diff:
                    best_diff = v[10]

     
                self.execute(
                    """
                    INSERT INTO `shares`
                    (time, rem_host, username, our_result, 
                      upstream_result, reason, solution)
                    VALUES 
                    (FROM_UNIXTIME(%(time)s), %(host)s, 
                      %(uname)s, %(lres)s, 0, %(reason)s, '')
                    """,
                    {
                        "time": v[4], 
                        "host": v[6], 
                        "uname": v[0], 
                        "lres": v[5], 
                        "reason": v[9]
                    }
					
		)
			
		self.dbh.commit()

    def found_block(self, data):
        # Note: difficulty = -1 here
        self.execute(
            """
            UPDATE `shares`
            SET `upstream_result` = %(result)s,
              `solution` = %(solution)s
            WHERE `time` = FROM_UNIXTIME(%(time)s)
              AND `username` =  %(uname)s
              LIMIT 1
            """,
            {
                "result": data[5], 
                "solution": data[2], 
                "time": data[4], 
                "uname": data[0]
            }
        )
         
        self.dbh.commit()

    def update_worker_diff(self, username, diff):
        log.debug("Setting difficulty for %s to %s", username, diff)
        
        self.execute(
            """
            UPDATE `pool_worker`
            SET `difficulty` = %(diff)s
            WHERE `username` = %(uname)s
            """,
            {
                "uname": username, 
                "diff": diff
            }
        )
        
        self.dbh.commit()

    def clear_worker_diff(self):
        if self.database_extend:
            log.debug("Resetting difficulty for all workers")
            
            self.execute(
                """
                UPDATE `pool_worker`
                SET `difficulty` = 0
                """
            )

    def close(self):
        self.dbh.close()

