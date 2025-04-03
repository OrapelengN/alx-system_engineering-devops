#!/usr/bin/python3
"""
Queries the Reddit API and returns the number of subscribers for a given
subreddit.
"""
import requests


def number_of_subscribers(subreddit):
    """
    Returns the number of subscribers for a given subreddit.
    If an invalid subreddit is given, returns 0.
    """
    url = f"https://www.reddit.com/r/{subreddit}/about.json"
    headers = {"User-Agent": "MyRedditBot/1.0"}

    try:
        response = requests.get(url, headers=headers, allow_redirects=False)

        if response.status_code == 200:
            data = response.json()
            subscribers = data.get("data", {}).get("subscribers", 0)
            return subscribers
        elif response.status_code == 404:
            return 0
        elif response.status_code == 302:
            return 0
        else:
            return 0

    except requests.exceptions.RequestException:
        return 0

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Please pass an argument for the subreddit to search.")
    else:
        print("{:d}".format(number_of_subscribers(sys.argv[1]))i)
