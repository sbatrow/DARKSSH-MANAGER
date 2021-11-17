import os

api_id = os.environ["API_ID"]
api_hash = os.environ["API_HASH"]
string = os.environ["STRING_SESSION"]
bot_token = os.environ["BOT_TOKEN"]

bot_name = os.environ["BOT_USERNAME"]


BANNER_NAME = os.environ.get("BANNER_NAME")

LIST_OF_ADMINS = os.environ.get("ADMINS") 

host = os.environ.get("SSH_IP")
username = os.environ.get("SSH_USERNAME")
password = os.environ.get("SSH_PASS")