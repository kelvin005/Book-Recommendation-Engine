import json
import os
import boto3
import requests
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def handler(event, context):
    logger.info("Received event: %s", json.dumps(event))

    genre = event.get("queryStringParameters", {}).get("genre", "fiction")

    try:
        # Try cache first
        cached = table.get_item(Key={"genre": genre})
        if "Item" in cached:
            logger.info("Cache hit for genre: %s", genre)
            return response(200, cached["Item"]["books"])

        # Call Google Books API
        books = fetch_books_from_google(genre)
        logger.info("Fetched books: %s", books)

        # Store in DynamoDB
        table.put_item(Item={"genre": genre, "books": books})
        return response(200, books )

    except Exception as e:
        logger.error("Error occurred: %s", str(e), exc_info=True)
        return response(500, {"error": str(e)})

def fetch_books_from_google(genre):
    url = f"https://www.googleapis.com/books/v1/volumes?q={genre}"
    r = requests.get(url)
    data = r.json()

    books = []
    for item in data.get("items", [])[:50]:
        info = item.get("volumeInfo", {})
        books.append({
            "title": info.get("title"),
            "authors": info.get("authors", []),
            "description": info.get("description", "")
        })

    return books

def response(status, body):
    return {
        "statusCode": status,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type"
        },
        "body": json.dumps(body)
    }
