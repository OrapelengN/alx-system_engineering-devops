#!/usr/bin/python3
"""
Recursive function to query the Reddit API and return a list of hot article
titles.
"""
import requests


def recurse(subreddit, hot_list=[], after=None):
    """
    Recursively queries the Reddit API and returns a list of hot article titles
    If no results are found, returns None.
    """
    url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit=100"
    headers = {"User-Agent": "MyRedditBot/1.0"}

    if after:
        url += f"&after={after}"

    try:
        response = requests.get(url, headers=headers, allow_redirects=False)

        if response.status_code == 200:
            data = response.json()
            posts = data.get("data", {}).get("children", [])
            after = data.get("data", {}).get("after")

            if not posts:
                if not hot_list:
                    return None
                else:
                    return hot_list

            for post in posts:
                hot_list.append(post["data"]["title"])

            if after:
                return recurse(subreddit, hot_list, after)
            else:
                return hot_list

        elif response.status_code == 404 or response.status_code == 302:
            return None
        else:
            return None

    except requests.exceptions.RequestException:
        return None


if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Please pass an argument for the subreddit to search.")
    else:
        result = recurse(sys.argv[1])
        if result is not None:
            print(len(result))
        else:
            print("None")
