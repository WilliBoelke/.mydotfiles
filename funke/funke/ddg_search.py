import urllib

import requests

import urllib.request
import urllib.parse
import re
import html

def search_web(query):
    url = "https://lite.duckduckgo.com/lite/"
    params = urllib.parse.urlencode({"q": query})

    req = urllib.request.Request(
        f"{url}?{params}",
        headers={
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Language": "en-US,en;q=0.5",
            "Cookie": "kl=wt-wt; p=-2; s=l; o=json",
            "Referer": "https://lite.duckduckgo.com/",
            "DNT": "1",
        }
    )


    response = urllib.request.urlopen(req)
    responseHtml = response.read().decode("utf-8")
    results_start = responseHtml.find('<table border="0">\n    \n      \n      <!-- Web results are present -->')
    if results_start != -1:
        responseHtml = responseHtml[results_start:]
    pattern = re.compile(
        r'<a rel="nofollow" href="(.*?)" class=\'result-link\'>(.*?)</a>'
        r'.*?<td class=\'result-snippet\'>\s*(.*?)\s*</td>'
        r'.*?<span class=\'link-text\'>(.*?)</span>',
        re.DOTALL
    )
    results = pattern.findall(responseHtml)
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
    results = search_web("Python programming")
    print(results)
