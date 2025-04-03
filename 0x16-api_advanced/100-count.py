#!/usr/bin/python3
"""
Recursive function to query the Reddit API, parse hot article titles,
and print a sorted count of given keywords.
"""
import requests


def count_words(subreddit, word_list, after=None, counts=None):
    """
    Recursively queries the Reddit API, parses hot article titles,
    and prints a sorted count of given keywords.
    """
    if counts is None:
        counts = {word.lower(): 0 for word in word_list}

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

            if not posts and not after:
                sorted_counts = sorted(
                    counts.items(), key=lambda item: (-item[1], item[0])
                )
                for word, count in sorted_counts:
                    if count > 0:
                        print(f"{word}: {count}")
                return

            for post in posts:
                title = post["data"]["title"].lower()
                for word in counts:
                    for title_word in title.split():
                        if title_word == word:
                            counts[word] += 1

            if after:
                count_words(subreddit, word_list, after, counts)
            else:
                sorted_counts = sorted(
                    counts.items(), key=lambda item: (-item[1], item[0])
                )
                for word, count in sorted_counts:
                    if count > 0:
                        print(f"{word}: {count}")

        elif response.status_code == 404 or response.status_code == 302:
            return
        else:
            return

    except requests.exceptions.RequestException:
        return


if __name__ == "__main__":
    import sys
    if len(sys.argv) < 3:
        print("Usage: {} <subreddit> <list of keywords>".format(
            sys.argv[0]
        ))
        print("Ex: {} programming 'python java javascript'".format(
            sys.argv[0]
        ))
    else:
        count_words(sys.argv[1], [x.lower() for x in sys.argv[2].split()])
