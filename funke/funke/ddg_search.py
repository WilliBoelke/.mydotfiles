import requests

import re
import html

import subprocess
import urllib.parse
import time
import random


def search_web(query):
    encoded = urllib.parse.quote_plus(query)

    # fetch the page
    result = subprocess.run(
        ["curl_firefox147", "-s",
         f"https://lite.duckduckgo.com/lite/?q={encoded}"],
        capture_output=True, text=True
    )

    response_html = result.stdout

    # mimic browser loading remaining resources with natural delay
    time.sleep(random.uniform(0.3, 1.2))

    # load tracking pixel
    subprocess.run(
        ["curl_firefox147", "-s",
         "https://duckduckgo.com/t/sl_l"],
        capture_output=True
    )

    results_start = response_html.find('<table border="0">\n    \n      \n      <!-- Web results are present -->')
    if results_start != -1:
        response_html = response_html[results_start:]
    pattern = re.compile(
        r'<a rel="nofollow" href="(.*?)" class=\'result-link\'>(.*?)</a>'
        r'.*?<td class=\'result-snippet\'>\s*(.*?)\s*</td>'
        r'.*?<span class=\'link-text\'>(.*?)</span>',
        re.DOTALL
    )

    results = pattern.findall(response_html)
    # cleanup snippets
    cleaned_results = []

    for url, title, snippet, domain in results[:5]:
        snippet = clean_snippet(snippet)
        url = "https:" + url if url.startswith("//") else url
        url = html.unescape(url)
        cleaned_results.append({
            "title": title,
            "url": url,
            "snippet": snippet,
            "domain": domain
        })

    return cleaned_results


def clean_snippet(text):
    text = re.sub(r'<.*?>', '', text)
    text = html.unescape(text)
    return text.strip()

def ddg_instant_answer(query):
    url = "https://api.duckduckgo.com/"
    params = {"q": query, "format": "json"}
    response = requests.get(url, params=params)
    data = response.json()
    if data.get("AnswerType") and data.get("Answer"):
        return data["Answer"]
    else:
        return None




if __name__ == "__main__":
    results = search_web("jetbrains")
    print(results)
