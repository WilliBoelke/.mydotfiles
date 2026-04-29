import urllib

import requests

import re
import html
from playwright.sync_api import sync_playwright


from playwright_stealth import Stealth

def search_web(query):
    with sync_playwright() as p:
        browser = p.chromium.launch_persistent_context(
            user_data_dir="/home/wboelke/.config/chromium",
            headless=True
        )
        page = browser.new_page()
        stealth = Stealth()
        stealth.apply_stealth_sync(page)
        page.goto(f"https://lite.duckduckgo.com/lite/?q={query}")
        response_html = page.content()
        browser.close()

        print(response_html)
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
    results = search_web("Python programming")
    print(results)
