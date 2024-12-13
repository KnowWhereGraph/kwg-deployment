import getpass
import bcrypt

# This file came from the Prometheus documentation
# It's used to take a password and encode it, which
# is then placed in the `web.yml` file
password = getpass.getpass("password: ")
hashed_password = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt())
print(hashed_password.decode())