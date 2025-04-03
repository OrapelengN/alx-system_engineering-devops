#!/usr/bin/python3
"""
Queries the Reddit API and prints the titles of the first 10 hot posts
for a given subreddit.
"""
import requests


def top_ten(subreddit):
    """
    Prints the titles of the first 10 hot posts for a given subreddit.
    If not a valid subreddit, prints None.
    """
    url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit=10"
    headers = {"User-Agent": "MyRedditBot/1.0"}

    try:
        response = requests.get(url, headers=headers, allow_redirects=False)

        if response.status_code == 200:
            data = response.json()
            posts = data.get("data", {}).get("children", [])

            if not posts:
                print(None)
                return

            for post in posts:
                print(post["data"]["title"])

        elif response.status_code == 404 or response.status_code == 302:
            print(None)
        else:
            print(None)

    except requests.exceptions.RequestException:
        print(None)


if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Please pass an argument for the subreddit to search.")
    else:
        top_ten(sys.argv[1])
