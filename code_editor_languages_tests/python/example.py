from sys import path

import pandas as pd

# %%


def hello() -> int:
    print(path)
    print("hello")
    return 1


def main():
    pd.DataFrame()
    hello()
    hola("Mario")


# %%
# Function to greet
def greeting() -> pd.DataFrame:
    print("greeting")
    return pd.DataFrame()


# buen días
def hola(name: str) -> int:
    pd.DataFrame()
    print(name)
    return 0


def hola_pasado() -> None:
    hola("Juan")


# Create a session
# session = boto3.Session(
#     aws_access_key_id="YOUR_ACCESS_KEY_ID",
#     aws_secret_access_key="YOUR_SECRET_ACCESS_KEY",
#     region_name="YOUR_REGION",
# )

# Create an S3 client
# s3_client = session.client("s3")

# Example usage: list all buckets
# response = s3_client.list_buckets()
# for bucket in response["Buckets"]:
#     print(f'Bucket Name: {bucket["Name"]}')
if __name__ == "__main__":
    main()
