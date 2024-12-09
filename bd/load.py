import pandas as pd
import sqlite3



log_dataframe = pd.read_csv(
    'log.csv', names=['user_id', 'time', 'bet', 'win'], encoding='utf-8', sep=',')

users_dataframe = pd.read_csv(
    'users.csv', names=['user_id', 'mail', 'geo'], encoding='koi8-r', sep='\t')

conn = sqlite3.connect('log_users.s3db')

log_dataframe.to_sql('fin_log', conn, if_exists='replace', index=False)
users_dataframe.to_sql('fin_users', conn, if_exists='replace', index=False)

conn.close()

